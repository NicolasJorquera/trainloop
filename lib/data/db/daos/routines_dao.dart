import 'package:drift/drift.dart';

import '../app_database.dart';
import '../converters.dart';
import '../tables.dart';

part 'routines_dao.g.dart';

/// Ejercicio de una rutina con su ejercicio y sus series objetivo.
class RoutineExerciseDetail {
  const RoutineExerciseDetail(this.entry, this.exercise, this.targets);

  final RoutineExercise entry;
  final Exercise exercise;
  final List<RoutineSetTarget> targets;
}

/// Rutina completa, lista para mostrar o copiar a una sesión.
class RoutineDetail {
  const RoutineDetail(this.routine, this.exercises);

  final StrengthRoutine routine;
  final List<RoutineExerciseDetail> exercises;

  /// Copia de la estructura para `session.templateSnapshot`.
  Map<String, Object?> toSnapshot() => {
    'routine': routine.toJson(),
    'exercises': [
      for (final e in exercises)
        {
          ...e.entry.toJson(),
          'exercise': e.exercise.toJson(),
          'targets': [for (final t in e.targets) t.toJson()],
        },
    ],
  };
}

/// Borrador de un ejercicio al guardar una rutina.
class RoutineExerciseDraft {
  const RoutineExerciseDraft({
    required this.exerciseId,
    this.restSeconds,
    this.targets = const [],
  });

  final String exerciseId;
  final int? restSeconds;

  /// Series objetivo; `sortOrder` y el padre los asigna el DAO.
  final List<RoutineSetTargetsCompanion> targets;
}

/// Rutinas de fuerza con sus ejercicios y series objetivo.
@DriftAccessor(
  tables: [StrengthRoutines, RoutineExercises, RoutineSetTargets, Exercises],
)
class RoutinesDao extends DatabaseAccessor<AppDatabase>
    with _$RoutinesDaoMixin {
  RoutinesDao(super.attachedDatabase);

  Future<String> create(StrengthRoutinesCompanion entry) async =>
      (await into(strengthRoutines).insertReturning(entry)).id;

  Future<void> edit(String id, StrengthRoutinesCompanion changes) =>
      (update(strengthRoutines)..where((t) => t.id.equals(id))).write(
        changes.copyWith(updatedAt: Value(nowUtc())),
      );

  Future<void> archive(String id) =>
      edit(id, StrengthRoutinesCompanion(archivedAt: Value(nowUtc())));

  Stream<List<StrengthRoutine>> watchActive() =>
      (select(strengthRoutines)
            ..where((t) => t.archivedAt.isNull())
            ..orderBy([
              (t) => OrderingTerm.asc(t.sortOrder),
              (t) => OrderingTerm.asc(t.name),
            ]))
          .watch();

  /// Reemplaza los ejercicios y series de la rutina en una transacción.
  Future<void> replaceExercises(
    String routineId,
    List<RoutineExerciseDraft> drafts,
  ) => transaction(() async {
    await (delete(
      routineExercises,
    )..where((t) => t.routineId.equals(routineId))).go();
    for (final (i, draft) in drafts.indexed) {
      final entry = await into(routineExercises).insertReturning(
        RoutineExercisesCompanion.insert(
          routineId: routineId,
          exerciseId: draft.exerciseId,
          sortOrder: i,
          restSeconds: Value(draft.restSeconds),
        ),
      );
      for (final (j, target) in draft.targets.indexed) {
        await into(routineSetTargets).insert(
          _withGrams(
            target,
          ).copyWith(routineExerciseId: Value(entry.id), sortOrder: Value(j)),
        );
      }
    }
    await edit(routineId, const StrengthRoutinesCompanion());
  });

  Future<RoutineDetail?> getDetail(String id) async {
    final routine = await (select(
      strengthRoutines,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (routine == null) return null;
    final rows =
        await (select(routineExercises).join([
                innerJoin(
                  exercises,
                  exercises.id.equalsExp(routineExercises.exerciseId),
                ),
              ])
              ..where(routineExercises.routineId.equals(id))
              ..orderBy([OrderingTerm.asc(routineExercises.sortOrder)]))
            .get();
    final details = <RoutineExerciseDetail>[];
    for (final row in rows) {
      final entry = row.readTable(routineExercises);
      final targets =
          await (select(routineSetTargets)
                ..where((t) => t.routineExerciseId.equals(entry.id))
                ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
              .get();
      details.add(
        RoutineExerciseDetail(entry, row.readTable(exercises), targets),
      );
    }
    return RoutineDetail(routine, details);
  }

  RoutineSetTargetsCompanion _withGrams(RoutineSetTargetsCompanion c) {
    final value = c.weightValue.present ? c.weightValue.value : null;
    final unit = c.weightUnit.present ? c.weightUnit.value : null;
    return c.copyWith(
      weightGrams: Value(
        value != null && unit != null ? unit.toGrams(value) : null,
      ),
    );
  }
}
