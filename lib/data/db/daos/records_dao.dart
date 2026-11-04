import 'package:drift/drift.dart';

import '../app_database.dart';
import '../converters.dart';
import '../enums.dart';
import '../tables.dart';

part 'records_dao.g.dart';

/// Récords personales: caché recalculable desde set_log (R-P3), uno por
/// ejercicio + tipo (+ peso en "más repeticiones con un peso dado").
@DriftAccessor(tables: [PersonalRecords])
class RecordsDao extends DatabaseAccessor<AppDatabase> with _$RecordsDaoMixin {
  RecordsDao(super.attachedDatabase);

  /// Crea o reemplaza el récord de [exerciseId], [type] y [weightGrams].
  Future<void> upsert({
    required String exerciseId,
    required RecordType type,
    required double value,
    required DateTime achievedAt,
    String? sessionId,
    int weightGrams = 0,
    int? reps,
    double? previousValue,
  }) => into(personalRecords).insert(
    PersonalRecordsCompanion.insert(
      exerciseId: exerciseId,
      type: type,
      value: value,
      sessionId: Value(sessionId),
      achievedAt: achievedAt.toUtc(),
      weightGrams: Value(weightGrams),
      reps: Value(reps),
      previousValue: Value(previousValue),
    ),
    onConflict: DoUpdate(
      (old) => PersonalRecordsCompanion(
        value: Value(value),
        sessionId: Value(sessionId),
        achievedAt: Value(achievedAt.toUtc()),
        reps: Value(reps),
        previousValue: Value(previousValue),
        updatedAt: Value(nowUtc()),
      ),
      target: [
        personalRecords.exerciseId,
        personalRecords.type,
        personalRecords.weightGrams,
      ],
    ),
  );

  /// Reemplaza todos los récords de [exerciseId] en una transacción.
  Future<void> replaceForExercise(
    String exerciseId,
    List<PersonalRecordsCompanion> rows,
  ) => transaction(() async {
    await clearForExercise(exerciseId);
    for (final r in rows) {
      await into(personalRecords).insert(r);
    }
  });

  Stream<List<PersonalRecord>> watchForExercise(String exerciseId) =>
      (select(personalRecords)
            ..where((t) => t.exerciseId.equals(exerciseId))
            ..orderBy([
              (t) => OrderingTerm.asc(t.type),
              (t) => OrderingTerm.asc(t.weightGrams),
            ]))
          .watch();

  Future<List<PersonalRecord>> forExercise(String exerciseId) =>
      watchForExercise(exerciseId).first;

  /// Récords que hoy pertenecen a [sessionId].
  Future<List<PersonalRecord>> forSession(String sessionId) => (select(
    personalRecords,
  )..where((t) => t.sessionId.equals(sessionId))).get();

  Stream<List<PersonalRecord>> watchForSession(String sessionId) => (select(
    personalRecords,
  )..where((t) => t.sessionId.equals(sessionId))).watch();

  Stream<List<PersonalRecord>> watchAll() => select(personalRecords).watch();

  /// Borra los récords de un ejercicio antes de recalcularlos.
  Future<int> clearForExercise(String exerciseId) => (delete(
    personalRecords,
  )..where((t) => t.exerciseId.equals(exerciseId))).go();

  Future<int> clearAll() => delete(personalRecords).go();
}
