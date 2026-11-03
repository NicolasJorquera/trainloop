# Trainloop — PRD v0.2 (copia de https://claude.ai/artifact/SpvyUHaQQchdMk6M3XfHC5)

# Trainloop — PRD v0.2
 · 

## Resumen
Trainloop es un cuaderno de entrenamiento Android, local y sin cuenta, que compite por fiabilidad: intervalos automatizados que no se cortan, registro de fuerza rápido y una planificación semanal simple que une ambos. Esta v0.2 incorpora investigación secundaria (comentarios públicos en Reddit y comunicación de competidores, 2023–2026). No son entrevistas: las 8–10 entrevistas reales siguen pendientes y este PRD se cierra después de ellas (Discovery).
Objetivos del MVP:

- Que una persona complete su primer entrenamiento (intervalos o fuerza) en menos de 30 segundos desde la primera apertura, sin formularios.

- Que el temporizador termine cada sesión con desfase ≤ 1 s cada 60 min, con pantalla apagada, llamadas y ahorro de batería.

- Que registrar una serie repetida cueste 1 toque.

- Que todos los datos queden en el teléfono y puedan respaldarse y restaurarse en un archivo abierto.

- Que los anuncios nunca aparezcan entre "Empezar" y el cierre del resumen de sesión.
No-objetivos del MVP: cuentas, sincronización en la nube, GPS, planes adaptativos, contenido en video, funciones sociales, wearables y Health Connect.
Convención: [O] observación verificada, [H] hipótesis por validar, [R] recomendación. Los requerimientos usan IDs (F-xx funcionales, NF-xx no funcionales, R-xx reglas) para trazarlos al diseño, las pruebas y el backlog.

## Cambios v0.1 → v0.2
La v0.2 baja el tono de certeza: el timer fiable pasa a ser la promesa central y la monetización más allá del banner queda como experimento. Las decisiones ya aprobadas (sin cuenta, offline, sin anuncios durante la sesión, medición con Firebase) se mantienen.

| Área
 | v0.1
 | v0.2
 | Motivo
 | 
| Nombre
 | "Ronda" (nombre de trabajo)
 | Trainloop
 | Decisión del equipo
 | 
| Posicionamiento
 | "Nadie combina intervalos fiables con registro de fuerza sin cuenta"
 | Intervalos automatizados fiables + registro rápido + semana conjunta simple, sin cuenta y offline. Se reconoce que Hevy ya registra cardio
 | E11, E01, E03
 | 
| Prioridades
 | Debe / Debería / Podría
 | P0 / P1 / P2 enfocado en un MVP publicable
 | Investigación secundaria §6
 | 
| Estadísticas
 | Gráficas, récords y 1RM en el MVP
 | MVP: última marca y conteo semanal; gráficas avanzadas a P2
 | Reducir alcance; sin evidencia de necesidad
 | 
| Vista semanal unificada
 | Asumida como motivadora
 | P1, a probar frente a vistas separadas
 | H5 con apoyo parcial (E08, E09, E10, E12)
 | 
| Intersticial al final
 | Aprobado con topes
 | Experimento desactivado por defecto; nunca tras cada entrenamiento
 | H4 no validada (E07)
 | 
| Precio "Sin anuncios"
 | US$3,99 propuesto
 | Hipótesis; a validar en beta; riesgo de Play Billing sin backend documentado
 | H4 no validada
 | 
| Temporizador
 | Requisitos NF-03 y reglas R-I
 | + criterios de aceptación, matriz de dispositivos y limitaciones reales
 | H3 con evidencia directa (E06)
 | 
| Datos locales
 | Respaldo en archivo (Debe)
 | Aviso de riesgo de pérdida en P0; respaldo y restauración en P1
 | Riesgo 4 de la investigación
 | 
| Validación
 | Entrevistas + beta
 | + plan de beta sin infraestructura pagada y experimentos de anuncios
 | Investigación secundaria §8
 | 
## Matriz de hipótesis H1–H5
Solo H3 (el timer falla con pantalla apagada) tiene evidencia directa de que el problema existe; H4 (anuncios y precio) sigue sin validar. La evidencia son comentarios públicos autoseleccionados, mayormente en inglés: prueban que un problema le ocurre a alguien, no su frecuencia ni la disposición a cambiar de app.

| Hipótesis
 | Respaldo
 | Contradicciones
 | Confianza
 | Preguntas abiertas
 | Cómo validar
 | 
| H1 — Quien combina pesas e intervalos usa 2+ herramientas y le molesta
 | E01, E03 (piden intervalos dentro de Hevy)
 | E02: usar varias apps no implica molestia
 | Media-baja
 | ¿Cuánto cuesta de verdad cambiar de app? ¿Qué parte del entrenamiento mixto duele más?
 | Entrevistas (pendientes) + uso combinado en beta (≥ 20% en 14 días)
 | 
| H2 — Cuenta obligatoria y límites del plan gratis hacen cambiar de app
 | E04, E05 (límites de rutinas, búsqueda de alternativas gratis)
 | E04: otros usuarios encuentran suficiente el plan gratis de Hevy
 | Media-baja
 | ¿Basta "sin cuenta" como razón para migrar?
 | Entrevistas + pregunta en la encuesta de beta
 | 
| H3 — Los timers fallan con pantalla apagada
 | E06 (Android 15, timers que se detienen con pantalla apagada; no necesariamente apps deportivas); quejas en reseñas de Play del Discovery
 | Ninguna
 | Alta en existencia; prevalencia desconocida
 | ¿En qué fabricantes y versiones?
 | Matriz de pruebas en dispositivos reales + métrica de recuperación en beta
 | 
| H4 — Banner fuera de sesión, intersticial final y US$3,99 son aceptables
 | E07 (iPhone: molestia con timers que cortan la música o tienen anuncios; disposición a pagar por uno simple)
 | No hay evidencia sobre el precio ni la frecuencia; E07 no es Android
 | Baja
 | ¿Qué frecuencia de intersticial tolera el segmento? ¿Qué precio?
 | Experimentos en beta (banner sí/no, intersticial con distinta frecuencia) + reseñas
 | 
| H5 — Ver fuerza e intervalos juntos en la semana motiva más
 | E08 (piden planificar la semana), E09 (distinguir cardio y fuerza en el calendario), E10 (ver días cumplidos motiva, en Hevy)
 | E12: abrir automáticamente la rutina del día le resulta molesto a otros usuarios
 | Media-baja
 | ¿La vista unificada ayuda o satura? ¿Plan opcional o automático?
 | Tarea de usabilidad: semana unificada frente a vistas separadas
 | Registro de evidencia (fuentes públicas; sin citas textuales ni cifras de mercado):

| ID
 | Fecha
 | Observación
 | Fuente
 | 
| E01
 | 2026-03-23
 | Pide que Hevy avance solo por ejercicios cronometrados y registrar remo, saltos, trineo y kettlebell junto con fuerza en la misma sesión
 | r/Hevy
 | 
| E02
 | 2026-03-11
 | Usuarios combinan Hevy con Strava, Garmin y timers HIIT
 | r/Hevy
 | 
| E03
 | 2025-06-07
 | Pide intervalos caminata/carrera dentro de Hevy
 | r/Hevy
 | 
| E04
 | 2024-12-05
 | Pagó Pro por más rutinas; otros dicen que el plan gratis basta
 | r/Hevy
 | 
| E05
 | 2026-10-12
 | Busca alternativa gratis a StrongLifts; le recomiendan FitNotes y mencionan límites de Hevy
 | r/LiftingRoutines
 | 
| E06
 | 2024-11-22
 | Pixel 9 Pro XL, Android 15: timers dejan de avanzar con pantalla apagada pese a ajustes de batería
 | r/AndroidQuestions
 | 
| E07
 | 2023-11-09
 | iPhone: timer que interrumpe la música, otros con anuncios; considera pagar por uno simple
 | r/HIIT
 | 
| E08
 | 2025-01-21
 | Pide planificar la semana y comparar metas con lo realizado
 | r/Hevy
 | 
| E09
 | 2023-10-06
 | Pide distinguir cardio y fuerza en calendario e historial
 | r/Hevy
 | 
| E10
 | 2026-08-12
 | Ver días cumplidos y récords le motiva (experiencia individual)
 | r/Hevy
 | 
| E11
 | 2026-07-03
 | Hevy anuncia cardio dentro de entrenamientos, vista de programas y mejoras del descanso; usuarios siguen pidiendo intervalos
 | r/Hevy
 | 
| E12
 | 2025-11-09
 | Uno quiere que se abra la rutina del día; otros lo ven molesto
 | r/Hevy
 | Enlaces tomados del informe de investigación secundaria del 2026-11-02; Reddit no fue accesible desde aquí para reverificarlos.

## Usuarios objetivo y problemas
El usuario primario entrena 3 o más veces por semana y mezcla pesas con HIIT o circuitos; hoy usa un timer gratuito y anota sus series en otra app o en notas [H].

| Perfil
 | Rol
 | Contexto
 | Hoy usa
 | Qué necesita de nosotros
 | 
| Entrenamiento mixto
 | Primario
 | 2 días de pesas + 1–2 de HIIT o circuitos; Android de gama media; escucha música mientras entrena
 | Timer gratuito + Hevy o notas del teléfono
 | Un solo lugar para ambos, sin cuenta, y ver su semana completa
 | 
| Gimnasio habitual
 | Secundario
 | 4–5 días de pesas, sigue un programa
 | Strong, Hevy o FitNotes
 | Registro rápido, sin límites de rutinas ni historial
 | 
| Intervalos de carrera por tiempo
 | Secundario
 | Series en pista o cinta, sin necesidad de GPS
 | Timer de intervalos o reloj
 | Alertas claras con el teléfono en el bolsillo
 | 
| Principiante que busca guía
 | Fuera de foco
 | Necesita saber qué hacer
 | Nike Training Club, YouTube
 | Contenido guiado: no lo cubre el MVP
 | Problemas principales:

| #
 | Problema
 | Evidencia
 | Se resuelve con
 | 
| P1
 | El timer se corta o se desfasa con pantalla apagada, llamadas o ahorro de batería
 | Quejas en Hevy, Runna, Tabata Timer, dreamspark, Seconds; E06 (Android 15) [O]
 | F-04, F-05, F-16, R-I6 a R-I11
 | 
| P2
 | Hay que crear cuenta y pasar un muro de pago antes de entrenar
 | Strong, Hevy, JEFIT, Runna, NTC [O]
 | F-01, NF-01
 | 
| P3
 | El plan gratis limita rutinas, historial o gráficas
 | Strong (3 rutinas), Hevy (4 rutinas, 3 meses); E04 y E05, con usuarios que sí encuentran suficiente el plan gratis [O]
 | F-06, F-11, F-12
 | 
| P4
 | Intervalos y fuerza quedan en apps distintas y no se ve la semana completa
 | E01, E03 piden intervalos dentro de Hevy; E02 muestra uso de varias apps sin molestia explícita [H]
 | F-10, F-11
 | 
| P5
 | Los datos quedan atrapados o se pierden
 | Hevy (cambio de login), Strong (actualización) [O]
 | F-14, NF-06
 | 
| P6
 | Anuncios que interrumpen o no se cierran
 | Tabata Timer, dreamspark [O]
 | F-15, R-A1 a R-A8
 | Posicionamiento revisado [R]: Trainloop no compite por "unir fuerza y cardio": Hevy ya permite registrar cardio dentro de un entrenamiento y anunció vista de programas y mejoras del descanso (E11). También tiene temporizador en línea para ejercicios por duración (v1.29.0) y descansos por defecto configurables más ejercicios para HYROX (v3.0.11, 2026-05-06) [O]. Lo que no encontramos en Hevy es un temporizador de intervalos automatizado (Tabata, EMOM, carrera por tiempo) que avance solo por fases, y los usuarios lo siguen pidiendo (E01, E03, E11). La oportunidad no cubierta: intervalos automatizados fiables + registro rápido + semana conjunta simple, sin cuenta obligatoria y con datos privados en el teléfono. Hay que revisar las funciones de Hevy antes de cada gate: se mueve rápido.

## Casos de uso y recorridos
Cinco recorridos cubren el MVP; los tres primeros son los que se miden en el test de usabilidad de la fase 3.
J1 — Primera apertura hasta el primer entrenamiento (objetivo < 30 s)

- Abre la app: ve Inicio con "Empezar intervalos", "Empezar fuerza" y 3 plantillas listas (Tabata 20/10, HIIT 40/20, EMOM 10 min). No hay registro ni tutorial bloqueante.

- Toca "Tabata 20/10" → ve el resumen (8 rondas, 4 min) → "Empezar".

- Android pide permiso de notificaciones en contexto, con una línea que explica para qué (ver el timer con pantalla apagada). Si lo niega, el entrenamiento empieza igual.

- Cuenta regresiva de preparación (10 s) y comienza.
J2 — Entrenamiento por intervalos

- En Intervalos toca "+" → elige estructura: calentamiento, bloque repetible (trabajo + descanso × rondas), descanso entre series, vuelta a la calma.

- Ajusta duraciones con selectores grandes; ve la duración total recalculada al instante. Guarda con nombre.

- "Empezar": pantalla completa con color por fase, tiempo restante grande, fase siguiente y progreso.

- Bloquea el teléfono: la notificación muestra fase y tiempo; las alertas de voz, pitidos y vibración siguen.

- Entra una llamada: el timer sigue y las alertas se silencian durante la llamada (configurable a "pausar").

- Termina: resumen con tiempo total, rondas completadas y omitidas; puede agregar esfuerzo percibido y nota. "Listo" guarda en el historial.
J3 — Entrenamiento de gimnasio

- En Fuerza crea una rutina: nombre → agrega ejercicios desde la biblioteca (búsqueda y filtros por músculo y equipo) → define series objetivo y descanso por ejercicio.

- "Empezar rutina": lista de ejercicios con sus series; cada serie muestra en gris el peso y las repeticiones de la vez anterior.

- Toca ✓ para aceptar los valores sugeridos (1 toque) o edita peso o repeticiones con botones ± (2 toques).

- Al marcar la serie arranca el descanso automático, visible arriba y en la notificación; suena y vibra al terminar.

- Puede agregar o quitar ejercicios y series durante la sesión sin alterar la rutina.

- "Terminar": resumen con duración, volumen y récords nuevos. Si cambió la estructura, pregunta "¿Actualizar la rutina?".
J4 — Revisar progreso

- En Progreso ve la semana actual: sesiones hechas frente al objetivo, minutos activos y volumen.

- Abre el calendario: días con sesiones marcadas por tipo; toca un día para ver el detalle.

- Abre un ejercicio: gráfico de 1RM estimado y peso máximo en el tiempo, y lista de récords.
J5 — Cambiar de teléfono

- En Configuración → Datos → "Crear respaldo": la app genera un archivo y abre el selector del sistema para guardarlo (Drive, descargas o compartir).

- En el teléfono nuevo: "Restaurar respaldo" → elige el archivo → ve un resumen (sesiones, rutinas, fecha) → confirma reemplazar los datos actuales.
Cambios v0.2 sobre los recorridos [R] (lo demás de J1–J5 se mantiene):

| Flujo
 | Recorrido
 | Cambio en v0.2
 | Prioridad
 | 
| Crear y ejecutar intervalos
 | J1, J2
 | La plantilla "Caminar/correr por tiempo" pasa al primer nivel (E03). El avance entre fases es siempre automático (E01). Las alertas respetan la música de otras apps y siguen con auriculares Bluetooth
 | P0
 | 
| Crear rutina
 | J3, paso 1
 | Sin cambios
 | P0
 | 
| Iniciar y terminar fuerza
 | J3
 | Cada serie muestra la última marca del ejercicio; el resumen muestra volumen y récord simple, sin gráficas
 | P0
 | 
| Revisar semana
 | J4
 | Vista semanal con tipos distinguibles (fuerza, intervalos, descanso, planificado) (E09). Dos variantes para el test: semana unificada y vistas separadas. El plan por día es opcional y nunca abre una rutina automáticamente (E12)
 | P1
 | 
| Guardar y exportar
 | J5
 | Tras la primera sesión, aviso de una línea: "Tus datos viven solo en este teléfono; si desinstalas la app se borran" con enlace a respaldo (P0). Respaldo, restauración y CSV quedan en P1
 | P0 aviso / P1 respaldo
 | 
## Requerimientos funcionales
El MVP publicable son los 11 requerimientos P0: timer fiable, registro de fuerza, base offline sin cuenta y recuperación de sesión. P1 completa la experiencia antes del lanzamiento si el tiempo lo permite; P2 espera datos de la beta. Complejidad en puntos relativos (1 = trivial, 5 = alta) [H], a recalibrar en la fase 4. Columna "Cambio": diferencia frente a v0.1.

| ID
 | Requerimiento
 | Complejidad
 | Prioridad
 | Cambio
 | 
| F-01
 | Primer uso sin cuenta: Inicio con accesos directos y plantillas listas; aviso de una línea de que los datos viven solo en el teléfono
 | 1
 | P0
 | + aviso de datos locales
 | 
| F-02
 | Crear y editar entrenamientos de intervalos con bloques repetibles
 | 3
 | P0
 | —
 | 
| F-03
 | Plantillas: Tabata, HIIT, EMOM, caminar/correr por tiempo; duplicar y personalizar
 | 1
 | P0
 | Caminar/correr destacada (E03)
 | 
| F-04
 | Ejecución del timer: pantalla completa, color por fase, avance automático, pausar, saltar, retroceder, bloqueo
 | 3
 | P0
 | —
 | 
| F-05
 | Alertas de voz, pitidos y vibración; convivencia con la música; segundo plano con notificación; criterios de aceptación del timer
 | 5
 | P0
 | + criterios y pruebas en dispositivos
 | 
| F-06
 | Rutinas de fuerza ilimitadas: crear, editar, duplicar, reordenar, archivar
 | 2
 | P0
 | —
 | 
| F-07
 | Biblioteca de ~100 ejercicios con búsqueda y filtros + ejercicios propios
 | 2
 | P0
 | —
 | 
| F-08
 | Sesión de fuerza: registro de series con la última marca visible, tipos de serie, RPE opcional
 | 3
 | P0
 | Última marca explícita
 | 
| F-09
 | Descanso automático por ejercicio, ±15 s, saltar, alerta y notificación
 | 3
 | P0
 | —
 | 
| F-10
 | Historial unificado, detalle editable y conteo de sesiones de la semana en Inicio
 | 2
 | P0
 | + conteo semanal (antes en F-12)
 | 
| F-16
 | Recuperación de sesión interrumpida por cierre, reinicio o falta de batería
 | 3
 | P0
 | —
 | 
| F-11
 | Vista semanal con fuerza, intervalos, descanso y planificado; plan opcional por día
 | 2
 | P1
 | De Debería a P1, a probar frente a vistas separadas (H5)
 | 
| F-13
 | Recordatorios locales por día y hora
 | 1
 | P1
 | —
 | 
| F-14
 | Respaldo y restauración en archivo; exportación CSV
 | 2
 | P1
 | De Debe a P1; el aviso de riesgo queda en P0 (F-01)
 | 
| F-17
 | Configuración de audio, vibración, descanso, unidades y tema (con valores por defecto sensatos en P0)
 | 1
 | P1
 | —
 | 
| F-15a
 | Banner en pantallas no críticas + consentimiento
 | 2
 | P1
 | Separado de F-15
 | 
| F-12
 | Estadísticas avanzadas: gráficas, 1RM estimado, volumen por músculo
 | 3
 | P2
 | De Debe a P2
 | 
| F-15b
 | Intersticial al finalizar (experimento, desactivado por defecto)
 | 2
 | P2
 | Ya no aprobado (H4)
 | 
| F-15c
 | Compra única "Sin anuncios"
 | 3
 | P2
 | Precio en hipótesis; riesgo sin backend
 | 
| F-20
 | Sesiones mixtas: bloques de intervalos y de fuerza en una sesión
 | 3
 | P2
 | Evidencia de interés en E01
 | 
| F-21
 | Superseries y circuitos de fuerza
 | 3
 | P2
 | —
 | 
| F-22
 | Calculadora de discos y de calentamiento
 | 2
 | P2
 | —
 | 
| F-23
 | Importar CSV de Strong, Hevy y FitNotes
 | 3
 | P2
 | Mitiga el costo de cambio de app
 | 
| F-24
 | Widget y accesos directos
 | 2
 | P2
 | —
 | 
| F-25
 | Exportar sesiones a Health Connect
 | 3
 | P2
 | —
 | Orden de construcción propuesto [R]: F-04/F-05/F-16 primero (riesgo técnico), luego F-02/F-03, F-06 a F-09, F-10 a F-14 y al final F-15. Coincide con los entregables 1–10 del brief.

## Flujo 1: entrenamiento por intervalos
El temporizador nunca depende de que la pantalla esté encendida ni de que la app siga viva: el tiempo se deriva de un reloj monotónico y el estado se guarda en cada transición.

[diagrama: estados de una sesión de intervalos · 7 estados]
La fase en curso puede quedar en Pausada, avanzar a la siguiente o llegar al Resumen. Si Android cierra la app, al volver a abrirla la sesión queda en Recuperación pendiente y nunca se pierde.
Reglas

| ID
 | Regla
 | 
| R-I1
 | Un entrenamiento es una lista ordenada de bloques. Un bloque es un intervalo (tipo, etiqueta, duración) o una repetición (1–99 rondas que contiene intervalos u otra repetición; máximo 2 niveles, p. ej. 4 series × 8 rondas).
 | 
| R-I2
 | Tipos de intervalo: preparación, calentamiento, trabajo, descanso, vuelta a la calma. Cada tipo tiene color y vibración propios.
 | 
| R-I3
 | Límites: intervalo de 1 s a 99:59; total ≤ 4 h; al menos un intervalo de trabajo; nombre de 1 a 40 caracteres (por defecto "Intervalos + fecha").
 | 
| R-I4
 | Una repetición puede "omitir el último descanso" (activado por defecto) y tener descanso entre series.
 | 
| R-I5
 | Preparación inicial configurable de 0 a 30 s (10 s por defecto).
 | 
| R-I6
 | El tiempo transcurrido = reloj monotónico actual − inicio − pausas acumuladas. La fase actual se calcula a partir de ese valor, nunca contando ticks.
 | 
| R-I7
 | Alertas por defecto: al iniciar cada fase, voz con su etiqueta + tono; pitidos 3-2-1 en los últimos 3 s; vibración larga al empezar trabajo y doble corta al empezar descanso; sonido final distinto. Aviso de mitad de intervalo opcional.
 | 
| R-I8
 | Las alertas bajan el volumen de la música de forma transitoria y no la pausan. Si el volumen multimedia está en 0 al empezar, se muestra un aviso.
 | 
| R-I9
 | Durante la sesión la app corre como servicio en primer plano con una notificación que muestra fase, tiempo restante, pausar y saltar. La opción "mantener pantalla encendida" está desactivada por defecto.
 | 
| R-I10
 | Controles: pausar y reanudar con un área táctil grande; saltar fase; volver al inicio de la fase o a la anterior; detener exige mantener presionado 1 s; bloqueo de controles opcional.
 | 
| R-I11
 | El estado se guarda en cada transición de fase y cada 10 s.
 | 
| R-I12
 | Al terminar: completada si se recorren todas las fases (saltadas cuentan como omitidas); incompleta si se detiene antes. Con menos de 30 s de actividad, el resumen propone descartar.
 | 
| R-I13
 | Solo hay una sesión activa a la vez (intervalos o fuerza). La sesión guarda una copia de la estructura: editar el entrenamiento después no altera el historial.
 | Casos excepcionales

| Situación
 | Comportamiento
 | 
| Llamada entrante
 | El timer sigue; las alertas sonoras se silencian durante la llamada y la vibración continúa. Opción "pausar en llamadas".
 | 
| Permiso de notificaciones negado
 | El entrenamiento funciona. Se avisa una vez que con pantalla apagada no se verá el estado, con enlace a ajustes.
 | 
| Ahorro de batería agresivo (fabricante conocido o sesión previa interrumpida)
 | Tras la primera sesión, no antes, se muestra una guía específica para ese fabricante.
 | 
| Android cierra la app o el teléfono se reinicia
 | Al abrir: "Tienes un entrenamiento sin terminar" con Reanudar (desde el último punto guardado, en pausa), Guardar como incompleta o Descartar.
 | 
| Auriculares desconectados
 | El timer sigue; las alertas pasan al altavoz del teléfono (configurable a "solo vibración").
 | 
| Modo No molestar
 | Las alertas usan el canal multimedia; si el sistema bloquea la vibración, se informa en el primer uso.
 | 
| Batería bajo 5%
 | Guardado inmediato del estado y aviso discreto.
 | 
| Cambio de hora o zona horaria
 | No afecta el conteo (reloj monotónico). La sesión registra hora de inicio y zona.
 | 
| Intentar iniciar otra sesión
 | Diálogo: volver a la sesión activa o terminarla primero.
 | 
| Rotación, pantalla dividida o cambio de tema
 | El estado se conserva sin reiniciar el conteo.
 | 
## Flujo 2: entrenamiento de gimnasio
Registrar una serie repetida cuesta 1 toque: la app propone los valores de la última vez y el usuario solo confirma. La sesión trabaja sobre una copia de la rutina, así que cambiar algo durante el entrenamiento nunca rompe la plantilla ni el historial.
Reglas

| ID
 | Regla
 | 
| R-G1
 | Una sesión de fuerza empieza desde una rutina, desde cero o con "repetir la última". La sesión copia la rutina al empezar.
 | 
| R-G2
 | Valores propuestos por serie, en orden de prioridad: la serie con el mismo número del mismo ejercicio en la última sesión completada → el objetivo de la rutina → vacío. Se muestran en gris hasta confirmarlos o editarlos.
 | 
| R-G3
 | Tocar ✓ en una serie con valores propuestos los guarda tal cual (1 toque). Editar usa botones ± con incremento configurable por ejercicio (2,5 kg por defecto) o teclado numérico.
 | 
| R-G4
 | Validaciones: peso 0–1.000 kg (0 = peso corporal), en pasos de 0,25; repeticiones 0–999; RPE 6–10 en pasos de 0,5, opcional; duración y distancia para ejercicios de tiempo o cardio.
 | 
| R-G5
 | Tipos de ejercicio según lo que registran: peso + repeticiones, solo repeticiones, tiempo, distancia + tiempo. La pantalla muestra solo los campos del tipo.
 | 
| R-G6
 | Tipos de serie: calentamiento, normal, al fallo, drop set. Las de calentamiento no cuentan para volumen ni récords.
 | 
| R-G7
 | El peso se guarda con su unidad original (kg o lb). Cambiar la unidad en ajustes solo cambia cómo se muestra.
 | 
| R-G8
 | Descanso: al marcar una serie arranca automáticamente. Duración: la del ejercicio en la rutina → la del ejercicio en la biblioteca → 90 s global. Botones −15 s, +15 s y saltar. Al terminar: sonido + vibración. Corre en el mismo servicio en primer plano que los intervalos.
 | 
| R-G9
 | Durante la sesión se pueden agregar, quitar, reordenar y reemplazar ejercicios y series. Reemplazar conserva las notas de la serie.
 | 
| R-G10
 | Al terminar, si quedan series sin marcar: "Hay N series sin completar" → descartarlas, marcarlas como completas o volver.
 | 
| R-G11
 | Una sesión sin ninguna serie completada no se guarda: se ofrece descartarla.
 | 
| R-G12
 | Si la estructura cambió frente a la rutina, el resumen pregunta "¿Actualizar la rutina?" (solo ejercicios y número de series, no pesos).
 | 
| R-G13
 | Rutinas y ejercicios usados en el historial no se borran: se archivan y siguen visibles en sesiones pasadas.
 | 
| R-G14
 | Las sesiones pasadas se pueden editar; los récords se recalculan al guardar.
 | 
| R-G15
 | Sin actividad durante 3 h, la notificación propone terminar la sesión; nunca la cierra sola.
 | Casos excepcionales

| Situación
 | Comportamiento
 | 
| Android cierra la app con la sesión abierta
 | Al reabrir, la sesión sigue donde estaba (cada serie se guarda al marcarla); el descanso en curso se recalcula con el reloj monotónico o se descarta si ya venció.
 | 
| Ejercicio sin historial previo
 | Sin valores en gris; se usa el objetivo de la rutina o los campos quedan vacíos.
 | 
| Ejercicio propio con nombre duplicado
 | Se avisa y se ofrece usar el existente.
 | 
| Rutina vacía
 | No se puede empezar; se invita a agregar ejercicios.
 | 
| Descanso termina con la app en segundo plano
 | Notificación con sonido y vibración; al tocarla vuelve a la serie siguiente.
 | 
| Se edita la rutina en otra pantalla durante la sesión
 | La sesión activa no cambia (trabaja sobre su copia).
 | 
## Flujo 3: progreso y estadísticas
Todos los indicadores se calculan en el teléfono con consultas sobre la base local; ninguno requiere conexión ni está detrás de un pago.
Alcance v0.2: en el MVP (P0) solo entran la última marca por ejercicio y el conteo de sesiones de la semana; el resto de esta tabla (gráficas, 1RM, volumen por músculo) pasa a P2 (F-12).

| Indicador
 | Cálculo
 | Dónde se muestra
 | 
| Sesiones de la semana
 | Sesiones completadas o incompletas guardadas, sin descartadas, en la semana actual
 | Inicio y Progreso
 | 
| Cumplimiento del objetivo
 | Sesiones de la semana ÷ objetivo semanal
 | Inicio y Progreso
 | 
| Racha semanal
 | Semanas consecutivas cumpliendo el objetivo; la semana en curso no la rompe hasta que termina
 | Progreso
 | 
| Cumplimiento del plan
 | Días planificados con sesión ÷ días planificados
 | Calendario
 | 
| Minutos activos
 | Suma de la duración activa (sin pausas) de todas las sesiones
 | Progreso, por semana
 | 
| Tiempo de trabajo en intervalos
 | Suma de fases de trabajo completadas
 | Detalle de sesión y Progreso
 | 
| Volumen
 | Σ peso × repeticiones de series completadas, excluyendo calentamiento; peso corporal = 0
 | Sesión, semana y por grupo muscular
 | 
| Series por grupo muscular
 | Series completadas no de calentamiento, contadas para el músculo principal del ejercicio
 | Progreso, por semana
 | 
| 1RM estimado
 | Fórmula de Epley (abajo) con la mejor serie de la sesión
 | Gráfico por ejercicio
 | 
| Récords
 | Peso máximo, 1RM estimado, más repeticiones con un peso dado, mayor volumen en una sesión
 | Resumen de sesión y ficha del ejercicio
 | Fórmula del 1RM estimado (Epley), aplicada solo a series de 1 a 12 repeticiones; con 1 repetición el 1RM es el peso levantado:
1RM = w \left(1 + \frac{r}{30}\right)
donde w es el peso y r las repeticiones.
Reglas

| ID
 | Regla
 | 
| R-P1
 | La semana empieza el lunes por defecto (configurable a domingo).
 | 
| R-P2
 | Una sesión pertenece al día local de su hora de inicio, con la zona horaria registrada al empezar.
 | 
| R-P3
 | Los récords se calculan al guardar la sesión y se guardan como caché; se recalculan si se edita o borra una sesión.
 | 
| R-P4
 | Los valores se muestran en la unidad elegida; la conversión usa 1 kg = 2,20462 lb y redondea a 0,1.
 | 
| R-P5
 | Los gráficos muestran por defecto 12 semanas, con opciones 4 semanas, 6 meses, 1 año y todo; sin límites en el plan gratis.
 | 
| R-P6
 | Con menos de 2 puntos de datos, el gráfico se reemplaza por un mensaje que explica cuántas sesiones faltan.
 | 
| R-P7
 | Toda cifra debe poder abrirse para ver las sesiones que la componen.
 | Casos excepcionales: sesiones editadas hacia otra semana mueven sus totales; ejercicios archivados siguen en los gráficos históricos; una sesión con fecha futura no se permite.

## Modelo de datos
Catorce entidades en una base local: plantillas que el usuario edita, un historial inmutable que copia la plantilla al empezar y datos derivados que se pueden recalcular.

[diagrama: modelo de datos lógico · 14 entidades]
Las flechas indican "1 a muchos" (de padre a hijo) y la referencia de RoutineExercise a Exercise. Session guarda una copia de la plantilla para que editar una rutina no altere sesiones pasadas.
Convenciones para todas las entidades:

- Identificador UUID generado en el teléfono (facilita respaldos y una futura importación sin colisiones).

- createdAt y updatedAt en UTC; las sesiones agregan la zona horaria local.

- Borrado lógico (archivedAt) para todo lo que el historial referencia.

- schemaVersion en la base y en cada respaldo, para migraciones y restauraciones entre versiones.

- Una sesión en curso se identifica por su estado; no hay tabla aparte. El punto de recuperación (fase, tiempo, pausas) vive en la propia Session.
El modelo físico (tablas, índices, motor) se decide en la fase 4.

## Requisitos no funcionales
Las promesas del posicionamiento se convierten en umbrales medibles; cada uno tendrá una prueba automática o manual en la fase 9.

| ID
 | Requisito
 | Umbral
 | 
| NF-01
 | Tiempo hasta el primer entrenamiento
 | < 30 s desde la primera apertura; 0 formularios
 | 
| NF-02
 | Arranque en frío
 | < 1,5 s en un teléfono de gama media de 2023
 | 
| NF-03
 | Precisión del temporizador
 | Desfase ≤ 1 s en 60 min con pantalla apagada; cada alerta suena a ±150 ms del cambio de fase
 | 
| NF-04
 | Estabilidad
 | ≥ 99,5% de usuarios sin fallos; ANR y fallos por debajo de los umbrales de Android vitals (0,47% y 1,09%)
 | 
| NF-05
 | Funcionamiento offline
 | 100% de las funciones esenciales sin conexión; la falta de red nunca muestra un error
 | 
| NF-06
 | Integridad de datos
 | Cada serie y cada fase se guardan al confirmarse; ningún cierre pierde más de 10 s de sesión; los respaldos se restauran entre versiones
 | 
| NF-07
 | Privacidad
 | Ningún dato de entrenamiento sale del teléfono salvo exportación del usuario; el SDK de anuncios es el único tráfico de red y se declara en Data safety
 | 
| NF-08
 | Accesibilidad
 | TalkBack en todas las pantallas; texto escalable al 200% sin cortes; contraste WCAG AA; áreas táctiles ≥ 48 dp (≥ 64 dp durante la sesión); la fase nunca se comunica solo por color
 | 
| NF-09
 | Usabilidad en ejercicio
 | Tiempo restante legible a 2 m; acciones principales en la mitad inferior; ningún gesto fino durante la sesión
 | 
| NF-10
 | Consumo de batería
 | ≤ 5% por hora de temporizador con pantalla apagada
 | 
| NF-11
 | Tamaño de descarga
 | < 20 MB
 | 
| NF-12
 | Compatibilidad
 | targetSdk 36 (exigido por Play desde agosto de 2026); minSdk a definir en fase 4 (propuesta: 26)
 | 
| NF-13
 | Idiomas
 | Español neutro e inglés al lanzamiento; números y fechas con formato local
 | 
| NF-14
 | Costo operativo
 | US$0: sin servidores, cuentas ni servicios de pago
 | 
## Criterios de aceptación y plan de pruebas del temporizador
El timer es la promesa central, así que cada caso de abajo se prueba en teléfonos reales antes de cada versión; lo que Android o el fabricante impiden se documenta, no se promete. El diseño técnico (fase 4) debe justificar: tiempo monotónico desde un instante de inicio, servicio en primer plano durante la sesión, notificación en curso y los permisos mínimos.
Casos de aceptación (sesión de referencia: 60 min con 120 cambios de fase):

| ID
 | Caso
 | Resultado esperado
 | 
| T-01
 | Pantalla bloqueada toda la sesión
 | Todas las alertas suenan y vibran a ±150 ms del cambio de fase; desfase final ≤ 1 s
 | 
| T-02
 | App en segundo plano (otra app abierta)
 | Igual que T-01; la notificación muestra fase y tiempo correctos
 | 
| T-03
 | Música de otra app (Spotify, YouTube Music)
 | Las alertas bajan el volumen de la música y lo devuelven; la música no se pausa
 | 
| T-04
 | Auriculares Bluetooth conectados, desconectados y reconectados
 | El timer no se detiene; las alertas siguen por la salida activa (o solo vibración, según ajuste)
 | 
| T-05
 | Pausa, reanudación, bloqueo/desbloqueo del teléfono y rotación
 | El tiempo restante no salta; las pausas no cuentan
 | 
| T-06
 | Llamada entrante y saliente
 | Comportamiento según ajuste (continuar silenciando / pausar); sin pérdida de estado
 | 
| T-07
 | Permiso de notificaciones denegado
 | La sesión corre; aviso único explicando la limitación
 | 
| T-08
 | Batería optimizada y restringida; modo ahorro
 | Con "optimizada" (por defecto): T-01 se cumple. Con "restringida": se detecta y se guía al usuario
 | 
| T-09
 | Doze tras 30+ min con pantalla apagada y teléfono quieto
 | T-01 se cumple mientras el servicio en primer plano siga activo
 | 
| T-10
 | El sistema mata el proceso
 | Al reabrir: recuperación con pérdida ≤ 10 s de sesión (S18-b)
 | 
| T-11
 | Reinicio del teléfono durante la sesión
 | Al abrir la app tras el reinicio: recuperación disponible; no se intenta reanudar sola
 | 
| T-12
 | Cambio de hora o zona horaria
 | El conteo no cambia
 | Matriz de dispositivos mínima (propia o prestada; sin granjas de dispositivos pagadas):

| Dispositivo
 | Capa / versión
 | Por qué
 | 
| Google Pixel (gama media)
 | Android 15 y 16 sin capa
 | Referencia; E06 reporta fallas en Pixel con Android 15
 | 
| Samsung Galaxy serie A
 | One UI reciente
 | Mayor cuota en Chile y LATAM; gestión de batería agresiva según Don't kill my app
 | 
| Xiaomi / Redmi
 | HyperOS
 | Entre los fabricantes más agresivos al cerrar apps
 | 
| Motorola
 | Android casi puro
 | Gama media popular en LATAM
 | 
| Un teléfono con la versión mínima soportada
 | minSdk que fije la fase 4
 | Compatibilidad hacia atrás
 | Umbrales: desfase ≤ 1 s en 60 min (T-01, T-02, T-09); alertas a ±150 ms; 0 sesiones perdidas en la matriz; consumo ≤ 5% de batería por hora con pantalla apagada (NF-10). En beta: ≤ 2% de sesiones pasan por recuperación.
Limitaciones reales (no se prometen):

- Si el usuario fuerza la detención de la app o la borra de recientes en algunos fabricantes, el sistema puede matar el servicio; solo podemos recuperar al reabrir.

- Fabricantes con optimizaciones propias pueden cerrar procesos en primer plano pese a las reglas de Android; mitigamos con guía por fabricante, no con garantías.

- Con la batería en "restringida" o en modos de ahorro extremo, el comportamiento depende del fabricante.

- Tras un reinicio no se reanuda sola una sesión: se ofrece recuperarla.

- No se pide la exención directa de optimización de batería: Play la limita a casos que no incluyen apps de fitness.
La ficha de Play y la app dirán "diseñado para seguir con la pantalla apagada", nunca "nunca falla".

## Estrategia de retención
La retención se apoya en el hábito semanal y en el valor acumulado del historial, no en notificaciones insistentes [R]. En un estudio con 3.034 usuarios de una app de entrenamiento, tener notificaciones activas se asoció a abandonar antes, y entrenar con más frecuencia a permanecer más tiempo (mHealth, 2025) [O].

| Momento
 | Mecanismo
 | Regla
 | 
| Primera sesión
 | Valor inmediato
 | Plantillas listas; nada que configurar antes de entrenar (NF-01)
 | 
| Tras la primera sesión
 | Objetivo semanal
 | Una sola pantalla opcional: sesiones por semana (1–7) y días preferidos
 | 
| Cada semana
 | Progreso visible
 | Inicio muestra "3 de 4 esta semana"; racha semanal, nunca diaria, para no castigar los días de descanso
 | 
| Días planificados
 | Recordatorio local
 | Solo si el usuario lo activó; no se envía si ya entrenó ese día; máximo 1 al día
 | 
| Cada serie
 | Memoria del entrenamiento
 | Valores de la última vez en gris; el usuario siente que la app recuerda por él o ella
 | 
| Al terminar
 | Logro
 | Récords nuevos destacados en el resumen
 | 
| Inicio
 | Repetir rápido
 | "Repetir último entrenamiento" visible; widget en v1.1
 | 
| 14 días sin actividad
 | Reenganche único
 | Una sola notificación (si hay permiso) con el último entrenamiento listo para repetir; luego silencio
 | 
| Datos acumulados
 | Confianza
 | Si hay más de 10 sesiones sin respaldo, sugerencia discreta en Progreso una vez al mes
 | Lo que no haremos: rachas diarias, mensajes de culpa, notificaciones promocionales, pedir reseña durante una sesión. La reseña se pide con la API oficial de Play en el resumen, después de la quinta sesión completada y de un récord.

## Modelo de publicidad y monetización (hipótesis)
En el lanzamiento solo hay banners en pantallas no críticas; el intersticial al final y el precio de "Sin anuncios" quedan como experimentos, no como decisiones [R]. Nada de la evidencia disponible prueba la frecuencia ni el precio aceptables (H4, E07). Sin intersticial, el escenario base necesita ~198.000 MAU para US$1.000/mes: la publicidad sola es aún más débil.
Ubicaciones por pantalla

| Pantalla
 | Anuncio
 | Motivo
 | 
| Inicio, Historial, Progreso, Calendario, bibliotecas de rutinas y ejercicios
 | Banner adaptativo anclado abajo
 | Pantallas de consulta, fuera de la sesión
 | 
| Editores de rutinas e intervalos
 | Ninguno
 | Usan teclado y precisión; riesgo de clics accidentales
 | 
| Sesión en curso: timer, fuerza, descanso
 | Nunca
 | Usuario concentrado en una actividad (política de Play y promesa del producto)
 | 
| Resumen de sesión
 | Ninguno por defecto; intersticial solo como experimento (R-A2)
 | Pausa lógica tras una pantalla de resultados, permitida por Google Play
 | 
| Configuración, respaldo, recuperación de sesión
 | Ninguno
 | Tareas críticas o de confianza
 | 
| Apertura de la app
 | Ninguno
 | El usuario abre para empezar rápido
 | Reglas

| ID
 | Regla
 | Estado v0.2
 | 
| R-A1
 | Ningún anuncio desde "Empezar" hasta que el usuario sale del resumen, ni mientras corre un timer o se registran series.
 | Vigente
 | 
| R-A2
 | Intersticial solo tras "Listo" en una sesión completada de al menos 5 minutos; nunca automáticamente tras cada entrenamiento.
 | Experimento, desactivado por defecto
 | 
| R-A3
 | Tope del experimento: máximo 1 cada 3 sesiones y 1 por día; ninguno en las primeras 5 sesiones ni en los primeros 7 días.
 | Experimento, desactivado por defecto
 | 
| R-A4
 | El anuncio se precarga; si no está listo, no se muestra (nunca hay espera).
 | Vigente
 | 
| R-A5
 | Nunca tras sesiones descartadas, recuperadas o incompletas.
 | Vigente
 | 
| R-A6
 | Banners separados de botones y ocultos cuando aparece el teclado.
 | Vigente
 | 
| R-A7
 | Consentimiento con UMP de Google donde aplique (EEE, Reino Unido, Suiza, estados de EE. UU.).
 | Vigente
 | 
| R-A8
 | Público objetivo declarado: mayores de 13 años; clasificación máxima de anuncios T (Teen).
 | Vigente
 | 
| R-A9
 | "Sin anuncios": pago único, precio a validar (US$3,99 es hipótesis); se restaura con la cuenta de Play.
 | Hipótesis (P2)
 | 
| R-A10
 | Solo AdMob en el MVP; mediación con más de 10.000 usuarios activos diarios.
 | Vigente
 | 
| R-A11
 | Sin anuncios en pantallas críticas: editores, respaldo y restauración, recuperación de sesión, configuración.
 | Nueva
 | Escenarios actualizados [H] (eCPM Android 2024 de Appodeal: intersticial LATAM US$1,3 y EU/NA US$6,6 promedio; banner LATAM US$0,10 y EU/NA US$0,35):

| Escenario
 | Mezcla de tráfico
 | Sesiones por MAU al mes
 | Sesiones con intersticial
 | Banners por sesión
 | Ingreso por MAU al mes (US$)
 | MAU para US$1.000/mes
 | MAU para US$5.000/mes
 | 
| Conservador
 | 100% LATAM
 | 6
 | 35%
 | 3
 | 0,0036
 | ~278.000
 | ~1.390.000
 | 
| Base
 | 70% LATAM / 30% EU-NA
 | 8
 | 45%
 | 4
 | 0,0144
 | ~69.000
 | ~347.000
 | 
| Optimista
 | 50% / 50%
 | 10
 | 50% (tope)
 | 5
 | 0,0295
 | ~34.000
 | ~170.000
 | Esta tabla supone el intersticial activo con el tope de v0.1 (hasta 50% de las sesiones). Con el tope experimental de v0.2 (1 cada 3 sesiones) y el intersticial apagado por defecto, es un techo, no una proyección.
Sin intersticial (configuración por defecto en v0.2), con las mismas suposiciones de banner: conservador ~694.000, base ~198.000 y optimista ~94.000 MAU para US$1.000/mes [H]. La tabla anterior queda como techo si el experimento del intersticial resulta aceptable.
Variables del modelo de ingresos que la beta debe medir, no suponer: usuarios activos diarios, sesiones por semana, impresiones aceptables por sesión, fill rate, eCPM por país y sensibilidad a la publicidad (reseñas, desinstalaciones y retención con y sin anuncios).
Compra única sin backend: riesgo documentado. Google Play Billing permite comprar, reconocer (acknowledge) y restaurar una compra única desde la app, sin servidor propio. Lo que no se puede sin backend es verificar la compra en un servidor; la validación queda en el cliente y es vulnerable a apps modificadas. Para un desbloqueo de bajo precio que solo quita anuncios, es un riesgo aceptable [R]; se revisa si el fraude supera el 5% de las compras. Detalles técnicos para la fase 4.
Diferencias con un juego

| Dimensión
 | Juego casual
 | Esta app
 | 
| Sesiones por usuario activo al día
 | Varias
 | ~0,4 (unas 3 por semana)
 | 
| Momentos naturales para un anuncio
 | Entre niveles, muchas veces al día
 | Al final de una sesión, como máximo cada 2 sesiones
 | 
| Anuncios con recompensa
 | Encajan (vidas, monedas)
 | Casi no hay qué recompensar sin bloquear funciones esenciales
 | 
| Ingreso diario por usuario activo
 | US$0,03–0,50 (blog de proveedor, no verificado)
 | ~US$0,001–0,004 estimado
 | 
| Costo de interrumpir
 | Bajo, el usuario busca entretenerse
 | Alto, rompe la promesa del producto
 | Conclusión: la publicidad cubre costos (que son US$0) pero no construye un negocio por sí sola. Es viable como ingreso complementario si el producto escala a decenas de miles de usuarios activos y el pago único convierte.

## Métricas de producto y negocio
Métrica norte: usuarios que completan 2 o más sesiones en una semana. Mide hábito real, se alinea con la retención y no premia abrir la app sin entrenar.

| Métrica
 | Definición
 | Meta del MVP
 | Fuente
 | 
| Usuarios con 2+ sesiones semanales
 | Usuarios únicos con ≥ 2 sesiones completadas en la semana
 | Crece semana a semana tras el lanzamiento
 | Analytics
 | 
| Activación
 | % de instalaciones con 1 sesión completada en 24 h
 | ≥ 50%
 | Analytics
 | 
| Retención D1 / D7 / D30
 | % de usuarios que vuelven el día 1, 7 y 30
 | ≥ 30% / ≥ 15% / ≥ 10% (categoría: 27% / ~13% / 3–8%)
 | Play Console + Analytics
 | 
| Uso combinado
 | % de usuarios activos que usan intervalos y fuerza en 14 días
 | ≥ 20%
 | Analytics
 | 
| Sesiones por usuario activo semanal
 | Promedio de sesiones completadas
 | ≥ 2,5
 | Analytics
 | 
| Tasa de finalización
 | Sesiones completadas ÷ iniciadas
 | ≥ 85%
 | Analytics
 | 
| Fiabilidad del timer
 | % de sesiones que pasan por recuperación tras cierre del sistema
 | ≤ 2%
 | Analytics
 | 
| Estabilidad
 | Usuarios sin fallos; tasa de ANR
 | ≥ 99,5%; < 0,47%
 | Play Console (Android vitals)
 | 
| Reputación
 | Calificación y % de reseñas que critican anuncios
 | ≥ 4,5★; < 5%
 | Play Console
 | 
| Ingreso por usuario activo diario
 | Ingreso de anuncios ÷ usuarios activos diarios
 | Seguimiento, sin meta inicial
 | AdMob + Analytics
 | 
| eCPM y fill rate
 | Por formato y país
 | Fill ≥ 90%
 | AdMob
 | 
| Intersticiales por sesión
 | Intersticiales mostrados ÷ sesiones
 | ≤ 0,5 (tope R-A3)
 | AdMob + Analytics
 | 
| Conversión "Sin anuncios"
 | Compras ÷ usuarios activos mensuales
 | 1–3%
 | Play Console
 | Cómo medir sin infraestructura propia [R]:

- Play Console (sin SDK, gratis): instalaciones, desinstalaciones, retención de adquisición, calificaciones, reseñas, fallos y ANR.

- AdMob (ya integrado por los anuncios): impresiones, eCPM, fill rate e ingresos.

- Google Analytics for Firebase (gratis, sin servidor propio): solo eventos agregados y sin datos personales ni contenido del entrenamiento. Eventos propuestos: session_start y session_complete (tipo y tramo de duración), session_recovered, routine_created, interval_created, goal_set, reminder_enabled, backup_created, purchase_remove_ads. Se declara en Data safety, respeta el consentimiento y se puede desactivar en Configuración.
Si se descarta la opción 3, las metas de activación, uso combinado, finalización y fiabilidad no se podrán medir; solo quedarían las fuentes 1 y 2. Es una decisión del Gate 2.

## Riesgos, supuestos y entrevistas
El mayor riesgo es técnico (timer en segundo plano) y el mayor supuesto es de producto (que el segmento acepte anuncios a cambio de no tener cuenta ni límites). Ambos se validan antes de programar el núcleo.

| Riesgo
 | Probabilidad
 | Impacto
 | Mitigación
 | Cuándo
 | 
| Costo de cambiar de app: rutinas e historial ya viven en Hevy o Strong (E04, E05)
 | Alta
 | Alto
 | Valor sin migrar (intervalos que Hevy no tiene); importar CSV en P2 (F-23); entrevistas sobre el costo real
 | Fases 2 y 7
 | 
| Competencia en movimiento: Hevy suma cardio, programas y mejoras del descanso (E11)
 | Alta
 | Alto
 | Diferenciarse en intervalos automatizados fiables y privacidad; revisar funciones de Hevy antes de cada gate
 | Todas
 | 
| Cero backend frente a compras: validación solo en el cliente
 | Media
 | Bajo
 | Pago único de bajo precio; Play Billing para comprar y restaurar; revisar si el fraude supera 5%
 | Fases 4 y 7
 | 
| Datos locales: pérdida por desinstalar o cambiar de teléfono
 | Media
 | Alto
 | Aviso en P0 (F-01); respaldo y restauración en P1; recordatorio de respaldo
 | Fases 3 y 5
 | 
| Ingresos publicitarios insuficientes: pocas impresiones aceptables por sesión
 | Alta
 | Medio
 | Costos US$0; medir DAU, impresiones, fill y eCPM por país en beta; pago único
 | Fases 6 y 7
 | 
| Sesgo de la investigación: Reddit, autoseleccionado y en inglés
 | Alta
 | Medio
 | Entrevistas reales con el perfil; datos de la beta; no presentar la evidencia como prevalencia
 | Fases 2 y 6
 | 
| Timer en segundo plano: permisos, versiones y fabricantes (E06)
 | Alta
 | Alto
 | Spike en fase 4; casos T-01 a T-12 en la matriz de dispositivos; limitaciones documentadas
 | Fases 4 y 9
 | 
| Play cuestiona el tipo de servicio en primer plano (health exige permisos de sensores)
 | Media
 | Alto
 | Spike con health y specialUse justificado
 | Fase 4
 | 
| Prueba cerrada de Play: 12 testers durante 14 días (Play)
 | Alta
 | Medio
 | Reclutar 20 testers
 | Fase 6
 | Supuestos a validar en entrevistas [H]:

- Quien combina pesas e intervalos usa hoy 2 o más herramientas y le molesta.

- Crear cuenta y los límites del plan gratis son razones reales para cambiar de app.

- Los cortes del timer con pantalla apagada son un problema vivido, no solo leído en reseñas.

- Un banner fuera de la sesión y un intersticial al final son aceptables; US$3,99 único por quitarlos es razonable.

- Ver la semana completa (intervalos + fuerza) motiva más que ver cada tipo por separado.
Guía de entrevistas (8–10 personas, 30 min, sin costo)

- Perfil: usa Android, entrena 3+ veces por semana y combina pesas con HIIT, circuitos o intervalos de carrera. Al menos 3 usan hoy Hevy, Strong o FitNotes, y al menos 3 un timer de intervalos.

- Reclutamiento: gimnasios y boxes conocidos, grupos de running, contactos del equipo. Pedir permiso para contactarles luego como testers de la beta.

- Preguntas:

- Cuéntame tu última semana de entrenamiento, día por día.

- ¿Qué usas para cronometrar y para anotar lo que haces? Muéstrame en tu teléfono.

- ¿Qué fue lo último que te frustró de esas apps?

- ¿Alguna vez se cortó el timer o perdiste datos? ¿Qué hiciste?

- ¿Cómo eliges una app nueva? ¿Qué te hace abandonarla?

- ¿Qué opinas de crear una cuenta para una app de entrenamiento?

- Entre una app gratis con un anuncio al terminar y otra que cobra para quitar límites, ¿cuál eliges y por qué?

- ¿Qué miras para saber si estás progresando?

- Registro: notas por entrevista con citas textuales, sin datos personales identificables (nivel confidencial según política interna). Los hallazgos ajustan este PRD a v0.2.

## Plan de validación beta (sin infraestructura pagada)
La beta cerrada de Google Play (mínimo 12 testers durante 14 días continuos; reclutamos 20) valida fiabilidad, uso combinado y tolerancia a anuncios con herramientas gratuitas. Costo: solo la cuenta de desarrollador de Play (pago único ya separado del costo de infraestructura).

| Qué validar
 | Cómo
 | Herramienta (gratis)
 | Criterio
 | 
| Fiabilidad del timer (H3)
 | Eventos session_recovered y sesiones completadas frente a iniciadas; casos T-01 a T-12 en los teléfonos de los testers
 | Firebase Analytics (aprobado), Android vitals
 | ≤ 2% de sesiones con recuperación; 0 sesiones perdidas reportadas
 | 
| Uso combinado (H1)
 | % de testers que usan intervalos y fuerza en 14 días
 | Firebase Analytics
 | ≥ 20%
 | 
| Semana unificada frente a vistas separadas (H5)
 | Tarea de usabilidad con 5 testers: "¿qué te falta por hacer esta semana?" en cada variante
 | Videollamada + prototipo
 | Menos tiempo y errores en la variante elegida
 | 
| Tolerancia a anuncios (H4)
 | Grupo A con banner, grupo B sin banner; intersticial solo en una cohorte pequeña, 1 cada 3 sesiones
 | Firebase Remote Config + AdMob
 | Sin caída de retención D7 ni quejas en la encuesta
 | 
| Precio "Sin anuncios" (H4)
 | Pregunta de disposición a pagar con 3 precios
 | Encuesta opcional (Google Forms) enlazada desde Configuración
 | Insumo, no decisión
 | 
| Costo de cambio y valor de "sin cuenta" (H2)
 | Preguntas abiertas en la encuesta
 | Google Forms
 | Insumo para v0.3
 | 
| Estabilidad
 | Fallos y ANR
 | Play Console (Android vitals)
 | ≥ 99,5% sin fallos
 | Qué seguirá sin validar tras la beta: prevalencia de los problemas en la población general, tamaño de mercado, intención de instalación orgánica y retención a 30 días con usuarios que no conocen al equipo. Eso solo lo dan las primeras semanas en producción.
La encuesta no pide datos personales; las respuestas son información confidencial según la política interna.

## Decisiones para el Gate 2
Gate 2 aprobado el 2026-11-03 con las decisiones de la v0.2. Las entrevistas reales siguen en paralelo; sus hallazgos se incorporan como cambios a la v0.3 si los hay. Siguiente fase: Arquitectura v0.1.
Decidido el 2026-11-02: medición con Google Analytics for Firebase y modelo de anuncios tal como está propuesto. La fase 3 (UX/UI) avanza en paralelo a las entrevistas; alcance y reglas quedan provisionales hasta la v0.2.
Para cerrar el Gate 2 con la v0.2 necesitamos estas decisiones; el PRD sigue abierto a las entrevistas reales:

- Nombre Trainloop y posicionamiento revisado (intervalos automatizados fiables + registro rápido + semana simple, sin cuenta).

- MVP = los 11 requerimientos P0; P1 y P2 según la tabla de requerimientos.

- Intersticial al final y precio de "Sin anuncios" como experimentos de beta, no como decisiones.

- Criterios T-01 a T-12 y matriz de dispositivos como condición de salida de cada versión.

- Plan de beta con Firebase Analytics (ya aprobado) + Remote Config para los experimentos + Google Forms para la encuesta.

- Realizar las 8–10 entrevistas reales con la guía de este documento; la investigación secundaria no las reemplaza.

- Revisión de consentimiento, Data safety, política de privacidad y nombre con Legal/Administración antes de la fase 6.
La fase 3 (UX/UI) debe reflejar la v0.2: aviso de datos locales en el primer uso, plantilla caminar/correr destacada, estadísticas simplificadas en el MVP, dos variantes de la vista semanal para el test y el intersticial fuera del flujo por defecto.
