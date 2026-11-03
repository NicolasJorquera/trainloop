import 'dart:ui';

import '../../../data/catalog/exercise_catalog.dart';
import '../../../data/db/app_database.dart';
import '../../../data/db/daos/exercises_dao.dart';

/// Nombre visible: el del catálogo en el idioma activo para los ejercicios
/// incluidos, el nombre literal de la persona para los propios.
String exerciseName(Exercise exercise, Locale locale) {
  final entry = exerciseCatalogByKey[exercise.catalogKey];
  return entry?.nameFor(locale) ?? exercise.name;
}

/// Busca un ejercicio activo que ya se llame como [name] (sin distinguir
/// mayúsculas, tildes ni espacios). Los incluidos se comparan con su nombre
/// en todos los idiomas: «Press militar» choca con «Overhead press».
/// [ignoreId] excluye al ejercicio que se está editando.
Exercise? findDuplicateExercise(
  String name,
  Iterable<Exercise> exercises, {
  String? ignoreId,
}) {
  final target = normalizeName(name);
  if (target.isEmpty) return null;
  for (final e in exercises) {
    if (e.id == ignoreId || e.archivedAt != null) continue;
    final entry = exerciseCatalogByKey[e.catalogKey];
    final names = entry == null
        ? [e.normalizedName]
        : entry.allNames.map(normalizeName);
    if (names.contains(target)) return e;
  }
  return null;
}
