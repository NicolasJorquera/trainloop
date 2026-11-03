# WeekCard

Tarjeta de Inicio que resume la semana: sesiones hechas frente al objetivo, minutos activos y racha semanal.

- Fondo `surface-1`, `radius-lg`, padding `space-4`. Etiqueta `overline` en `ink-muted`.
- Cifra protagonista en `display-xl` («2/4»; el «/4» en `ink-muted`).
- Barra segmentada: un segmento por sesión del objetivo, 8 px de alto, `radius-sm`; hechos en `accent`, pendientes en `bar-off`.
- Datos secundarios con la cifra en `display` 700 y la unidad en `body-sm`.
- La racha es semanal: nunca se rompe un día de descanso.
- Toda la tarjeta es un enlace a Progreso. Accesibilidad: se lee «2 de 4 sesiones esta semana, 95 minutos activos, racha de 3 semanas».
