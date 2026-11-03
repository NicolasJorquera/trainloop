# SetRow

Fila de una serie en la sesión de fuerza: Serie · Anterior · kg · Reps · ✓.

- Columnas: 40 px · flexible · 68 px · 60 px · 52 px; alto mínimo 52 px.
- Pendiente: kg y reps muestran la vez anterior en `ink-muted` sobre `surface-2`; ✓ con borde `line`.
- Completada: fondo `success-soft`, ✓ relleno en `success`, valores en `ink`. Un toque en ✓ completa la serie y arranca el descanso.
- Calentamiento: etiqueta «C» en `warning`; no cuenta para volumen ni récords.
- Cifras en `display` 700 con `tabular-nums`; coma o punto decimal según el idioma (82,5 / 82.5).
- Accesibilidad: la fila se lee «Serie 2, anterior 80 kilos por 8, pendiente»; ✓ mide al menos 48 px.
