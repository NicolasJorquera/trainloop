import 'package:drift/drift.dart';

import '../app_database.dart';
import '../converters.dart';
import '../enums.dart';
import '../tables.dart';

part 'interval_workouts_dao.g.dart';

/// Bloque al guardar un entrenamiento: un intervalo o un grupo con hijos.
class IntervalBlockDraft {
  const IntervalBlockDraft.interval({
    required PhaseType this.phaseType,
    required int this.durationSeconds,
    this.label,
  }) : kind = IntervalBlockKind.interval,
       rounds = 1,
       children = const [];

  const IntervalBlockDraft.group({
    required this.rounds,
    required this.children,
    this.label,
  }) : kind = IntervalBlockKind.group,
       phaseType = null,
       durationSeconds = null;

  final IntervalBlockKind kind;
  final PhaseType? phaseType;
  final int? durationSeconds;
  final String? label;
  final int rounds;
  final List<IntervalBlockDraft> children;
}

/// Entrenamiento con sus bloques en orden (los hijos referencian al padre).
class IntervalWorkoutDetail {
  const IntervalWorkoutDetail(this.workout, this.blocks);

  final IntervalWorkout workout;
  final List<IntervalBlock> blocks;

  /// Hijos directos de [parentId] (`null` = primer nivel), en orden.
  List<IntervalBlock> childrenOf(String? parentId) =>
      blocks.where((b) => b.parentId == parentId).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  /// Copia de la estructura para `session.templateSnapshot`.
  Map<String, Object?> toSnapshot() => {
    'workout': workout.toJson(),
    'blocks': [for (final b in blocks) b.toJson()],
  };
}

/// Entrenamientos de intervalos y su árbol de bloques.
@DriftAccessor(tables: [IntervalWorkouts, IntervalBlocks])
class IntervalWorkoutsDao extends DatabaseAccessor<AppDatabase>
    with _$IntervalWorkoutsDaoMixin {
  IntervalWorkoutsDao(super.attachedDatabase);

  Future<String> create(IntervalWorkoutsCompanion entry) async =>
      (await into(intervalWorkouts).insertReturning(entry)).id;

  Future<void> edit(String id, IntervalWorkoutsCompanion changes) =>
      (update(intervalWorkouts)..where((t) => t.id.equals(id))).write(
        changes.copyWith(updatedAt: Value(nowUtc())),
      );

  Future<void> archive(String id) =>
      edit(id, IntervalWorkoutsCompanion(archivedAt: Value(nowUtc())));

  Stream<List<IntervalWorkout>> watchActive() =>
      (select(intervalWorkouts)
            ..where((t) => t.archivedAt.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .watch();

  /// Reemplaza el árbol de bloques en una transacción.
  Future<void> replaceBlocks(
    String workoutId,
    List<IntervalBlockDraft> drafts,
  ) => transaction(() async {
    await (delete(
      intervalBlocks,
    )..where((t) => t.workoutId.equals(workoutId))).go();
    await _insertLevel(workoutId, null, drafts);
    await edit(workoutId, const IntervalWorkoutsCompanion());
  });

  Future<void> _insertLevel(
    String workoutId,
    String? parentId,
    List<IntervalBlockDraft> drafts,
  ) async {
    for (final (i, d) in drafts.indexed) {
      final row = await into(intervalBlocks).insertReturning(
        IntervalBlocksCompanion.insert(
          workoutId: workoutId,
          parentId: Value(parentId),
          sortOrder: i,
          kind: d.kind,
          phaseType: Value(d.phaseType),
          label: Value(d.label),
          durationSeconds: Value(d.durationSeconds),
          rounds: Value(d.rounds),
        ),
      );
      await _insertLevel(workoutId, row.id, d.children);
    }
  }

  Future<IntervalWorkoutDetail?> getDetail(String id) async {
    final workout = await (select(
      intervalWorkouts,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (workout == null) return null;
    final blocks =
        await (select(intervalBlocks)
              ..where((t) => t.workoutId.equals(id))
              ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
            .get();
    return IntervalWorkoutDetail(workout, blocks);
  }
}
