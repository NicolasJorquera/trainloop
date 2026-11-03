# PhaseTimer

Pantalla completa del temporizador: el fondo toma el color de la fase y el tiempo restante domina la vista.

- Fondo y texto: el par `phase-*` / `phase-*-ink` de la fase en curso; todo el texto de la pantalla usa ese ink.
- Jerarquía: barra de fases arriba (segmentos proporcionales a la duración), nombre de fase en estilo `phase` con su ícono (▲ TRABAJO), tiempo en estilo `timer`, «Siguiente: …» en `body`.
- Controles en el tercio inferior: anterior y saltar de 64 px, pausa de 152 × 88 px en el ink de la fase, «Mantén para detener» (1 s) y candado.
- Sin anuncios, sin barra de navegación.
- Accesibilidad: el cambio de fase se anuncia con una región viva educada; la fase se identifica por palabra e ícono además del color.
- Idiomas: TRABAJO / WORK / TRABALHO. El nombre de fase debe caber en 350 px al 64 px; si no, baja a 52 px.
