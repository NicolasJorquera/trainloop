package com.trainloop.app.diagnostics

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test
import org.junit.rules.TemporaryFolder
import java.io.File
import java.util.Date

class CrashLogTest {
    @get:Rule
    val tmp = TemporaryFolder()

    private fun entries(file: File) =
        file.readText().split(CrashLog.SEPARATOR).map { it.trim() }.filter { it.isNotEmpty() }

    @Test
    fun guardaSoloLasUltimas() {
        val file = File(tmp.root, "diagnostics/native_crashes.log")
        for (i in 1..8) CrashLog.append(file, "error $i\nlinea", max = 5)
        val kept = entries(file)
        assertEquals(5, kept.size)
        assertEquals("error 4\nlinea", kept.first())
        assertEquals("error 8\nlinea", kept.last())
        assertTrue(!File(file.path + ".tmp").exists())
    }

    @Test
    fun describeIncluyeHiloFechaYPila() {
        val text = CrashLog.describe("TimerEngine", IllegalStateException("boom"), Date(0))
        assertTrue(text.startsWith("[1970-01-01T00:00:00.000Z] thread=TimerEngine"))
        assertTrue(text.contains("java.lang.IllegalStateException: boom"))
        assertTrue(text.length <= CrashLog.MAX_CHARS)
    }
}
