# UX: sesión en curso, atrás, nomenclatura y «Igual que antes»

Correcciones tras la prueba de uso (rama `fix/ux-sesion-en-curso`).

## Nomenclatura (es-419 / en / pt-BR)

| Concepto | es | en | pt |
|---|---|---|---|
| Modo de entrenamiento | Intervalos · Fuerza | Intervals · Strength | Intervalos · Força |
| Plantilla guardada de intervalos | temporizador | timer | timer |
| Plantilla guardada de fuerza | rutina (de fuerza) | routine | rotina |
| Lo que se registra al entrenar | sesión | session | sessão |

- Inicio (INTERVALOS / FUERZA), el selector de Entrenar y la barra de sesión
  usan siempre el **modo**. «Rutinas» solo nombra las plantillas de fuerza,
  dentro del modo Fuerza.
- «Entrenamiento» queda como palabra genérica (p. ej. «Entrenamiento libre»),
  nunca para nombrar una plantilla de intervalos.

## Causas

- **Inicio → destino inesperado:** `TrainScreen` guardaba la vista en su
  estado y `didUpdateWidget` solo pasaba a rutinas, nunca volvía a intervalos.
  Tras tocar FUERZA (o elegir el segmento a mano), INTERVALOS mostraba las
  rutinas. Ahora la vista sale siempre de la URL (`?kind=`). No había áreas
  táctiles solapadas.
- **Atrás «rebota hacia adelante» en S10:** `SessionGate` hacía `push(S10)`
  en *cada* vuelta a la app (`onResume`) si había sesión de fuerza y S10 no
  estaba visible. Cualquier pausa/reanudación (aviso de fin de descanso,
  diálogo de permisos, cortina de notificaciones) volvía a apilar S10 después
  de salir con atrás. Ahora solo salta a la sesión al abrir la app; atrás
  minimiza y la barra «sesión en curso» la trae de vuelta.

## Comportamiento

- Barra «sesión en curso» arriba, en toda pantalla que no sea la sesión ni su
  resumen: modo y nombre, tiempo y series (fuerza) o fase (intervalos), toque
  para volver y ■ para terminar con confirmación.
- Empezar otra sesión: «VOLVER A LA SESIÓN», «TERMINAR Y EMPEZAR NUEVA» o
  Cancelar.
- «IGUAL QUE ANTES: 10 kg × 8» en cada ejercicio de S10: repite la última
  serie efectiva (el calentamiento solo si no hay ninguna) en la primera serie
  pendiente o en una nueva. Agregar serie ya no copia el calentamiento.

## Deuda

- Tocar la notificación con la app en segundo plano ya no abre S05/S10 si la
  persona había salido de la sesión: queda en la pantalla anterior con la
  barra. Para distinguirlo haría falta un extra en el `Intent` nativo.
- La barra no tiene tooltip (vive fuera del `Navigator`, sin `Overlay`); el
  botón ■ tiene etiqueta para TalkBack.
- «Terminar y empezar nueva» con intervalos espera hasta 5 s a que el servicio
  confirme el guardado; si no responde, no empieza la nueva.
- Sin prueba de widget del flujo de terminar intervalos desde la barra
  (`FakeTimerEngine.stop` no emite el estado detenido).
