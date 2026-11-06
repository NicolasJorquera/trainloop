# Data safety de Google Play: borrador (D8)

> **Pendiente de revisión de Legal/Administración.** Es un borrador técnico para completar el formulario «Seguridad de los datos» de Play Console. Las respuestas sobre el SDK de anuncios siguen la guía pública de Google para AdMob y deben contrastarse con su versión vigente al publicar. No es una opinión legal.

Versión de la app: 1.0.0 (D8). SDK: `google_mobile_ads` 9.2.0 (Google Mobile Ads 25.5.0, UMP 4.0.0) e `in_app_purchase` 3.3.1 (Play Billing). Fecha: 2026-11-03.

## 1. Resumen

- **Sin cuenta ni servidor propio.** La app no tiene backend: no recibe ni guarda datos de nadie fuera del teléfono.
- **Los datos de entrenamiento no salen del teléfono** (NF-07): rutinas, sesiones, series, pesos, notas, récords, recordatorios y preferencias viven en la base local (SQLite) y en `shared_preferences`.
- **Único tráfico de red: el SDK de anuncios de Google** (AdMob + UMP) y Google Play Billing para la compra «Sin anuncios». La analítica está preparada pero **no tiene proveedor**: hoy no envía nada.
- **Respaldo:** la copia automática de Android (al Google Drive de la persona, gestionada por el sistema) y el archivo manual que la persona guarda donde elige (selector del sistema). Ninguno pasa por servidores del desarrollador.

## 2. Respuestas del formulario

### 2.1 Recolección y seguridad

| Pregunta | Respuesta | Nota |
|---|---|---|
| ¿La app recolecta o comparte alguno de los tipos de datos requeridos? | **Sí** | Por el SDK de anuncios (AdMob). Sin anuncios (compra) el SDK sigue presente, pero no pide anuncios. |
| ¿Todos los datos se cifran en tránsito? | **Sí** | El SDK de Google usa HTTPS/TLS. La app no hace otras conexiones. |
| ¿Ofreces una forma de pedir que se borren los datos? | **No hay cuenta** | Los datos de la app se borran desinstalando o con «Borrar datos». Para el ID de publicidad, la persona lo restablece o elimina en Ajustes de Android. Confirmar con Legal la respuesta exacta para apps sin cuenta. |
| ¿Los datos se recolectan de forma opcional? | **Mixto** | Los del SDK de anuncios son necesarios para mostrar anuncios. En el EEE, Reino Unido, Suiza y estados de EE. UU. con ley, UMP pide el consentimiento (personalización); sin él, AdMob sirve anuncios limitados o no personalizados. |
| Compromiso con la Política de Familias | No aplica | Público objetivo: mayores de 13 años (R-A8). Anuncios con clasificación máxima T. |

### 2.2 Tipos de datos (los recolecta el SDK de AdMob, no la app)

| Categoría Play | Tipo | ¿Recolectado? | ¿Compartido? | Propósito | ¿Opcional? |
|---|---|---|---|---|---|
| Ubicación | Ubicación aproximada (derivada de la IP) | Sí | Sí, con socios de publicidad | Publicidad o marketing; Analíticas; Prevención de fraude, seguridad y cumplimiento | No |
| Actividad en la app | Interacciones con la app (impresiones y clics en anuncios) | Sí | Sí | Publicidad o marketing; Analíticas | No |
| Información y rendimiento de la app | Registros de fallas | Sí | No | Analíticas; Prevención de fraude | No |
| Información y rendimiento de la app | Diagnóstico (rendimiento del SDK, tiempos de carga) | Sí | No | Analíticas; Prevención de fraude | No |
| Información y rendimiento de la app | Otros datos de rendimiento | Sí | No | Analíticas | No |
| ID de dispositivo u otros | ID de publicidad (AAID), App Set ID y, en Android 13+, los de Privacy Sandbox (Topics, Attribution) | Sí | Sí, con socios de publicidad | Publicidad o marketing; Analíticas; Prevención de fraude | No |

**No se recolectan:** información personal (nombre, correo, teléfono, dirección), salud y fitness (los entrenamientos son locales; procesarlos en el teléfono no es «recolección»), mensajes, fotos, audio, archivos, calendario, contactos, historial web, ubicación precisa.

**Compras:** el pago lo procesa Google Play (Play Billing). La app solo recibe el estado de la compra del producto `trainloop_remove_ads` y lo guarda localmente (`ad_state.ads_removed`); no ve medios de pago. Según la guía de Play, lo que Google Play procesa no se declara como recolección del desarrollador: **confirmar con Legal**.

**Analítica:** hoy el destino es un no-op (log en depuración). Cuando Gestión elija proveedor (p. ej. Google Analytics for Firebase), habrá que **agregar**: «Actividad en la app → Interacciones con la app» y «ID de dispositivo u otros» (ID de instancia del proveedor), propósito Analíticas, no compartidos, opcionales (interruptor «Estadísticas de uso anónimas» en Configuración y consentimiento). Los eventos previstos solo llevan tipo de sesión, tramo de duración, clave de plantilla incluida y resultado de la compra (`lib/features/analytics/domain/analytics_service.dart`).

### 2.3 Datos que NO salen del teléfono (para la ficha y la política de privacidad)

- Base local: ejercicios, rutinas, sesiones, series (peso, reps, RPE), fases, récords, plan semanal, recordatorios y estado de anuncios/compra.
- Preferencias: tema, acento, idioma, unidad, objetivo, alertas, interruptor de analítica.
- Respaldo manual: lo exporta la persona, al destino que ella elige (SAF). Respaldo automático de Android: copia del sistema a la cuenta de Google de la persona; el desarrollador no tiene acceso.

## 3. Permisos del manifiesto final

Revisado con `aapt dump permissions build/app/outputs/flutter-apk/app-debug.apk` (D8):

| Permiso | Lo agrega | Para qué |
|---|---|---|
| `android.permission.INTERNET` | SDK de anuncios (en depuración también Flutter) | Pedir anuncios y el consentimiento |
| `android.permission.ACCESS_NETWORK_STATE` | SDK de anuncios | Saber si hay red antes de pedir |
| `com.google.android.gms.permission.AD_ID` | SDK de anuncios | Leer el ID de publicidad. **En Play Console, la declaración del ID de publicidad debe decir «Sí, para publicidad»** |
| `android.permission.ACCESS_ADSERVICES_AD_ID`, `ACCESS_ADSERVICES_ATTRIBUTION`, `ACCESS_ADSERVICES_TOPICS` | SDK de anuncios | APIs de Privacy Sandbox en Android 13+ |
| `com.android.vending.BILLING` | `in_app_purchase` | Compra «Sin anuncios» |
| `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_SPECIAL_USE`, `POST_NOTIFICATIONS`, `WAKE_LOCK`, `VIBRATE` | App (D4/D5) | Temporizador en primer plano y avisos |
| `RECEIVE_BOOT_COMPLETED` | App (D7) | Reprogramar recordatorios |
| `com.gonisoma.trainloop.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` | AndroidX | Interno (receptores dinámicos) |

Meta-dato `com.google.android.gms.ads.APPLICATION_ID`: hoy el ID de **prueba** de Google (`ca-app-pub-3940256099942544~3347511713`). Cambiarlo antes de publicar (README, «Anuncios»).

## 4. Pendientes de Legal/Administración

1. Validar las respuestas de 2.1 y 2.2 contra la guía vigente de AdMob y de Play.
2. Texto del formulario de consentimiento (se configura en AdMob → Privacidad y mensajes, con la cuenta real) y su idioma en es-419, en y pt-BR.
3. Si «respondió el formulario» basta para encender la analítica o hay que leer los propósitos TCF (deuda en `docs/pruebas-monetizacion.md`).
4. `tagForUnderAgeOfConsent`: hoy no se envía (público 13+); en el EEE la edad de consentimiento llega a 16 en algunos países.
5. Política de privacidad pública (D10) coherente con este borrador: anuncios de Google, ID de publicidad, compra por Play, datos locales y respaldo de la persona.
6. Declaración del ID de publicidad en Play Console y clasificación de contenido con anuncios.
