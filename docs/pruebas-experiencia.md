# Pruebas de experiencia y accesibilidad (D7)

Emulador `emulator-5560` (Android 16, API 36, 1080 × 2400), build de depuración, fecha 2026-11-03. Pruebas cortas por decisión del usuario: unos 20 min de emulador y ninguna sesión larga.

Criterio de D7 (docs/arquitectura.md): «NF-01 y NF-08 cumplidos; respaldo restaurado en un emulador limpio; TalkBack recorre J1–J3. App completa sin anuncios».

## 1. Pruebas automáticas

`flutter test`: 227 pruebas, todas pasan (~22 s). `./gradlew testDebugUnitTest`: 29 pruebas JVM (4 nuevas del recordatorio).

| Área | Archivo | Qué prueba |
|---|---|---|
| Respaldo | `test/features/backup/backup_test.dart` | Ida y vuelta de una base con datos (historial de D6 + datos de prueba + recordatorio): todas las tablas idénticas, aunque el destino tenía otros datos. Copia automática previa que a su vez se restaura. Respaldo de una base **v4** (con caché de récords vieja) que se migra a v5 y recalcula los récords. Rechazos: archivo cualquiera, versión más nueva, sentencias que no son CREATE, columnas con nombres raros, clave foránea rota (sin tocar la base), sesión en curso. |
| CSV | `test/features/backup/csv_export_test.dart` | Una fila por sesión del historial en orden, fechas ISO con −03:00, volumen en kg con punto; series solo hechas; escape de comas, comillas y saltos de línea. |
| S17 | `test/features/backup/backup_screen_test.dart` | Crear (nombre del archivo y «Último respaldo»), cancelar el selector, restaurar con resumen y confirmación, archivo inválido y CSV en dos archivos. |
| Recordatorios | `test/features/reminders/reminder_test.dart` y `ReminderSchedulerTest.kt` | Próximo aviso (hoy, otro día, semana siguiente, la hora exacta no se repite, cambio de horario de verano), máximo uno por día, una fila por día en la base, el controlador envía al lado nativo y relee tras restaurar, S16 pide permiso y queda apagado si se niega. |
| F-01 / NF-01 | `test/features/home/first_use_test.dart` | Primera apertura sin campos de texto; Tabata corriendo en 3 toques; el aviso se cierra para siempre y abre S17. |
| NF-08 | `test/a11y/accessibility_test.dart` | Fuentes reales, teléfono de 411 × 914 dp, 100 % y 200 %: Inicio, Entrenar (intervalos y rutinas), S07, Historial, Progreso, S03, S05, S10 (con descanso), S16 y S17. Sin desbordes ni textos cortados; `androidTapTargetGuideline` y `labeledTapTargetGuideline` al 100 %; 64 dp en S05 y S10 en ambos tamaños; la fase de S05 se anuncia con su nombre. |
| Contraste | `test/core/theme/contrast_test.dart` | WCAG AA en claro y oscuro con los 8 acentos: ink, inkMuted, acento, danger, success, warning e intervalos sobre bg, surface1 y surface2 (4,5:1); acento sobre su fondo suave; texto de botones; fases (4,5:1); acento frente a la barra apagada y botón frente al fondo (3:1). |
| Otros | `settings_repository_test`, `routine_flow_test`, `pseudo_locale_test`, `app_info_test` | Nuevas preferencias, «¿Descartar los cambios?» del editor de rutina, S16 y S17 en en-XA y `appVersion` = pubspec. |

## 2. Criterios

### NF-01: primer entrenamiento en menos de 30 s y sin formularios

Desde un emulador limpio (`pm clear`, idioma por app es-419):

- **Toques:** Tabata 20/10 → EMPEZAR → CONTINUAR (explicación del permiso, una sola vez) → Permitir (diálogo de Android). Son 3 toques en la app más 1 del sistema. Si la persona elige «Ahora no · empezar igual», también son 3.
- **Formularios:** 0. No hay cuenta, registro ni campos de texto en el camino.
- **Tiempo:** 17,6 s desde `am start` hasta ver «Fase 1 de 16», con 1 s entre toques por adb. Incluye un arranque en frío de 8,3 s del build de depuración recién limpiado (en otras aperturas, 3,1–4,1 s) y la demora de la detección por `uiautomator`. Cumple el umbral. NF-02 (arranque en frío) se mide en release en D9.

### NF-08: accesibilidad

| Punto | Estado | Cómo |
|---|---|---|
| TalkBack en todas las pantallas | Cumple en J1–J3 y D7 | Etiquetas verificadas por prueba (`labeledTapTargetGuideline`) y en el emulador con TalkBack (ver abajo). |
| Texto al 200 % sin cortes | Cumple en las pantallas probadas | Prueba de widgets al 200 % con fuentes reales y captura en el emulador. Con letra grande, la barra inferior crece y achica la etiqueta para no cortarla; los acentos pasan a 2 columnas; la vista previa de fases se apila; S14 saca la cifra y la leyenda del objetivo fuera de las barras. |
| Contraste WCAG AA | Cumple | Prueba de contraste. En el tema claro se oscurecieron naranja (`#A84B0E`), amarillo (`#806200`), lima (`#47730E`), success (`#247534`), warning (`#A15300`), danger (`#C52929`) e intervalos (`#0A7368`). También en `docs/design/system/tokens.json`. |
| Áreas táctiles ≥ 48 dp | Cumple | Segmentos, chips, días de la semana y días del plan pasaron de 40–44 a 48 dp. |
| ≥ 64 dp durante la sesión | Cumple en S05 y S10 | Detener, bloquear, volver, TERMINAR, celdas de peso y reps, ✓, agregar serie o ejercicio y menú del ejercicio. |
| Fase nunca solo por color | Cumple | S05 muestra y anuncia el nombre de la fase («PREPÁRATE», «TRABAJO») y su forma (`PhaseGlyph`); la semana usa letras F/I; S14 marca la semana actual con su texto. |

### Respaldo restaurado en un emulador limpio

1. Con los datos que ya tenía el emulador, S17 → CREAR RESPALDO → Descargas → Guardar: `trainloop-2026-11-03.json.gz` (11,9 KB). EXPORTAR CSV guardó los dos CSV (862 B y 1,1 KB), con el contenido esperado.
2. `pm clear` (también se usó para NF-01).
3. S17 → RESTAURAR RESPALDO → el archivo → «Respaldo del 3 nov 2026: 5 sesiones, 1 rutina, 1 entrenamiento de intervalos» → RESTAURAR → «Respaldo restaurado».
4. Conteos de la base antes → después (copia por `run-as` + `sqlite3`): exercise 105 → 105, strength_routine 1 → 1, routine_exercise 2 → 2, interval_workout 1 → 1, interval_block 3 → 3, session 8 → 8, session_exercise 3 → 3, set_log 6 → 6, interval_phase_log 65 → 65, personal_record 9 → 9. Las filas de `session` y `set_log` son idénticas. Quedó `files/backups/antes-de-restaurar.json.gz` (2,2 KB).

**Cumple.** La restauración desde un esquema anterior se probó en Dart (v4 → v5), no en el emulador.

### TalkBack recorre J1–J3

TalkBack se activó con `settings put secure enabled_accessibility_services …TalkBackService`. Con `uiautomator dump` se revisaron las etiquetas de:

- Inicio;
- J1: S03 Tabata y S05 en curso;
- J2: Entrenar (intervalos) y S04 editor;
- J3: Entrenar (rutinas), S07 editor, S10 con series y el diálogo «Ninguna serie hecha».

Todos los botones tienen nombre:

- S05: «Volver al inicio de la fase», «Pausar», «Saltar a la siguiente fase», «Mantén presionado para detener la sesión» y «Bloquear controles».
- S10: «60, Editar peso, Press de banca con barra · serie 1» y «Completar Press de banca con barra · serie 1».
- S04: «Restar 5 segundos a Trabajo».

Con TalkBack se activaron por doble toque Inicio → REPETIR ÚLTIMO (S10) y TERMINAR. El doble toque por adb resultó inestable, así que el resto del recorrido se hizo sin TalkBack y se volvió a activar solo para el volcado de cada pantalla. **Cumple, con esa salvedad.**

### App completa sin anuncios

No hay espacios reservados ni código de anuncios: la franja «Anuncio · banner» de Main y las filas de anuncios de S16 (estadísticas, consentimiento y quitar anuncios) quedan para D8.

## 3. Capturas

En `scratchpad/d7-shots/` (fuera del repositorio):

- `primer-uso-aviso.png`
- `s16-configuracion-1..3.png`
- `s17-respaldo.png`, `s17-respaldo-creado.png`, `s17-confirmar-restauracion.png`, `s17-restaurado.png`
- `texto-200-inicio.png`, `texto-200-s16.png`
- `s12-semana-final.png`
- `talkback-s03.png`, `talkback-s05.png`, `talkback-s10.png`

## 4. Decisiones

- **Formato del respaldo:** JSON versionado y comprimido con gzip, como define la arquitectura, en vez de copiar el SQLite. Se valida sin abrir un archivo ajeno como base viva, lleva el esquema de su versión y reutiliza las migraciones de Drift al restaurar (NF-06: «los respaldos se restauran entre versiones»).
- **Recordatorios sin paquete:** se usa AlarmManager inexacto nativo y no `flutter_local_notifications`. Se evitan `timezone` y una dependencia más. La regla «no avisar si ya entrenó ese día» necesita código al sonar, y el proyecto ya tiene Kotlin, canales y notificaciones. No se usan alarmas exactas.
- **SAF nativo** (`DocumentsBridge`) en vez de `file_picker`: dos intents, sin permisos ni dependencias.
- **CSV en dos guardados seguidos**, no en un zip: así se abren directo en una hoja de cálculo.

## 5. Desviaciones del PRD y del diseño

- El aviso de datos locales aparece desde la primera apertura (F-01 y la nota final del PRD), no «tras la primera sesión» (J5). Es descartable y abre S17.
- El diseño de S17 nombra el archivo `.json`; se usa `.json.gz`, como dice la arquitectura.
- S16:
  - Las opciones del diseño «aviso de mitad», «mantener pantalla encendida» y «durante una llamada: pausar» no se implementaron, porque el motor no las soporta (deuda de D4). F-17 no las exige.
  - Estadísticas, consentimiento y «Quitar anuncios» quedan para D8.
  - Los recordatorios no estaban en el diseño de S16: se agregó una sección propia.
- El descanso por defecto se aplica a los ejercicios propios nuevos. Los de la biblioteca conservan el suyo y el respaldo R-G8 sigue en 90 s.
- El diálogo S18-d (objetivo semanal tras la primera sesión con días preferidos) no se implementó: el objetivo está en S16 y los días de recordatorio en su sección.
- Los tokens de color del tema claro cambiaron levemente para cumplir AA (ver NF-08).
- Con letra grande, las etiquetas de la barra inferior se achican para caber en vez de crecer al 200 %.

## 6. Deuda

- **Pendiente para Legal/Administración:** la política de privacidad debe mencionar el respaldo automático de Android en Google Drive y el archivo de respaldo y los CSV exportados por la persona.
- **TalkBack:**
  - El recorrido completo con gestos reales (doble toque, mantener para detener) queda para un teléfono real (D9).
  - En la lista de rutinas, el ▶ «Empezar Empuje» queda fusionado con la tarjeta.
  - El nodo de «ENTRENAMIENTO LIBRE» se superpone en el árbol de semántica.
  - En S04, la duración («0:20») no dice de qué fase es.
  - La leyenda de la semana (S12) no aparece en el volcado de `uiautomator`. Hay que revisarlo con TalkBack.
- **Deuda de D6:** la leyenda de S12 se ve completa sobre la barra de navegación al desplazar (captura `s12-semana-final.png`) y no se cambió. La etiqueta «objetivo» de S14 está resuelta.
- **Pantallas al 200 %:** no entraron en la prueba automática S06, S08, S09, S11, S13 y S15, ni los diálogos.
- **Restauración:**
  - Corre en el hilo principal (la base temporal es `NativeDatabase.memory`). Con miles de sesiones puede trabar la interfaz unos instantes.
  - No restaura las preferencias (no van en el respaldo).
  - La copia previa a restaurar guarda solo la última.
- **Recordatorios:**
  - No se probaron en el emulador: alarma real, reinicio y cambio de hora.
  - La regla de 14 días sin actividad (reenganche) no está implementada.
  - Tampoco la sugerencia de respaldo en Progreso tras más de 10 sesiones.
- **CSV:**
  - Usa los nombres en el idioma de la app, no un idioma neutro.
  - Requiere dos diálogos.
- **Emulador:** NF-01 medido con un build de depuración. El arranque en frío de release se mide en D9 (NF-02).

## 7. Estado en que quedó el emulador

- App en español (`settings.language = es`) y sin idioma por app.
- TalkBack apagado (`enabled_accessibility_services` = null, `accessibility_enabled` = 0) y letra al 100 %.
- Se quitó la marca temporal `user-fixed` del permiso de notificaciones de TalkBack. Queda «no permitido», con USER_SET: el diálogo de TalkBack se respondió «No permitir».
- Se borraron de Descargas el respaldo y los CSV de prueba.
- La base es la restaurada, con 2 sesiones descartadas más de las pruebas (Tabata de NF-01 y la sesión vacía de S10). No cuentan en el historial.
- Las preferencias perdieron por `pm clear` la fecha del último respaldo.
