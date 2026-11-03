package com.trainloop.app.timer

import org.json.JSONObject
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

/** Descanso de fuerza (F-09) con un reloj de mentira: los instantes son números (ms). */
class RestTimerTest {

    @Test
    fun `el fin es un instante absoluto y avisa una sola vez`() {
        val r = RestTimer()
        r.start(1_000, 120_000)
        assertEquals(RestState.RUNNING, r.state)
        assertEquals(121_000L, r.endsAt)
        assertEquals(60_000L, r.remainingMs(61_000))
        assertFalse(r.tick(120_999))
        assertTrue(r.tick(121_004))
        assertEquals(RestState.DONE, r.state)
        assertEquals(0L, r.remainingMs(121_004))
        // Un aviso repetido (o tardío) no vuelve a sonar.
        assertFalse(r.tick(130_000))
    }

    @Test
    fun `si la CPU se detuvo, el aviso llega en cuanto despierta`() {
        val r = RestTimer()
        r.start(0, 90_000)
        assertTrue(r.tick(95_000))
        assertEquals(RestState.DONE, r.state)
    }

    @Test
    fun `mas y menos 15 s mueven el fin`() {
        val r = RestTimer()
        r.start(0, 90_000)
        assertTrue(r.adjust(10_000, 15_000))
        assertEquals(105_000L, r.endsAt)
        assertEquals(105_000L, r.durationMs)
        assertTrue(r.adjust(20_000, -15_000))
        assertEquals(90_000L, r.endsAt)
        assertEquals(90_000L, r.durationMs)
        assertEquals(70_000L, r.remainingMs(20_000))
    }

    @Test
    fun `restar mas de lo que queda termina en el siguiente tick con aviso`() {
        val r = RestTimer()
        r.start(0, 20_000)
        assertTrue(r.adjust(10_000, -15_000))
        assertEquals(10_000L, r.endsAt)
        assertEquals(0L, r.remainingMs(10_000))
        assertTrue(r.tick(10_000))
    }

    @Test
    fun `saltar termina sin aviso y no hay ajustes sin descanso`() {
        val r = RestTimer()
        assertFalse(r.adjust(0, 15_000))
        assertFalse(r.skip())
        r.start(0, 60_000)
        assertTrue(r.skip())
        assertEquals(RestState.IDLE, r.state)
        assertFalse(r.tick(60_000))
        assertFalse(r.adjust(1_000, 15_000))
    }

    @Test
    fun `un descanso de 0 s no empieza y uno nuevo reemplaza al anterior`() {
        val r = RestTimer()
        r.start(0, 0)
        assertEquals(RestState.IDLE, r.state)
        r.start(0, 60_000)
        r.start(30_000, 120_000)
        assertEquals(150_000L, r.endsAt)
        assertEquals(120_000L, r.durationMs)
        assertTrue(r.tick(150_000))
        r.start(200_000, 60_000)
        assertEquals(RestState.RUNNING, r.state)
    }

    private fun checkpoint(state: RestState = RestState.RUNNING) = StrengthCheckpoint(
        sessionId = "s1",
        restState = state,
        restEndsAt = 500_000,
        restDurationMs = 120_000,
        next = "Sentadilla, serie 3",
        savedElapsed = 400_000,
        savedWallMs = 1_700_000_000_000,
    )

    @Test
    fun `al reabrir el descanso se recalcula con el reloj monotonico`() {
        val cp = checkpoint()
        // 30 s después, mismo arranque: quedan 70 s.
        assertEquals(70_000L, cp.remainingRestMs(430_000, 1_700_000_030_000))
        // Ya venció: 0 (se descarta).
        assertEquals(0L, cp.remainingRestMs(600_000, 1_700_000_200_000))
    }

    @Test
    fun `tras un reinicio o sin descanso en curso se descarta`() {
        // El reloj monotónico volvió a empezar (reinicio del teléfono).
        assertEquals(0L, checkpoint().remainingRestMs(5_000, 1_700_000_060_000))
        // La hora de pared avanzó mucho más que el reloj monotónico: otro arranque.
        assertEquals(0L, checkpoint().remainingRestMs(450_000, 1_700_009_000_000))
        assertEquals(0L, checkpoint(RestState.DONE).remainingRestMs(430_000, 1_700_000_030_000))
    }

    @Test
    fun `el punto de fuerza ida y vuelta por JSON`() {
        val cp = checkpoint()
        val back = StrengthCheckpoint.fromJson(cp.toJson())
        assertEquals(cp, back)
        assertEquals("strength", JSONObject(cp.toJson()).getString("kind"))
    }

    @Test
    fun `el programa de fuerza ida y vuelta por JSON`() {
        val p = StrengthProgram(
            sessionId = "s1", title = "Piernas A", locale = "es-419", sounds = true,
            voice = false, vibration = true,
            strings = mapOf("rest" to "Descanso", "restOver" to "¡A la siguiente serie!"),
            restColor = 0xFF2BD9C5.toInt(), color = 0xFFD45CFF.toInt(),
            startedAtWallMs = 1_700_000_000_000,
        )
        assertEquals(p, StrengthProgram.fromJson(p.toJson()))
    }
}
