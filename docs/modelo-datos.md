# PRD v0.2 — Modelo de datos

Modelo de datos
Catorce entidades en una base local: plantillas que el usuario edita, un historial inmutable que copia la plantilla al empezar y datos derivados que se pueden recalcular.
Las flechas indican "1 a muchos" (de padre a hijo) y la referencia de RoutineExercise a Exercise. Session guarda una copia de la plantilla para que editar una rutina no altere sesiones pasadas.
Convenciones para todas las entidades:
Identificador UUID generado en el teléfono (facilita respaldos y una futura importación sin colisiones).

createdAt y updatedAt en UTC; las sesiones agregan la zona horaria local.

Borrado lógico (archivedAt) para todo lo que el historial referencia.

schemaVersion en la base y en cada respaldo, para migraciones y restauraciones entre versiones.

Una sesión en curso se identifica por su estado; no hay tabla aparte. El punto de recuperación (fase, tiempo, pausas) vive en la propia Session.

El modelo físico (tablas, índices, motor) se decide en la fase 4.

# Arquitectura — Persistencia local

Persistencia local
SQLite a través de Drift: consultas tipadas, transacciones, migraciones versionadas y agregados (volumen, récords) calculados en la propia base [R]. Las preferencias simples (tema, acento, idioma, unidades) van en un almacén clave-valor aparte.
Opción
 | A favor
 | En contra
 | Decisión
 | 
Drift (SQLite)
 | Relacional, migraciones probables con tests, consultas reactivas, SQL para estadísticas
 | Generación de código
 | Elegida
 | 
sqflite
 | Simple, muy usada
 | SQL a mano, sin tipos ni migraciones asistidas
 | Descartada
 | 
Isar / Hive
 | Rápidas, sin SQL
 | Sin consultas relacionales cómodas; dudas de mantenimiento
 | Descartadas
 | 
Esquema físico (las 14 entidades del PRD; IDs UUID en texto, fechas en milisegundos UTC + zona horaria en sesiones):
Tabla
 | Claves e índices
 | 
exercise
 | índice por nombre normalizado (duplicados, búsqueda) y por músculo; único por catalog_key (v2)
 | 
strength_routine, routine_exercise, routine_set_target
 | índice por rutina + orden
 | 
interval_workout, interval_block
 | índice por entrenamiento + padre + orden
 | 
session
 | índice por fecha de inicio y por estado (recuperación)
 | 
session_exercise, set_log
 | índice por ejercicio (historial y gráficos) y por sesión
 | 
interval_phase_log
 | índice por sesión
 | 
personal_record
 | único por ejercicio + tipo
 | 
plan_day, reminder
 | —
 | 
Peso: se guarda el valor y la unidad originales, y además una columna normalizada en gramos (entero) para sumar volumen sin errores de redondeo.

Escritura: cada serie y cada fase se guarda en su propia transacción al confirmarse (NF-06).

Migraciones: schemaVersion en la base y en los respaldos; cada migración tiene un test que parte de una base de la versión anterior.

Respaldo del sistema: se habilita la copia automática de Android hacia el Google Drive de la persona, con reglas que incluyen la base y las preferencias. No pasa por servidores nuestros y complementa el respaldo manual en archivo [R]. Debe mencionarse en la política de privacidad (Legal/Administración).

# Entidades lógicas (diagrama del PRD)

Plantillas (editables):
- Exercise: nombre, tipo de registro (peso+reps, tiempo, distancia…), músculo principal, equipo, incremento, descanso por defecto, propio (custom), archivado.
- StrengthRoutine: nombre, notas, orden, archivada.  1→N RoutineExercise.
- RoutineExercise: ejercicio (→Exercise), orden, descanso (s); series objetivo: tipo, reps, peso, RPE  (físico: routine_exercise + routine_set_target).
- IntervalWorkout: nombre, preparación (s), notas, archivado. 1→N IntervalBlock.
- IntervalBlock: intervalo o repetición (grupo), bloque padre (anidamiento), orden, tipo (trabajo/descanso/calentamiento/enfriamiento…), etiqueta, duración (s), rondas.

Historial (inmutable; Session copia la plantilla al empezar):
- Session: tipo (intervalos | fuerza), origen (id de plantilla), estado (en curso, completada, incompleta, descartada, recuperación pendiente), inicio, fin, zona horaria, pausas (s), copia de la estructura al empezar (JSON), esfuerzo percibido 1–10, nota. El checkpoint de recuperación (fase, tiempo, pausas) vive en Session.
- SessionExercise: ejercicio, orden, notas. 1→N SetLog.
- SetLog: orden, tipo de serie, peso + unidad (+ columna normalizada en gramos, entero), reps, RPE, tiempo (s), distancia (m), completada, hora de registro.
- IntervalPhaseLog: tipo, etiqueta, ronda, orden, planificado vs real (s), omitida.

Derivados y ajustes:
- PersonalRecord: ejercicio, tipo, valor, sesión, fecha (caché recalculable desde SetLog). Único por ejercicio+tipo.
- Settings: unidad, inicio de semana, sonidos, voz, vibración, objetivo semanal → va en el almacén clave-valor (NO tabla).
- PlanDay (día → entrenamiento) · Reminder (día y hora, activo).
- AdState: último intersticial, sesiones desde él, estado UMP y "sin anuncios".

14 tablas físicas = exercise, strength_routine, routine_exercise, routine_set_target, interval_workout, interval_block, session, session_exercise, set_log, interval_phase_log, personal_record, plan_day, reminder, ad_state.

# Cambios de esquema

- v2 (D3): `exercise.catalog_key` (texto, nulo en los propios) con índice único `idx_exercise_catalog_key`. Identifica los ejercicios de la biblioteca incluida: el nombre visible sale del catálogo localizado (`lib/data/catalog/exercise_catalog.dart`) y la siembra inserta solo las claves que faltan. `name` guarda el nombre en inglés como respaldo. La copia de la sesión (`template_snapshot`) incluye la clave.
- v3 (D4): `interval_block.skip_last_rest` (booleano, activado por defecto) en las repeticiones: en la última ronda se omiten los descansos finales (R-I4). Con anidamiento, el "descanso entre series" es un intervalo de descanso al final de la repetición externa y también se omite tras la última serie. Las plantillas incluidas (Tabata, HIIT, EMOM, caminar/correr, AMRAP) viven en el código (`interval_templates.dart`); una sesión que parte de una plantilla guarda `template:<clave>` en `session.template_id`.
- v4 (D5): `session_exercise.rest_seconds` (entero, nulo en sesiones anteriores): descanso del ejercicio dentro de la sesión de fuerza, copiado al empezar (rutina → biblioteca → 90 s, R-G8) o al agregarlo. La sesión copia la rutina como filas: `session_exercise` y `set_log` sin completar con el objetivo; las series hechas son las de `completed = 1`. El volumen excluye el calentamiento.
