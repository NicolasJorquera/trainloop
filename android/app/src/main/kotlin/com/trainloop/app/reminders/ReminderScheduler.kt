package com.trainloop.app.reminders

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.util.Log
import java.time.LocalTime
import java.time.ZonedDateTime

/**
 * Recordatorios locales (F-13): una sola alarma inexacta (`setAndAllowWhileIdle`, sin permiso
 * de alarmas exactas) para el próximo día elegido. Al sonar se programa la siguiente. Como cada
 * vez se calcula con la zona horaria actual, los cambios de horario de verano no corren la
 * hora; los cambios de hora o zona y el reinicio vuelven a programarla (ReminderReceiver).
 */
object ReminderScheduler {

    private const val TAG = "TrainloopReminder"
    const val ACTION_FIRE = "com.trainloop.app.REMINDER_FIRE"

    /**
     * Próximo instante estrictamente después de [now] en uno de [days] (ISO 1 = lunes … 7 =
     * domingo) a la hora local [minuteOfDay]. `null` si no hay días.
     */
    fun nextTrigger(now: ZonedDateTime, days: Set<Int>, minuteOfDay: Int): ZonedDateTime? {
        if (days.isEmpty()) return null
        val time = LocalTime.of(minuteOfDay / 60, minuteOfDay % 60)
        for (offset in 0..7) {
            val date = now.toLocalDate().plusDays(offset.toLong())
            if (date.dayOfWeek.value !in days) continue
            // ZonedDateTime.of corre una hora inexistente (salto de verano) hacia adelante.
            val candidate = ZonedDateTime.of(date, time, now.zone)
            if (candidate.isAfter(now)) return candidate
        }
        return null
    }

    /** Programa (o cancela) la alarma según lo guardado. */
    fun schedule(context: Context, now: ZonedDateTime = ZonedDateTime.now()) {
        val store = ReminderStore(context)
        val alarms = context.getSystemService(AlarmManager::class.java)
        val pending = firePendingIntent(context)
        alarms.cancel(pending)
        if (!store.enabled) {
            Log.i(TAG, "reminders off")
            return
        }
        val next = nextTrigger(now, store.days, store.minuteOfDay) ?: return
        val at = next.toInstant().toEpochMilli()
        alarms.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, at, pending)
        store.nextAt = at
        Log.i(TAG, "next reminder $next")
    }

    private fun firePendingIntent(context: Context): PendingIntent = PendingIntent.getBroadcast(
        context,
        0,
        Intent(context, ReminderReceiver::class.java).setAction(ACTION_FIRE),
        PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
    )
}
