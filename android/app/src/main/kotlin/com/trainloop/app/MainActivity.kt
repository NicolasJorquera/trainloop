package com.trainloop.app

import android.content.Intent
import android.os.Bundle
import com.trainloop.app.diagnostics.CrashLog
import com.trainloop.app.files.DocumentsBridge
import com.trainloop.app.reminders.ReminderBridge
import com.trainloop.app.timer.TimerBridge
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {

    private var timer: TimerBridge? = null
    private var documents: DocumentsBridge? = null
    private var reminders: ReminderBridge? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        CrashLog.install(this)
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        timer = TimerBridge(this, messenger)
        documents = DocumentsBridge(this, messenger)
        reminders = ReminderBridge(applicationContext, messenger)
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        timer?.dispose()
        timer = null
        documents?.dispose()
        documents = null
        reminders?.dispose()
        reminders = null
        super.cleanUpFlutterEngine(flutterEngine)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        timer?.onPermissionResult(requestCode, grantResults)
    }

    @Deprecated("Deprecated in Java")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (documents?.onActivityResult(requestCode, resultCode, data) == true) return
        @Suppress("DEPRECATION")
        super.onActivityResult(requestCode, resultCode, data)
    }
}
