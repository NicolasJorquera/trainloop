import 'package:drift/drift.dart';

import '../../../data/catalog/exercise_catalog_seeder.dart';
import '../../../data/db/app_database.dart';
import '../../../data/db/daos/exercises_dao.dart';
import '../domain/exercise_draft.dart';

/// Biblioteca de ejercicios: incluidos (sembrados del catálogo) y propios.
class ExerciseRepository {
  ExerciseRepository(this._dao);

  final ExercisesDao _dao;

  /// Ejercicios activos. Antes siembra el catálogo (idempotente).
  Stream<List<Exercise>> watchLibrary() async* {
    await seedExerciseCatalog(_dao);
    yield* _dao.watchActive();
  }

  Future<Exercise?> findById(String id) => _dao.findById(id);

  /// Crea (sin [id]) o actualiza un ejercicio propio y lo devuelve.
  Future<Exercise> saveCustom(ExerciseDraft d, {String? id}) async {
    final name = d.name.trim().replaceAll(RegExp(r'\s+'), ' ');
    final increment = d.tracksWeight ? d.increment : null;
    final unit = increment == null ? null : d.unit;
    final rest = d.restSeconds;
    if (id == null) {
      id = await _dao.create(
        name: name,
        logType: d.logType,
        primaryMuscle: d.muscle,
        equipment: d.equipment,
        incrementValue: increment,
        incrementUnit: unit,
        defaultRestSeconds: rest,
      );
    } else {
      await _dao.edit(
        id,
        ExercisesCompanion(
          name: Value(name),
          logType: Value(d.logType),
          primaryMuscle: Value(d.muscle),
          equipment: Value(d.equipment),
          incrementValue: Value(increment),
          incrementUnit: Value(unit),
          defaultRestSeconds: Value(rest),
        ),
      );
    }
    return (await _dao.findById(id))!;
  }

  /// Borrado lógico: deja de listarse, pero rutinas e historial lo siguen
  /// resolviendo.
  Future<void> archive(String id) => _dao.archive(id);
}
