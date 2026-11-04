# Trainloop

Cuaderno de entrenamiento para Android: temporizador de intervalos y registro de fuerza, sin cuenta y offline. Flutter (Android primero), Riverpod, go_router y localización ARB/ICU.

Estado: **entregable 5, registro de fuerza.** D1 dejó el sistema de diseño (Pizarra de hierro), las 4 pestañas con estados vacíos, la pantalla de Configuración (tema, acento e idioma) y CI. D2 agregó la base SQLite con Drift (14 tablas, DAOs, migraciones con pruebas), las preferencias y el respaldo automático de Android. D3 agregó la biblioteca de ejercicios (105 incluidos y propios, con búsqueda y filtros) y las rutinas de fuerza. D4 agregó el temporizador de intervalos: editor, plantillas, motor nativo en un servicio en primer plano, avisos, notificación, recuperación y resumen. D5 agrega la sesión de fuerza con descanso automático en el mismo servicio, el resumen y la unidad kg/lb. Siguen: historial y estadísticas (D6), y anuncios y consentimiento (D8).

## Cómo correrla

Requisitos: Flutter 3.41 stable y un emulador o teléfono con Android 8.0 (API 26) o superior.

```sh
# Los repos personales resuelven paquetes desde pub.dev (hay un mirror global del trabajo).
export PUB_HOSTED_URL=https://pub.dev

flutter pub get
flutter run                  # depuración
flutter test --timeout 60s   # pruebas (el límite evita procesos colgados)
flutter analyze              # lints
flutter build apk --debug    # APK en build/app/outputs/flutter-apk/
```

`pubspec.lock` debe apuntar a `https://pub.dev`. Si ves `jfrog` en el lockfile, exporta la variable y vuelve a correr `flutter pub get`.

## Estructura

```
lib/
  main.dart                     arranque: abre shared_preferences y monta ProviderScope
  data/db/                      base Drift: tables.dart (esquema), enums, convertidores,
                                app_database.dart, daos/ (uno por agregado), providers
                                y demo_seed.dart (solo depuración). *.g.dart es generado
  data/catalog/                 biblioteca incluida (exercise_catalog.dart, nombres es/en/pt)
                                y su siembra idempotente
  app/                          TrainloopApp (MaterialApp.router) y AppShell (barra inferior)
  core/
    units/                      WeightUnit (kg/lb ↔ gramos)
    theme/                      tokens (TlColors, TlSpace, TlRadius, TlSize), TlText, acentos,
                                regla de colores de fase (phasePaletteFor) y buildTrainloopTheme
    l10n/                       idiomas soportados, resolución de locale y pseudo-locale
    router/                     go_router: StatefulShellRoute con 4 ramas + /settings
    widgets/                    componentes del sistema: TlButton, TlBottomNav,
                                TlSegmentedControl, AccentPicker, PhaseGlyph, EmptyState…
  features/<feature>/           por funcionalidad: domain / data / application / presentation
    home, train, history, progress, settings, exercises (S08/S09), routines (S07),
    intervals (S02–S06, S18: editor, plantillas, temporizador, resumen, recuperación),
    strength (S10, S11, S06 fuerza: sesión, registro de serie, resumen, recuperación)
  platform/                     puente con el motor nativo del temporizador (canales)
android/app/src/main/kotlin/com/trainloop/app/timer/
                                TimerService, TimerEngine, CuePlayer, SessionNotification,
                                CheckpointStore, RestTimer (descanso de fuerza) y TimerBridge
                                (MethodChannel/EventChannel)
android/app/src/test/           pruebas JVM del motor y del punto de recuperación
  l10n/                         ARB (fuente) y gen/ (generado por flutter gen-l10n)
assets/fonts/                   Barlow Condensed e Inter (OFL, empaquetadas: no se descargan)
docs/design/                    copia del sistema de diseño (system/) y prototipos HTML (screens/)
docs/modelo-datos.md            modelo de datos del PRD y decisiones de persistencia
drift_schemas/                  esquema de cada versión de la base (JSON, para migraciones)
tool/                           script del pseudo-locale y timer_adb.sh (pruebas del
                                temporizador por adb)
test/                           unitarias (tokens, fases, pseudo, repositorio, DAOs), de widgets
                                y drift/ (migraciones; generated/ es generado)
```

Cada entregable nuevo agrega su carpeta en `lib/features/` y, si hace falta, una rama o ruta en `lib/core/router/app_router.dart`.

## Ejercicios y rutinas (D3)

- **Biblioteca incluida.** `lib/data/catalog/exercise_catalog.dart` lista 105 ejercicios con clave estable (`bench_press_barbell`), músculo, equipo, tipo de registro, incremento y descanso, y su nombre en es, en y pt-BR. La base guarda la clave en `exercise.catalog_key`; la pantalla muestra el nombre del idioma activo (`exerciseName`), así cambiar de idioma renombra la biblioteca sin reiniciar. En en-XA el nombre se pseudo-localiza. Los ejercicios propios guardan el nombre literal.
- **Siembra.** `seedExerciseCatalog` inserta solo las claves que faltan (índice único en `catalog_key`); corre al abrir la biblioteca. Para ampliar la biblioteca basta con agregar entradas con claves nuevas. Nunca cambies ni reutilices una clave.
- **Búsqueda y duplicados.** La búsqueda compara el nombre visible sin mayúsculas ni tildes. Al crear un ejercicio propio, `findDuplicateExercise` lo compara con los propios y con los incluidos en los 3 idiomas («plank» choca con «Plancha»): avisa, no deja guardar y ofrece usar el existente.
- **Rutinas.** El editor maneja series iguales por ejercicio (series, reps o tiempo, peso opcional y descanso); al agregar un ejercicio toma 3 × 10 (o 3 × 0:45 si es por tiempo) y su descanso por defecto. El peso se escribe y se muestra en la unidad de la persona. Guardar reemplaza los ejercicios de la plantilla; las sesiones pasadas no cambian porque guardan su copia en `template_snapshot` (lo prueba `test/features/routines/routine_repository_test.dart`). Archivar es borrado lógico con "Deshacer".

## Temporizador de intervalos (D4)

- **Estructura.** Un entrenamiento es una lista de bloques: intervalos (calentamiento, trabajo, descanso, vuelta a la calma, con etiqueta opcional, de 1 s a 99:59) y repeticiones de 1 a 99 rondas que pueden contener otra (2 niveles). Una repetición omite por defecto el descanso final de la última ronda (`interval_block.skip_last_rest`, esquema v3). `expandPhases` (dominio, sin Flutter) la convierte en la lista de fases; el total incluye la preparación (0–30 s): Tabata = 0:10 + 8 × 0:20 + 7 × 0:10 = **4:00**.
- **Plantillas.** Tabata 20/10, HIIT 40/20 y 30/30, EMOM 10, AMRAP 12 y caminar/correr viven en `interval_templates.dart` con clave estable; su nombre sale de l10n. Inicio muestra 4: Tabata se empieza en 2 toques (plantilla → EMPEZAR). "Personalizar" copia una plantilla al editor.
- **Motor nativo.** Flutter solo envía el programa (fases con textos ya localizados y colores de `phasePaletteFor`) y muestra el estado. `TimerService` (servicio en primer plano `specialUse`, hilo propio de prioridad alta) usa `TimerEngine`: objetivos absolutos sobre `SystemClock.elapsedRealtime`, nunca ticks; pausas, saltar y volver (en los primeros 2 s de una fase vuelve a la anterior). Wake lock parcial solo mientras corre. Sin alarmas exactas. La interfaz recibe un estado por cambio y calcula el tiempo restante localmente.
- **Avisos.** Tono y voz al empezar cada fase (nombre, ronda y fase siguiente, en el idioma de la app), pitidos 3-2-1, vibración por tipo de fase y sonido final distinto; respetan los interruptores de Configuración → Alertas (voz activada por defecto, R-I7). La voz se precalienta al abrir la app y al entrar en S03; sin voz para el idioma quedan los pitidos. Pide foco de audio transitorio con atenuación sin depender de él; durante una llamada no suena, solo vibra.
- **Notificación.** Fase y ronda, cuenta regresiva nativa, color de la fase y acciones Pausar/Reanudar y Saltar. El permiso de notificaciones se pide antes de la primera sesión con una explicación única; si se niega, la sesión corre igual.
- **Batería restringida.** Antes de empezar se consulta `isBackgroundRestricted()`; si está restringida se muestra la guía (S18-c), porque Android detendría el servicio en ~1 min.
- **Datos.** Al empezar, la sesión guarda la copia de la estructura y las fases (`template_snapshot`) y `template_id` (`template:<clave>` para las plantillas). Cada fase cerrada se guarda en su propia transacción (`replacePhase`, idempotente) con planificado, real y omitida. Al terminar queda completada (recorrió todas las fases) o incompleta (se detuvo); el resumen (S06) guarda esfuerzo 1–10 y nota y, con menos de 30 s, propone descartarla.
- **Recuperación.** El motor guarda su punto en `files/timer_checkpoint.json` en cada cambio y cada 5 s, con escritura atómica (temporal + fsync + renombrar). Si Android cierra la app, el teléfono se reinicia o el sistema detiene el servicio, al abrir (o al instante, si la app está abierta) se ofrece Reanudar (en pausa), Guardar como incompleta o Descartar, y la sesión pasa por "recuperación pendiente". Nunca se reanuda sola.
- **Pruebas.** Unitarias del dominio, textos de voz en 3 idiomas, repositorio y transiciones de recuperación; de widgets del editor, S05 con un motor de prueba, mantener para detener y recuperación; JVM del motor y del punto atómico (`cd android && ./gradlew testDebugUnitTest`). Resultados en emulador de T-01 a T-12 y deuda técnica en `docs/pruebas-temporizador.md`.

## Sesión de fuerza (D5)

- **Empezar (R-G1).** ▶ en la tarjeta de la rutina, ENTRENAMIENTO LIBRE debajo de la lista o «REPETIR ÚLTIMO» en Inicio (copia ejercicios y series hechas de la última sesión de fuerza). Una rutina vacía no empieza: invita a agregar ejercicios. Antes pasa por los mismos pasos que los intervalos (`checkBeforeSession`: sesión activa, permiso de notificaciones, batería restringida, volumen en 0).
- **Copia.** `StrengthSessionRepository.startFromRoutine` crea en una transacción la sesión con `template_snapshot`, un `session_exercise` por ejercicio con su descanso (rutina → biblioteca → 90 s) y las series por hacer (`set_log` sin completar con el objetivo). Editar la rutina después no cambia la sesión ni al revés.
- **S10.** Cada serie muestra la última marca (la serie con el mismo número del ejercicio en la última sesión del historial) y los valores propuestos en gris: esa marca → el objetivo → vacío (R-G2). ✓ los guarda en 1 toque y arranca el descanso; sin valores abre S11; ✓ otra vez la desmarca. Agregar/quitar series, agregar ejercicios desde la biblioteca, subir/bajar, quitar y notas por ejercicio. TERMINAR resuelve las series pendientes (R-G10) o descarta si no hay ninguna hecha (R-G11).
- **S11.** Peso con ± del incremento del ejercicio (2,5 kg / 5 lb por defecto) o teclado, reps, RPE 6–10 opcional y tipo de serie (calentamiento, normal, al fallo, drop set). Validaciones de R-G4. Peso en la unidad elegida; se guarda con su unidad original (R-G7). Decimales con coma en es-419 y pt-BR (`numberLocale`).
- **Descanso (F-09).** Corre en `TimerService` en modo fuerza (sin un temporizador en Dart): `RestTimer` con fin absoluto en `elapsedRealtime`, ±15 s y saltar; wake lock solo durante el descanso; pitidos 3-2-1, tono, voz y vibración al terminar según Configuración → Alertas, también con la pantalla apagada. La notificación muestra el descanso con +15 s y Saltar, «¡A la siguiente serie!» o la sesión con su tiempo y series.
- **Persistencia y recuperación.** Cada serie se guarda en su propia transacción al marcarla. Si Android cierra la app, al abrir se ofrece retomarla (S18-b: Reanudar, Guardar como incompleta, Descartar); el descanso en curso se recalcula con el reloj monotónico desde `files/strength_checkpoint.json` o se descarta si venció o hubo un reinicio.
- **Resumen.** Duración, volumen (sin calentamiento), series, récords nuevos de la sesión (desde D6, leídos de la caché `personal_record`), «¿Actualizar la rutina?» si cambió la estructura (R-G12), esfuerzo 1–10 y nota.
- **Pruebas.** Dominio, repositorio (copia, última marca, serie repetida, cierre forzado con la base en archivo), flujo de S10/S11/resumen/recuperación con un motor falso, pseudo-locale y JVM de `RestTimer`. Resultados en emulador y deuda: `docs/pruebas-fuerza.md`.

## Historial y estadísticas (D6)

- **S12 Historial** (pestaña): SEMANA, LISTA y CALENDARIO.
  - **Semana:** fuerza, intervalos, descanso, libre y planificado; tocar un día de hoy en adelante abre el plan opcional del día, que se repite cada semana y nunca empieza una sesión.
  - **Lista:** sesiones agrupadas por semana, con sesiones y minutos.
  - **Calendario:** mes con marcas F/I; tocar un día muestra sus sesiones.
- **Variante H5 (unificada o separada).** No tiene pantalla pública.
  - En depuración: Configuración → sección de depuración → «Vista semanal (prueba H5)».
  - En cualquier build: `--dart-define=TL_WEEK_VARIANT=separate` (o `unified`). Este valor manda sobre el ajuste guardado (`debug.weekVariant`).
- **S13 Detalle de sesión** (`/history/:id`).
  - Muestra volumen, series y récords (fuerza), o total, rondas y trabajo (intervalos).
  - EDITAR permite cambiar el nombre, el esfuerzo y la nota. En fuerza, además, tocar una serie abre S11 para cambiar peso, reps, RPE o tipo, o para quitarla.
  - GUARDAR COMO RUTINA crea una rutina con las series hechas.
  - ELIMINAR pide confirmación, archiva la sesión y ofrece DESHACER durante 5 s.
- **Récords (R-P3, `RecordsRepository`).** Tipos: peso máximo (con sus reps), 1RM de Epley (1–12 reps), más reps con cada peso, mayor volumen del ejercicio en una sesión, y mayor duración o distancia.
  - Se recalculan desde `set_log` al terminar una sesión de fuerza, al descartarla desde el resumen y al editar, borrar o restaurar una sesión.
  - Se guardan en `personal_record`, que es solo una caché.
  - Un récord es «nuevo» si superó una marca anterior (`previous_value`); la primera vez no se destaca.
- **Inicio:** «2/3 sesiones de tu objetivo», minutos activos y racha, según el inicio de semana y el objetivo semanal (ambos nuevos en Configuración → Entrenamiento).
- **S14 Progreso:** la semana en curso (sesiones/objetivo, minutos, racha y volumen), barras de sesiones de las últimas 8 semanas con la línea del objetivo (tocar una barra lista sus sesiones) y la última marca por ejercicio e intervalos.
- **S15 Detalle de ejercicio** (`/progress/exercises/:id`): última marca y su 1RM, tendencia simple del 1RM estimado (CustomPaint, rangos 4 sem / 12 sem / 6 m / 1 año / todo), récords e historial.
- **Pruebas:** cifras calculadas a mano frente a la app, y recálculo al editar y al borrar. Ver `docs/pruebas-historial.md`, que incluye la deuda.

## Tema, acento e idioma

- Los colores salen de `docs/design/system/tokens.json` y viven en `TlColors` (un `ThemeExtension`). En los widgets: `context.colors.accent`, `context.text.headline`.
- Hay 8 acentos (`AccentPreset`). `phasePaletteFor(accent)` aplica la regla de distinción entre fases: Trabajo siempre es el acento; con Amarillo o Naranja, Calentamiento pasa a rosa; con Azul, Vuelta a la calma pasa a violeta; con Lima, Descanso pasa a azul y Vuelta a la calma a violeta.
- Las preferencias están en `SettingsController` (Riverpod) y se guardan con `SettingsRepository` sobre shared_preferences (clave-valor, como define la arquitectura; no van en la base). Además de tema, acento e idioma guardan unidad de peso (kg por defecto, se elige en Configuración → Entrenamiento), inicio de semana (lunes), sonidos (sí), voz (sí), vibración (sí) y objetivo semanal (3 sesiones, entre 1 y 14). Sonidos, voz y vibración se ajustan en Configuración → Alertas; el objetivo semanal aún no tiene pantalla. Al cambiar una preferencia, `MaterialApp` se reconstruye con el nuevo tema o locale sin reiniciar y sin perder la navegación (el router no depende de las preferencias).

## Localización

Idiomas: español latinoamericano (`es`, servido como `es-419`), inglés (`en`) y portugués de Brasil (`pt`, servido como `pt-BR`).

- `lib/l10n/app_en.arb` es la plantilla: cada mensaje lleva su `@descripción` para traducción.
- `app_es.arb` y `app_pt.arb` tienen el contenido. `app_es_419.arb` y `app_pt_BR.arb` solo declaran la variante regional, por eso `flutter gen-l10n` avisa de mensajes "untranslated" en ellos. Es lo esperado: heredan de `es` y `pt`.
- Con "Idioma del teléfono", cualquier español del sistema resuelve a `es-419`, cualquier portugués a `pt-BR` y, si el teléfono no tiene ninguno de los tres idiomas, se usa inglés.
- En Android 13 o superior, `android/app/src/main/res/xml/locales_config.xml` (declarado con `android:localeConfig`) habilita el idioma por app en los ajustes del sistema. Si cambia un idioma, también hay que actualizarlo ahí.

Flujo para agregar o cambiar un texto:

1. Agrégalo a `app_en.arb` con su `@clave` y descripción, y a `app_es.arb` y `app_pt.arb`.
2. Regenera el pseudo-locale: `dart run tool/pseudo_locale.dart`.
3. Genera el código: `flutter gen-l10n` (también corre solo con `flutter run`).
4. Úsalo con `context.l10n.miClave`. Nunca escribas texto visible directamente en un widget.

Las pruebas verifican que `es` y `pt` traduzcan todas las claves y que `app_en_XA.arb` esté sincronizado. CI además falla si el código generado en `lib/l10n/gen` no está al día.

## Pseudo-locale (en-XA)

Sirve para detectar textos fijos en el código y textos que se cortan al traducirse. `tool/pseudo_locale.dart` genera `app_en_XA.arb` a partir del inglés: acentúa las letras, alarga cada texto un 40 % y lo envuelve en `[ ]`, por ejemplo `[Šéţţîñĝš ····]`. Respeta los placeholders y la sintaxis ICU.

Solo está disponible en builds de depuración. En release, en-XA no figura entre los idiomas soportados y la opción no aparece.

- **Desde la app:** Configuración → Idioma → "Pseudo-locale (en-XA, debug)".
- **Al arrancar:** `flutter run --dart-define=TL_PSEUDO=true`.
- **En pruebas:** `test/app/pseudo_locale_test.dart` recorre las pestañas, Configuración, la biblioteca, el formulario de ejercicio y el editor de rutina en en-XA y falla si algún texto visible no tiene las marcas `[ ]`, es decir, si no viene de l10n.

Cualquier texto que veas en la app sin corchetes ni acentos está escrito directamente en el código.

## Base de datos

SQLite con Drift, en `trainloop.sqlite` dentro del directorio de soporte de la app (en Android, `files/`). El esquema está en `lib/data/db/tables.dart` y sigue `docs/modelo-datos.md`:

- 14 tablas: `exercise`, `strength_routine`, `routine_exercise`, `routine_set_target`, `interval_workout`, `interval_block`, `session`, `session_exercise`, `set_log`, `interval_phase_log`, `personal_record`, `plan_day`, `reminder` y `ad_state`.
- Ids UUID en texto generados en el teléfono; `created_at`/`updated_at` en milisegundos UTC (en Dart llegan como `DateTime` UTC). La sesión guarda además la zona IANA (si se conoce) y el desfase local en minutos.
- Borrado lógico con `archived_at` en ejercicios, rutinas, temporizadores y sesiones. Los hijos de una plantilla se reemplazan completos al guardarla: el historial no depende de ellos porque la sesión guarda una copia en JSON (`template_snapshot`).
- Peso: valor y unidad originales más una columna en gramos enteros, que calcula el DAO.
- Claves foráneas activas (`PRAGMA foreign_keys = ON`). Los enums se guardan como texto con su nombre: renombrar un valor exige una migración.
- Cada serie (`SessionsDao.logSet`) y cada fase (`logPhase`) se guarda en su propia transacción (NF-06).

Acceso: un DAO por agregado (`ExercisesDao`, `RoutinesDao`, `IntervalWorkoutsDao`, `SessionsDao`, `RecordsDao`, `PlanDao`, `AdStateDao`), expuestos por providers de Riverpod en `lib/data/db/database_providers.dart`. `appDatabaseProvider` abre una sola instancia y la cierra al desechar el `ProviderScope`; las pruebas la sobrescriben con una base en memoria.

Versión actual del esquema: **5** (D3 agregó `exercise.catalog_key` con índice único; D4, `interval_block.skip_last_rest`; D5, `session_exercise.rest_seconds`; D6, en `personal_record`, `weight_grams`, `reps` y `previous_value`, con el índice único ejercicio + tipo + peso. La migración vacía la caché de récords y la app la recalcula al abrir).

El código generado (`*.g.dart`, `test/drift/*/generated/`) va en el repositorio. Tras cambiar tablas o DAOs:

```sh
dart run build_runner build
```

Para cambiar el esquema:

1. Sube `schemaVersion` en `app_database.dart`.
2. `dart run drift_dev make-migrations` guarda `drift_schemas/app_database/drift_schema_vN.json`, regenera los helpers de prueba y `app_database.steps.dart`.
3. Escribe el paso en `onUpgrade` (`m.runMigrationSteps`) y una prueba en `test/drift/app_database/migration_test.dart` que parta de la versión anterior con `SchemaVerifier`.

`drift` y `drift_dev` van fijos en 2.34.0: es la última versión de drift_dev compatible con el analyzer que permite Flutter 3.41.

En depuración, Configuración muestra al final una sección con los conteos de la base y un botón para agregar datos de prueba. Sirve para comprobar que los datos persisten al cerrar la app.

## Respaldo automático de Android

`android:allowBackup` está activo, con reglas para Android 12 o superior (`res/xml/data_extraction_rules.xml`) y para versiones anteriores (`res/xml/backup_rules.xml`). Solo incluyen la base (`files/trainloop.sqlite`) y las preferencias (`shared_prefs/FlutterSharedPreferences.xml`); la caché nunca se respalda. Si cambia el nombre o la ubicación de alguno de esos archivos, hay que actualizar ambos XML.

La copia la hace Android hacia el **Google Drive de la persona** (y a un teléfono nuevo al transferir datos). No pasa por servidores nuestros, pero **debe mencionarse en la política de privacidad** (lo revisa Legal/Administración). Complementa el respaldo manual en archivo de un entregable posterior.

La app no pide el permiso `INTERNET` en release; solo lo declaran los manifiestos de `debug` y `profile`, que Flutter necesita para depurar.

## CI

`.github/workflows/ci.yml` corre en cada pull request y en cada push a `main`. Ejecuta `pub get` con el lockfile, revisa que las localizaciones y el código generado de Drift estén al día, revisa el formato y corre `analyze`, `test`, `build apk --debug` y las pruebas JVM del motor del temporizador (`./gradlew testDebugUnitTest`). El APK queda como artefacto del run. No usa secretos.

## Fuentes

Barlow Condensed e Inter se distribuyen bajo la SIL Open Font License 1.1 (`assets/fonts/OFL-*.txt`). Van empaquetadas en la app y se registran en la pantalla de licencias. La app no descarga nada en tiempo de ejecución.
