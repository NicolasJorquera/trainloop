package com.trainloop.app.diagnostics

import android.content.Context
import java.io.File
import java.io.PrintWriter
import java.io.StringWriter
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.TimeZone

/**
 * Registro local de cierres del lado nativo (NF-04 sin proveedor): guarda
 * las últimas [MAX_ENTRIES] excepciones no capturadas del proceso (motor del
 * temporizador, recordatorios, canales) en `files/diagnostics/native_crashes.log`
 * y deja seguir al manejador anterior (Android cierra la app como siempre y
 * Android vitals lo cuenta). No sale del teléfono: Dart lo incluye en el
 * registro que la persona exporta desde Configuración (`ErrorLog`).
 */
object CrashLog {
    const val MAX_ENTRIES = 5
    const val MAX_CHARS = 8_000
    const val SEPARATOR = "\n---\n"

    @Volatile
    private var installed = false

    /** Idempotente: se llama desde la actividad, el servicio y el receptor. */
    fun install(context: Context) {
        if (installed) return
        synchronized(this) {
            if (installed) return
            installed = true
        }
        val file = File(context.applicationContext.filesDir, "diagnostics/native_crashes.log")
        val previous = Thread.getDefaultUncaughtExceptionHandler()
        Thread.setDefaultUncaughtExceptionHandler { thread, error ->
            try {
                append(file, describe(thread.name, error, Date()))
            } catch (_: Throwable) {
                // Nunca tapar el error original.
            }
            previous?.uncaughtException(thread, error)
        }
    }

    internal fun describe(thread: String, error: Throwable, at: Date): String {
        val stamp = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.ROOT).apply {
            timeZone = TimeZone.getTimeZone("UTC")
        }.format(at)
        val trace = StringWriter().also { error.printStackTrace(PrintWriter(it)) }.toString()
        return "[$stamp] thread=$thread\n$trace".take(MAX_CHARS).trim()
    }

    /** Agrega [entry] y deja solo las últimas [max], con escritura atómica. */
    internal fun append(file: File, entry: String, max: Int = MAX_ENTRIES) {
        file.parentFile?.mkdirs()
        val old = if (file.exists()) {
            file.readText().split(SEPARATOR).map { it.trim() }.filter { it.isNotEmpty() }
        } else {
            emptyList()
        }
        val kept = (old + entry.trim()).takeLast(max)
        val tmp = File(file.path + ".tmp")
        tmp.outputStream().use { out ->
            out.write(kept.joinToString(SEPARATOR, postfix = SEPARATOR).toByteArray())
            out.fd.sync()
        }
        if (!tmp.renameTo(file)) {
            file.delete()
            tmp.renameTo(file)
        }
    }
}
