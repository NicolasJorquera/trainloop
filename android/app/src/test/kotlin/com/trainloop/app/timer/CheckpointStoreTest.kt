package com.trainloop.app.timer

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Rule
import org.junit.Test
import org.junit.rules.TemporaryFolder
import java.io.File

class CheckpointStoreTest {

    @get:Rule
    val tmp = TemporaryFolder()

    private fun program() = TimerProgram(
        sessionId = "s1",
        title = "Tabata 20/10",
        locale = "es-419",
        sounds = true,
        voice = false,
        vibration = true,
        strings = mapOf("pause" to "Pausar", "skip" to "Saltar"),
        phases = listOf(
            PhaseSpec("prepare", "Preparación", "Prepárate", 10_000, 0xFF0E0F11.toInt()),
            PhaseSpec("work", "Trabajo · Ronda 1/8", "Trabajo", 20_000, 0xFFD45CFF.toInt()),
        ),
    )

    private fun checkpoint(position: Long) = Checkpoint(
        program = program(),
        state = SessionState.RUNNING,
        snapshot = EngineSnapshot(1, position, position, 0, 10_000),
        results = listOf(PhaseResult(0, 10_000, 10_000, false)),
        savedAtWallMs = 1_700_000_000_000,
    )

    @Test
    fun `guarda y lee el punto completo`() {
        val store = CheckpointStore(File(tmp.root, CheckpointStore.FILE_NAME))
        assertNull(store.load())
        val cp = checkpoint(15_000)
        store.save(cp)
        assertEquals(cp, store.load())
        store.clear()
        assertNull(store.load())
    }

    @Test
    fun `cada escritura reemplaza la anterior y no deja temporales`() {
        val store = CheckpointStore(File(tmp.root, CheckpointStore.FILE_NAME))
        for (i in 1..200) store.save(checkpoint(i * 1_000L))
        assertEquals(200_000L, store.load()!!.snapshot.positionMs)
        assertEquals(listOf(CheckpointStore.FILE_NAME), tmp.root.list()!!.toList())
    }

    @Test
    fun `un cierre en medio de la escritura deja el punto anterior completo`() {
        val file = File(tmp.root, CheckpointStore.FILE_NAME)
        val store = CheckpointStore(file)
        store.save(checkpoint(20_000))
        // Simula un kill -9 mientras se escribía: temporal a medias, sin renombrar.
        val partial = checkpoint(25_000).toJson()
        File(tmp.root, CheckpointStore.FILE_NAME + ".tmp").writeText(partial.take(partial.length / 2))
        assertEquals(20_000L, store.load()!!.snapshot.positionMs)
        // La siguiente escritura lo pisa sin problema.
        store.save(checkpoint(30_000))
        assertEquals(30_000L, store.load()!!.snapshot.positionMs)
    }

    @Test
    fun `un archivo dañado no rompe la app`() {
        val file = File(tmp.root, CheckpointStore.FILE_NAME)
        file.writeText("{\"version\":1,")
        assertNull(CheckpointStore(file).load())
        assertFalse(File(tmp.root, CheckpointStore.FILE_NAME + ".tmp").exists())
    }

    @Test
    fun `el programa viaja intacto, con colores negativos incluidos`() {
        val p = program()
        assertEquals(p, TimerProgram.fromJson(p.toJson()))
        val fromChannel = TimerProgram.fromMap(
            mapOf(
                "sessionId" to "s1", "title" to "Tabata 20/10", "locale" to "es-419",
                "sounds" to true, "voice" to false, "vibration" to true,
                "strings" to mapOf("pause" to "Pausar", "skip" to "Saltar"),
                "phases" to listOf(
                    mapOf("type" to "prepare", "title" to "Preparación", "speech" to "Prepárate",
                        "durationMs" to 10_000, "color" to 0xFF0E0F11L),
                    mapOf("type" to "work", "title" to "Trabajo · Ronda 1/8", "speech" to "Trabajo",
                        "durationMs" to 20_000L, "color" to 0xFFD45CFFL),
                ),
            ),
        )
        assertEquals(p, fromChannel)
    }
}
