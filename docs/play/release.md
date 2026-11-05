# Release en Google Play (D10)

Pasos para pasar de este repositorio a producción. Los pasos marcados con **[Gestión]** necesitan la cuenta de Play Console o de AdMob, que aún no existen.

Versión actual: `pubspec.yaml` → `version: 1.0.0+2`, es decir, `versionName` 1.0.0 y `versionCode` 2. El 1 ya se usó en los builds de prueba de D1–D9. Cada subida a Play necesita un `versionCode` mayor: subir el número tras `+` y agregar `fastlane/metadata/android/<locale>/changelogs/<versionCode>.txt` (lo valida `test/tool/play_metadata_test.dart`).

> Con `--split-per-abi`, Flutter multiplica el código: el APK arm64 de las capturas quedó instalado como 2002 en `emulator-5554`. El AAB usa el código tal cual (2). Para volver a instalar una versión de depuración en ese emulador, primero desinstala la app.

## 1. Generar la llave de subida [Gestión]

Una sola vez, fuera del repo (`*.jks`, `*.keystore` y `key.properties` están en `.gitignore`):

```sh
keytool -genkey -v -keystore ~/trainloop-upload.jks -keyalg RSA -keysize 2048 \
  -validity 10000 -alias upload
```

Guarda el archivo y las dos claves en el gestor de contraseñas de la organización. Si se pierde, se puede pedir a Play que la restablezca (con Play App Signing), pero toma días.

## 2. Configurar `key.properties`

`android/key.properties` (no se versiona):

```properties
storeFile=/Users/<tú>/trainloop-upload.jks
storePassword=…
keyAlias=upload
keyPassword=…
```

En CI se usan las variables `TL_KEYSTORE_PATH`, `TL_KEYSTORE_PASSWORD`, `TL_KEY_ALIAS` y `TL_KEY_PASSWORD`. Sin llave, Gradle firma con la de depuración y avisa. Ese AAB **no** sirve para Play.

## 3. IDs reales de AdMob [Gestión]

1. En AdMob, crear la app Android «Trainloop» y dos bloques: banner e intersticial.
2. En AdMob → Privacidad y mensajes, crear el mensaje de consentimiento (GDPR y estados de EE. UU.) en es, en y pt. Lo revisa Legal (`docs/data-safety.md`, punto 2 de pendientes).
3. Pasar los IDs al build. El App ID se puede pasar con `-PTL_ADMOB_APP_ID`, con la variable `TL_ADMOB_APP_ID` o en `android/local.properties`.
4. **Nunca** hacer clic en anuncios reales. En los teléfonos de prueba, usar `--dart-define=TL_AD_TEST_DEVICES=<hash>`.

## 4. Compilar el AAB

```sh
export PUB_HOSTED_URL=https://pub.dev
flutter clean && flutter pub get
flutter build appbundle --release \
  -PTL_ADMOB_APP_ID=ca-app-pub-XXX~YYY \
  --dart-define=TL_ADMOB_BANNER_ID=ca-app-pub-XXX/AAA \
  --dart-define=TL_ADMOB_INTERSTITIAL_ID=ca-app-pub-XXX/BBB
# → build/app/outputs/bundle/release/app-release.aab
```

- La tarea `verifyReleaseAdIds` hace fallar el build si algún ID es de prueba. Es lo esperado mientras no estén los IDs reales.
- Para comprobar que compila sin IDs reales: `TL_ALLOW_TEST_ADS=true flutter build appbundle --release`. **Ese AAB no se sube a Play.**
- El intersticial queda apagado salvo que se compile con `--dart-define=TL_INTERSTITIAL=on`, que se decide para la beta.
- Antes de compilar: `dart format --set-exit-if-changed lib test tool integration_test test_driver`, `flutter analyze` y `flutter test`.

Verificación de D10 (5 nov 2026), sin IDs reales: ver «Estado» al final.

## 5. Play App Signing [Gestión]

1. Crear la app en Play Console:
   - nombre «Trainloop»;
   - idioma predeterminado es-419;
   - app, gratis, con anuncios.
2. Al subir el primer AAB, aceptar **Play App Signing** con la llave generada por Google. La llave del paso 1 queda como llave de subida.
3. Copiar el certificado SHA-1/SHA-256 de la llave de firma de la app (Configuración → Integridad de la app) por si un servicio lo pide más adelante (Firebase, por ejemplo).

## 6. Producto «Sin anuncios» [Gestión]

Hace falta haber subido al menos un AAB con el permiso `BILLING` a cualquier pista.

1. Monetizar → Productos → **Productos integrados en la app** → Crear producto.
2. ID: `trainloop_remove_ads`. Debe coincidir con `removeAdsProductId` en `lib/features/monetization/domain/monetization_config.dart`.
3. Nombre y descripción en es-419, en-US y pt-BR (p. ej., «Sin anuncios» / "Remove ads" / «Sem anúncios»: «Quita los anuncios para siempre. Pago único.»).
4. Precio: la hipótesis H4 es US$3,99. Lo decide Gestión. Play convierte el precio por país.
5. Activar. Agregar las cuentas de prueba en Configuración → **Prueba de licencias** para comprar sin cargo.

## 7. Pistas: interna → cerrada → producción

### 7.1 Prueba interna

- Subir el AAB y agregar hasta 100 testers internos (lista de correos).
- Comprobar:
  - instalación desde Play;
  - compra de prueba y «Restaurar compra»;
  - consentimiento UMP con una VPN o `TL_UMP_DEBUG_GEOGRAPHY`;
  - banner real con el dispositivo de prueba;
  - bloque de teléfono real de `docs/pruebas-estabilidad.md` §4.
- Revisar el informe previo al lanzamiento (Pre-launch report) y Android vitals.

### 7.2 Prueba cerrada (requisito para cuentas personales nuevas)

Play exige **≥ 12 testers que hayan aceptado y sigan inscritos durante 14 días seguidos** antes de pedir el acceso a producción. El PRD apunta a reclutar 20 por si alguno se da de baja.

1. Crear la pista «Prueba cerrada – beta» con la lista de correos o un Grupo de Google.
2. Subir el mismo AAB (o uno con un `versionCode` mayor) y enviarlo a revisión.
3. Mandar la invitación (plantilla abajo) con el enlace de inscripción («Unirse en la Web» o el enlace de Play).
4. Llevar el registro de testers (plantilla abajo). Revisarlo los días 1, 7 y 13; si alguien se da de baja, reemplazarlo antes de que el contador baje de 12.
5. Pasados los 14 días, responder en Play Console el cuestionario de acceso a producción: cómo se reclutó, qué feedback hubo y qué se cambió.

**Plantilla de invitación (es):**

> Asunto: ¿Me ayudas a probar Trainloop 14 días?
>
> Hola, [nombre]:
>
> Estoy por publicar Trainloop, una app Android de intervalos y fuerza que funciona sin cuenta y sin conexión. Google Play me pide que al menos 12 personas la prueben durante 14 días seguidos antes de publicarla.
>
> 1. Abre este enlace con la cuenta de Google de tu teléfono: [ENLACE DE INSCRIPCIÓN]
> 2. Toca «Convertirse en tester» y luego instala la app desde Play.
> 3. Úsala cuando entrenes (con una o dos sesiones por semana basta) y **no la desinstales ni te salgas de la prueba hasta el [FECHA FIN]**.
>
> Si algo falla o no se entiende, respóndeme a este correo o escribe en Play (Ficha → «Enviar comentarios privados»). Tus entrenamientos se quedan en tu teléfono: no recibo ningún dato tuyo.
>
> ¡Gracias!
> [Firma]

**Plantilla de invitación (en):**

> Subject: Can you help me test Trainloop for 14 days?
>
> Hi [name],
>
> I'm about to publish Trainloop, an Android interval and strength training app that works without an account or a connection. Google Play requires at least 12 people to test it for 14 days in a row before it can go live.
>
> 1. Open this link with the Google account on your phone: [OPT-IN LINK]
> 2. Tap "Become a tester", then install the app from Play.
> 3. Use it when you train (one or two sessions a week is enough) and **please don't uninstall it or leave the test until [END DATE]**.
>
> If anything breaks or is confusing, reply to this email or send private feedback on Play. Your workouts stay on your phone: I don't receive any of your data.
>
> Thanks!
> [Signature]

**Registro de testers** (mantenerlo fuera del repo, en una planilla interna: contiene correos, que son datos personales):

| # | Nombre | Correo de Google Play | Invitado | Aceptó (fecha) | Instaló | Día 7 activo | Día 14 activo | Teléfono / Android | Feedback | Baja (fecha) |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | | | | | | | | | | |
| … | | | | | | | | | | |
| 20 | | | | | | | | | | |

Inicio de los 14 días: fecha en que el tester número 12 aceptó. Fin: inicio + 14 días.

### 7.3 Producción

1. Pedir el acceso a producción (Panel → «Solicitar acceso a producción»).
2. Promover el AAB de la beta a producción con lanzamiento escalonado del 20 %. Vigilar Android vitals: ≥ 99,5 % de sesiones sin fallos (NF-04).
3. Si en 3–7 días no aparecen problemas, subir al 100 %.

## Recursos de la ficha

| Recurso | Archivo |
|---|---|
| Ícono 512 × 512 | `docs/play/icon-512.png` |
| Gráfico destacado 1024 × 500 | `docs/play/feature-graphic.png` (fuente `feature-graphic.svg`; la línea está en es) |
| Textos y novedades | `fastlane/metadata/android/<locale>/` |
| Capturas de teléfono | `fastlane/metadata/android/<locale>/images/phoneScreenshots/` |

Con fastlane: `fastlane supply --aab build/app/outputs/bundle/release/app-release.aab --track internal` lee esa estructura. Requiere la llave JSON de una cuenta de servicio de Play [Gestión]. No hay `Fastfile`: también se puede cargar a mano.

**Capturas.** Se tomaron en `emulator-5554` (1080 × 2400, tema oscuro) con un release arm64 compilado así: `TL_ALLOW_TEST_ADS=true flutter build apk --release --split-per-abi --target-platform android-arm64 --dart-define=TL_ADS=off`. Ese build no tiene barra de anuncios. Los datos son de demostración: la semilla de depuración más 16 sesiones de las últimas 4 semanas cargadas en la base, que se instaló encima del build de depuración. La barra de estado está en modo demo (09:00). Nombres de la semilla: la rutina se llama «Empuje» también en en y pt.

**Gráfico destacado.** Se rasterizó con `qlmanage` (WebKit), pasando una copia del SVG con `width="768" height="768" viewBox="0 -262 1024 1024"`. Luego se recortó con `sips --cropToHeightWidth 500 1024` y se pasó por JPEG para quitar el canal alfa, que Play no acepta.

## Estado (D10)

- `flutter build appbundle --release` sin IDs reales: **falla en `verifyReleaseAdIds`**, como se espera.
- `TL_ALLOW_TEST_ADS=true flutter build appbundle --release`: **compila** (`build/app/outputs/bundle/release/app-release.aab`). Ese AAB solo sirve para probar el build. El AAB real necesita los IDs reales y la llave de subida.
