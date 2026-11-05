# Pruebas y estabilidad (D9)

Criterio de `docs/arquitectura.md`, fila 9: NF-02 a NF-06 y NF-10 medidos; ≥ 99,5 % de sesiones sin fallos en la prueba interna.

Sin teléfono real, Firebase ni Play Console: todo se midió en el emulador `emulator-5554` (Pixel arm64, API 36, sobre un Mac con otro emulador abierto) y en versión corta. Las cifras del emulador son **indicativas**: no reemplazan un teléfono de gama media 2023.

## 1. Requisitos no funcionales

| NF | Umbral | Cómo se midió | Emulador | Estado |
|---|---|---|---|---|
| NF-02 arranque en frío | < 1,5 s en gama media 2023 | 8 × `am force-stop` + `am start -W -S` sobre el release (arm64) | mediana 1,04 s; p90 3,68 s (la 1.ª corrida, con el host cargado). Sin ella: mediana 1,04 s, p90 1,26 s | cumple en emulador · **pendiente teléfono** |
| NF-03 desfase | ≤ 1 s en 60 min, pantalla apagada; alertas ±150 ms | Tabata 150 s con pantalla apagada, `tool/timer_adb.sh stats` (build de depuración) | 10 cambios de fase, atraso medio 2,4 ms, máx. 5 ms | cumple versión corta · **60 min pendiente teléfono** (`tool/noche_telefono.sh`) |
| NF-04 sin fallos | ≥ 99,5 % de sesiones; ANR < 0,47 %, crash < 1,09 % | Recorridos de `integration_test` (4/4 pasan); registro local de errores; release con R8 corrido a mano | sin cierres; el recorrido de rendimiento encontró y se corrigió un error de Flutter al soltar «Mantén para detener» | **pendiente Play** (Android vitals en la prueba interna, D10) |
| NF-05 offline | 100 % sin red | `integration_test/offline_test.dart` en modo avión con AdMob, UMP y Billing reales | abre, sin banner ni hueco, Tabata completo y guardado | cumple |
| NF-06 persistencia | cada serie/fase al confirmarse; ningún cierre pierde > 10 s; respaldos entre versiones | Recorrido «cierre forzado» (serie guardada al confirmar, se reabre y se retoma); respaldos v3, v4 y v5 en `test/fixtures/backups/`; `kill -9` ya medido en D4 (T-10: ≤ 2,4 s) | pasa | cumple · `kill -9` en Samsung/Xiaomi pendiente teléfono |
| NF-10 batería | ≤ 5 %/h con pantalla apagada | Tabata 4:00 en release, pantalla apagada, `dumpsys batterystats` y `dumpsys alarm` | wake lock `trainloop:session` 3:54 (toda la sesión, por diseño); CPU de la app 15,7 s en 4:48 (≈ 5 % de un núcleo, incluye 34 s en primer plano); 0 alarmas de la app; servicio en primer plano 3:54 | **no medible en emulador** (no hay batería real) · pendiente teléfono |
| NF-11 tamaño | < 20 MB | `flutter build apk --split-per-abi` y `appbundle` (release, R8) | APK arm64 27,2 MB (bibliotecas sin comprimir); `gzip -9` ≈ 14,2 MB (proxy de la descarga). armeabi-v7a 25,0 / ≈ 13,8 MB; x86_64 28,6 / ≈ 14,4 MB. AAB 59,1 MB (todas las ABI) | cumple estimado · confirmar descarga en Play Console |

Rendimiento de S05 (20 s en marcha, `flutter drive --profile --no-dds`, `integration_test/perf_test.dart`): 286 cuadros; build medio 1,1 ms, p99 9,2 ms, 2 cuadros sobre presupuesto; raster medio 18,7 ms, p90 24,2 ms, 151 sobre presupuesto. El hilo de interfaz va holgado; el raster del emulador usa GPU emulada y no es representativo: **repetir en teléfono**.

## 2. Qué quedó en D9

- **Release:** R8 con `isMinifyEnabled` e `isShrinkResources` (`android/app/proguard-rules.pro`), firma con `android/key.properties` o `TL_KEYSTORE_*` (si no, la de depuración con un aviso). Probado en el emulador: Tabata, notificación, saltar fases y resumen funcionan con R8.
- **Guarda de AdMob:** `verifyReleaseAdIds` hace fallar el release con los IDs de prueba, salvo con `TL_ALLOW_TEST_ADS=true` o `TL_ADS=off`. La CI comprueba que falle y compila el release permitido, con el tamaño en el resumen.
- **Registro de errores (NF-04 sin proveedor):** `FlutterError.onError` y `PlatformDispatcher.onError` → anillo de 50 entradas en `files/diagnostics/errors.jsonl`; `CrashLog.kt` guarda las 5 últimas excepciones nativas. No sale del teléfono (NF-07): S16 → Datos y privacidad → «Registro de errores» lo exporta con el SAF. `ErrorReporter` permite sumar un proveedor después. No se usa `runZonedGuarded`: `PlatformDispatcher.onError` cubre los errores asíncronos y Flutter ya no lo recomienda.
- **El ≥ 99,5 %** se mide con Android vitals en la prueba interna de Play (D10), sin SDK.
- **Deuda de código cerrada:** SessionGate ya no apila otra S05/S10 (deuda 8 de D8); `ad_state` fuera del respaldo y compatible con respaldos viejos (deuda 4); banner con reintento a los 30 s, 1, 2 y 5 min (deuda 2, sin escuchar la conectividad); guarda de IDs (deuda 6).
- **Pruebas:** `integration_test/` (Tabata, fuerza, cierre forzado, sin red, rendimiento) y `tool/test_lab.sh` (no se ejecutó: no hay proyecto de Firebase).

Capturas (fuera del repo): S05 en release, resumen tras la sesión y Configuración con el registro de errores.

## 3. Matriz de dispositivos (Test Lab)

En `tool/test_lab.sh`. Verificar los ids con `gcloud firebase test android models list` antes de usarla.

| Tipo | Modelo (id) | API | Por qué |
|---|---|---|---|
| Virtual | MediumPhone.arm | 26, 30, 34, 36 | minSdk, intermedias y targetSdk; barato para cada PR del motor |
| Físico | Samsung Galaxy A12 (`a12`) | 30 | gama de entrada/media más vendida |
| Físico | Samsung Galaxy A52s (`a52sxq`) | 33 | One UI, gestión de batería agresiva |
| Físico | Xiaomi Redmi Note 9 Pro (`joyeuse`) | 30 | MIUI: mata servicios en segundo plano |
| Físico | Google Pixel 6 (`oriole`) / Pixel 8 (`shiba`) | 33 / 34 | Android de referencia |

## 4. Plan para el bloque en teléfono real

Necesita: un Samsung y un Xiaomi de gama media (y un Pixel si hay), depuración USB, carga > 80 %, auriculares Bluetooth y una noche. Unas 3 h de trabajo más la noche.

| Prueba | Cómo | Tiempo |
|---|---|---|
| NF-02 arranque | release instalado; 10 × `adb shell am start -W -S -n com.trainloop.app/.MainActivity`, mediana y p90 | 10 min por teléfono |
| NF-03 + NF-10 | `tool/noche_telefono.sh` con el build de profile y «Prueba 60 min», sin cargador (adb por wifi) | 70 min, de noche |
| NF-06 `kill -9` | build de depuración; `tool/timer_adb.sh tabata`, `kill` a los 30 s, reabrir y medir lo perdido | 10 min |
| T-03 música | Spotify sonando: avisos con atenuación, sin cortar la música | 10 min |
| T-04 Bluetooth | auriculares: avisos por BT; desconectar a mitad | 10 min |
| TalkBack | recorrido completo con gestos reales (doble toque, mantener para detener) | 30 min |
| Voz/TTS | avisos con voz en es/en/pt-BR sin huecos (el TTS del emulador se cae con SIGILL) | 15 min |
| Rendimiento | `flutter drive --profile --no-dds … perf_test.dart` | 5 min |
| Test Lab | `TL_FIREBASE_PROJECT=… tool/test_lab.sh` | 20 min |

## 5. Deuda abierta (consolidada)

Detalle en los documentos de cada entregable (no se borraron).

- **D9 (este):** medir en teléfono NF-02, NF-03 (60 min), NF-10 y el raster de S05; Test Lab sin correr; reintento del banner sin escuchar la conectividad (pediría `connectivity_plus`); `classes.dex` pesa 5,9 MB (AdMob): revisar las reglas `-keep` de AdMob y Billing si el tamaño aprieta; los respaldos v3/v4 son sintéticos (el respaldo en archivo existe desde v5).
- **D4** (`pruebas-temporizador.md`): T-03, T-04, voz en teléfono real; «pausar en llamadas», «solo vibración», aviso de mitad y pantalla encendida sin implementar.
- **D5** (`pruebas-fuerza.md`): reemplazar ejercicio (R-G9), distancia (R-G5), R-G15, «repetir» intervalos, S10 con TalkBack.
- **D6** (`pruebas-historial.md`): casos de varias semanas, pruebas de widgets de S12–S15, F-12 (P2), capturas faltantes.
- **D7** (`pruebas-experiencia.md`): TalkBack con gestos reales y nodos fusionados; pantallas al 200 % faltantes; restauración en el hilo principal y sin preferencias; recordatorios sin probar en emulador; regla de 14 días; CSV.
- **D8** (`pruebas-monetizacion.md`): analítica y TCF (1), compra real (3), `getAnchoredAdaptiveBannerAdSize` obsoleto (5), `tagForUnderAgeOfConsent` (7), mensaje único de Play (9). Cerradas en D9: 2, 4, 6 y 8.

## 6. Decisiones pendientes

- **Gestión:** proveedor de errores y analítica (Crashlytics u otro), proyecto de Firebase para Test Lab, cuenta de Play Console y llave de subida (Play App Signing), IDs reales de AdMob.
- **Legal/Administración:** mencionar en la política de privacidad el registro local de errores y su exportación manual (además de lo ya pendiente: respaldo de Android, archivos exportados, TCF y edad).

## 7. Estado del emulador

`emulator-5554`: build de depuración instalado con los datos borrados (`pm clear`), idioma de la app es-419, modo avión desactivado. `emulator-5570` no se tocó.
