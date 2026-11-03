package com.trainloop.app.timer

import android.Manifest
import android.app.Activity
import android.app.ActivityManager
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Puente con Flutter (lib/platform/timer_engine_client.dart). Comandos por MethodChannel y estados
 * por EventChannel: solo se envía un estado en cada cambio (inicio, fase, pausa, fin); la
 * interfaz calcula el tiempo restante localmente.
 */
class TimerBridge(private val activity: Activity, messenger: BinaryMessenger) :
    MethodChannel.MethodCallHandler, EventChannel.StreamHandler {

    companion object {
        const val METHODS = "trainloop/timer"
        const val EVENTS = "trainloop/timer/events"
        const val REQUEST_NOTIFICATIONS = 4201
    }

    private var permissionResult: MethodChannel.Result? = null

    init {
        MethodChannel(messenger, METHODS).setMethodCallHandler(this)
        EventChannel(messenger, EVENTS).setStreamHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "start" -> {
                @Suppress("UNCHECKED_CAST")
                val program = TimerProgram.fromMap(call.arguments as Map<String, Any?>)
                activity.startForegroundService(
                    intent(TimerService.ACTION_START)
                        .putExtra(TimerService.EXTRA_PROGRAM, program.toJson().toString()),
                )
                result.success(null)
            }
            "pause" -> command(TimerService.ACTION_PAUSE, result)
            "resume" -> command(TimerService.ACTION_RESUME, result)
            "skip" -> command(TimerService.ACTION_SKIP, result)
            "previous" -> command(TimerService.ACTION_PREVIOUS, result)
            "stop" -> command(TimerService.ACTION_STOP, result)
            "state" -> result.success(TimerService.instance?.stateMap())
            "pending" -> result.success(pending())
            "restore" -> {
                if (TimerService.instance == null) {
                    activity.startForegroundService(intent(TimerService.ACTION_RESTORE))
                }
                result.success(null)
            }
            "clear" -> {
                if (TimerService.instance == null) TimerService.store(activity).clear()
                result.success(null)
            }
            "prewarmVoice" -> {
                val tag = call.argument<String>("locale") ?: "es-419"
                CuePlayer.prewarm(activity, tag) { ready -> activity.runOnUiThread { result.success(ready) } }
            }
            "backgroundRestricted" -> result.success(
                Build.VERSION.SDK_INT >= 28 &&
                    activity.getSystemService(ActivityManager::class.java).isBackgroundRestricted,
            )
            "openAppSettings" -> {
                activity.startActivity(
                    Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                        .setData(Uri.fromParts("package", activity.packageName, null)),
                )
                result.success(null)
            }
            "notificationsGranted" -> result.success(notificationsGranted())
            "requestNotifications" -> {
                if (notificationsGranted() || Build.VERSION.SDK_INT < 33) {
                    result.success(true)
                } else {
                    permissionResult = result
                    activity.requestPermissions(
                        arrayOf(Manifest.permission.POST_NOTIFICATIONS), REQUEST_NOTIFICATIONS,
                    )
                }
            }
            "mediaVolumeZero" -> result.success(CuePlayer.mediaVolumeIsZero(activity))
            "manufacturer" -> result.success(Build.MANUFACTURER.replaceFirstChar { it.uppercase() })
            else -> result.notImplemented()
        }
    }

    /** Llamado por MainActivity al responder el diálogo del sistema. */
    fun onPermissionResult(requestCode: Int, grantResults: IntArray) {
        if (requestCode != REQUEST_NOTIFICATIONS) return
        permissionResult?.success(
            grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED,
        )
        permissionResult = null
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        TimerService.listener = { events.success(it) }
        TimerService.instance?.stateMap()?.let { events.success(it) }
    }

    override fun onCancel(arguments: Any?) {
        TimerService.listener = null
    }

    fun dispose() {
        TimerService.listener = null
        permissionResult = null
    }

    /**
     * Sesión guardada sin servicio vivo: en curso (Android cerró la app o se reinició el
     * teléfono: recuperación) o terminada sin interfaz (Flutter la guarda en la base).
     */
    private fun pending(): Map<String, Any?>? {
        if (TimerService.instance != null) return null
        val cp = TimerService.store(activity).load() ?: return null
        return mapOf(
            "sessionId" to cp.program.sessionId,
            "state" to TimerService.stateName(cp.state),
            "index" to cp.snapshot.index,
            "count" to cp.program.phases.size,
            "remainingMs" to 0L,
            "positionMs" to cp.snapshot.positionMs,
            "activeMs" to cp.snapshot.activeMs,
            "pausedMs" to cp.snapshot.pausedMs,
            "results" to TimerService.resultMaps(cp.results),
            "savedAtWallMs" to cp.savedAtWallMs,
        )
    }

    private fun notificationsGranted() = Build.VERSION.SDK_INT < 33 ||
        activity.checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) ==
        PackageManager.PERMISSION_GRANTED

    private fun intent(action: String) = Intent(activity, TimerService::class.java).setAction(action)

    private fun command(action: String, result: MethodChannel.Result) {
        if (TimerService.instance != null) activity.startService(intent(action))
        result.success(null)
    }
}
