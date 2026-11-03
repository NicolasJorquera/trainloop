package com.trainloop.app.timer

import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.Handler
import android.os.HandlerThread
import android.os.IBinder
import android.os.Looper
import android.os.PowerManager
import android.os.Process
import android.os.SystemClock
import android.util.Log
import org.json.JSONObject
import java.io.File

/**
 * Servicio en primer plano (specialUse) que corre la sesión de intervalos (F-04). Flutter solo
 * envía el programa y muestra el estado que este servicio publica; si Android detiene la
 * interfaz o se apaga la pantalla, el entrenamiento sigue.
 *
 * - Cada cambio de fase se programa en su instante absoluto de SystemClock.elapsedRealtime
 *   (inmune a cambios de hora) a partir de [TimerEngine]; nunca se cuentan ticks.
 * - Corre en un hilo propio de prioridad alta (no en el hilo principal, que comparte con la
 *   interfaz): así un hilo principal ocupado no atrasa los avisos. El estado se protege con el
 *   monitor del servicio y los estados se publican en el hilo principal.
 * - Wake lock parcial solo mientras la sesión corre: se suelta en pausa y al terminar.
 * - Punto de recuperación atómico en cada cambio y cada 5 s (R-I11 pide ≥ 1 cada 10 s).
 * - Sin alarmas exactas: el spike no las necesitó (ver docs/arquitectura.md).
 */
class TimerService : Service() {

    companion object {
        private const val TAG = "TrainloopTimer"
        const val ACTION_START = "com.trainloop.app.timer.START"
        const val ACTION_RESTORE = "com.trainloop.app.timer.RESTORE"
        const val ACTION_PAUSE = "com.trainloop.app.timer.PAUSE"
        const val ACTION_RESUME = "com.trainloop.app.timer.RESUME"
        const val ACTION_SKIP = "com.trainloop.app.timer.SKIP"
        const val ACTION_PREVIOUS = "com.trainloop.app.timer.PREVIOUS"
        const val ACTION_STOP = "com.trainloop.app.timer.STOP"
        const val EXTRA_PROGRAM = "program"
        const val CHECKPOINT_EVERY_MS = 5_000L
        private const val DEBUG_LOG = "timer_debug.csv"

        @Volatile
        var instance: TimerService? = null
            private set

        /** Receptor de estados (el EventChannel mientras haya interfaz). Hilo principal. */
        var listener: ((Map<String, Any?>) -> Unit)? = null

        fun store(context: Context) =
            CheckpointStore(File(context.filesDir, CheckpointStore.FILE_NAME))

        fun stateName(s: SessionState) = s.name.lowercase()

        fun resultMaps(results: List<PhaseResult>) = results.map {
            mapOf("index" to it.index, "plannedMs" to it.plannedMs,
                "actualMs" to it.actualMs, "skipped" to it.skipped)
        }
    }

    private val thread = HandlerThread("trainloop-timer", Process.THREAD_PRIORITY_URGENT_AUDIO)
    private lateinit var handler: Handler
    private val main = Handler(Looper.getMainLooper())
    private lateinit var checkpoints: CheckpointStore
    private var program: TimerProgram? = null
    private var engine: TimerEngine? = null
    private var endState: SessionState? = null
    private val ended get() = endState != null
    private var wakeLock: PowerManager.WakeLock? = null
    private var debugLog: File? = null

    override fun onCreate() {
        super.onCreate()
        instance = this
        thread.start()
        handler = Handler(thread.looper)
        checkpoints = store(this)
        if (applicationInfo.flags and ApplicationInfo.FLAG_DEBUGGABLE != 0) {
            debugLog = File(filesDir, DEBUG_LOG).also {
                if (!it.exists()) {
                    it.writeText("event,session,index,type,target,actual,lateness_ms,interactive,idle,wall_ms\n")
                }
            }
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.action
        val program = intent?.getStringExtra(EXTRA_PROGRAM)
        handler.post {
            synchronized(this) {
                when (action) {
                    ACTION_START -> program?.let { begin(TimerProgram.fromJson(JSONObject(it))) }
                    ACTION_RESTORE -> restore()
                    ACTION_PAUSE -> pause()
                    ACTION_RESUME -> resume()
                    ACTION_SKIP -> skip()
                    ACTION_PREVIOUS -> previous()
                    ACTION_STOP -> end(SessionState.STOPPED)
                }
                if (engine == null) stopSelf()
            }
        }
        return START_NOT_STICKY
    }

    override fun onDestroy() {
        synchronized(this) {
            // Detenido por el sistema con la sesión en curso (p. ej. app restringida): queda el
            // punto para recuperarla y la interfaz, si está abierta, lo sabe al instante.
            if (!ended && engine != null) {
                saveCheckpoint()
                log("interrupted", engine?.index ?: -1, now(), now())
                stateMap(SessionState.RUNNING)?.let { m ->
                    main.post { listener?.invoke(m + ("state" to "interrupted")) }
                }
            }
            handler.removeCallbacksAndMessages(null)
            releaseWake()
            instance = null
        }
        thread.quitSafely()
        super.onDestroy()
    }

    // ------------------------------------------------------------------ sesión

    private fun now() = SystemClock.elapsedRealtime()

    private fun begin(p: TimerProgram) {
        handler.removeCallbacksAndMessages(null)
        program = p
        endState = null
        val e = TimerEngine(p.phases.map { it.durationMs }.toLongArray())
        engine = e
        CuePlayer.prewarm(this, p.locale)
        e.start(now())
        if (!goForeground()) return
        acquireWake()
        log("start", 0, now(), now())
        enterPhase()
        handler.postDelayed(checkpointLoop, CHECKPOINT_EVERY_MS)
    }

    private fun restore() {
        val cp = checkpoints.load()
        if (cp == null || cp.state == SessionState.FINISHED || cp.state == SessionState.STOPPED) {
            return
        }
        handler.removeCallbacksAndMessages(null)
        program = cp.program
        endState = null
        val e = TimerEngine(cp.program.phases.map { it.durationMs }.toLongArray())
        engine = e
        CuePlayer.prewarm(this, cp.program.locale)
        e.restore(cp.snapshot, cp.results, now())
        if (!goForeground()) return
        log("restore", e.index, now(), now())
        if (e.finished) end(SessionState.FINISHED) else changed()
        handler.postDelayed(checkpointLoop, CHECKPOINT_EVERY_MS)
    }

    private fun pause() {
        val e = engine ?: return
        if (!e.pause(now())) return
        CuePlayer.stopSpeaking()
        releaseWake()
        log("pause", e.index, now(), now())
        changed()
    }

    private fun resume() {
        val e = engine ?: return
        if (!e.resume(now())) return
        acquireWake()
        log("resume", e.index, now(), now())
        changed()
    }

    private fun skip() {
        val e = engine ?: return
        e.skip(now()) ?: return
        log("skip", e.index, now(), now())
        if (e.finished) end(SessionState.FINISHED) else enterPhase()
    }

    private fun previous() {
        val e = engine ?: return
        if (e.finished) return
        e.previous(now())
        log("previous", e.index, now(), now())
        enterPhase()
    }

    private val transition = Runnable { synchronized(this) { onTransition() } }

    private fun onTransition() {
        val e = engine ?: return
        val target = e.nextTransitionAt() ?: return
        val actual = now()
        val closed = e.tick(actual)
        if (closed.isEmpty()) {
            // Llegó antes de tiempo: se reprograma con el mismo objetivo absoluto.
            schedule()
            return
        }
        log("transition", e.index, target, actual)
        if (e.finished) end(SessionState.FINISHED) else enterPhase()
    }

    /** Avisos de la fase actual (si corre) y todo lo que sigue a un cambio. */
    private fun enterPhase() {
        val e = engine ?: return
        val p = program ?: return
        if (!e.paused) {
            val spoke = CuePlayer.phaseStart(this, p, p.phases[e.index], "phase${e.index}")
            log("cue_voice=$spoke;audio=${CuePlayer.audioAllowed(this)}", e.index, now(), now())
        }
        changed()
    }

    private fun changed() {
        schedule()
        updateNotification()
        saveCheckpoint()
        emit()
    }

    private fun schedule() {
        handler.removeCallbacks(transition)
        beeps.forEach { handler.removeCallbacks(it) }
        val at = engine?.nextTransitionAt() ?: return
        val t = now()
        handler.postDelayed(transition, (at - t).coerceAtLeast(0))
        for (s in 1..3) {
            val d = at - s * 1000L - t
            if (d > 0) handler.postDelayed(beeps[s - 1], d)
        }
    }

    private val beeps = Array(3) { i ->
        Runnable {
            synchronized(this) {
                program?.let { CuePlayer.countdown(this, it) }
                log("beep${i + 1}", engine?.index ?: -1, 0, now())
            }
        }
    }

    private fun end(state: SessionState) {
        val e = engine ?: return
        val p = program ?: return
        if (ended) return
        if (state == SessionState.STOPPED) e.stop(now())
        endState = state
        handler.removeCallbacksAndMessages(null)
        if (state == SessionState.FINISHED) CuePlayer.finish(this, p, p.strings["finishSpeech"])
        log(stateName(state), e.index, now(), now())
        saveCheckpoint(state)
        emit(state)
        releaseWake()
        stopForeground(STOP_FOREGROUND_REMOVE)
        stopSelf()
    }

    // ------------------------------------------------------- estado y avisos

    private fun currentState(): SessionState =
        endState ?: if (engine?.paused == true) SessionState.PAUSED else SessionState.RUNNING

    /** Estado para la interfaz; `null` si no hay sesión. */
    @Synchronized
    fun stateMap(state: SessionState = currentState()): Map<String, Any?>? {
        val e = engine ?: return null
        val p = program ?: return null
        val t = now()
        return mapOf(
            "sessionId" to p.sessionId,
            "state" to stateName(state),
            "index" to e.index,
            "count" to e.count,
            "remainingMs" to e.remainingMs(t),
            "positionMs" to e.positionMs(t),
            "activeMs" to e.activeMs(t),
            "pausedMs" to e.pausedMs(t),
            "results" to resultMaps(e.results()),
            "voiceReady" to CuePlayer.voiceReady,
        )
    }

    private fun emit(state: SessionState = currentState()) {
        val map = stateMap(state) ?: return
        main.post { listener?.invoke(map) }
    }

    private fun saveCheckpoint(state: SessionState = currentState()) {
        val e = engine ?: return
        val p = program ?: return
        try {
            checkpoints.save(
                Checkpoint(p, state, e.snapshot(now()), e.results(), System.currentTimeMillis()),
            )
        } catch (ex: Exception) {
            Log.e(TAG, "checkpoint", ex)
        }
    }

    private val checkpointLoop = object : Runnable {
        override fun run() {
            synchronized(this@TimerService) {
                if (ended) return
                if (engine?.paused == false) saveCheckpoint()
                handler.postDelayed(this, CHECKPOINT_EVERY_MS)
            }
        }
    }

    private fun goForeground(): Boolean {
        val e = engine ?: return false
        val p = program ?: return false
        SessionNotification.ensureChannel(this, p.string("channel"))
        val n = SessionNotification.build(this, p, p.phases[e.index.coerceAtMost(e.count - 1)],
            e.paused, e.remainingMs(now()))
        return try {
            if (Build.VERSION.SDK_INT >= 34) {
                startForeground(SessionNotification.ID, n, ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE)
            } else {
                startForeground(SessionNotification.ID, n)
            }
            true
        } catch (ex: Exception) {
            // Sin permiso para el primer plano (p. ej. app restringida): queda el punto guardado.
            Log.e(TAG, "startForeground", ex)
            saveCheckpoint()
            stopSelf()
            false
        }
    }

    private fun updateNotification() {
        val e = engine ?: return
        val p = program ?: return
        if (ended || e.finished) return
        getSystemService(NotificationManager::class.java).notify(
            SessionNotification.ID,
            SessionNotification.build(this, p, p.phases[e.index], e.paused, e.remainingMs(now())),
        )
    }

    private fun acquireWake() {
        if (wakeLock?.isHeld == true) return
        wakeLock = getSystemService(PowerManager::class.java)
            .newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "trainloop:session")
            .apply { acquire(5 * 60 * 60 * 1000L) }
    }

    private fun releaseWake() {
        if (wakeLock?.isHeld == true) wakeLock?.release()
        wakeLock = null
    }

    /** Registro CSV solo en depuración (pruebas de precisión por adb). */
    private fun log(event: String, index: Int, target: Long, actual: Long) {
        val file = debugLog ?: return
        val pm = getSystemService(PowerManager::class.java)
        val late = if (target > 0) actual - target else 0
        val type = program?.phases?.getOrNull(index)?.type ?: "-"
        val line = "$event,${program?.sessionId},$index,$type,$target,$actual,$late," +
            "${pm.isInteractive},${pm.isDeviceIdleMode},${System.currentTimeMillis()}"
        Log.i(TAG, line)
        try {
            file.appendText(line + "\n")
        } catch (ex: Exception) {
            Log.e(TAG, "log", ex)
        }
    }
}
