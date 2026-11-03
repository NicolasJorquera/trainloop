import 'package:drift/drift.dart';

import '../../core/units/weight_unit.dart';
import '../db/app_database.dart';
import '../db/daos/exercises_dao.dart';
import 'exercise_catalog.dart';

/// Inserta los ejercicios del catálogo que aún no están en la base, por
/// clave. Es idempotente: corre en cada arranque y solo agrega las entradas
/// nuevas de una actualización de la biblioteca; nunca duplica ni revive un
/// ejercicio archivado. Devuelve cuántos insertó.
///
/// `name` guarda el nombre en inglés (respaldo si la clave dejara de
/// existir); la pantalla muestra el del catálogo en el idioma activo.
Future<int> seedExerciseCatalog(
  ExercisesDao dao, {
  List<CatalogExercise> catalog = exerciseCatalog,
}) async {
  final present = await dao.catalogKeys();
  final missing = [
    for (final e in catalog)
      if (!present.contains(e.key)) e,
  ];
  if (missing.isEmpty) return 0;
  await dao.insertAllOrIgnore([
    for (final e in missing)
      ExercisesCompanion.insert(
        name: e.en,
        normalizedName: normalizeName(e.en),
        logType: e.logType,
        primaryMuscle: e.muscle,
        equipment: Value(e.equipment),
        incrementValue: Value(e.incrementKg),
        incrementUnit: Value(e.incrementKg == null ? null : WeightUnit.kg),
        defaultRestSeconds: Value(e.restSeconds),
        isCustom: const Value(false),
        catalogKey: Value(e.key),
      ),
  ]);
  return missing.length;
}
