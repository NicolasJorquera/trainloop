# Trainloop

Cuaderno de entrenamiento para Android: temporizador de intervalos y registro de fuerza, sin cuenta y offline. Flutter (Android primero), Riverpod, go_router y localización ARB/ICU.

Estado: **entregable 3, ejercicios y rutinas.** D1 dejó el sistema de diseño (Pizarra de hierro), las 4 pestañas con estados vacíos, la pantalla de Configuración (tema, acento e idioma) y CI. D2 agregó la base SQLite con Drift (14 tablas, DAOs, migraciones con pruebas), las preferencias y el respaldo automático de Android. D3 agrega la biblioteca de ejercicios (105 incluidos y propios, con búsqueda y filtros) y las rutinas de fuerza (crear, editar, duplicar, reordenar y archivar). Siguen: temporizador (D4), registro de fuerza (D5), historial y estadísticas (D6), y anuncios y consentimiento (D8).

## Cómo correrla

Requisitos: Flutter 3.41 stable y un emulador o teléfono con Android 8.0 (API 26) o superior.

```sh
# Los repos personales resuelven paquetes desde pub.dev (hay un mirror global del trabajo).
export PUB_HOSTED_URL=https://pub.dev

flutter pub get
flutter run                  # depuración
flutter test                 # pruebas
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
    home, train, history, progress, settings, exercises (S08/S09), routines (S07)
  l10n/                         ARB (fuente) y gen/ (generado por flutter gen-l10n)
assets/fonts/                   Barlow Condensed e Inter (OFL, empaquetadas: no se descargan)
docs/design/                    copia del sistema de diseño (system/) y prototipos HTML (screens/)
docs/modelo-datos.md            modelo de datos del PRD y decisiones de persistencia
drift_schemas/                  esquema de cada versión de la base (JSON, para migraciones)
tool/                           script del pseudo-locale
test/                           unitarias (tokens, fases, pseudo, repositorio, DAOs), de widgets
                                y drift/ (migraciones; generated/ es generado)
```

Cada entregable nuevo agrega su carpeta en `lib/features/` y, si hace falta, una rama o ruta en `lib/core/router/app_router.dart`.

## Ejercicios y rutinas (D3)

- **Biblioteca incluida.** `lib/data/catalog/exercise_catalog.dart` lista 105 ejercicios con clave estable (`bench_press_barbell`), músculo, equipo, tipo de registro, incremento y descanso, y su nombre en es, en y pt-BR. La base guarda la clave en `exercise.catalog_key`; la pantalla muestra el nombre del idioma activo (`exerciseName`), así cambiar de idioma renombra la biblioteca sin reiniciar. En en-XA el nombre se pseudo-localiza. Los ejercicios propios guardan el nombre literal.
- **Siembra.** `seedExerciseCatalog` inserta solo las claves que faltan (índice único en `catalog_key`); corre al abrir la biblioteca. Para ampliar la biblioteca basta con agregar entradas con claves nuevas. Nunca cambies ni reutilices una clave.
- **Búsqueda y duplicados.** La búsqueda compara el nombre visible sin mayúsculas ni tildes. Al crear un ejercicio propio, `findDuplicateExercise` lo compara con los propios y con los incluidos en los 3 idiomas («plank» choca con «Plancha»): avisa, no deja guardar y ofrece usar el existente.
- **Rutinas.** El editor maneja series iguales por ejercicio (series, reps o tiempo, peso opcional y descanso); al agregar un ejercicio toma 3 × 10 (o 3 × 0:45 si es por tiempo) y su descanso por defecto. El peso se escribe y se muestra en la unidad de la persona. Guardar reemplaza los ejercicios de la plantilla; las sesiones pasadas no cambian porque guardan su copia en `template_snapshot` (lo prueba `test/features/routines/routine_repository_test.dart`). Archivar es borrado lógico con "Deshacer".
- Empezar una sesión de fuerza y el entrenamiento libre llegan en D5; los intervalos de Entrenar, en D4.

## Tema, acento e idioma

- Los colores salen de `docs/design/system/tokens.json` y viven en `TlColors` (un `ThemeExtension`). En los widgets: `context.colors.accent`, `context.text.headline`.
- Hay 8 acentos (`AccentPreset`). `phasePaletteFor(accent)` aplica la regla de distinción entre fases: Trabajo siempre es el acento; con Amarillo o Naranja, Calentamiento pasa a rosa; con Azul, Vuelta a la calma pasa a violeta; con Lima, Descanso pasa a azul y Vuelta a la calma a violeta.
- Las preferencias están en `SettingsController` (Riverpod) y se guardan con `SettingsRepository` sobre shared_preferences (clave-valor, como define la arquitectura; no van en la base). Además de tema, acento e idioma guardan unidad de peso (kg por defecto), inicio de semana (lunes), sonidos (sí), voz (no), vibración (sí) y objetivo semanal (3 sesiones, entre 1 y 14). Esas últimas aún no tienen pantalla: las usan D4 a D6. Al cambiar una preferencia, `MaterialApp` se reconstruye con el nuevo tema o locale sin reiniciar y sin perder la navegación (el router no depende de las preferencias).

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

Versión actual del esquema: **2** (D3 agregó `exercise.catalog_key` con índice único).

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

`.github/workflows/ci.yml` corre en cada pull request y en cada push a `main`. Ejecuta `pub get` con el lockfile, revisa que las localizaciones y el código generado de Drift estén al día, revisa el formato y corre `analyze`, `test` y `build apk --debug`. El APK queda como artefacto del run. No usa secretos.

## Fuentes

Barlow Condensed e Inter se distribuyen bajo la SIL Open Font License 1.1 (`assets/fonts/OFL-*.txt`). Van empaquetadas en la app y se registran en la pantalla de licencias. La app no descarga nada en tiempo de ejecución.
