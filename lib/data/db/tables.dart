// Las restricciones CHECK de Drift se declaran referenciando la propia columna.
// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';

import '../../core/units/weight_unit.dart';
import 'converters.dart';
import 'enums.dart';

// Esquema físico de las 14 entidades del PRD (docs/modelo-datos.md).
// Convenciones: id UUID en texto generado en el teléfono; createdAt/updatedAt
// en milisegundos UTC; archivedAt (borrado lógico) en lo que el historial
// referencia; peso = valor + unidad originales + gramos enteros.

/// Columnas comunes: id, createdAt y updatedAt.
mixin Entity on Table {
  TextColumn get id => text().clientDefault(newId)();

  IntColumn get createdAt => integer()
      .map(const UtcMillisConverter())
      .clientDefault(() => DateTime.now().millisecondsSinceEpoch)();

  IntColumn get updatedAt => integer()
      .map(const UtcMillisConverter())
      .clientDefault(() => DateTime.now().millisecondsSinceEpoch)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Borrado lógico: las filas archivadas no se listan pero el historial
/// sigue resolviendo sus referencias.
mixin Archivable on Table {
  IntColumn get archivedAt =>
      integer().map(const UtcMillisConverter()).nullable()();
}

// ---------------------------------------------------------------- Plantillas

@TableIndex(name: 'idx_exercise_normalized_name', columns: {#normalizedName})
@TableIndex(name: 'idx_exercise_muscle', columns: {#primaryMuscle})
@TableIndex(
  name: 'idx_exercise_catalog_key',
  columns: {#catalogKey},
  unique: true,
)
class Exercises extends Table with Entity, Archivable {
  @override
  String get tableName => 'exercise';

  TextColumn get name => text().withLength(min: 1, max: 120)();

  /// Nombre en minúsculas, sin tildes ni espacios repetidos: duplicados y
  /// búsqueda. Lo calcula `normalizeName`.
  TextColumn get normalizedName => text()();
  TextColumn get logType => textEnum<ExerciseLogType>()();
  TextColumn get primaryMuscle => textEnum<Muscle>()();
  TextColumn get equipment => textEnum<Equipment>().nullable()();
  RealColumn get incrementValue => real().nullable()();
  TextColumn get incrementUnit => textEnum<WeightUnit>().nullable()();
  IntColumn get incrementGrams => integer().nullable()();
  IntColumn get defaultRestSeconds => integer().nullable()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();

  /// Clave estable de los ejercicios de la biblioteca (v2), p. ej.
  /// `bench_press_barbell`: el nombre visible sale del catálogo localizado y
  /// la siembra no duplica. `null` en los ejercicios propios.
  TextColumn get catalogKey => text().nullable()();
}

class StrengthRoutines extends Table with Entity, Archivable {
  @override
  String get tableName => 'strength_routine';

  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get notes => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

@TableIndex(
  name: 'idx_routine_exercise_routine_order',
  columns: {#routineId, #sortOrder},
)
class RoutineExercises extends Table with Entity {
  @override
  String get tableName => 'routine_exercise';

  TextColumn get routineId =>
      text().references(StrengthRoutines, #id, onDelete: KeyAction.cascade)();
  TextColumn get exerciseId => text().references(Exercises, #id)();
  IntColumn get sortOrder => integer()();
  IntColumn get restSeconds => integer().nullable()();
}

@TableIndex(
  name: 'idx_routine_set_target_parent_order',
  columns: {#routineExerciseId, #sortOrder},
)
class RoutineSetTargets extends Table with Entity {
  @override
  String get tableName => 'routine_set_target';

  TextColumn get routineExerciseId =>
      text().references(RoutineExercises, #id, onDelete: KeyAction.cascade)();
  IntColumn get sortOrder => integer()();
  TextColumn get setType =>
      textEnum<SetType>().withDefault(Constant(SetType.normal.name))();
  IntColumn get reps => integer().nullable()();
  RealColumn get weightValue => real().nullable()();
  TextColumn get weightUnit => textEnum<WeightUnit>().nullable()();
  IntColumn get weightGrams => integer().nullable()();
  RealColumn get rpe => real().nullable()();
  IntColumn get durationSeconds => integer().nullable()();
  RealColumn get distanceMeters => real().nullable()();
}

class IntervalWorkouts extends Table with Entity, Archivable {
  @override
  String get tableName => 'interval_workout';

  TextColumn get name => text().withLength(min: 1, max: 120)();
  IntColumn get prepareSeconds => integer().withDefault(const Constant(10))();
  TextColumn get notes => text().nullable()();
}

@TableIndex(
  name: 'idx_interval_block_workout_parent_order',
  columns: {#workoutId, #parentId, #sortOrder},
)
class IntervalBlocks extends Table with Entity {
  @override
  String get tableName => 'interval_block';

  TextColumn get workoutId =>
      text().references(IntervalWorkouts, #id, onDelete: KeyAction.cascade)();

  /// Grupo que contiene a este bloque; `null` en el primer nivel.
  TextColumn get parentId => text().nullable().references(
    IntervalBlocks,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get sortOrder => integer()();
  TextColumn get kind => textEnum<IntervalBlockKind>()();

  /// Solo en intervalos (`kind = interval`).
  TextColumn get phaseType => textEnum<PhaseType>().nullable()();
  TextColumn get label => text().nullable()();
  IntColumn get durationSeconds => integer().nullable()();

  /// Repeticiones de un grupo; 1 en intervalos.
  IntColumn get rounds => integer().withDefault(const Constant(1))();

  /// Solo en grupos: en la última ronda se omite el descanso final (R-I4).
  /// v3.
  BoolColumn get skipLastRest => boolean().withDefault(const Constant(true))();
}

// ----------------------------------------------------------------- Historial

@TableIndex(name: 'idx_session_started_at', columns: {#startedAt})
@TableIndex(name: 'idx_session_status', columns: {#status})
class Sessions extends Table with Entity, Archivable {
  @override
  String get tableName => 'session';

  TextColumn get kind => textEnum<SessionKind>()();

  /// Rutina o entrenamiento de origen (sin FK: puede ser de dos tablas y la
  /// sesión no depende de él gracias a [templateSnapshot]).
  TextColumn get templateId => text().nullable()();
  TextColumn get status => textEnum<SessionStatus>()();
  IntColumn get startedAt => integer().map(const UtcMillisConverter())();
  IntColumn get endedAt =>
      integer().map(const UtcMillisConverter()).nullable()();

  /// Zona IANA (p. ej. America/Santiago) si se conoce, y el desfase local
  /// al empezar, para agrupar por día y semana del usuario.
  TextColumn get timeZoneId => text().nullable()();
  IntColumn get utcOffsetMinutes => integer()();
  IntColumn get pausedSeconds => integer().withDefault(const Constant(0))();

  /// Copia de la plantilla al empezar: editarla no altera esta sesión.
  TextColumn get templateSnapshot =>
      text().map(const JsonMapConverter()).nullable()();
  IntColumn get perceivedEffort =>
      integer().nullable().check(perceivedEffort.isBetweenValues(1, 10))();
  TextColumn get note => text().nullable()();

  // Punto de recuperación de una sesión en curso.
  IntColumn get checkpointPhaseIndex => integer().nullable()();
  IntColumn get checkpointElapsedMs => integer().nullable()();
  IntColumn get checkpointAt =>
      integer().map(const UtcMillisConverter()).nullable()();
}

@TableIndex(name: 'idx_session_exercise_exercise', columns: {#exerciseId})
@TableIndex(
  name: 'idx_session_exercise_session',
  columns: {#sessionId, #sortOrder},
)
class SessionExercises extends Table with Entity {
  @override
  String get tableName => 'session_exercise';

  TextColumn get sessionId =>
      text().references(Sessions, #id, onDelete: KeyAction.cascade)();
  TextColumn get exerciseId => text().references(Exercises, #id)();
  IntColumn get sortOrder => integer()();
  TextColumn get notes => text().nullable()();
}

/// Serie registrada. [sessionId] y [exerciseId] se repiten (desnormalizados)
/// para que historial y gráficos por ejercicio usen un índice directo.
@TableIndex(name: 'idx_set_log_exercise', columns: {#exerciseId})
@TableIndex(name: 'idx_set_log_session', columns: {#sessionId})
@TableIndex(
  name: 'idx_set_log_session_exercise_order',
  columns: {#sessionExerciseId, #sortOrder},
)
class SetLogs extends Table with Entity {
  @override
  String get tableName => 'set_log';

  TextColumn get sessionExerciseId =>
      text().references(SessionExercises, #id, onDelete: KeyAction.cascade)();
  TextColumn get sessionId =>
      text().references(Sessions, #id, onDelete: KeyAction.cascade)();
  TextColumn get exerciseId => text().references(Exercises, #id)();
  IntColumn get sortOrder => integer()();
  TextColumn get setType =>
      textEnum<SetType>().withDefault(Constant(SetType.normal.name))();
  RealColumn get weightValue => real().nullable()();
  TextColumn get weightUnit => textEnum<WeightUnit>().nullable()();
  IntColumn get weightGrams => integer().nullable()();
  IntColumn get reps => integer().nullable()();
  RealColumn get rpe => real().nullable()();
  IntColumn get durationSeconds => integer().nullable()();
  RealColumn get distanceMeters => real().nullable()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  IntColumn get loggedAt =>
      integer().map(const UtcMillisConverter()).nullable()();
}

@TableIndex(
  name: 'idx_interval_phase_log_session',
  columns: {#sessionId, #sortOrder},
)
class IntervalPhaseLogs extends Table with Entity {
  @override
  String get tableName => 'interval_phase_log';

  TextColumn get sessionId =>
      text().references(Sessions, #id, onDelete: KeyAction.cascade)();
  IntColumn get sortOrder => integer()();
  TextColumn get phaseType => textEnum<PhaseType>()();
  TextColumn get label => text().nullable()();
  IntColumn get round => integer().withDefault(const Constant(1))();
  IntColumn get plannedSeconds => integer()();
  IntColumn get actualSeconds => integer()();
  BoolColumn get skipped => boolean().withDefault(const Constant(false))();
}

// ------------------------------------------------------ Derivados y ajustes

/// Caché recalculable desde set_log. [value] va en unidad canónica:
/// gramos (peso, 1RM, volumen), repeticiones, segundos o metros.
@TableIndex(
  name: 'idx_personal_record_exercise_type',
  columns: {#exerciseId, #type},
  unique: true,
)
class PersonalRecords extends Table with Entity {
  @override
  String get tableName => 'personal_record';

  TextColumn get exerciseId =>
      text().references(Exercises, #id, onDelete: KeyAction.cascade)();
  TextColumn get type => textEnum<RecordType>()();
  RealColumn get value => real()();
  TextColumn get sessionId => text().nullable().references(
    Sessions,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get achievedAt => integer().map(const UtcMillisConverter())();
}

/// Día de la semana (ISO: 1 = lunes … 7 = domingo) → entrenamiento.
class PlanDays extends Table with Entity {
  @override
  String get tableName => 'plan_day';

  IntColumn get weekday => integer().check(weekday.isBetweenValues(1, 7))();
  TextColumn get kind => textEnum<SessionKind>()();
  TextColumn get templateId => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

class Reminders extends Table with Entity {
  @override
  String get tableName => 'reminder';

  IntColumn get weekday => integer().check(weekday.isBetweenValues(1, 7))();

  /// Hora local en minutos desde medianoche.
  IntColumn get minuteOfDay =>
      integer().check(minuteOfDay.isBetweenValues(0, 1439))();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
}

/// Fila única con el estado de anuncios (D8).
class AdStates extends Table with Entity {
  @override
  String get tableName => 'ad_state';

  IntColumn get lastInterstitialAt =>
      integer().map(const UtcMillisConverter()).nullable()();
  IntColumn get sessionsSinceInterstitial =>
      integer().withDefault(const Constant(0))();
  TextColumn get consentStatus => textEnum<ConsentStatus>().withDefault(
    Constant(ConsentStatus.unknown.name),
  )();
  BoolColumn get adsRemoved => boolean().withDefault(const Constant(false))();
}
