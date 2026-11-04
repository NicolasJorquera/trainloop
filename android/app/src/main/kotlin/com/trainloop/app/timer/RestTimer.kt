package com.trainloop.app.timer

import org.json.JSONObject

/** Estado del descanso entre series. */
enum class RestState { IDLE, RUNNING, DONE }

/**
 * Descanso automático de la sesión de fuerza (F-09, R-G8). Como [TimerEngine], solo conoce un
 * reloj monotónico que recibe en cada llamada (SystemClock.elapsedRealtime en el servicio): el
 * fin es un instante absoluto, nunca se cuentan ticks. ±15 s mueve ese instante.
 */
class RestTimer {

    var state = RestState.IDLE
        private set

    /** Instante del reloj en que termina (solo con [RestState.RUNNING]). */
    var endsAt = 0L
        private set

    /** Duración total, con los ±15 s aplicados. */
    var durationMs = 0L
        private set

    val running: Boolean get() = state == RestState.RUNNING

    fun remainingMs(now: Long): Long = if (running) (endsAt - now).coerceAtLeast(0) else 0

    /** Empieza un descanso de [duration] ms; con 0 o menos no hay descanso. */
    fun start(now: Long, duration: Long) {
        if (duration <= 0) {
            state = RestState.IDLE
            return
        }
        endsAt = now + duration
        durationMs = duration
        state = RestState.RUNNING
    }

    /**
     * Suma o resta [delta] ms. Restar más de lo que queda lo deja en 0: termina en el siguiente
     * [tick] con su aviso. `false` si no hay descanso en curso.
     */
    fun adjust(now: Long, delta: Long): Boolean {
        if (!running) return false
        val remaining = (endsAt - now + delta).coerceAtLeast(0)
        durationMs = (durationMs + (now + remaining - endsAt)).coerceAtLeast(0)
        endsAt = now + remaining
        return true
    }

    /** Salta el descanso: sin aviso. */
    fun skip(): Boolean {
        if (!running) return false
        state = RestState.IDLE
        return true
    }

    /** Cierra el descanso si ya pasó su fin. `true` solo la vez que termina (avisar). */
    fun tick(now: Long): Boolean {
        if (!running || now < endsAt) return false
        state = RestState.DONE
        return true
    }

    fun reset() {
        state = RestState.IDLE
        endsAt = 0
        durationMs = 0
    }
}

/** Sesión de fuerza tal como la envía Flutter: avisos, textos ya localizados y colores (ARGB). */
data class StrengthProgram(
    val sessionId: String,
    val title: String,
    val locale: String,
    val sounds: Boolean,
    val voice: Boolean,
    val vibration: Boolean,
    val strings: Map<String, String>,
    val restColor: Int,
    val color: Int,
    val startedAtWallMs: Long,
) {
    fun string(key: String): String = strings[key] ?: key

    fun toJson(): JSONObject = JSONObject()
        .put("sessionId", sessionId).put("title", title).put("locale", locale)
        .put("sounds", sounds).put("voice", voice).put("vibration", vibration)
        .put("strings", JSONObject(strings)).put("restColor", restColor).put("color", color)
        .put("startedAtWallMs", startedAtWallMs)

    companion object {
        fun fromJson(o: JSONObject): StrengthProgram {
            val s = o.getJSONObject("strings")
            return StrengthProgram(
                sessionId = o.getString("sessionId"),
                title = o.getString("title"),
                locale = o.getString("locale"),
                sounds = o.getBoolean("sounds"),
                voice = o.getBoolean("voice"),
                vibration = o.getBoolean("vibration"),
                strings = s.keys().asSequence().associateWith { s.getString(it) },
                restColor = o.getInt("restColor"),
                color = o.getInt("color"),
                startedAtWallMs = o.getLong("startedAtWallMs"),
            )
        }

        @Suppress("UNCHECKED_CAST")
        fun fromMap(m: Map<String, Any?>): StrengthProgram = StrengthProgram(
            sessionId = m["sessionId"] as String,
            title = m["title"] as String,
            locale = m["locale"] as String,
            sounds = m["sounds"] as Boolean,
            voice = m["voice"] as Boolean,
            vibration = m["vibration"] as Boolean,
            strings = m["strings"] as Map<String, String>,
            restColor = (m["restColor"] as Number).toLong().toInt(),
            color = (m["color"] as Number).toLong().toInt(),
            startedAtWallMs = (m["startedAtWallMs"] as Number).toLong(),
        )
    }
}

/**
 * Punto de recuperación de la sesión de fuerza (las series viven en la base de Flutter; aquí
 * solo el descanso). Guarda el fin del descanso en el reloj monotónico y la hora de pared del
 * guardado para saber, al reabrir, si sigue el mismo arranque del teléfono.
 */
data class StrengthCheckpoint(
    val sessionId: String,
    val restState: RestState,
    val restEndsAt: Long,
    val restDurationMs: Long,
    val next: String,
    val savedElapsed: Long,
    val savedWallMs: Long,
) {
    /**
     * Lo que falta del descanso al reabrir (R-G8, casos excepcionales): se recalcula con el reloj
     * monotónico si el teléfono no se reinició; si ya venció o hubo un reinicio, 0 (se descarta).
     */
    fun remainingRestMs(nowElapsed: Long, nowWallMs: Long): Long {
        if (restState != RestState.RUNNING) return 0
        val elapsedDelta = nowElapsed - savedElapsed
        val wallDelta = nowWallMs - savedWallMs
        val sameBoot = elapsedDelta >= 0 && kotlin.math.abs(wallDelta - elapsedDelta) < SAME_BOOT_TOLERANCE_MS
        return if (sameBoot) (restEndsAt - nowElapsed).coerceAtLeast(0) else 0
    }

    fun toJson(): String = JSONObject()
        .put("version", 1).put("kind", "strength").put("sessionId", sessionId)
        .put("restState", restState.name).put("restEndsAt", restEndsAt)
        .put("restDurationMs", restDurationMs).put("next", next)
        .put("savedElapsed", savedElapsed).put("savedWallMs", savedWallMs)
        .toString()

    companion object {
        const val FILE_NAME = "strength_checkpoint.json"

        /** Diferencia máxima entre ambos relojes para considerar el mismo arranque. */
        const val SAME_BOOT_TOLERANCE_MS = 120_000L

        fun fromJson(text: String): StrengthCheckpoint {
            val o = JSONObject(text)
            return StrengthCheckpoint(
                sessionId = o.getString("sessionId"),
                restState = RestState.valueOf(o.getString("restState")),
                restEndsAt = o.getLong("restEndsAt"),
                restDurationMs = o.getLong("restDurationMs"),
                next = o.optString("next", ""),
                savedElapsed = o.getLong("savedElapsed"),
                savedWallMs = o.getLong("savedWallMs"),
            )
        }
    }
}
