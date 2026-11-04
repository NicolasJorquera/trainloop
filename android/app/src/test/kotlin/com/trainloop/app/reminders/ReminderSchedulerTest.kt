package com.trainloop.app.reminders

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test
import java.time.ZoneId
import java.time.ZonedDateTime

class ReminderSchedulerTest {

    private val santiago = ZoneId.of("America/Santiago")
    private val newYork = ZoneId.of("America/New_York")

    private fun at(zone: ZoneId, y: Int, m: Int, d: Int, h: Int, min: Int = 0) =
        ZonedDateTime.of(y, m, d, h, min, 0, 0, zone)

    @Test
    fun `sin días no hay próxima`() {
        assertNull(ReminderScheduler.nextTrigger(at(santiago, 2026, 11, 3, 10), emptySet(), 600))
    }

    @Test
    fun `hoy si la hora no pasó, si no el próximo día elegido`() {
        // Martes 3 de noviembre de 2026.
        val now = at(santiago, 2026, 11, 3, 10)
        assertEquals(
            at(santiago, 2026, 11, 3, 18),
            ReminderScheduler.nextTrigger(now, setOf(2), 18 * 60),
        )
        assertEquals(
            at(santiago, 2026, 11, 4, 7),
            ReminderScheduler.nextTrigger(now, setOf(2, 3), 7 * 60),
        )
        // Solo martes y ya pasó: el martes siguiente.
        assertEquals(
            at(santiago, 2026, 11, 10, 7),
            ReminderScheduler.nextTrigger(now, setOf(2), 7 * 60),
        )
    }

    @Test
    fun `la hora exacta de ahora no se repite`() {
        val now = at(santiago, 2026, 11, 3, 18)
        assertEquals(
            at(santiago, 2026, 11, 10, 18),
            ReminderScheduler.nextTrigger(now, setOf(2), 18 * 60),
        )
    }

    @Test
    fun `respeta el cambio de horario de verano`() {
        // EE. UU. vuelve al horario de invierno el domingo 1 de noviembre de 2026.
        val now = at(newYork, 2026, 10, 31, 12)
        val next = ReminderScheduler.nextTrigger(now, setOf(1), 7 * 60)!!
        assertEquals(7, next.hour)
        assertEquals(-5 * 3600, next.offset.totalSeconds)
    }
}
