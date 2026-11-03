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

    /**
     * Variante fuerza de S19: durante el descanso, cuenta regresiva nativa con el color del
     * descanso, la serie siguiente y las acciones +15 s y Saltar; al terminar, "¡A la siguiente
     * serie!"; sin descanso, la sesión con su tiempo y las series hechas.
     */
    fun buildStrength(
        context: Context,
        program: StrengthProgram,
        rest: RestTimer,
        now: Long,
        next: String,
        progress: String,
    ): Notification {
        val b = Notification.Builder(context, CHANNEL)
            .setSmallIcon(R.drawable.ic_stat_timer)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setCategory(Notification.CATEGORY_WORKOUT)
            .setContentIntent(openApp(context))
            .setVisibility(Notification.VISIBILITY_PUBLIC)
        when (rest.state) {
            RestState.RUNNING -> {
                b.setContentTitle(program.string("rest"))
                    .setContentText(next.ifEmpty { program.title })
                    .setSubText(program.title)
                    .setColor(program.restColor)
                    .setColorized(true)
                    .setUsesChronometer(true)
                    .setChronometerCountDown(true)
                    .setShowWhen(true)
                    .setWhen(System.currentTimeMillis() + rest.remainingMs(now))
                b.addAction(
                    Notification.Action.Builder(null, program.string("plus15"),
                        restAction(context, TimerService.ACTION_REST_ADD, 3)).build(),
                )
                b.addAction(
                    Notification.Action.Builder(null, program.string("skip"),
                        restAction(context, TimerService.ACTION_REST_SKIP, 4)).build(),
                )
            }
            RestState.DONE -> b.setContentTitle(program.string("restOver"))
                .setContentText(next.ifEmpty { program.title })
                .setSubText(program.title)
                .setColor(program.color)
                .setShowWhen(false)
            RestState.IDLE -> b.setContentTitle(program.title)
                .setContentText(progress.ifEmpty { program.string("inProgress") })
                .setColor(program.color)
                .setUsesChronometer(true)
                .setShowWhen(true)
                .setWhen(program.startedAtWallMs)
        }
        if (Build.VERSION.SDK_INT >= 31) {
            b.setForegroundServiceBehavior(Notification.FOREGROUND_SERVICE_IMMEDIATE)
        }
        return b.build()
    }

    private fun openApp(context: Context) = PendingIntent.getActivity(
        context, 0,
        Intent(context, MainActivity::class.java).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP),
        PendingIntent.FLAG_IMMUTABLE,
    )

    private fun restAction(context: Context, action: String, code: Int) = PendingIntent.getService(
        context, code,
        Intent(context, TimerService::class.java).setAction(action)
            .putExtra(TimerService.EXTRA_DELTA, 15_000L),
        PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
    )

    private fun action(context: Context, action: String, code: Int) = PendingIntent.getService(
        context, code, Intent(context, TimerService::class.java).setAction(action),
        PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
    )
}
