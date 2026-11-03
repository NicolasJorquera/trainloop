package com.trainloop.app.timer

import org.json.JSONArray
import org.json.JSONObject
import java.io.File
import java.io.FileOutputStream
import java.nio.file.Files
import java.nio.file.StandardCopyOption

/** Fase tal como la envía Flutter: textos ya localizados y color de la fase (ARGB). */
data class PhaseSpec(
    val type: String,
    val title: String,
    val speech: String,
    val durationMs: Long,
    val color: Int,
)

/** Programa de una sesión: fases, preferencias de avisos y textos de la notificación. */
data class TimerProgram(
    val sessionId: String,
    val title: String,
    val locale: String,
    val sounds: Boolean,
    val voice: Boolean,
    val vibration: Boolean,
    val strings: Map<String, String>,
    val phases: List<PhaseSpec>,
) {
    fun string(key: String): String = strings[key] ?: key

    fun toJson(): JSONObject = JSONObject()
        .put("sessionId", sessionId).put("title", title).put("locale", locale)
        .put("sounds", sounds).put("voice", voice).put("vibration", vibration)
        .put("strings", JSONObject(strings))
        .put("phases", JSONArray(phases.map {
            JSONObject().put("type", it.type).put("title", it.title).put("speech", it.speech)
                .put("durationMs", it.durationMs).put("color", it.color)
        }))

    companion object {
        fun fromJson(o: JSONObject): TimerProgram {
            val s = o.getJSONObject("strings")
            val p = o.getJSONArray("phases")
            return TimerProgram(
                sessionId = o.getString("sessionId"),
                title = o.getString("title"),
                locale = o.getString("locale"),
                sounds = o.getBoolean("sounds"),
                voice = o.getBoolean("voice"),
                vibration = o.getBoolean("vibration"),
                strings = s.keys().asSequence().associateWith { s.getString(it) },
                phases = (0 until p.length()).map { i ->
                    val f = p.getJSONObject(i)
                    PhaseSpec(f.getString("type"), f.getString("title"), f.getString("speech"),
                        f.getLong("durationMs"), f.getInt("color"))
                },
            )
        }

        /** Desde el mapa del MethodChannel. */
        @Suppress("UNCHECKED_CAST")
        fun fromMap(m: Map<String, Any?>): TimerProgram = TimerProgram(
            sessionId = m["sessionId"] as String,
            title = m["title"] as String,
            locale = m["locale"] as String,
            sounds = m["sounds"] as Boolean,
            voice = m["voice"] as Boolean,
            vibration = m["vibration"] as Boolean,
            strings = m["strings"] as Map<String, String>,
            phases = (m["phases"] as List<Map<String, Any?>>).map {
                PhaseSpec(it["type"] as String, it["title"] as String, it["speech"] as String,
                    (it["durationMs"] as Number).toLong(), (it["color"] as Number).toLong().toInt())
            },
        )
    }
}

/** Estado de la sesión en el punto de recuperación. */
enum class SessionState { RUNNING, PAUSED, FINISHED, STOPPED }

/** Todo lo necesario para recuperar o cerrar una sesión sin la interfaz. */
data class Checkpoint(
    val program: TimerProgram,
    val state: SessionState,
    val snapshot: EngineSnapshot,
    val results: List<PhaseResult>,
    val savedAtWallMs: Long,
) {
    fun toJson(): String = JSONObject()
        .put("version", 1)
        .put("program", program.toJson())
        .put("state", state.name)
        .put("snapshot", JSONObject()
            .put("index", snapshot.index).put("positionMs", snapshot.positionMs)
            .put("activeMs", snapshot.activeMs).put("pausedMs", snapshot.pausedMs)
            .put("entryActiveMs", snapshot.entryActiveMs))
        .put("results", JSONArray(results.map {
            JSONObject().put("index", it.index).put("plannedMs", it.plannedMs)
                .put("actualMs", it.actualMs).put("skipped", it.skipped)
        }))
        .put("savedAtWallMs", savedAtWallMs)
        .toString()

    companion object {
        fun fromJson(text: String): Checkpoint {
            val o = JSONObject(text)
            val s = o.getJSONObject("snapshot")
            val r = o.getJSONArray("results")
            return Checkpoint(
                program = TimerProgram.fromJson(o.getJSONObject("program")),
                state = SessionState.valueOf(o.getString("state")),
                snapshot = EngineSnapshot(s.getInt("index"), s.getLong("positionMs"),
                    s.getLong("activeMs"), s.getLong("pausedMs"), s.getLong("entryActiveMs")),
                results = (0 until r.length()).map { i ->
                    val x = r.getJSONObject(i)
                    PhaseResult(x.getInt("index"), x.getLong("plannedMs"), x.getLong("actualMs"),
                        x.getBoolean("skipped"))
                },
                savedAtWallMs = o.getLong("savedAtWallMs"),
            )
        }
    }
}

/**
 * Punto de recuperación en un archivo propio, con escritura atómica: se escribe un temporal, se
 * sincroniza con el disco y se renombra sobre el anterior. Un cierre a la fuerza en medio deja
 * siempre el punto anterior completo (el spike perdió hasta 10,7 s con SharedPreferences.apply).
 */
class CheckpointStore(private val file: File) {

    private val tmp = File(file.parentFile, file.name + ".tmp")

    @Synchronized
    fun save(checkpoint: Checkpoint) = write(checkpoint.toJson())

    @Synchronized
    fun write(text: String) {
        FileOutputStream(tmp).use { out ->
            out.write(text.toByteArray(Charsets.UTF_8))
            out.fd.sync()
        }
        Files.move(tmp.toPath(), file.toPath(),
            StandardCopyOption.ATOMIC_MOVE, StandardCopyOption.REPLACE_EXISTING)
    }

    /** El último punto completo, o `null` si no hay o está dañado (el temporal se ignora). */
    @Synchronized
    fun load(): Checkpoint? = try {
        if (file.exists()) Checkpoint.fromJson(file.readText(Charsets.UTF_8)) else null
    } catch (e: Exception) {
        null
    }

    @Synchronized
    fun clear() {
        file.delete()
        tmp.delete()
    }

    companion object {
        const val FILE_NAME = "timer_checkpoint.json"
    }
}
