# Pruebas de monetización y consentimiento (D8)

Emulador `emulator-5560` (Android 16, API 36, 1080 × 2400, con Play Store), build de depuración con `--dart-define=TL_UMP_DEBUG_GEOGRAPHY=eea`, fecha 2026-11-03. Pruebas cortas por decisión del usuario: unos 8 min de emulador.

Criterio de D8 (docs/arquitectura.md): «Ningún anuncio en sesión (prueba automatizada); sin red la app funciona igual; compra restaurable; Data safety completo».

## 1. Pruebas automáticas

`flutter test`: 252 pruebas, todas pasan (~16 s); 25 nuevas en `test/features/monetization/`. `pumpTrainloop` monta por defecto un AdMob/UMP falso (`FakeAdsPlatform`, sin banner) y un Play Billing falso (`FakeInAppPurchase`, implementa `InAppPurchase`), en `test/helpers/fake_monetization.dart`.

| Área | Archivo | Qué prueba |
|---|---|---|
| **Ningún anuncio en sesión** | `no_ads_in_session_test.dart` | AdMob falso que **siempre** tiene banner. Intervalos: Inicio con banner → S03 → EMPEZAR → S05 corriendo y en pausa → fin → S06 → Listo → Inicio con banner. Fuerza: Entrenar con banner → ▶ → S10 → serie ✓ → descanso → S11 → guardar → TERMINAR → series pendientes → resumen → Listo. En cada paso: el guard niega banner (pestañas y biblioteca) e intersticial, no hay **ningún** banner montado (`skipOffstage: false`, también debajo de la pantalla visible), todos los banners cargados se descartaron, y un listener registra cada cambio del guard mientras dura la sesión (ninguno permitido). |
| Reglas | `ad_rules_test.dart` | Guard puro: pantallas con y sin banner (S03, editores, S13, Configuración, respaldo), la sesión manda sobre todo, compra/consentimiento/SDK. Intersticial: apagado por defecto, 5 min, R-A5 (incompleta, descartada, recuperada) y topes de R-A3. Eventos de analítica sin datos del entrenamiento. |
| **Sin red** | `offline_and_consent_test.dart` | UMP, SDK y Play lanzan error: la app abre, Tabata corre hasta el resumen, sin excepciones, sin banner y **sin hueco** (alto 0); comprar muestra «Google Play no está disponible». SDK que no inicia o AdMob sin relleno: sin hueco. EEE sin responder: sin anuncios ni analítica; «Preferencias de privacidad» reabre el formulario y entonces inicia el SDK; el interruptor apaga la analítica. |
| **Compra** | `remove_ads_test.dart` | Comprar → sin anuncios, reconocida (`completePurchase`), guardada en `ad_state`, evento de analítica. «Instalación nueva» (otra base, mismo Play): se restaura al abrir y con «Restaurar compra». Restaurar sin compra. Un estado local falso (respaldo de otra cuenta) lo revoca Play. Sin red se mantiene la compra local. Pendiente → se activa al confirmarse. Cancelada, error y producto inexistente. S16: comprar oculta el banner de Inicio y el intersticial. |
| Intersticial | `interstitial_test.dart` | Apagado: no se carga ni se muestra. Con `TL_INTERSTITIAL=on`: se precarga al abrir, no aparece en el resumen, sí tras «Listo» en una completada de 5 min y se vuelve a precargar; no tras 4 min, al descartar ni tras una incompleta; si no cargó, no se muestra ni se espera. |

## 2. Criterios

### Ningún anuncio en sesión (prueba automatizada)

`test/features/monetization/no_ads_in_session_test.dart` (arriba). El guard es uno solo: `decideAd` (`lib/features/monetization/domain/ad_guard.dart`) con entradas de `adGuardInputsProvider`: sesión de intervalos o fuerza abierta, motor corriendo, registro de series, resumen abierto, ruta visible (la de la última ruta apilada, no `uri`, que con `push` queda en la pestaña de abajo) y pasos críticos (`AdHold`: arranque hasta saber si hay una sesión viva, desde «Empezar» hasta que la sesión existe, y la recuperación). El banner se desmonta y se descarta cuando el guard dice que no, así que no queda un anuncio vivo bajo S05/S10.

En el emulador: banner de prueba en Inicio; nada en S03, S05, el resumen ni S10 (capturas 02–05 y 10).

### Sin red la app funciona igual

Prueba automática (arriba) y emulador: `svc wifi disable; svc data disable`, forzar cierre y abrir: Inicio sin banner ni hueco, Tabata corre (capturas 08–09). Red reactivada después. Se encontró y corrigió que el banner no volvía al recuperar la red: ahora se reintenta al volver a la app.

### Compra restaurable

Prueba automática con `InAppPurchase` falso (arriba). En el emulador **no se pudo probar la compra real**: el APK está instalado por adb, sin cuenta de Play con acceso de prueba y el producto no existe en Play Console (`BillingClient: In-app billing API version 3 is not supported on this device`). La app mostró «Google Play no está disponible ahora…» sin errores (captura 07). Probar con un tester de licencias en la prueba interna (D9/D10).

### Data safety completo

`docs/data-safety.md`: respuestas del formulario, tipos de datos del SDK, cifrado, sin cuenta, respaldo de la persona, datos que no salen del teléfono y permisos del manifiesto final. **Pendiente de revisión de Legal/Administración.**

## 3. Capturas

En la carpeta temporal de la sesión (`d8-shots/`): 00 arranque, 01 formulario UMP (geografía EEE forzada), 02 Inicio con banner de prueba (tamaño anclado estándar), 03 S03 sin banner, 04 S05 sin anuncio, 05 resumen sin anuncio, 06 Configuración (analítica, preferencias de privacidad, compra), 07 compra sin Play, 08 Inicio sin red, 09 sesión sin red, 10 S10 sin anuncio.

En el formulario UMP se eligió «No dar consentimiento» (la opción más restrictiva): UMP deja pedir anuncios limitados y el banner de prueba cargó igual.

## 4. Decisiones

- **Indicador del intersticial por `--dart-define`** (`TL_INTERSTITIAL=on`), no Remote Config (pedido de D8: sin backend). Los topes de R-A3 se aplican salvo `TL_INTERSTITIAL_CAPS=off` (solo QA).
- **Estado de la compra en `ad_state.ads_removed`** (tabla prevista en D2) y reverificado con Play al abrir: si Play responde, manda (también revoca). Sin respuesta, se mantiene lo local.
- **Analítica sin proveedor:** `AnalyticsSink` no-op con log en depuración; se conecta sobrescribiendo `analyticsSinkProvider`. Solo registra con el interruptor encendido y con UMP en «no requerido» u «obtenido».
- **UMP y SDK arrancan después del primer cuadro** y solo sin sesión, resumen ni pasos críticos; el formulario nunca aparece durante una sesión.
- **Banner adaptativo anclado estándar** (~50–60 dp, como Main). La variante «large» que recomienda el SDK 9.x medía ~120 dp en el emulador.

## 5. Desviaciones del PRD y del diseño

- Arquitectura: Remote Config y Firebase Analytics → reemplazados por `--dart-define` y un destino no-op (decisión de Gestión pendiente).
- PRD, analítica: se implementaron `session_start`, `session_complete`, `template_used` y `purchase_remove_ads`; quedan fuera `session_recovered`, `routine_created`, `interval_created`, `goal_set`, `reminder_enabled` y `backup_created` (el pedido de D8 era el mínimo).
- R-A3 «primeros 7 días» se mide desde la primera sesión completada (no hay fecha de instalación sin otro paquete).
- S16 (diseño): la fila «Consentimiento de anuncios · REVISAR» se llama «Preferencias de privacidad» y solo aparece si UMP lo pide; la tarjeta de compra suma el botón con el precio de Play, «Restaurar compra» y el estado. El texto del diseño «Precio por validar en la beta (H4)» era una nota interna: se reemplazó por «Un solo pago, sin suscripción…».
- El intersticial solo se permite sobre una pantalla de consulta (tras «Listo» se vuelve a Inicio).
- La biblioteca de ejercicios tiene banner solo en modo consulta; al elegir ejercicios (editor o sesión) no.

## 6. Deuda

1. **Analítica y TCF:** encenderla con «formulario respondido» puede no bastar; leer `IABTCF_PurposeConsents` (propósitos 1, 7–9) o el modo de consentimiento cuando haya proveedor. Validar con Legal.
2. **Reintento del banner** solo al volver a la app; no hay escucha de conectividad.
3. **Compra real sin probar** (ver 2). Falta crear `trainloop_remove_ads` en Play Console y probar con testers de licencia: compra, pendiente (pago en efectivo), reembolso y restauración en otro teléfono.
4. `ad_state` viaja en el respaldo (incluye `ads_removed` y el estado de consentimiento): la reverificación lo corrige, pero conviene excluirlo del archivo.
5. `AdSize.getAnchoredAdaptiveBannerAdSize` está obsoleto en `google_mobile_ads` 9.x; decidir con Diseño si se adopta el «large».
6. Un build de release **sigue con los IDs de prueba** si no se pasan los reales; agregar una verificación en CI antes de D10.
7. `tagForUnderAgeOfConsent` sin enviar (Legal).
8. Observación sin verificar (previa a D8): `SessionGate` compara `currentConfiguration.uri.path` con `/timer`, pero con `push` ese `uri` queda en la ruta de abajo; al volver a la app con S05 abierta podría apilar otra S05. Revisar en D9.
9. Mensaje único «Google Play no está disponible» también cuando el producto no existe en Play Console.

## 7. Estado en que quedó el emulador

`emulator-5560` con la app instalada (build de depuración con geografía EEE de UMP), idioma de la app **español**, consentimiento respondido («No dar consentimiento»), wifi y datos **activados**, 2 sesiones cortas de prueba en el historial. No se tocó ningún otro emulador.
