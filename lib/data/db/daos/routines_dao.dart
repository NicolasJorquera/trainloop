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

/// Rutina activa con su cantidad de ejercicios (lista de Entrenar).
class RoutineSummary {
  const RoutineSummary(this.routine, this.exerciseCount);

  final StrengthRoutine routine;
  final int exerciseCount;
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

  /// Deshace [archive] (botón "Deshacer").
  Future<void> unarchive(String id) =>
      edit(id, const StrengthRoutinesCompanion(archivedAt: Value(null)));

  /// Cantidad de rutinas activas.
  Future<int> countActive() async {
    final count = strengthRoutines.id.count();
    final row =
        await (selectOnly(strengthRoutines)
              ..addColumns([count])
              ..where(strengthRoutines.archivedAt.isNull()))
            .getSingle();
    return row.read(count) ?? 0;
  }

  /// Orden para una rutina nueva: al final de la lista.
  Future<int> nextSortOrder() async {
    final max = strengthRoutines.sortOrder.max();
    final row = await (selectOnly(
      strengthRoutines,
    )..addColumns([max])).getSingle();
    return (row.read(max) ?? -1) + 1;
  }

  /// Guarda el orden de la lista: cada id toma su posición.
  Future<void> reorder(List<String> orderedIds) => transaction(() async {
    for (final (i, id) in orderedIds.indexed) {
      await (update(strengthRoutines)..where((t) => t.id.equals(id))).write(
        StrengthRoutinesCompanion(sortOrder: Value(i)),
      );
    }
  });

  /// Copia profunda (rutina, ejercicios y series objetivo) al final de la
  /// lista. Devuelve el id de la copia.
  Future<String> duplicate(String id, {required String name}) =>
      transaction(() async {
        final source = await getDetail(id);
        if (source == null) throw StateError('Rutina $id no existe');
        final copyId = await create(
          StrengthRoutinesCompanion.insert(
            name: name,
            notes: Value(source.routine.notes),
            sortOrder: Value(await nextSortOrder()),
          ),
        );
        await replaceExercises(copyId, [
          for (final e in source.exercises)
            RoutineExerciseDraft(
              exerciseId: e.exercise.id,
              restSeconds: e.entry.restSeconds,
              targets: [for (final t in e.targets) _copyTarget(t)],
            ),
        ]);
        return copyId;
      });

  /// Rutinas activas en su orden, con la cantidad de ejercicios.
  Stream<List<RoutineSummary>> watchSummaries() {
    final count = routineExercises.id.count();
    final query =
        select(strengthRoutines).join([
            leftOuterJoin(
              routineExercises,
              routineExercises.routineId.equalsExp(strengthRoutines.id),
              useColumns: false,
            ),
          ])
          ..addColumns([count])
          ..where(strengthRoutines.archivedAt.isNull())
          ..groupBy([strengthRoutines.id])
          ..orderBy([
            OrderingTerm.asc(strengthRoutines.sortOrder),
            OrderingTerm.asc(strengthRoutines.name),
          ]);
    return query.watch().map(
      (rows) => [
        for (final r in rows)
          RoutineSummary(r.readTable(strengthRoutines), r.read(count) ?? 0),
      ],
    );
  }

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

  RoutineSetTargetsCompanion _copyTarget(RoutineSetTarget t) =>
      RoutineSetTargetsCompanion(
        setType: Value(t.setType),
        reps: Value(t.reps),
        weightValue: Value(t.weightValue),
        weightUnit: Value(t.weightUnit),
        rpe: Value(t.rpe),
        durationSeconds: Value(t.durationSeconds),
        distanceMeters: Value(t.distanceMeters),
      );

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
