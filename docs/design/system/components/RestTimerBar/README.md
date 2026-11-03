# RestTimerBar

Barra fija bajo la cabecera de la sesión de fuerza que muestra el descanso en curso.

- Aparece al completar una serie y desaparece al terminar o al tocar Saltar.
- Fondo `phase-rest`, texto `phase-rest-ink`; cuenta regresiva en `display` 800 a 40 px con `tabular-nums`.
- Acciones: −15 s, +15 s (botones translúcidos de 48 px) y SALTAR (fondo `phase-rest-ink`, texto `phase-rest`).
- Al llegar a cero: sonido y vibración, y la barra muestra «¡A la siguiente serie!» 3 s en `success-soft`.
- Accesibilidad: `role="timer"` con región viva educada; los botones llevan etiquetas localizadas («Restar 15 segundos»).
