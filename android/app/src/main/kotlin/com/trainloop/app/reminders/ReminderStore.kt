package com.trainloop.app.reminders

import android.content.Context

/**
 * Copia nativa de los recordatorios para reprogramarlos sin Flutter (reinicio, cambio de hora).
 * La fuente es la tabla `reminder` de la base; Flutter la envía con cada cambio y al abrir la app,
 * junto con los textos ya traducidos.
 */
class ReminderStore(context: Context) {

    private val prefs = context.getSharedPreferences("trainloop_reminders", Context.MODE_PRIVATE)

    var enabled: Boolean
        get() = prefs.getBoolean("enabled", false)
        set(v) = prefs.edit().putBoolean("enabled", v).apply()

    var days: Set<Int>
        get() = prefs.getString("days", "").orEmpty().split(',')
            .mapNotNull { it.toIntOrNull() }.filter { it in 1..7 }.toSet()
        set(v) = prefs.edit().putString("days", v.sorted().joinToString(",")).apply()

    var minuteOfDay: Int
        get() = prefs.getInt("minuteOfDay", 18 * 60).coerceIn(0, 1439)
        set(v) = prefs.edit().putInt("minuteOfDay", v).apply()

    var title: String
        get() = prefs.getString("title", null) ?: "Trainloop"
        set(v) = prefs.edit().putString("title", v).apply()

    var body: String
        get() = prefs.getString("body", null) ?: ""
        set(v) = prefs.edit().putString("body", v).apply()

    var channelName: String
        get() = prefs.getString("channelName", null) ?: "Reminders"
        set(v) = prefs.edit().putString("channelName", v).apply()

    /** Próxima alarma programada (milisegundos UTC), para depurar. */
    var nextAt: Long
        get() = prefs.getLong("nextAt", 0L)
        set(v) = prefs.edit().putLong("nextAt", v).apply()

    /** Día local (aaaa-mm-dd) del último aviso: máximo uno por día. */
    var lastShownDay: String?
        get() = prefs.getString("lastShownDay", null)
        set(v) = prefs.edit().putString("lastShownDay", v).apply()
}
