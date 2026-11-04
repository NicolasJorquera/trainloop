package com.trainloop.app.reminders

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/** Canal `trainloop/reminders` (lib/platform/reminder_client.dart). */
class ReminderBridge(private val context: Context, messenger: BinaryMessenger) :
    MethodChannel.MethodCallHandler {

    private val channel = MethodChannel(messenger, "trainloop/reminders")
        .also { it.setMethodCallHandler(this) }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "schedule" -> {
                val store = ReminderStore(context)
                store.enabled = call.argument<Boolean>("enabled") ?: false
                store.days = call.argument<List<Int>>("weekdays").orEmpty().toSet()
                store.minuteOfDay = call.argument<Int>("minuteOfDay") ?: (18 * 60)
                call.argument<String>("title")?.let { store.title = it }
                call.argument<String>("body")?.let { store.body = it }
                call.argument<String>("channelName")?.let { store.channelName = it }
                ReminderScheduler.schedule(context)
                result.success(if (store.enabled) store.nextAt else null)
            }
            else -> result.notImplemented()
        }
    }

    fun dispose() = channel.setMethodCallHandler(null)
}
