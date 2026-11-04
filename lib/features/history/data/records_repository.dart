import 'package:drift/drift.dart';

import '../../../data/db/app_database.dart';
import '../../../data/db/daos/sessions_dao.dart';
import '../../../data/db/enums.dart';
import '../domain/personal_records.dart';

/// Récords nuevos de un ejercicio en una sesión (resumen y detalle).
class ExerciseRecords {
  const ExerciseRecords(this.exercise, this.records);

  final Exercise exercise;
  final List<PersonalRecord> records;
}

/// Caché de récords (R-P3): se recalcula al guardar una sesión de fuerza y
/// al editar, borrar o restaurar una sesión, siempre desde set_log y para
/// los ejercicios afectados.
class RecordsRepository {
  RecordsRepository(this._db);

  final AppDatabase _db;

  /// Series hechas de [exerciseId] en sesiones del historial (completadas o
  /// incompletas, no borradas), en orden cronológico.
  Future<List<RecordSet>> historySets(String exerciseId) async {
    final db = _db;
    final rows =
        await (db.select(db.setLogs).join([
                innerJoin(
                  db.sessions,
                  db.sessions.id.equalsExp(db.setLogs.sessionId),
                ),
                innerJoin(
                  db.sessionExercises,
                  db.sessionExercises.id.equalsExp(
                    db.setLogs.sessionExerciseId,
                  ),
                ),
              ])
              ..where(
                db.setLogs.exerciseId.equals(exerciseId) &
                    db.setLogs.completed.equals(true) &
                    db.sessions.archivedAt.isNull() &
                    db.sessions.status.isInValues(SessionsDao.historyStatuses),
              )
              ..orderBy([
                OrderingTerm.asc(db.sessions.startedAt),
                OrderingTerm.asc(db.sessionExercises.sortOrder),
                OrderingTerm.asc(db.setLogs.sortOrder),
              ]))
            .get();
    return [
      for (final r in rows)
        RecordSet(
          set: r.readTable(db.setLogs),
          sessionStartedAt: r.readTable(db.sessions).startedAt,
        ),
    ];
  }

  /// Recalcula y guarda los récords de [exerciseId].
  Future<List<ComputedRecord>> recomputeExercise(String exerciseId) =>
      _db.transaction(() async {
        final exercise = await _db.exercisesDao.findById(exerciseId);
        if (exercise == null) return const [];
        final computed = computeRecords(
          exercise.logType,
          await historySets(exerciseId),
        );
        await _db.recordsDao.replaceForExercise(exerciseId, [
          for (final r in computed)
            PersonalRecordsCompanion.insert(
              exerciseId: exerciseId,
              type: r.type,
              value: r.value,
              sessionId: Value(r.sessionId),
              achievedAt: r.achievedAt,
              weightGrams: Value(r.weightGrams),
              reps: Value(r.reps),
              previousValue: Value(r.previousValue),
            ),
        ]);
        return computed;
      });

  Future<void> recomputeExercises(Iterable<String> exerciseIds) async {
    for (final id in exerciseIds.toSet()) {
      await recomputeExercise(id);
    }
  }

  /// Ejercicios con series en [sessionId] (hechas o no).
  Future<Set<String>> exercisesOfSession(String sessionId) async {
    final rows =
        await (_db.selectOnly(_db.setLogs, distinct: true)
              ..addColumns([_db.setLogs.exerciseId])
              ..where(_db.setLogs.sessionId.equals(sessionId)))
            .get();
    final fromSets = {for (final r in rows) r.read(_db.setLogs.exerciseId)!};
    final entries = await _db.sessionsDao.exercisesOf(sessionId);
    return {...fromSets, for (final (_, e) in entries) e.id};
  }

  /// Recalcula los ejercicios de una sesión (guardarla, editarla, borrarla o
  /// restaurarla).
  Future<void> recomputeSession(String sessionId) async =>
      recomputeExercises(await exercisesOfSession(sessionId));

  /// Recalcula toda la caché (tras migrar a v5).
  Future<void> rebuildAll() async {
    final rows =
        await (_db.selectOnly(_db.setLogs, distinct: true)
              ..addColumns([_db.setLogs.exerciseId])
              ..where(_db.setLogs.completed.equals(true)))
            .get();
    await _db.recordsDao.clearAll();
    await recomputeExercises([
      for (final r in rows) r.read(_db.setLogs.exerciseId)!,
    ]);
  }

  /// Si la migración vació la caché, la recalcula una vez.
  Future<void> rebuildIfPending() async {
    // Abrir la base corre la migración (y marca la caché pendiente).
    await _db.customSelect('SELECT 1').get();
    if (!_db.recordsRebuildPending) return;
    _db.recordsRebuildPending = false;
    await rebuildAll();
  }

  /// Récords nuevos (que superaron una marca anterior) que hoy pertenecen a
  /// [sessionId], agrupados por ejercicio en el orden de la sesión.
  Future<List<ExerciseRecords>> newRecordsOf(String sessionId) async {
    final records = [
      for (final r in await _db.recordsDao.forSession(sessionId))
        if (r.previousValue != null) r,
    ];
    if (records.isEmpty) return const [];
    final out = <ExerciseRecords>[];
    for (final (_, exercise) in await _db.sessionsDao.exercisesOf(sessionId)) {
      if (out.any((g) => g.exercise.id == exercise.id)) continue;
      final mine = [
        for (final r in records)
          if (r.exerciseId == exercise.id) r,
      ]..sort(compareRecords);
      if (mine.isNotEmpty) out.add(ExerciseRecords(exercise, mine));
    }
    return out;
  }

  Stream<List<PersonalRecord>> watchForExercise(String exerciseId) =>
      _db.recordsDao.watchForExercise(exerciseId);
}

/// Orden de los récords al mostrarlos: tipo y peso.
int compareRecords(PersonalRecord a, PersonalRecord b) {
  final t = a.type.index.compareTo(b.type.index);
  return t != 0 ? t : a.weightGrams.compareTo(b.weightGrams);
}

/// Tipos que se muestran (en ese orden) en la ficha y el resumen.
const shownRecordTypes = [
  RecordType.maxWeight,
  RecordType.estimatedOneRm,
  RecordType.maxReps,
  RecordType.maxSessionVolume,
  RecordType.maxDuration,
  RecordType.maxDistance,
];
