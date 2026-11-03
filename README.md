# Trainloop

Cuaderno de entrenamiento para Android: temporizador de intervalos y registro de fuerza, sin cuenta y offline. Flutter (Android primero), Riverpod, go_router y localización ARB/ICU.

Estado: **entregable 1, proyecto base y navegación.** Incluye el sistema de diseño (Pizarra de hierro), las 4 pestañas con estados vacíos, la pantalla de Configuración (tema, acento e idioma) y CI. Las funciones reales llegan en entregables posteriores: base de datos con Drift (D2), ejercicios y rutinas (D3), temporizador (D4), registro de fuerza (D5), historial y estadísticas (D6), y anuncios y consentimiento (D8).

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
  app/                          TrainloopApp (MaterialApp.router) y AppShell (barra inferior)
  core/
    theme/                      tokens (TlColors, TlSpace, TlRadius, TlSize), TlText, acentos,
                                regla de colores de fase (phasePaletteFor) y buildTrainloopTheme
    l10n/                       idiomas soportados, resolución de locale y pseudo-locale
    router/                     go_router: StatefulShellRoute con 4 ramas + /settings
    widgets/                    componentes del sistema: TlButton, TlBottomNav,
                                TlSegmentedControl, AccentPicker, PhaseGlyph, EmptyState…
  features/<feature>/           por funcionalidad: domain / data / application / presentation
    home, train, history, progress, settings
  l10n/                         ARB (fuente) y gen/ (generado por flutter gen-l10n)
assets/fonts/                   Barlow Condensed e Inter (OFL, empaquetadas: no se descargan)
docs/design/                    copia del sistema de diseño (system/) y prototipos HTML (screens/)
tool/                           script del pseudo-locale
test/                           unitarias (tokens, fases, pseudo, repositorio) y de widgets
```

Cada entregable nuevo agrega su carpeta en `lib/features/` y, si hace falta, una rama o ruta en `lib/core/router/app_router.dart`.

## Tema, acento e idioma

- Los colores salen de `docs/design/system/tokens.json` y viven en `TlColors` (un `ThemeExtension`). En los widgets: `context.colors.accent`, `context.text.headline`.
- Hay 8 acentos (`AccentPreset`). `phasePaletteFor(accent)` aplica la regla de distinción entre fases: Trabajo siempre es el acento; con Amarillo o Naranja, Calentamiento pasa a rosa; con Azul, Vuelta a la calma pasa a violeta; con Lima, Descanso pasa a azul y Vuelta a la calma a violeta.
- Las preferencias están en `SettingsController` (Riverpod) y se guardan con `SettingsRepository`. Por ahora la implementación usa shared_preferences; en D2 se puede reemplazar por Drift sin tocar la UI. Al cambiar una preferencia, `MaterialApp` se reconstruye con el nuevo tema o locale sin reiniciar y sin perder la navegación (el router no depende de las preferencias).

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
- **En pruebas:** `test/app/pseudo_locale_test.dart` recorre las pestañas y Configuración en en-XA y falla si algún texto visible no tiene las marcas `[ ]`, es decir, si no viene de l10n.

Cualquier texto que veas en la app sin corchetes ni acentos está escrito directamente en el código.

## CI

`.github/workflows/ci.yml` corre en cada pull request y en cada push a `main`. Ejecuta `pub get` con el lockfile, revisa que las localizaciones estén al día, revisa el formato y corre `analyze`, `test` y `build apk --debug`. El APK queda como artefacto del run. No usa secretos.

## Fuentes

Barlow Condensed e Inter se distribuyen bajo la SIL Open Font License 1.1 (`assets/fonts/OFL-*.txt`). Van empaquetadas en la app y se registran en la pantalla de licencias. La app no descarga nada en tiempo de ejecución.
