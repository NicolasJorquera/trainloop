package com.trainloop.app.timer

/** Fase al dejarla: duración planificada frente al tiempo activo real (sin pausas). */
data class PhaseResult(
    val index: Int,
    val plannedMs: Long,
    val actualMs: Long,
    val skipped: Boolean,
)

/** Punto de recuperación del motor. No guarda instantes del reloj: sirve tras un reinicio. */
data class EngineSnapshot(
    val index: Int,
    val positionMs: Long,
    val activeMs: Long,
    val pausedMs: Long,
    val entryActiveMs: Long,
)

/**
 * Motor del temporizador (R-I6). Solo conoce duraciones y un reloj monotónico que recibe en cada
 * llamada (SystemClock.elapsedRealtime en el servicio, un número en las pruebas).
 *
 * - activo = ahora − inicio − pausas: tiempo realmente entrenado.
 * - posición = activo + desplazamiento: punto de la línea de tiempo. Saltar suma lo que faltaba de
 *   la fase y volver resta; así la fase actual se calcula siempre desde la posición, nunca
 *   contando ticks, y cada cambio de fase tiene un instante absoluto en el reloj.
 */
class TimerEngine(private val durations: LongArray) {

    /** Fin de cada fase en la línea de tiempo (acumulado). */
    val ends: LongArray = LongArray(durations.size).also { a ->
        var acc = 0L
        durations.forEachIndexed { i, d -> acc += d; a[i] = acc }
    }

    val count: Int get() = durations.size

    var index = 0
        private set
    var paused = false
        private set

    private var startAt = 0L
    private var pausedAccum = 0L
    private var pausedAt = 0L
    private var pausedBefore = 0L
    private var offset = 0L
    private var entryActive = 0L
    private val results = sortedMapOf<Int, PhaseResult>()

    val finished: Boolean get() = index >= count

    fun activeMs(now: Long): Long = (if (paused) pausedAt else now) - startAt - pausedAccum

    fun positionMs(now: Long): Long = activeMs(now) + offset

    fun pausedMs(now: Long): Long = pausedBefore + pausedAccum + if (paused) now - pausedAt else 0

    fun phaseStartMs(i: Int): Long = if (i == 0) 0 else ends[i - 1]

    fun remainingMs(now: Long): Long =
        if (finished) 0 else (ends[index] - positionMs(now)).coerceAtLeast(0)

    /** Instante del reloj en que termina la fase actual; `null` en pausa o al terminar. */
    fun nextTransitionAt(): Long? =
        if (paused || finished) null else startAt + pausedAccum + ends[index] - offset

    fun results(): List<PhaseResult> = results.values.toList()

    /** Fase que contiene [position] (`count` si ya pasó la última). */
    fun locate(position: Long): Int {
        for (i in ends.indices) if (position < ends[i]) return i
        return count
    }

    fun start(now: Long) {
        startAt = now
        pausedAccum = 0
        pausedBefore = 0
        offset = 0
        entryActive = 0
        index = 0
        paused = false
        results.clear()
    }

    fun pause(now: Long): Boolean {
        if (paused || finished) return false
        paused = true
        pausedAt = now
        return true
    }

    fun resume(now: Long): Boolean {
        if (!paused || finished) return false
        pausedAccum += now - pausedAt
        paused = false
        return true
    }

    /**
     * Cierra las fases cuyo fin ya pasó y devuelve sus resultados. Es idempotente: si el aviso
     * llega antes de tiempo no cambia nada, y si la CPU se detuvo cierra varias de una vez.
     */
    fun tick(now: Long): List<PhaseResult> {
        if (finished) return emptyList()
        val target = locate(positionMs(now))
        val out = ArrayList<PhaseResult>()
        while (index < target) {
            val endActive = ends[index] - offset
            out += record(index, endActive - entryActive, skipped = false)
            entryActive = endActive
            index++
        }
        return out
    }

    /** Salta a la siguiente fase; la actual queda como omitida. */
    fun skip(now: Long): PhaseResult? {
        if (finished) return null
        val active = activeMs(now)
        val result = record(index, active - entryActive, skipped = true)
        offset += ends[index] - positionMs(now)
        entryActive = active
        index++
        return result
    }

    /**
     * Vuelve al inicio de la fase; si iba en sus primeros 2 s, a la fase anterior (S05). Volver a
     * una fase ya cerrada borra su resultado: se registra de nuevo al dejarla.
     */
    fun previous(now: Long) {
        if (finished) return
        val inPhase = positionMs(now) - phaseStartMs(index)
        if (inPhase > RESTART_WINDOW_MS || index == 0) {
            offset -= inPhase
        } else {
            offset -= inPhase + durations[index - 1]
            index--
            results.remove(index)
            entryActive = activeMs(now)
        }
    }

    /** Detiene la sesión: la fase en curso queda con su tiempo parcial. */
    fun stop(now: Long): PhaseResult? {
        if (finished) return null
        val result = record(index, activeMs(now) - entryActive, skipped = false)
        index = count
        return result
    }

    fun snapshot(now: Long) = EngineSnapshot(
        index = index,
        positionMs = positionMs(now),
        activeMs = activeMs(now),
        pausedMs = pausedMs(now),
        entryActiveMs = entryActive,
    )

    /** Retoma desde un punto guardado, en pausa (F-16). */
    fun restore(snap: EngineSnapshot, saved: List<PhaseResult>, now: Long) {
        startAt = now - snap.activeMs
        pausedAccum = 0
        pausedBefore = snap.pausedMs
        offset = snap.positionMs - snap.activeMs
        entryActive = snap.entryActiveMs
        index = snap.index.coerceIn(0, count)
        paused = true
        pausedAt = now
        results.clear()
        saved.forEach { results[it.index] = it }
    }

    private fun record(i: Int, actual: Long, skipped: Boolean): PhaseResult =
        PhaseResult(i, durations[i], actual.coerceAtLeast(0), skipped).also { results[i] = it }

    companion object {
        const val RESTART_WINDOW_MS = 2_000L
    }
}
