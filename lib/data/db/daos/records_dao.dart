import 'package:drift/drift.dart';

import '../app_database.dart';
import '../converters.dart';
import '../enums.dart';
import '../tables.dart';

part 'records_dao.g.dart';

/// Récords personales: caché recalculable desde set_log, uno por
/// ejercicio + tipo.
@DriftAccessor(tables: [PersonalRecords])
class RecordsDao extends DatabaseAccessor<AppDatabase> with _$RecordsDaoMixin {
  RecordsDao(super.attachedDatabase);

  /// Crea o reemplaza el récord de [exerciseId] y [type].
  Future<void> upsert({
    required String exerciseId,
    required RecordType type,
    required double value,
    required DateTime achievedAt,
    String? sessionId,
  }) => into(personalRecords).insert(
    PersonalRecordsCompanion.insert(
      exerciseId: exerciseId,
      type: type,
      value: value,
      sessionId: Value(sessionId),
      achievedAt: achievedAt.toUtc(),
    ),
    onConflict: DoUpdate(
      (old) => PersonalRecordsCompanion(
        value: Value(value),
        sessionId: Value(sessionId),
        achievedAt: Value(achievedAt.toUtc()),
        updatedAt: Value(nowUtc()),
      ),
      target: [personalRecords.exerciseId, personalRecords.type],
    ),
  );

  Stream<List<PersonalRecord>> watchForExercise(String exerciseId) =>
      (select(personalRecords)
            ..where((t) => t.exerciseId.equals(exerciseId))
            ..orderBy([(t) => OrderingTerm.asc(t.type)]))
          .watch();

  /// Borra los récords de un ejercicio antes de recalcularlos.
  Future<int> clearForExercise(String exerciseId) => (delete(
    personalRecords,
  )..where((t) => t.exerciseId.equals(exerciseId))).go();
}
