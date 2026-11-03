# SegmentedControl

Control para alternar entre 2 y 3 vistas u opciones excluyentes: Intervalos / Rutinas, Semana / Lista / Calendario, Sistema / Claro / Oscuro.

- Contenedor `surface-2`, padding 4 px, `radius-md`; segmentos de 40 px de alto.
- Seleccionado: fondo `surface-1`, texto `ink` 600. No seleccionado: transparente, `ink-muted` 500.
- Texto en `body` 14 px; en mayúsculas solo si el contexto es una sesión.
- Para chips de filtro (músculo, equipo) usa el mismo patrón suelto: seleccionado en `accent-soft` con texto y borde `accent`.
- Accesibilidad: `role="tablist"` con `aria-selected` cuando cambia de vista; `aria-pressed` cuando es una opción.
