import 'package:drift/drift.dart';

import '../../../data/db/app_database.dart';
import '../../../data/db/daos/routines_dao.dart';
import '../domain/routine_draft.dart';

/// Rutinas de fuerza: lista, edición, copia, archivo y orden.
///
/// Guardar reemplaza los ejercicios y series de la plantilla; las sesiones
/// pasadas no cambian porque guardan su propia copia (`template_snapshot`).
class RoutineRepository {
  RoutineRepository(this._db);

  final AppDatabase _db;

  RoutinesDao get _dao => _db.routinesDao;

  Stream<List<RoutineSummary>> watchSummaries() => _dao.watchSummaries();

  /// Carga la rutina para editarla. Cada ejercicio toma el objetivo de su
  /// primera serie (el editor maneja series iguales).
  Future<RoutineDraft?> load(String id) async {
    final detail = await _dao.getDetail(id);
    if (detail == null) return null;
    return RoutineDraft(
      id: id,
      name: detail.routine.name,
      entries: [for (final e in detail.exercises) _entryFrom(e)],
    );
  }

  /// Guarda la rutina (la crea si no tiene id) y devuelve su id. Un nombre
  /// vacío se reemplaza por [fallbackName].
  Future<String> save(
    RoutineDraft draft, {
    required String fallbackName,
  }) => _db.transaction(() async {
    final name = draft.name.trim().isEmpty ? fallbackName : draft.name.trim();
    var id = draft.id;
    if (id == null) {
      id = await _dao.create(
        StrengthRoutinesCompanion.insert(
          name: name,
          sortOrder: Value(await _dao.nextSortOrder()),
        ),
      );
    } else {
      await _dao.edit(id, StrengthRoutinesCompanion(name: Value(name)));
    }
    await _dao.replaceExercises(id, [
      for (final e in draft.entries)
        RoutineExerciseDraft(
          exerciseId: e.exercise.id,
          restSeconds: e.restSeconds,
          targets: [
            for (var i = 0; i < e.sets; i++)
              RoutineSetTargetsCompanion(
                reps: Value(e.countsReps ? e.reps : null),
                durationSeconds: Value(e.countsTime ? e.durationSeconds : null),
                weightValue: Value(e.tracksWeight ? e.weight : null),
                weightUnit: Value(
                  e.tracksWeight && e.weight != null ? e.weightUnit : null,
                ),
              ),
          ],
        ),
    ]);
    return id;
  });

  Future<String> duplicate(String id, {required String name}) =>
      _dao.duplicate(id, name: name);

  Future<void> archive(String id) => _dao.archive(id);

  Future<void> unarchive(String id) => _dao.unarchive(id);

  Future<void> reorder(List<String> orderedIds) => _dao.reorder(orderedIds);

  /// Cantidad de rutinas activas (nombre por defecto "Rutina N").
  Future<int> activeCount() async => (await _dao.watchSummaries().first).length;

  RoutineEntryDraft _entryFrom(RoutineExerciseDetail e) {
    final first = e.targets.firstOrNull;
    final base = RoutineEntryDraft.defaultsFor(e.exercise);
    return RoutineEntryDraft(
      exercise: e.exercise,
      sets: e.targets.isEmpty ? base.sets : e.targets.length,
      reps: first?.reps ?? base.reps,
      durationSeconds: first?.durationSeconds ?? base.durationSeconds,
      weight: first?.weightValue,
      weightUnit: first?.weightUnit,
      restSeconds: e.entry.restSeconds ?? base.restSeconds,
    );
  }
}
