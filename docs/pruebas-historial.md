# Pruebas del historial y las estadísticas (D6)

Criterio de aceptación de D6: las cifras coinciden con un conjunto de datos de prueba calculado a mano, y la semana unificada y la separada quedan disponibles para el test H5.

- Conjunto de datos: `test/fixtures/history_fixture.dart` (`buildHistoryFixture`).
- Prueba que compara cada cifra: `test/features/history/history_figures_test.dart` (3 tests, en verde).

## 1. Conjunto de datos

Una semana: lunes 26 a domingo 1 de noviembre de 2026. Hoy es el miércoles 28. Las sesiones guardan `utc_offset_minutes = −180` (UTC−3). La semana empieza el lunes y el objetivo es de 3 sesiones. Las sesiones se insertan con los DAOs; los récords se calculan al guardar cada sesión (`RecordsRepository.recomputeSession`), como en la app.

| Sesión | Día y hora local | Tipo | Contenido | Duración |
|---|---|---|---|---|
| A | lun 26, 18:00 | Fuerza | Sentadilla: **40×10 (calentamiento)**, 80×8, 80×6 → **editada a 85×8**. Press de banca: 60×8 | 50 min |
| B | mar 27, 07:00 | Intervalos | Tabata 20/10 completo: preparación 10 s + 8×20 s de trabajo + 7×10 s de descanso | todas las fases |
| C | mar 27, 19:00 | Intervalos | Tabata **incompleto**: 6 fases (prep. 10, trabajo 20, descanso 10, trabajo 20, descanso 10, trabajo **15 de 20**) y 30 s de pausa | 6 fases |
| D | mié 28, 07:00 | Fuerza | Sentadilla: 90×3 | 20 min |

La edición de A pasa por `HistoryRepository.updateSet` (la misma ruta que S13), que recalcula los récords.

## 2. Cifras esperadas, calculadas a mano

**1. Sesiones de la semana.** Cuentan las completadas e incompletas, sin descartadas ni borradas: A, B, C y D = **4** (el objetivo es 3).

**2. Minutos activos.** En fuerza se cuenta fin − inicio − pausas. En intervalos, la suma de las fases registradas, sin pausas:

- A: 50 min = 3.000 s.
- B: 10 + 8·20 + 7·10 = 240 s.
- C: 10 + 20 + 10 + 20 + 10 + 15 = 85 s. Los 30 s de pausa no cuentan.
- D: 20 min = 1.200 s.
- Total: 3.000 + 240 + 85 + 1.200 = 4.525 s; 4.525 / 60 = 75,4, que se redondea a **75 min**.

**3. Volumen de A (sin calentamiento).** 80·8 + 85·8 + 60·8 = 640 + 680 + 480 = **1.800 kg**. Los 40×10 de calentamiento (400 kg) no cuentan.

**4. Volumen semanal.** 1.800 (A) + 90·3 = 270 (D) = **2.070 kg**. Se muestra «2.070 kg» en es-419.

**5. Tabata incompleto (C).** Cuentan las rondas con su fase de trabajo terminada: 2 de 8, porque el 3.er trabajo quedó en 15 de 20 s. Resultado: **2/8 rondas**. Tiempo de trabajo: 20 + 20 + 15 = **55 s**.

**6. Récords de sentadilla.** Se calculan en orden cronológico y no cuentan el calentamiento.

- Peso máximo: A llega a 85 kg (primera marca, no se destaca). D levanta 90 > 85, así que el récord es **90 kg × 3, de D, y superó 85 kg**.
- 1RM estimado con la fórmula de Epley (1RM = w·(1 + r/30), solo para 1 a 12 repeticiones):
  - A: 80×8 = 101,33 kg y 85×8 = 85·38/30 = **107,67 kg**.
  - D: 90×3 = 90·1,1 = 99 kg.
  - El récord es **107,7 kg**, de A (redondeado a 0,1 según R-P4).

**7. Recálculo al editar.** Si la serie editada vuelve a 80×6:

- El 1RM de A pasa a 80×8 = **101,33 kg**.
- El peso máximo de D superaba 80 kg (`previousValue` = 80.000 g).
- El volumen semanal queda en 640 + 480 + 480 + 270 = **1.870 kg**.

**8. Recálculo al borrar y al deshacer.** Al borrar D:

- El peso máximo vuelve a **85 kg de A**, sin valor superado porque es la primera marca.
- La semana queda con **3** sesiones.

Al deshacer, vuelven 90 kg de D y las **4** sesiones.

## 3. Resultado

| # | Cifra | A mano | App |
|---|---|---|---|
| 1 | Sesiones de la semana | 4 | 4 ✅ |
| 2 | Minutos activos | 4.525 s → 75 min | 4.525 s → 75 ✅ |
| 3 | Volumen de A | 1.800 kg | 1.800.000 g ✅ |
| 4 | Volumen semanal | 2.070 kg | 2.070.000 g, «2.070 kg» ✅ |
| 5 | Tabata incompleto | 2/8, 55 s | 2/8, 55 s ✅ |
| 6 | Peso máximo y 1RM | 90×3 (superó 85) · 107,67 kg | igual, «107,7 kg» ✅ |
| 7 | Tras editar | 1RM 101,33 · volumen 1.870 | igual ✅ |
| 8 | Tras borrar y deshacer | 85 kg (A) · 3 → 90 kg (D) · 4 | igual ✅ |

La migración v4 → v5, que vacía la caché y la recalcula, tiene su propia prueba con `SchemaVerifier` en `test/drift/app_database/migration_test.dart`.

## 4. Semana unificada y separada (H5)

La variante es un ajuste interno (`AppSettings.weekVariant`, clave `debug.weekVariant`) y no tiene pantalla pública:

- **Build de depuración:** Configuración → sección de depuración → «Vista semanal (prueba H5)» → UNIFICADA / SEPARADA.
- **Cualquier build (p. ej. release para los testers):** `flutter run --dart-define=TL_WEEK_VARIANT=separate` (o `unified`). El valor fijado al compilar manda sobre el guardado.

## 5. Deuda de pruebas (por pedido de cerrar rápido)

- El conjunto de datos tiene una sola semana. Faltan casos de varias semanas en automático:
  - racha semanal;
  - sesiones por semana de las últimas 8 semanas y su promedio;
  - cambio de semana con inicio en domingo;
  - sesión de domingo por la noche que en UTC ya es lunes (R-P2);
  - drop set y al fallo;
  - más reps por peso y mayor volumen por sesión, para la que hay código pero no cifras a mano;
  - una sesión descartada.
- No hay pruebas de widgets de S12, S13, S14 y S15: la vista semanal y su plan, la edición en S13, el borrado con deshacer desde la interfaz, las barras de S14 y el gráfico de S15. Tampoco se agregaron al test de pseudo-locale. El test de pseudo-locale existente (Inicio, Historial, Progreso y Configuración vacíos) pasa.
- No se probaron en el emulador las sesiones reales, el récord nuevo en el resumen ni S13 en modo edición; ver las capturas en el informe de D6.

## 6. Deuda técnica y desviaciones

- **El diseño S12 muestra el selector UNIFICADA/SEPARADA en pantalla.** Por pedido, quedó como ajuste interno o `--dart-define`, sin pantalla pública. La nota del diseño «Variante para comparar…» no se muestra.
- **«Descanso» en la semana.** `plan_day` no tiene un tipo descanso. «Descanso» es un día pasado sin sesiones y «Libre», hoy o un día futuro sin plan. En el diseño, un día futuro aparece como «Descanso».
- **Plan por día.** Hay una hoja simple, sin diseño propio, con una opción por día (rutina, entrenamiento o plantilla rápida, o sin plan). Faltan varios entrenamientos por día y el cumplimiento del plan del calendario.
- **S13.** Solo se editan series ya hechas: no se agregan series ni ejercicios, y no se cambian la fecha ni la hora (R-P7: «sesiones editadas hacia otra semana»). El nombre editado se guarda en la copia `template_snapshot`.
- **F-12 (P2), pendiente:**
  - gráfico del peso máximo en el tiempo (solo está el 1RM);
  - volumen y series por grupo muscular;
  - cumplimiento del plan;
  - sugerencia de respaldo en Progreso.
  - R-P7 solo está en las barras de S14: las demás cifras no abren las sesiones que las componen.
- **«Más reps con X kg» en S15.** Se muestran todos los pesos, no solo uno como en el diseño.
- **Racha y objetivo.** La racha usa el objetivo actual para todas las semanas, porque no se guarda el historial del objetivo.
- **Filtros del historial.** El diseño no los pide y no se implementaron.
- **Ruta del detalle de ejercicio.** S15 vive en `/progress/exercises/:id` porque `/exercises/:id` ya es el formulario del ejercicio.
- **Pruebas de widgets.** El test de la sección de depuración necesitó un bucle de `runAsync` y `pump`: Inicio e Historial escuchan la base con streams que corren en el reloj falso y se alternan con la siembra.
