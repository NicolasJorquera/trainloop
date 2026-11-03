import 'package:drift/drift.dart';

import '../../../data/db/app_database.dart';
import '../../../data/db/daos/interval_workouts_dao.dart';
import '../../../data/db/enums.dart';
import '../domain/interval_workout_draft.dart';

/// Entrenamiento guardado con su estructura (tarjetas de S02 y S03).
class IntervalWorkoutSummary {
  const IntervalWorkoutSummary(this.workout);

  final IntervalWorkoutDraft workout;

  String get id => workout.id!;
}

/// Entrenamientos de intervalos: lista, edición, copia y archivo.
///
/// Guardar reemplaza el árbol de bloques; las sesiones pasadas no cambian
/// porque guardan su propia copia (`template_snapshot`).
class IntervalWorkoutRepository {
  IntervalWorkoutRepository(this._db);

  final AppDatabase _db;

  IntervalWorkoutsDao get _dao => _db.intervalWorkoutsDao;

  /// Activos por nombre, con sus bloques. Guardar bloques toca `updated_at`
  /// del entrenamiento, así la lista se actualiza también al editarlos.
  Stream<List<IntervalWorkoutSummary>> watchSummaries() =>
      _dao.watchActive().asyncMap(
        (rows) async => [
          for (final w in rows)
            if (await load(w.id) case final draft?)
              IntervalWorkoutSummary(draft),
        ],
      );

  Future<IntervalWorkoutDraft?> load(String id) async {
    final detail = await _dao.getDetail(id);
    if (detail == null) return null;
    return IntervalWorkoutDraft(
      id: id,
      name: detail.workout.name,
      prepareSeconds: detail.workout.prepareSeconds,
      blocks: _nodes(detail.toDrafts()),
    );
  }

  /// Guarda (crea si no tiene id) y devuelve el id. Un nombre vacío se
  /// reemplaza por [fallbackName]; el nombre se corta a 40 caracteres (R-I3).
  Future<String> save(
    IntervalWorkoutDraft draft, {
    required String fallbackName,
  }) => _db.transaction(() async {
    final trimmed = draft.name.trim();
    final name = String.fromCharCodes(
      (trimmed.isEmpty ? fallbackName : trimmed).runes.take(
        IntervalWorkoutDraft.maxNameLength,
      ),
    );
    var id = draft.id;
    if (id == null) {
      id = await _dao.create(
        IntervalWorkoutsCompanion.insert(
          name: name,
          prepareSeconds: Value(draft.prepareSeconds),
        ),
      );
    } else {
      await _dao.edit(
        id,
        IntervalWorkoutsCompanion(
          name: Value(name),
          prepareSeconds: Value(draft.prepareSeconds),
        ),
      );
    }
    await _dao.replaceBlocks(id, _drafts(draft.blocks));
    return id;
  });

  Future<String> duplicate(String id, {required String name}) =>
      _dao.duplicate(id, name: name);

  Future<void> archive(String id) => _dao.archive(id);

  Future<void> unarchive(String id) => _dao.unarchive(id);

  static List<IntervalNode> _nodes(List<IntervalBlockDraft> drafts) => [
    for (final d in drafts)
      if (d.kind == IntervalBlockKind.group)
        IntervalRepeat(
          d.rounds,
          _nodes(d.children),
          skipLastRest: d.skipLastRest,
          label: d.label,
        )
      else
        IntervalStep(d.phaseType!, d.durationSeconds!, label: d.label),
  ];

  static List<IntervalBlockDraft> _drafts(List<IntervalNode> nodes) => [
    for (final n in nodes)
      switch (n) {
        IntervalStep() => IntervalBlockDraft.interval(
          phaseType: n.type,
          durationSeconds: n.seconds,
          label: n.label,
        ),
        IntervalRepeat() => IntervalBlockDraft.group(
          rounds: n.rounds,
          skipLastRest: n.skipLastRest,
          label: n.label,
          children: _drafts(n.children),
        ),
      },
  ];
}
