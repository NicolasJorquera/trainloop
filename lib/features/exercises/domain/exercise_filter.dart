import '../../../data/db/app_database.dart';
import '../../../data/db/daos/exercises_dao.dart';
import '../../../data/db/enums.dart';

/// Grupos de los chips de músculo de la biblioteca (S08).
enum MuscleGroup {
  legs,
  chest,
  back,
  shoulders,
  arms,
  core,
  other;

  static MuscleGroup of(Muscle m) => switch (m) {
    Muscle.quads ||
    Muscle.hamstrings ||
    Muscle.glutes ||
    Muscle.calves => MuscleGroup.legs,
    Muscle.chest => MuscleGroup.chest,
    Muscle.back => MuscleGroup.back,
    Muscle.shoulders => MuscleGroup.shoulders,
    Muscle.biceps || Muscle.triceps || Muscle.forearms => MuscleGroup.arms,
    Muscle.core => MuscleGroup.core,
    Muscle.fullBody || Muscle.cardio || Muscle.other => MuscleGroup.other,
  };
}

/// Búsqueda y filtros de la biblioteca. `null` = sin filtrar.
class ExerciseFilter {
  const ExerciseFilter({
    this.query = '',
    this.group,
    this.equipment,
    this.logType,
  });

  final String query;
  final MuscleGroup? group;
  final Equipment? equipment;
  final ExerciseLogType? logType;

  ExerciseFilter copyWith({
    String? query,
    MuscleGroup? Function()? group,
    Equipment? Function()? equipment,
    ExerciseLogType? Function()? logType,
  }) => ExerciseFilter(
    query: query ?? this.query,
    group: group != null ? group() : this.group,
    equipment: equipment != null ? equipment() : this.equipment,
    logType: logType != null ? logType() : this.logType,
  );

  bool matches(Exercise e, String displayName) {
    if (group != null && MuscleGroup.of(e.primaryMuscle) != group) {
      return false;
    }
    if (equipment != null && e.equipment != equipment) return false;
    if (logType != null && e.logType != logType) return false;
    final q = normalizeName(query);
    return q.isEmpty || normalizeName(displayName).contains(q);
  }
}

/// Ejercicios activos que pasan el filtro, ordenados por su nombre visible
/// (sin tildes). [nameOf] da el nombre en el idioma activo.
List<Exercise> filterExercises(
  Iterable<Exercise> exercises,
  ExerciseFilter filter,
  String Function(Exercise) nameOf,
) {
  final out = [
    for (final e in exercises)
      if (e.archivedAt == null && filter.matches(e, nameOf(e)))
        (normalizeName(nameOf(e)), e),
  ]..sort((a, b) => a.$1.compareTo(b.$1));
  return [for (final (_, e) in out) e];
}
