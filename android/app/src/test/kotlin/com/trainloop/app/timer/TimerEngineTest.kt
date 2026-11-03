package com.trainloop.app.timer

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

/** Motor con un reloj de mentira: los instantes son números (ms). */
class TimerEngineTest {

    /** Tabata: 10 s de preparación + 8 × (20 s / 10 s) sin el último descanso = 240 s. */
    private fun tabata(): TimerEngine {
        val d = mutableListOf(10_000L)
        for (r in 1..8) {
            d += 20_000L
            if (r < 8) d += 10_000L
        }
        return TimerEngine(d.toLongArray())
    }

    @Test
    fun `fases y objetivos absolutos desde el inicio`() {
        val e = tabata()
        assertEquals(16, e.count)
        assertEquals(240_000L, e.ends.last())
        e.start(1_000)
        assertEquals(0, e.index)
        assertEquals(11_000L, e.nextTransitionAt())
        assertEquals(0, e.locate(9_999))
        assertEquals(1, e.locate(10_000))
        assertEquals(16, e.locate(240_000))
    }

    @Test
    fun `tick cierra la fase solo al llegar a su fin`() {
        val e = tabata()
        e.start(0)
        assertTrue(e.tick(9_999).isEmpty())
        val closed = e.tick(10_003)
        assertEquals(listOf(PhaseResult(0, 10_000, 10_000, false)), closed)
        assertEquals(1, e.index)
        assertEquals(30_000L, e.nextTransitionAt())
        assertEquals(19_997L, e.remainingMs(10_003))
    }

    @Test
    fun `si la CPU se detuvo, cierra varias fases a la vez sin acumular error`() {
        val e = tabata()
        e.start(0)
        val closed = e.tick(45_000) // prep (10) + trabajo (20) + descanso (10) → en el 2.º trabajo
        assertEquals(listOf(0, 1, 2), closed.map { it.index })
        assertEquals(3, e.index)
        assertEquals(60_000L, e.nextTransitionAt())
        assertEquals(240_000L, e.ends.last())
    }

    @Test
    fun `las pausas no cuentan y corren los objetivos`() {
        val e = tabata()
        e.start(0)
        e.tick(10_000)
        assertTrue(e.pause(15_000))
        assertFalse(e.pause(16_000))
        assertNull(e.nextTransitionAt())
        assertEquals(15_000L, e.remainingMs(99_000))
        assertEquals(84_000L, e.pausedMs(99_000))
        assertTrue(e.resume(99_000))
        assertEquals(114_000L, e.nextTransitionAt())
        assertEquals(15_000L, e.activeMs(99_000))
        val r = e.tick(114_000).single()
        assertEquals(20_000L, r.actualMs)
        assertEquals(84_000L, e.pausedMs(200_000))
    }

    @Test
    fun `saltar marca la fase como omitida con su tiempo real`() {
        val e = tabata()
        e.start(0)
        e.tick(10_000)
        val r = e.skip(15_000)!!
        assertEquals(PhaseResult(1, 20_000, 5_000, true), r)
        assertEquals(2, e.index)
        assertEquals(30_000L, e.positionMs(15_000))
        assertEquals(25_000L, e.nextTransitionAt())
        val next = e.tick(25_000).single()
        assertEquals(PhaseResult(2, 10_000, 10_000, false), next)
    }

    @Test
    fun `volver reinicia la fase o, en sus primeros 2 s, va a la anterior`() {
        val e = tabata()
        e.start(0)
        e.tick(10_000)
        e.previous(17_000) // 7 s dentro del trabajo: vuelve a su inicio
        assertEquals(1, e.index)
        assertEquals(10_000L, e.positionMs(17_000))
        assertEquals(37_000L, e.nextTransitionAt())

        e.previous(18_000) // 1 s dentro: vuelve a la preparación y borra su resultado
        assertEquals(0, e.index)
        assertEquals(0L, e.positionMs(18_000))
        assertTrue(e.results().isEmpty())
        val again = e.tick(28_000).single()
        assertEquals(PhaseResult(0, 10_000, 10_000, false), again)
    }

    @Test
    fun `detener deja la fase en curso con su tiempo parcial`() {
        val e = tabata()
        e.start(0)
        e.tick(10_000)
        val r = e.stop(22_000)!!
        assertEquals(PhaseResult(1, 20_000, 12_000, false), r)
        assertTrue(e.finished)
        assertNull(e.nextTransitionAt())
        assertEquals(2, e.results().size)
    }

    @Test
    fun `una sesión completa termina en 240 s exactos`() {
        val e = tabata()
        e.start(5_000)
        var now = 5_000L
        var transitions = 0
        while (!e.finished) {
            now = e.nextTransitionAt()!!
            transitions += e.tick(now).size
        }
        assertEquals(16, transitions)
        assertEquals(245_000L, now)
        assertTrue(e.results().none { it.skipped })
        assertEquals(240_000L, e.results().sumOf { it.actualMs })
    }

    @Test
    fun `restaurar desde un punto guardado queda en pausa en la misma posición`() {
        val e = tabata()
        e.start(0)
        e.tick(10_000)
        e.pause(12_000)
        e.resume(14_000)
        val snap = e.snapshot(20_000) // activo 18 s, en el 1.er trabajo
        assertEquals(EngineSnapshot(1, 18_000, 18_000, 2_000, 10_000), snap)
        val saved = e.results()

        // Tras matar el proceso: otro reloj (p. ej. después de reiniciar el teléfono).
        val r = tabata()
        r.restore(snap, saved, 500)
        assertTrue(r.paused)
        assertEquals(1, r.index)
        assertEquals(12_000L, r.remainingMs(9_999))
        assertEquals(2_000L, r.pausedMs(500))
        r.resume(1_500)
        assertEquals(13_500L, r.nextTransitionAt())
        val done = r.tick(13_500).single()
        assertEquals(PhaseResult(1, 20_000, 20_000, false), done)
        assertEquals(listOf(0, 1), r.results().map { it.index })
    }

    @Test
    fun `el reloj de pared no interviene`() {
        // El motor solo usa el número que recibe: cambiar la hora del sistema no lo afecta (T-12).
        val e = tabata()
        e.start(1_000_000)
        assertEquals(1_010_000L, e.nextTransitionAt())
        assertEquals(1, e.tick(1_010_000).size)
    }
}
