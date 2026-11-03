package com.trainloop.app.timer

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import com.trainloop.app.MainActivity
import com.trainloop.app.R

/**
 * Notificación de la sesión en curso (S19, R-I9): fase y ronda, cuenta regresiva nativa
 * (setChronometerCountDown, el tiempo avanza sin despertar la app), color de la fase y acciones
 * Pausar/Reanudar y Saltar. Visible en la pantalla de bloqueo: no muestra datos sensibles.
 */
object SessionNotification {

    const val CHANNEL = "session"
    const val ID = 42

    fun ensureChannel(context: Context, name: String) {
        val nm = context.getSystemService(NotificationManager::class.java)
        nm.createNotificationChannel(
            NotificationChannel(CHANNEL, name, NotificationManager.IMPORTANCE_LOW).apply {
                setShowBadge(false)
                lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            },
        )
    }

    fun build(
        context: Context,
        program: TimerProgram,
        phase: PhaseSpec,
        paused: Boolean,
        remainingMs: Long,
    ): Notification {
        val open = PendingIntent.getActivity(
            context, 0,
            Intent(context, MainActivity::class.java).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP),
            PendingIntent.FLAG_IMMUTABLE,
        )
        val title = if (paused) "${program.string("paused")} · ${phase.title}" else phase.title
        val b = Notification.Builder(context, CHANNEL)
            .setSmallIcon(R.drawable.ic_stat_timer)
            .setContentTitle(title)
            .setContentText(program.title)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setCategory(Notification.CATEGORY_WORKOUT)
            .setColor(phase.color)
            .setColorized(true)
            .setContentIntent(open)
            .setVisibility(Notification.VISIBILITY_PUBLIC)
        if (!paused) {
            b.setUsesChronometer(true)
                .setChronometerCountDown(true)
                .setShowWhen(true)
                .setWhen(System.currentTimeMillis() + remainingMs)
        } else {
            b.setShowWhen(false)
        }
        b.addAction(
            Notification.Action.Builder(
                null,
                program.string(if (paused) "resume" else "pause"),
                action(context, if (paused) TimerService.ACTION_RESUME else TimerService.ACTION_PAUSE, 1),
            ).build(),
        )
        b.addAction(
            Notification.Action.Builder(
                null, program.string("skip"), action(context, TimerService.ACTION_SKIP, 2),
            ).build(),
        )
        if (Build.VERSION.SDK_INT >= 31) {
            b.setForegroundServiceBehavior(Notification.FOREGROUND_SERVICE_IMMEDIATE)
        }
        return b.build()
    }

    private fun action(context: Context, action: String, code: Int) = PendingIntent.getService(
        context, code, Intent(context, TimerService::class.java).setAction(action),
        PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
    )
}
