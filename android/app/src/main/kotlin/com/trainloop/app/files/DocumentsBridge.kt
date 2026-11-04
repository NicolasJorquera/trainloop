package com.trainloop.app.files

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.provider.OpenableColumns
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.util.concurrent.Executors

/**
 * Respaldo y CSV (F-14) con el selector de documentos del sistema (Storage Access Framework):
 * ACTION_CREATE_DOCUMENT para guardar y ACTION_OPEN_DOCUMENT para abrir. La persona elige dónde
 * (Drive, Descargas…) y la app solo recibe permiso sobre ese archivo: no pide permisos de
 * almacenamiento. La lectura y escritura corren fuera del hilo principal.
 */
class DocumentsBridge(private val activity: Activity, messenger: BinaryMessenger) :
    MethodChannel.MethodCallHandler {

    companion object {
        const val CHANNEL = "trainloop/documents"
        private const val REQUEST_CREATE = 4301
        private const val REQUEST_OPEN = 4302

        /** Límite de lectura de un respaldo (comprimido). */
        private const val MAX_BYTES = 64 * 1024 * 1024
    }

    private val channel = MethodChannel(messenger, CHANNEL).also { it.setMethodCallHandler(this) }
    private val io = Executors.newSingleThreadExecutor()
    private val main = Handler(Looper.getMainLooper())
    private var pending: MethodChannel.Result? = null
    private var pendingBytes: ByteArray? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "create" -> {
                if (!claim(result)) return
                pendingBytes = call.argument<ByteArray>("bytes")
                val intent = Intent(Intent.ACTION_CREATE_DOCUMENT)
                    .addCategory(Intent.CATEGORY_OPENABLE)
                    .setType(call.argument<String>("mimeType") ?: "application/octet-stream")
                    .putExtra(Intent.EXTRA_TITLE, call.argument<String>("name"))
                launch(intent, REQUEST_CREATE)
            }
            "open" -> {
                if (!claim(result)) return
                // Drive y Descargas no siempre informan el tipo de un .gz: se acepta cualquiera y
                // la app valida el contenido.
                val intent = Intent(Intent.ACTION_OPEN_DOCUMENT)
                    .addCategory(Intent.CATEGORY_OPENABLE)
                    .setType("*/*")
                launch(intent, REQUEST_OPEN)
            }
            else -> result.notImplemented()
        }
    }

    private fun claim(result: MethodChannel.Result): Boolean {
        if (pending != null) {
            result.error("busy", "Ya hay un selector abierto", null)
            return false
        }
        pending = result
        return true
    }

    private fun launch(intent: Intent, request: Int) {
        try {
            @Suppress("DEPRECATION")
            activity.startActivityForResult(intent, request)
        } catch (e: Exception) {
            finish { it.error("unavailable", e.message, null) }
        }
    }

    /** Llamado por MainActivity. Devuelve `true` si el resultado era de este puente. */
    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != REQUEST_CREATE && requestCode != REQUEST_OPEN) return false
        val uri = data?.data
        if (resultCode != Activity.RESULT_OK || uri == null) {
            finish { it.success(null) }
            return true
        }
        if (requestCode == REQUEST_CREATE) write(uri) else read(uri)
        return true
    }

    private fun write(uri: Uri) {
        val bytes = pendingBytes ?: ByteArray(0)
        io.execute {
            try {
                activity.contentResolver.openOutputStream(uri, "wt")!!.use { it.write(bytes) }
                val name = displayName(uri)
                main.post { finish { it.success(name) } }
            } catch (e: Exception) {
                main.post { finish { it.error("io", e.message, null) } }
            }
        }
    }

    private fun read(uri: Uri) {
        io.execute {
            try {
                val out = ByteArrayOutputStream()
                activity.contentResolver.openInputStream(uri)!!.use { input ->
                    val buffer = ByteArray(64 * 1024)
                    while (true) {
                        val n = input.read(buffer)
                        if (n < 0) break
                        out.write(buffer, 0, n)
                        if (out.size() > MAX_BYTES) throw IllegalStateException("too large")
                    }
                }
                val map = mapOf("name" to displayName(uri), "bytes" to out.toByteArray())
                main.post { finish { it.success(map) } }
            } catch (e: Exception) {
                main.post { finish { it.error("io", e.message, null) } }
            }
        }
    }

    private fun displayName(uri: Uri): String? = try {
        activity.contentResolver.query(uri, arrayOf(OpenableColumns.DISPLAY_NAME), null, null, null)
            ?.use { c -> if (c.moveToFirst()) c.getString(0) else null }
    } catch (e: Exception) {
        null
    }

    private fun finish(block: (MethodChannel.Result) -> Unit) {
        val result = pending ?: return
        pending = null
        pendingBytes = null
        block(result)
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
        io.shutdown()
        pending = null
        pendingBytes = null
    }
}
