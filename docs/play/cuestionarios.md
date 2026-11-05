# Cuestionarios de Play Console (respuestas propuestas)

Play Console → Contenido de la app (Políticas y programas → Contenido de la app). Son propuestas: Gestión y Legal/Administración confirman antes de enviar. Formulario de seguridad de los datos: `docs/data-safety.md`.

## 1. Clasificación de contenido (IARC)

- Correo de contacto: `[CORREO DE CONTACTO]`.
- Categoría: **Todas las demás apps** (no es juego, red social ni comunicación).

| Pregunta | Respuesta | Por qué |
|---|---|---|
| Violencia, sangre, terror | No | Solo hay temporizadores, series y gráficos. |
| Sexualidad o desnudos | No | |
| Lenguaje soez u ofensivo | No | |
| Drogas, alcohol o tabaco | No | |
| Apuestas o juegos de azar simulados | No | |
| Humor crudo | No | |
| ¿Los usuarios pueden interactuar o intercambiar contenido? | No | No hay cuenta, chat ni contenido compartido. Exportar un archivo es local. |
| ¿Comparte la ubicación física de la persona con otros usuarios? | No | La ubicación aproximada que deduce AdMob va al SDK, no a otros usuarios. |
| ¿Permite compras de bienes digitales? | Sí | Compra única «Sin anuncios» (`trainloop_remove_ads`). |
| ¿Contiene anuncios? | Sí | Banner de AdMob fuera de la sesión. |
| ¿Es un navegador o motor de búsqueda? | No | |

Resultado esperado: clasificación para todo público (ESRB Everyone, PEGI 3 o equivalente), con los avisos «Compras en la app» y «Contiene anuncios».

## 2. Público objetivo y contenido

| Pregunta | Respuesta propuesta |
|---|---|
| Grupos de edad | **13–15, 16–17 y 18 o más.** Ninguno menor de 13. |
| ¿La ficha o la app atraen a niños sin querer? | No: sin personajes, juegos ni lenguaje infantil. |
| Política de Familias | No aplica, porque no se eligen menores de 13. |

**Decisión de Gestión y Legal/Administración.** El público 13+ (R-A8 del PRD) evita las reglas de Familias: SDK de anuncios certificado para familias, sin ID de publicidad, etc. Riesgos que deben revisar:
- en el EEE, la edad de consentimiento digital llega a 16 años en algunos países;
- hoy la app no envía `tagForUnderAgeOfConsent` (`docs/data-safety.md`, punto 4 de pendientes).

## 3. Anuncios

- ¿La app contiene anuncios? **Sí.** Banner de AdMob fuera de la sesión. El intersticial experimental está apagado en el build de producción (README, «Anuncios»).
- Declaración del ID de publicidad: **Sí, la app usa el ID de publicidad** para **Publicidad o marketing**. Lo agrega el SDK de AdMob (`com.google.android.gms.permission.AD_ID`).

## 4. Acceso a la app

- **Toda la funcionalidad está disponible sin restricciones de acceso.** No hay cuenta, inicio de sesión ni código.
- Nota para el revisor (opcional), en: "No account or login. All features are available on first launch. The 'Remove ads' purchase is optional."

## 5. Salud y fitness

- **Categoría de la app** (Presencia en la tienda → Configuración de la tienda): **Salud y fitness**. Etiquetas sugeridas: Fitness, Entrenamiento.
- **Declaración de apps de salud** (Contenido de la app → Apps de salud). Play la pide a toda app de la categoría Salud y fitness o con funciones de salud. Propuesta:
  - funciones: **Actividad física y fitness** (temporizador de intervalos y registro de entrenamientos de fuerza);
  - no aplica: investigación médica, dispositivos médicos, salud mental, salud reproductiva, gestión de enfermedades ni medicamentos;
  - no usa Health Connect, sensores corporales ni el reconocimiento de actividad.
- Las funciones y los textos de la ficha no hacen afirmaciones médicas ni prometen resultados de salud.
- **Pendiente de Legal:** revisar si la declaración vigente de apps de salud exige algo más (por ejemplo, una política de privacidad específica) para una app de fitness sin datos que salgan del teléfono.

## 6. Otros formularios

| Formulario | Respuesta | Fuente |
|---|---|---|
| Seguridad de los datos | Ver borrador | `docs/data-safety.md` |
| Política de privacidad (URL) | `[URL]` cuando se aloje `docs/play/privacy/index.html` | `docs/play/politica-privacidad.md` |
| Permisos de servicios en primer plano | `specialUse` | `docs/play/declaracion-fgs.md` |
| Apps gubernamentales | No | |
| Funciones financieras | No | |
| Apps de noticias | No | |
| Alarmas exactas (`SCHEDULE_EXACT_ALARM` / `USE_EXACT_ALARM`) | No se piden | Recordatorios con alarma inexacta (README, F-13) |
