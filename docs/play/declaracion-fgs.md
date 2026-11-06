# Declaración del servicio en primer plano (`specialUse`)

Play Console → Contenido de la app → **Permisos de servicios en primer plano**. Trainloop declara un solo servicio: `com.trainloop.app.timer.TimerService`, tipo `specialUse`, permiso `FOREGROUND_SERVICE_SPECIAL_USE`.

Manifiesto (`android/app/src/main/AndroidManifest.xml`), propiedad obligatoria para `specialUse`:

```xml
<property
    android:name="android.app.PROPERTY_SPECIAL_USE_FGS_SUBTYPE"
    android:value="Workout timer started by the user: interval phases and strength rest periods keep counting and play audio/vibration cues while the screen is off." />
```

Hechos que respaldan el texto (README, D4 y D5):

- Se inicia solo cuando la persona toca EMPEZAR (intervalos) o empieza una sesión de fuerza. Nunca al arrancar el teléfono ni en segundo plano.
- Se detiene cuando la sesión termina, se detiene o se descarta.
- Muestra una notificación persistente con la fase y la cuenta regresiva.
- Cuenta con el reloj monotónico (`elapsedRealtime`) y un wake lock parcial. En cada cambio de fase emite pitidos, voz (si el teléfono tiene una voz para el idioma) y vibración.
- Guarda un punto de recuperación cada 5 s. Si Android cierra la app, se ofrece reanudar.

## Texto para el formulario

### Español

**¿Qué hace el servicio?**
Es el temporizador de entrenamiento de Trainloop. Cuando la persona empieza una sesión de intervalos (por ejemplo, Tabata 20/10) o una sesión de fuerza, el servicio cuenta cada fase de trabajo y descanso, o cada descanso entre series. Al cambiar de fase emite pitidos, voz y vibración, y muestra una notificación con la fase y el tiempo que queda. Se detiene cuando la sesión termina.

**¿Por qué lo necesita la persona?**
Durante el entrenamiento el teléfono queda con la pantalla apagada, en el bolsillo o en el suelo, y a veces con otra app de música abierta. La persona depende de los avisos para saber cuándo trabajar y cuándo descansar sin mirar la pantalla. Si el conteo se pausa o se retrasa, el entrenamiento queda mal hecho. El servicio lo inicia y lo detiene la persona; no se ejecuta en ningún otro momento.

**¿Por qué no sirve otro tipo de servicio?**
- `mediaPlayback`: la app no reproduce contenido multimedia; solo avisos cortos.
- `health`: exige pedir permisos de sensores o de actividad física (`BODY_SENSORS`, `ACTIVITY_RECOGNITION` o `HIGH_SAMPLING_RATE_SENSORS`) que la app no usa. Trainloop no lee sensores.
- `shortService`: tiene un límite de unos 3 minutos y una sesión dura de 4 a 60 minutos o más.
- `dataSync`, `location` y los demás tipos no describen el caso.
- WorkManager y AlarmManager no garantizan avisos al segundo durante varios minutos con la pantalla apagada y en Doze. Además, la app usa solo alarmas inexactas: no pide `SCHEDULE_EXACT_ALARM`.

### English

**What does the service do?**
It is Trainloop's workout timer. When the user starts an interval session (for example, Tabata 20/10) or a strength session, the service counts every work and rest phase, or every rest period between sets. At each phase change it plays beeps, voice prompts and vibration, and it shows a notification with the current phase and the time left. It stops when the session ends.

**Why does the user need it?**
During a workout the phone is usually locked, in a pocket or on the floor, sometimes with a music app in front. The user relies on the cues to know when to work and when to rest without looking at the screen. If counting pauses or drifts, the workout is ruined. The user starts and stops the service; it never runs at any other time.

**Why doesn't another service type fit?**
- `mediaPlayback`: the app does not play media, only short cues.
- `health`: requires sensor or physical activity permissions (`BODY_SENSORS`, `ACTIVITY_RECOGNITION` or `HIGH_SAMPLING_RATE_SENSORS`) that the app does not use. Trainloop reads no sensors.
- `shortService`: limited to about 3 minutes, while a session lasts from 4 to 60+ minutes.
- `dataSync`, `location` and the other types do not describe this use.
- WorkManager and AlarmManager cannot guarantee second-accurate cues for several minutes with the screen off and in Doze. The app also uses inexact alarms only and does not request `SCHEDULE_EXACT_ALARM`.

## Guion del video (30 s)

Play pide un enlace a un video (YouTube no listado o Drive) que muestre el uso. Grabar en un teléfono real con `adb shell screenrecord` o el grabador del sistema, en en-US. **Pendiente: no se ha grabado.**

| Tiempo | Pantalla | Acción | Texto en pantalla (opcional) |
|---|---|---|---|
| 0–5 s | Inicio | Tocar INTERVALS → Tabata 20/10 | "User starts a workout" |
| 5–9 s | Detalle | Tocar START; aceptar notificaciones | |
| 9–14 s | Sesión en curso | Se ve PREPARE → WORK con la cuenta regresiva | "Timer counts each phase" |
| 14–20 s | Pantalla apagada | Bloquear el teléfono; se oyen pitidos y voz al cambiar a REST | "Cues keep playing with the screen off" |
| 20–25 s | Pantalla de bloqueo / cortina | Mostrar la notificación con fase y tiempo | "Ongoing notification" |
| 25–30 s | Sesión | Desbloquear, mantener HOLD TO STOP; aparece el resumen | "User stops it; the service ends" |

Riesgo: si Play rechaza `specialUse`, la alternativa es `health` con `ACTIVITY_RECOGNITION`, que obliga a pedir un permiso que la app no usa. Esa decisión es de Arquitectura.
