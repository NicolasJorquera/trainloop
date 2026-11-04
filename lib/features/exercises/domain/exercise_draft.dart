import '../../../core/units/weight_unit.dart';
import '../../../data/db/app_database.dart';
import '../../../data/db/enums.dart';

/// Ejercicio propio en edición (S09).
class ExerciseDraft {
  const ExerciseDraft({
    this.name = '',
    this.logType = ExerciseLogType.weightReps,
    this.muscle = Muscle.chest,
    this.equipment = Equipment.barbell,
    this.increment,
    this.unit = WeightUnit.kg,
    this.restSeconds = defaultRestSeconds,
  });

  /// Carga un ejercicio existente con el incremento en [unit].
  factory ExerciseDraft.from(Exercise e, WeightUnit unit) => ExerciseDraft(
    name: e.name,
    logType: e.logType,
    muscle: e.primaryMuscle,
    equipment: e.equipment ?? Equipment.other,
    increment: e.incrementValue == null || e.incrementUnit == null
        ? null
        : unit.convertFrom(e.incrementValue!, e.incrementUnit!),
    unit: unit,
    restSeconds: e.defaultRestSeconds ?? defaultRestSeconds,
  );

  /// Ejercicio nuevo: incremento por defecto de 2,5 kg o 5 lb y el
  /// descanso por defecto de Configuración (S16).
  factory ExerciseDraft.initial(
    String name,
    WeightUnit unit, {
    int restSeconds = defaultRestSeconds,
  }) => ExerciseDraft(
    name: name,
    unit: unit,
    increment: unit == WeightUnit.kg ? 2.5 : 5,
    restSeconds: restSeconds,
  );

  static const defaultRestSeconds = 90;
  static const maxNameLength = 40;
  static const maxRestSeconds = 600;

  final String name;
  final ExerciseLogType logType;
  final Muscle muscle;
  final Equipment equipment;

  /// Incremento de peso en [unit]; solo aplica a peso + reps.
  final double? increment;
  final WeightUnit unit;
  final int restSeconds;

  bool get tracksWeight => logType == ExerciseLogType.weightReps;

  bool get hasValidName {
    final n = name.trim();
    return n.isNotEmpty && n.length <= maxNameLength;
  }

  ExerciseDraft copyWith({
    String? name,
    ExerciseLogType? logType,
    Muscle? muscle,
    Equipment? equipment,
    double? Function()? increment,
    int? restSeconds,
  }) => ExerciseDraft(
    name: name ?? this.name,
    logType: logType ?? this.logType,
    muscle: muscle ?? this.muscle,
    equipment: equipment ?? this.equipment,
    increment: increment != null ? increment() : this.increment,
    unit: unit,
    restSeconds: (restSeconds ?? this.restSeconds).clamp(0, maxRestSeconds),
  );
}
