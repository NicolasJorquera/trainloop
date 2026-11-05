package com.trainloop.app.reminders

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.database.sqlite.SQLiteDatabase
import android.util.Log
import com.trainloop.app.MainActivity
import com.trainloop.app.R
import com.trainloop.app.diagnostics.CrashLog
import java.io.File
import java.time.LocalDate
import java.time.ZoneId

/**
 * Recibe la alarma del recordatorio y los avisos del sistema que obligan a reprogramarla:
 * reinicio, cambio de hora o de zona y actualización de la app.
 *
 * Reglas (PRD, hábitos): solo si la persona lo activó, máximo uno al día y nunca si ya entrenó
 * ese día. Sin permiso de notificaciones no se muestra nada (Android lo bloquearía igual).
 */
class ReminderReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "TrainloopReminder"
        const val CHANNEL = "reminders"
        const val NOTIFICATION_ID = 77
    }

    override fun onReceive(context: Context, intent: Intent) {
        CrashLog.install(context)
        if (intent.action == ReminderScheduler.ACTION_FIRE) fire(context)
        // En todos los casos, la próxima.
        ReminderScheduler.schedule(context)
    }

    private fun fire(context: Context) {
        val store = ReminderStore(context)
        val today = LocalDate.now().toString()
        val nm = context.getSystemService(NotificationManager::class.java)
        when {
            !store.enabled -> Log.i(TAG, "skip: off")
            store.lastShownDay == today -> Log.i(TAG, "skip: already shown today")
            !nm.areNotificationsEnabled() -> Log.i(TAG, "skip: notifications blocked")
            trainedToday(context) -> Log.i(TAG, "skip: trained today")
            else -> {
                ensureChannel(context, store.channelName)
                nm.notify(NOTIFICATION_ID, build(context, store))
                store.lastShownDay = today
                Log.i(TAG, "shown")
            }
        }
    }

    private fun build(context: Context, store: ReminderStore): Notification {
        val open = PendingIntent.getActivity(
            context, 1,
            Intent(context, MainActivity::class.java).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP),
            PendingIntent.FLAG_IMMUTABLE,
        )
        return Notification.Builder(context, CHANNEL)
            .setSmallIcon(R.drawable.ic_stat_timer)
            .setContentTitle(store.title)
            .setContentText(store.body)
            .setCategory(Notification.CATEGORY_REMINDER)
            .setAutoCancel(true)
            .setContentIntent(open)
            .build()
    }

    private fun ensureChannel(context: Context, name: String) {
        context.getSystemService(NotificationManager::class.java).createNotificationChannel(
            NotificationChannel(CHANNEL, name, NotificationManager.IMPORTANCE_DEFAULT),
        )
    }

    /**
     * Hay una sesión completada o incompleta que empezó hoy (hora local). Lee la base de Drift
     * en solo lectura; si no se puede, se muestra el recordatorio.
     */
    private fun trainedToday(context: Context): Boolean {
        val file = File(context.filesDir, "trainloop.sqlite")
        if (!file.exists()) return false
        val start = LocalDate.now().atStartOfDay(ZoneId.systemDefault()).toInstant().toEpochMilli()
        return try {
            SQLiteDatabase.openDatabase(file.path, null, SQLiteDatabase.OPEN_READONLY).use { db ->
                db.rawQuery(
                    "SELECT COUNT(*) FROM session WHERE archived_at IS NULL AND " +
                        "status IN ('completed', 'incomplete', 'inProgress') AND started_at >= ?",
                    arrayOf(start.toString()),
                ).use { c -> c.moveToFirst() && c.getInt(0) > 0 }
            }
        } catch (e: Exception) {
            Log.w(TAG, "trainedToday: ${e.message}")
            false
        }
    }
}
