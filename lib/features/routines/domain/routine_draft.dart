import '../../../core/units/weight_unit.dart';
import '../../../data/db/app_database.dart';
import '../../../data/db/enums.dart';
import 'reorder.dart';

/// Ejercicio de una rutina en edición: series iguales con su objetivo.
class RoutineEntryDraft {
  const RoutineEntryDraft({
    required this.exercise,
    this.sets = defaultSets,
    this.reps,
    this.durationSeconds,
    this.weight,
    this.weightUnit,
    this.restSeconds = defaultRestSeconds,
  });

  /// Valores por defecto según el ejercicio: 3 series de 10 reps (o de 45 s
  /// si se registra por tiempo) y su descanso por defecto.
  factory RoutineEntryDraft.defaultsFor(Exercise e) => RoutineEntryDraft(
    exercise: e,
    reps: _countsReps(e.logType) ? defaultReps : null,
    durationSeconds: _countsTime(e.logType) ? defaultDurationSeconds : null,
    restSeconds: e.defaultRestSeconds ?? defaultRestSeconds,
  );

  static const defaultSets = 3;
  static const defaultReps = 10;
  static const defaultDurationSeconds = 45;
  static const defaultRestSeconds = 90;
  static const maxSets = 20;
  static const maxReps = 100;
  static const maxDurationSeconds = 3600;
  static const maxRestSeconds = 600;
  static const restStep = 15;
  static const durationStep = 15;

  final Exercise exercise;
  final int sets;
  final int? reps;
  final int? durationSeconds;

  /// Peso objetivo opcional en [weightUnit].
  final double? weight;
  final WeightUnit? weightUnit;
  final int restSeconds;

  bool get countsReps => _countsReps(exercise.logType);
  bool get countsTime => _countsTime(exercise.logType);
  bool get tracksWeight => exercise.logType == ExerciseLogType.weightReps;

  RoutineEntryDraft copyWith({
    int? sets,
    int? reps,
    int? durationSeconds,
    double? Function()? weight,
    WeightUnit? weightUnit,
    int? restSeconds,
  }) => RoutineEntryDraft(
    exercise: exercise,
    sets: (sets ?? this.sets).clamp(1, maxSets),
    reps: reps == null ? this.reps : reps.clamp(1, maxReps),
    durationSeconds: durationSeconds == null
        ? this.durationSeconds
        : durationSeconds.clamp(durationStep, maxDurationSeconds),
    weight: weight != null ? weight() : this.weight,
    weightUnit: weightUnit ?? this.weightUnit,
    restSeconds: (restSeconds ?? this.restSeconds).clamp(0, maxRestSeconds),
  );

  static bool _countsReps(ExerciseLogType t) =>
      t == ExerciseLogType.weightReps || t == ExerciseLogType.reps;

  static bool _countsTime(ExerciseLogType t) =>
      t == ExerciseLogType.time || t == ExerciseLogType.timeDistance;
}

/// Rutina en edición (S07). Inmutable: cada operación devuelve una copia.
class RoutineDraft {
  const RoutineDraft({this.id, this.name = '', this.entries = const []});

  /// `null` mientras la rutina no se ha guardado.
  final String? id;
  final String name;
  final List<RoutineEntryDraft> entries;

  bool get canSave => entries.isNotEmpty;

  RoutineDraft rename(String name) =>
      RoutineDraft(id: id, name: name, entries: entries);

  /// Agrega los ejercicios al final, con sus valores por defecto.
  RoutineDraft addAll(Iterable<Exercise> exercises) => _with([
    ...entries,
    for (final e in exercises) RoutineEntryDraft.defaultsFor(e),
  ]);

  RoutineDraft removeAt(int index) => _with([...entries]..removeAt(index));

  RoutineDraft replaceAt(int index, RoutineEntryDraft entry) =>
      _with([...entries]..[index] = entry);

  /// Reordena con la convención de `ReorderableListView`.
  RoutineDraft move(int oldIndex, int newIndex) =>
      _with(reorderList(entries, oldIndex, newIndex));

  RoutineDraft _with(List<RoutineEntryDraft> entries) =>
      RoutineDraft(id: id, name: name, entries: entries);
}
