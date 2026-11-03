# Button

Botón de acción en tres variantes: principal, secundario y texto.

- **Principal**: `primary-bg` + `primary-ink`, estilo `button` (Barlow Condensed 800, mayúsculas), alto 56 px, `radius-md`. Una sola por pantalla.
- **Secundario**: borde de 2 px en `ink`, fondo transparente, mismo texto.
- **Texto**: sin borde, `accent` en oscuro y en claro; para acciones menores («Omitir»). Acciones destructivas usan `danger`.
- Durante una sesión los botones miden al menos `touch-session` (64 px).
- El texto es un verbo: EMPEZAR, GUARDAR SERIE, TERMINAR. Deja espacio para un 30% más de largo al traducir.
- Accesibilidad: elemento `button` real; los botones solo con ícono llevan `aria-label` localizado.
