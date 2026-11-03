# Trainloop

Trainloop es un cuaderno de entrenamiento para Android que une un temporizador de intervalos y un registro de fuerza, sin cuenta y con los datos en el teléfono. El sistema visual se llama **Pizarra de hierro**: oscuro por defecto, casi negro con un acento vivo que la persona elige entre 8 (Orquídea por defecto), cifras grandes en tipografía condensada y esquinas casi rectas. Tiene que sentirse de gimnasio y no parecerse a la app de juegos de la misma organización, que usa gris claro, tarjetas blancas y azul.

Fuentes de este sistema: la dirección A aprobada en el lienzo [Trainloop — Pantallas MVP](https://claude.ai/artifact/PKjPBayWUvS8Hc3SorSkrm) y el documento [Trainloop — UX/UI](https://claude.ai/artifact/TWuoDWG5iCTz5UgFWkpJVC).

## Principios

1. **Entrenar primero.** Cualquier entrenamiento está a dos toques desde Inicio.
2. **Durante la sesión, lo mínimo.** Una acción principal, controles de 64 dp o más en la mitad inferior, sin anuncios.
3. **Legible a dos metros.** El tiempo restante usa el estilo `timer` (188 px, condensado, cifras tabulares).
4. **La fase se reconoce por color, ícono y palabra a la vez.** Nunca solo por color.
5. **La app recuerda por ti.** Los valores de la vez anterior aparecen en `ink-muted` hasta confirmarlos.

## Voz y contenido

- Directa, en segunda persona, con tuteo: «Empezar», «Mantén para detener», «Tus datos están solo en este teléfono».
- Verbos de acción en botones y en mayúsculas condensadas (`button`): EMPEZAR, GUARDAR SERIE.
- Sin culpa ni presión: la racha es **semanal**, nunca diaria.
- Términos fijos del glosario: serie, repetición (reps), descanso, ronda, trabajo, calentamiento, vuelta a la calma, RPE.

## Idiomas

Al lanzamiento: español latinoamericano (`es`), inglés (`en`) y portugués de Brasil (`pt-BR`), revisados por un hablante nativo.

| es | en | pt-BR |
| --- | --- | --- |
| Entrenar | Train | Treinar |
| Fuerza | Strength | Força |
| Serie | Set | Série |
| Descanso | Rest | Descanso |
| Ronda | Round | Rodada |
| Mantén para detener | Hold to stop | Segure para parar |

- Números: coma decimal en `es` y `pt-BR` (82,5 kg), punto en `en` (82.5 kg). Miles: 6.240 frente a 6,240.
- El peso se guarda en su unidad original; kg o lb según la región, cambiable en Configuración.
- Deja holgura para textos un 30% más largos (alemán, a futuro). Nada de texto dentro de imágenes.

## Color

Dos temas: **Oscuro** (referencia) y **Claro**. La app sigue el tema del sistema y ofrece Sistema / Claro / Oscuro en Configuración.

- `accent` (orquídea) es la firma: pestaña activa, barras de progreso, marcas de fuerza. Sobre `accent` siempre va `on-accent`.
- `primary-bg` / `primary-ink`: el botón principal es orquídea con texto negro en oscuro, y negro con texto orquídea en claro.
- `ink-muted` nunca va sobre `accent` ni sobre colores de fase.
- Colores de fase, iguales en ambos temas:

| Fase | Fondo | Texto | Ícono |
| --- | --- | --- | --- |
| Preparación | `phase-prep` | `phase-prep-ink` | ■ |
| Calentamiento | `phase-warm` (ámbar) | `phase-warm-ink` | ◆ |
| Trabajo | `phase-work` (= acento elegido) | `phase-work-ink` | ▲ |
| Descanso | `phase-rest` (turquesa) | `phase-rest-ink` | ● |
| Vuelta a la calma | `phase-cool` (azul) | `phase-cool-ink` | ▼ |

Todas las fases vivas tienen la misma intensidad que los acentos y llevan texto negro. Así ninguna se ve más apagada que otra. Evitamos el par rojo/verde.

## Acento personalizable

La persona elige su acento en Configuración entre 8 opciones predefinidas; no hay selector libre. Todas tienen luminosidad similar para que el texto negro encima siempre alcance al menos 5:1.

| Acento | Oscuro (relleno) | Claro (texto y barras) | Fondo suave |
| --- | --- | --- | --- |
| Orquídea (por defecto) | `accent-orquidea` #D45CFF | #8A2BBF | `accent-orquidea-soft` |
| Rosa | `accent-rosa` #FF5CA8 | #B8216A | `accent-rosa-soft` |
| Rojo | `accent-rojo` #FF5A5F | #C2262E | `accent-rojo-soft` |
| Naranja | `accent-naranja` #FF8A3D | #B4500F | `accent-naranja-soft` |
| Amarillo | `accent-amarillo` #FFD23F | #8A6A00 | `accent-amarillo-soft` |
| Lima | `accent-lima` #A3E635 | #4D7C0F | `accent-lima-soft` |
| Azul | `accent-azul` #4D9FFF | #1F5FC9 | `accent-azul-soft` |
| Violeta | `accent-violeta` #9B7BFF | #5B3FD1 | `accent-violeta-soft` |

- Al elegir uno, `accent`, `accent-soft`, `primary-bg` / `primary-ink` y `phase-work` toman sus valores. En oscuro el acento rellena con texto negro; en claro los botones son casi negros con texto en el acento, y el texto o las barras sobre fondo claro usan la columna «Claro».
- **Regla de distinción entre fases:** Trabajo siempre es el acento. Si el acento se parece a otra fase, esa fase cambia a su alternativo:
    - Amarillo o Naranja → Calentamiento usa `phase-alt-pink`.
    - Azul → Vuelta a la calma usa `phase-alt-violet`.
    - Lima → Descanso usa `phase-cool` y Vuelta a la calma usa `phase-alt-violet`.
- El acento nunca reemplaza a `danger`, `success` ni `warning`: el rojo de acento no significa error.

## Tipografía

- **Barlow Condensed** (`display`, Google Fonts): cifras, títulos, botones y nombres de fase. Itálica 800 solo para el logotipo y el nombre de fase.
- **Inter** (`body`, Google Fonts): texto corrido, metadatos y etiquetas `overline`.
- Siempre `font-variant-numeric: tabular-nums` en tiempos, pesos y repeticiones.

## Forma y espacio

- Rejilla de 4 px; margen lateral `space-4` (16 px).
- Esquinas casi rectas: `radius-md` en botones, `radius-lg` en tarjetas. Sin sombras: la profundidad la dan `surface-1` y `surface-2`.
- Áreas táctiles: `touch-min` fuera de sesión, `touch-session` durante la sesión, `touch-primary` para pausar.
- Sin tarjetas con borde lateral de color ni emojis como marcadores.

## Iconografía

Íconos de trazo de 2 px, esquinas redondeadas, 22–24 px. Los íconos de fase son formas geométricas (■ ◆ ▲ ● ▼) para que funcionen sin color.

## Imágenes

- Dentro de la app no hay fotos en el flujo de uso: la personalidad viene de tipografía, color y movimiento.
- Las personas aparecen solo en la ficha de Play, el onboarding y los estados vacíos: reales, diversas en cuerpo, edad y género, en acción. Nada de «antes/después» ni cuerpos idealizados.
- Las licencias de fotos (Unsplash, Pexels) se validan con Legal/Administración antes de publicar. No se usan imágenes generadas con IA para personas.

## Publicidad

El espacio de banner (`banner-height`, borde punteado `line`) solo aparece en Inicio, Entrenar, Historial, Progreso y la biblioteca de ejercicios. Nunca durante una sesión, en editores, diálogos ni en el resumen.

## Accesibilidad

- Contraste: texto 4.5:1 en ambos temas; cifras grandes y bordes de control 3:1.
- Todo control es un `button` o `a` real con etiqueta localizada.
- Respeta `prefers-reduced-motion` y el tamaño de texto del sistema hasta 200%.
