# Temporizador (D4): pruebas en emulador

Emulador `Trainloop_Spike_API36` (Android 16, API 36, arm64, Google Play), serial `emulator-5560`, build de depuración. Mediciones con el registro CSV de depuración (`files/timer_debug.csv`, solo en builds depurables) y `tool/timer_adb.sh stats`. "Retraso" = instante real del cambio de fase menos su objetivo absoluto en `SystemClock.elapsedRealtime`. Fecha: 2026-11-03.

Durante las pruebas el host tuvo carga media de ~20 (otros emuladores y procesos); los atípicos de más de 100 ms coinciden con pausas de todo el sistema (`system_server` registra "Slow dispatch"), no del motor.

| Caso | Resultado | Datos |
|---|---|---|
| T-01 Pantalla bloqueada toda la sesión | PASS | Tabata con pantalla apagada desde el s. 2: 16/16 cambios con pantalla apagada, retraso medio 3 ms, máx. 13 ms; último cambio en 240 001 ms (desfase +1 ms); 48 pitidos y 16 avisos de fase. |
| T-02 App en segundo plano (Ajustes abierto) | PASS | 16 cambios, máx. 3 ms. La notificación decía "Trabajo · Ronda 2/8" y su cuenta regresiva terminaba a 1 ms del fin real de la fase. |
| T-03 Música de otra app | NO PROBADO (emulador) | No hay app de música en el emulador. Los avisos piden foco transitorio con atenuación sin depender de él (Android 16 lo ignora en segundo plano, ver spike). Pendiente en teléfono real. |
| T-04 Auriculares Bluetooth | NO PROBADO (emulador) | El emulador no simula Bluetooth. Pendiente en teléfono real. |
| T-05 Pausa, reanudar, bloquear/desbloquear, rotar | PASS | Pausa de 10 319 ms, rotación 4 veces y pantalla apagada 8 s: mismo proceso (PID igual), 16 cambios, máx. 3 ms; tiempo activo 239 998 ms de 240 000 (las pausas no cuentan). |
| T-06 Llamada entrante (gsm call/accept/cancel) | PASS | El temporizador siguió; durante el timbre y la llamada los avisos de fase salieron sin sonido (`audio=false`) y con vibración; tras colgar volvieron a sonar. "Pausar en llamadas" no está implementado (ver deuda). |
| T-07 Permiso de notificaciones denegado | PASS | Explicación única (S18-a) y "No permitir" en el diálogo del sistema: la sesión corre, servicio en primer plano `types=0x40000000` (specialUse), 0 notificaciones, 4 cambios en 60 s con pantalla apagada. 1 atípico de 447 ms con el hilo principal ocupado: el motor pasó a un hilo propio de prioridad alta. |
| T-08 Batería restringida | PASS (detección y guía) | Con `RUN_ANY_IN_BACKGROUND=ignore` se muestra S18-c ("Evita que Google pause el temporizador", 3 pasos, abrir ajustes). Si se empieza igual, Android detiene el servicio a los 66 s ("Stopping service due to app idle"), como en el spike; queda el punto en 65,6 s y la app ofrece recuperar al instante. Restricción quitada al terminar. |
| T-09 Doze | PASS (versión corta) | Doze profundo forzado (`battery unplug` + `deviceidle force-idle`) con pantalla apagada: 15 de 16 cambios en Doze, máx. 13 ms. La sesión de 60 min queda como deuda. |
| T-10 El sistema mata el proceso (`kill -9`) | PASS | Recuperación al reabrir (S18-b) en pausa y en la misma fase. Pérdida medida (cota superior): 0 s (matado justo tras un cambio), 1,2 s y 2,4 s; el punto se guarda en cada cambio y cada 5 s, con escritura atómica. |
| T-11 Reinicio del teléfono | PASS | `adb reboot` a los 30 s: tras arrancar no hay servicio (no se reanuda solo); al abrir, S18-b con el punto en 30,0 s y la sesión en "recuperación pendiente". |
| T-12 Cambio de hora y de zona | PASS | Hora +2 h y zona Asia/Tokyo a los 15 s, luego −5 h y America/Santiago: el conteo no cambió (los cambios siguientes, 2–61 ms). La hora de pared del registro saltó; el desfase se mide en el reloj monotónico. Hora y zona restauradas. |

Otros resultados:

- Tabata desde Inicio: **2 toques** (plantilla → EMPEZAR). La primera vez se suman la explicación del permiso y el diálogo del sistema.
- Total de Tabata: 4:00 con la preparación (S03, Inicio y S06 coinciden; ver `docs/arquitectura.md`).
- Voz: el primer aviso habla gracias al precalentamiento (`cue_voice=true` en la preparación). En este emulador el servicio Google TTS se cae con SIGILL después de hablar (lápida en `dropbox`), así que avisos alternos salen sin voz; la app reinicia el TTS, repite el aviso si alcanza en 2 s y mantiene el tono. No se espera en teléfonos reales: revisar en D9.
- Notificación: cuenta regresiva nativa, color de la fase, "Pausar"/"Reanudar" y "Saltar" funcionan desde la notificación. El emulador no tiene pantalla de bloqueo configurada; la captura es del panel de notificaciones.

## Deuda técnica

- **Prueba de desfase ≤ 1 s en 60 min con pantalla apagada/Doze (criterio de D4): pendiente.** Hacer en D9 junto a las pruebas en Samsung/Xiaomi. Hoy solo hay versiones cortas (T-01, T-09) y la sesión de 29:50 del spike (+3 ms).
- T-03 (música) y T-04 (Bluetooth) en teléfono real.
- Opciones de ajustes del PRD aún sin pantalla: "pausar en llamadas", "solo vibración" con auriculares desconectados, aviso de mitad de intervalo y mantener pantalla encendida (R-I7, R-I9).
- Voz del emulador: confirmar en teléfonos reales que no hay avisos sin voz.
- D5 sumó deuda propia (pruebas saltadas de `routine_flow_test.dart`, entre otras): ver `docs/pruebas-fuerza.md`.
