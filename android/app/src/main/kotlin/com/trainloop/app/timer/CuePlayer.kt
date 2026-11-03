package com.trainloop.app.timer

import android.content.Context
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.media.ToneGenerator
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.speech.tts.TextToSpeech
import android.speech.tts.UtteranceProgressListener
import android.util.Log
import java.util.Locale

/**
 * Pitidos, voz y vibración (R-I7). Vive en el proceso (no en el servicio) para precalentar la voz
 * al abrir la app y al entrar en S03: así el primer aviso ya habla.
 *
 * - Pide foco de audio transitorio con atenuación, pero no depende de él: Android 16 lo ignora
 *   desde segundo plano y los avisos suenan igual.
 * - Durante una llamada no suena nada; la vibración sigue (se consulta el modo de audio, sin
 *   pedir el permiso de estado del teléfono).
 * - Sin voz para el idioma, el aviso de fase usa un pitido de respaldo.
 */
object CuePlayer {

    private const val TAG = "TrainloopCue"

    private val handler = Handler(Looper.getMainLooper())
    private var tts: TextToSpeech? = null
    private var ttsReady = false
    private var ttsLocale: String? = null
    private var pending = mutableListOf<(Boolean) -> Unit>()
    private var tone: ToneGenerator? = null
    private var focus: AudioFocusRequest? = null

    /** Hay voz sin conexión para el idioma pedido. */
    val voiceReady: Boolean get() = ttsReady

    /** Inicia el TTS (si hace falta) con [languageTag] y avisa si hay voz para ese idioma. */
    fun prewarm(context: Context, languageTag: String, onReady: ((Boolean) -> Unit)? = null) {
        val app = context.applicationContext
        val engine = tts
        if (engine == null) {
            ttsLocale = languageTag
            onReady?.let { pending += it }
            tts = TextToSpeech(app) { status ->
                ttsReady = status == TextToSpeech.SUCCESS && applyLanguage(languageTag)
                tts?.setOnUtteranceProgressListener(progress(app))
                Log.i(TAG, "tts init status=$status ready=$ttsReady lang=$languageTag")
                val callbacks = pending
                pending = mutableListOf()
                callbacks.forEach { it(ttsReady) }
            }
            return
        }
        if (onReady != null && pending.isNotEmpty()) {
            // Aún iniciando: responde al terminar.
            pending += onReady
            return
        }
        if (ttsLocale != languageTag) {
            ttsLocale = languageTag
            ttsReady = applyLanguage(languageTag)
        }
        onReady?.invoke(ttsReady)
    }

    /** Si el motor de voz falla al hablar, se reinicia ya para que el próximo aviso hable. */
    private fun progress(app: Context) = object : UtteranceProgressListener() {
        override fun onStart(utteranceId: String?) = Unit

        override fun onDone(utteranceId: String?) {
            Log.i(TAG, "tts done $utteranceId")
        }

        @Deprecated("Deprecated in Java")
        override fun onError(utteranceId: String?) = onError(utteranceId, TextToSpeech.ERROR)

        override fun onError(utteranceId: String?, errorCode: Int) {
            Log.w(TAG, "tts error $utteranceId code=$errorCode: restarting")
            handler.post { restart(app) }
        }
    }

    private fun restart(context: Context) {
        tts?.shutdown()
        tts = null
        ttsReady = false
        ttsLocale?.let { prewarm(context, it) }
    }

    private fun applyLanguage(tag: String): Boolean {
        val engine = tts ?: return false
        val res = engine.setLanguage(Locale.forLanguageTag(tag))
        engine.setAudioAttributes(attributes(AudioAttributes.CONTENT_TYPE_SPEECH))
        return res != TextToSpeech.LANG_MISSING_DATA && res != TextToSpeech.LANG_NOT_SUPPORTED
    }

    /**
     * Inicio de fase: tono + voz con su etiqueta y vibración del tipo de fase. Devuelve `true` si
     * la voz habló (para el registro de depuración).
     */
    fun phaseStart(context: Context, program: TimerProgram, phase: PhaseSpec, id: String): Boolean {
        var spoke = false
        val audible = audioAllowed(context)
        if (audible && (program.sounds || program.voice)) {
            withFocus(context) {
                if (program.sounds) tone()?.startTone(ToneGenerator.TONE_PROP_ACK, 200)
                if (program.voice && ttsReady) spoke = speak(context, phase.speech, id)
                if (program.voice && !spoke && !program.sounds) {
                    // Respaldo sin voz para el idioma: un pitido marca la fase.
                    tone()?.startTone(ToneGenerator.TONE_PROP_ACK, 200)
                }
            }
        }
        if (program.vibration) vibrate(context, patternFor(phase.type))
        return spoke
    }

    /** Si el servicio de voz murió, se vuelve a iniciar para el próximo aviso. */
    private fun speak(context: Context, text: String, id: String): Boolean {
        val ok = tts?.speak(text, TextToSpeech.QUEUE_FLUSH, null, id) == TextToSpeech.SUCCESS
        if (!ok) {
            Log.w(TAG, "tts speak failed: restarting")
            restart(context)
        }
        return ok
    }

    /** Pitido 3-2-1 de los últimos segundos. */
    fun countdown(context: Context, program: TimerProgram) {
        if (!program.sounds || !audioAllowed(context)) return
        withFocus(context) { tone()?.startTone(ToneGenerator.TONE_PROP_BEEP, 120) }
    }

    /** Sonido final distinto + vibración larga. */
    fun finish(context: Context, program: TimerProgram, speech: String?) {
        if (audioAllowed(context)) {
            withFocus(context) {
                if (program.sounds) tone()?.startTone(ToneGenerator.TONE_CDMA_ALERT_CALL_GUARD, 600)
                if (program.voice && ttsReady && speech != null) {
                    tts?.speak(speech, TextToSpeech.QUEUE_ADD, null, "finish")
                }
            }
        }
        if (program.vibration) vibrate(context, longArrayOf(0, 900))
    }

    fun stopSpeaking() {
        tts?.stop()
    }

    /** Patrón de vibración propio de cada tipo de fase (R-I2). */
    fun patternFor(type: String): LongArray? = when (type) {
        "work" -> longArrayOf(0, 600)
        "rest" -> longArrayOf(0, 150, 120, 150)
        "warmup" -> longArrayOf(0, 300)
        "cooldown" -> longArrayOf(0, 300, 200, 300, 200, 300)
        else -> null
    }

    /** Sin llamada en curso ni sonando: los avisos pueden sonar. */
    fun audioAllowed(context: Context): Boolean {
        val mode = context.getSystemService(AudioManager::class.java).mode
        return mode != AudioManager.MODE_IN_CALL && mode != AudioManager.MODE_IN_COMMUNICATION &&
            mode != AudioManager.MODE_RINGTONE
    }

    private fun tone(): ToneGenerator? = tone ?: try {
        ToneGenerator(AudioManager.STREAM_MUSIC, 90).also { tone = it }
    } catch (e: RuntimeException) {
        null
    }

    private fun attributes(content: Int) = AudioAttributes.Builder()
        .setUsage(AudioAttributes.USAGE_ASSISTANCE_SONIFICATION)
        .setContentType(content)
        .build()

    private fun withFocus(context: Context, block: () -> Unit) {
        appContext = context.applicationContext
        val am = context.getSystemService(AudioManager::class.java)
        val req = focus ?: AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK)
            .setAudioAttributes(attributes(AudioAttributes.CONTENT_TYPE_SONIFICATION))
            .build().also { focus = it }
        val granted = am.requestAudioFocus(req)
        if (granted != AudioManager.AUDIOFOCUS_REQUEST_GRANTED) Log.i(TAG, "audio focus: $granted")
        block()
        handler.removeCallbacks(abandon)
        handler.postDelayed(abandon, 2_500)
    }

    private val abandon = Runnable { abandonFocus() }

    private var appContext: Context? = null

    private fun abandonFocus() {
        val req = focus ?: return
        appContext?.getSystemService(AudioManager::class.java)?.abandonAudioFocusRequest(req)
    }

    private fun vibrate(context: Context, pattern: LongArray?) {
        if (pattern == null) return
        val v: Vibrator = if (Build.VERSION.SDK_INT >= 31) {
            context.getSystemService(VibratorManager::class.java).defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            context.getSystemService(Vibrator::class.java)
        }
        v.vibrate(VibrationEffect.createWaveform(pattern, -1))
    }

    /** El volumen multimedia está en 0 (R-I8: se avisa antes de empezar). */
    fun mediaVolumeIsZero(context: Context): Boolean =
        context.getSystemService(AudioManager::class.java)
            .getStreamVolume(AudioManager.STREAM_MUSIC) == 0
}
