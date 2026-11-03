import '../../../core/units/weight_unit.dart';
import '../../../data/db/app_database.dart';
import '../../../data/db/enums.dart';

// Reglas de la sesión de fuerza (PRD, flujo 2: R-G2 a R-G8 y R-G12), sin
// Flutter ni base: se prueban solas.

/// Descanso global cuando ni la rutina ni la biblioteca lo definen (R-G8).
const defaultRestSeconds = 90;

/// Paso de los botones ±15 s del descanso (F-09).
const restStepSeconds = 15;

/// Límites de una serie (R-G4).
abstract final class SetLimits {
  static const maxWeightKg = 1000.0;
  static const weightStep = 0.25;
  static const maxReps = 999;
  static const minRpe = 6.0;
  static const maxRpe = 10.0;
  static const rpeStep = 0.5;
  static const maxDurationSeconds = 99 * 60 + 59;

  /// Valores de RPE que ofrece S11: 6, 6,5 … 10.
  static final rpeValues = [for (var v = minRpe; v <= maxRpe; v += rpeStep) v];
}

/// Incremento por defecto de los botones ± del peso: 2,5 kg o 5 lb (R-G3).
double defaultIncrement(WeightUnit unit) => switch (unit) {
  WeightUnit.kg => 2.5,
  WeightUnit.lb => 5,
};

/// Incremento del ejercicio expresado en [unit]: el que define el ejercicio
/// o el de por defecto. Si la persona usa otra unidad que la del ejercicio,
/// se usa el de por defecto de su unidad (2,5 kg no son 5,51 lb útiles).
double incrementFor(Exercise exercise, WeightUnit unit) {
  final value = exercise.incrementValue;
  final from = exercise.incrementUnit;
  if (value == null || value <= 0 || from == null || from != unit) {
    return defaultIncrement(unit);
  }
  return value;
}

/// Duración del descanso de un ejercicio: la de la rutina → la de la
/// biblioteca → 90 s (R-G8).
int restSecondsFor({int? routineRest, int? libraryRest}) =>
    routineRest ?? libraryRest ?? defaultRestSeconds;

/// Valores de una serie: registrada, objetivo o propuesta.
class SetValues {
  const SetValues({
    this.weight,
    this.unit,
    this.reps,
    this.durationSeconds,
    this.rpe,
    this.type = SetType.normal,
  });

  factory SetValues.ofLog(SetLog log) => SetValues(
    weight: log.weightValue,
    unit: log.weightUnit,
    reps: log.reps,
    durationSeconds: log.durationSeconds,
    rpe: log.rpe,
    type: log.setType,
  );

  /// Peso en [unit] (0 = peso corporal).
  final double? weight;
  final WeightUnit? unit;
  final int? reps;
  final int? durationSeconds;
  final double? rpe;
  final SetType type;

  bool get isEmpty => weight == null && reps == null && durationSeconds == null;

  /// Peso expresado en [target] (la unidad de la persona), o `null`.
  double? weightIn(WeightUnit target) {
    final w = weight;
    if (w == null) return null;
    return roundWeight(target.convertFrom(w, unit ?? target));
  }

  int? get grams {
    final w = weight;
    return w == null ? null : (unit ?? WeightUnit.kg).toGrams(w);
  }

  SetValues copyWith({
    double? Function()? weight,
    WeightUnit? unit,
    int? Function()? reps,
    int? Function()? durationSeconds,
    double? Function()? rpe,
    SetType? type,
  }) => SetValues(
    weight: weight != null ? weight() : this.weight,
    unit: unit ?? this.unit,
    reps: reps != null ? reps() : this.reps,
    durationSeconds: durationSeconds != null
        ? durationSeconds()
        : this.durationSeconds,
    rpe: rpe != null ? rpe() : this.rpe,
    type: type ?? this.type,
  );

  @override
  bool operator ==(Object other) =>
      other is SetValues &&
      other.weight == weight &&
      other.unit == unit &&
      other.reps == reps &&
      other.durationSeconds == durationSeconds &&
      other.rpe == rpe &&
      other.type == type;

  @override
  int get hashCode =>
      Object.hash(weight, unit, reps, durationSeconds, rpe, type);

  @override
  String toString() =>
      'SetValues($weight $unit × $reps, ${durationSeconds}s, rpe $rpe, '
      '${type.name})';
}

/// Redondea un peso convertido a 2 decimales (45,359… kg → 45,36).
double roundWeight(double value) => (value * 100).roundToDouble() / 100;

/// Valores propuestos para la serie [index] (R-G2): la serie con el mismo
/// número del mismo ejercicio en la última sesión → el objetivo de la rutina
/// (lo que guarda la serie sin completar) → vacío. El tipo de serie es
/// siempre el de la sesión (un calentamiento sigue siéndolo).
SetValues proposeSet({
  required int index,
  required List<SetLog> previous,
  required SetValues target,
}) {
  final last = index < previous.length ? previous[index] : null;
  if (last != null) {
    return SetValues.ofLog(last).copyWith(type: target.type, rpe: () => null);
  }
  return target.copyWith(rpe: () => null);
}

/// Lo que registra cada tipo de ejercicio (R-G5).
extension ExerciseFields on ExerciseLogType {
  bool get tracksWeight => this == ExerciseLogType.weightReps;
  bool get tracksReps =>
      this == ExerciseLogType.weightReps || this == ExerciseLogType.reps;
  bool get tracksTime =>
      this == ExerciseLogType.time ||
      this == ExerciseLogType.timeDistance ||
      this == ExerciseLogType.distance;
}

/// La serie tiene lo necesario para guardarla con 1 toque: peso y reps (o
/// solo reps, o tiempo, según el tipo). Un peso de 0 vale (peso corporal).
bool canLogDirectly(ExerciseLogType type, SetValues v) {
  if (type.tracksWeight && v.weight == null) return false;
  if (type.tracksReps && v.reps == null) return false;
  if (type.tracksTime && v.durationSeconds == null) return false;
  return true;
}

/// Errores de validación de una serie (R-G4).
enum SetError { weightRange, weightStep, repsRange, rpeRange, durationRange }

/// Valida [v] para un ejercicio de tipo [type]. Lista vacía = válida.
List<SetError> validateSet(ExerciseLogType type, SetValues v) {
  final errors = <SetError>[];
  final w = v.weight;
  if (type.tracksWeight && w != null) {
    final kg = WeightUnit.kg.convertFrom(w, v.unit ?? WeightUnit.kg);
    if (w < 0 || kg > SetLimits.maxWeightKg + 1e-6) {
      errors.add(SetError.weightRange);
    } else if (((w / SetLimits.weightStep) - (w / SetLimits.weightStep).round())
            .abs() >
        1e-6) {
      errors.add(SetError.weightStep);
    }
  }
  final reps = v.reps;
  if (type.tracksReps &&
      reps != null &&
      (reps < 0 || reps > SetLimits.maxReps)) {
    errors.add(SetError.repsRange);
  }
  final rpe = v.rpe;
  if (rpe != null &&
      (rpe < SetLimits.minRpe ||
          rpe > SetLimits.maxRpe ||
          (rpe * 2).roundToDouble() != rpe * 2)) {
    errors.add(SetError.rpeRange);
  }
  final d = v.durationSeconds;
  if (type.tracksTime &&
      d != null &&
      (d < 0 || d > SetLimits.maxDurationSeconds)) {
    errors.add(SetError.durationRange);
  }
  return errors;
}

/// Volumen en gramos: Σ peso × reps de las series completadas, sin el
/// calentamiento; peso corporal = 0 (R-G6, flujo 3).
int volumeGrams(Iterable<SetLog> sets) => sets
    .where((s) => s.completed && s.setType != SetType.warmup)
    .fold(0, (t, s) => t + (s.weightGrams ?? 0) * (s.reps ?? 0));

/// 1RM estimado (Epley) en gramos, solo con 1 a 12 repeticiones; con 1
/// repetición es el peso levantado.
double? estimatedOneRmGrams(int? grams, int? reps) {
  if (grams == null || reps == null || reps < 1 || reps > 12) return null;
  if (reps == 1) return grams.toDouble();
  return grams * (1 + reps / 30);
}

/// Mejor serie de un ejercicio en la sesión que supera lo hecho antes
/// (récord del día). Calentamiento y peso corporal no cuentan.
class DayRecord {
  const DayRecord({
    required this.exercise,
    required this.set,
    required this.weightRecord,
    this.oneRmGrams,
  });

  final Exercise exercise;
  final SetLog set;

  /// `true` si el peso es el mayor levantado; si no, solo mejora el 1RM.
  final bool weightRecord;
  final double? oneRmGrams;
}

/// Récord simple del día para un ejercicio: peso máximo o 1RM estimado
/// mayores que en todo el historial anterior. Sin historial no hay récord
/// (la primera vez no se compara con nada).
DayRecord? dayRecordFor(
  Exercise exercise,
  Iterable<SetLog> sessionSets,
  Iterable<SetLog> historySets,
) {
  bool counts(SetLog s) =>
      s.completed &&
      s.setType != SetType.warmup &&
      (s.weightGrams ?? 0) > 0 &&
      (s.reps ?? 0) > 0;
  final before = historySets.where(counts).toList();
  final today = sessionSets.where(counts).toList();
  if (before.isEmpty || today.isEmpty) return null;

  int maxGrams(List<SetLog> l) =>
      l.map((s) => s.weightGrams!).reduce((a, b) => a > b ? a : b);
  double maxRm(List<SetLog> l) => l
      .map((s) => estimatedOneRmGrams(s.weightGrams, s.reps) ?? 0)
      .reduce((a, b) => a > b ? a : b);

  final best = today.reduce((a, b) {
    final ra = estimatedOneRmGrams(a.weightGrams, a.reps) ?? 0;
    final rb = estimatedOneRmGrams(b.weightGrams, b.reps) ?? 0;
    if (a.weightGrams != b.weightGrams) {
      return a.weightGrams! >= b.weightGrams! ? a : b;
    }
    return ra >= rb ? a : b;
  });
  final weightRecord = maxGrams(today) > maxGrams(before);
  final todayRm = maxRm(today);
  final rmRecord = todayRm > 0 && todayRm > maxRm(before) + 0.5;
  if (!weightRecord && !rmRecord) return null;
  final bestRmSet = today.reduce(
    (a, b) =>
        (estimatedOneRmGrams(a.weightGrams, a.reps) ?? 0) >=
            (estimatedOneRmGrams(b.weightGrams, b.reps) ?? 0)
        ? a
        : b,
  );
  final shown = weightRecord ? best : bestRmSet;
  return DayRecord(
    exercise: exercise,
    set: shown,
    weightRecord: weightRecord,
    oneRmGrams: estimatedOneRmGrams(shown.weightGrams, shown.reps),
  );
}

/// Estructura de una sesión o rutina para comparar (R-G12): ejercicios en
/// orden con su número de series.
typedef StructureEntry = ({String exerciseId, int sets});

/// La estructura cambió frente a la rutina (ejercicios o número de series).
bool structureChanged(List<StructureEntry> routine, List<StructureEntry> now) {
  if (routine.length != now.length) return true;
  for (var i = 0; i < routine.length; i++) {
    if (routine[i].exerciseId != now[i].exerciseId ||
        routine[i].sets != now[i].sets) {
      return true;
    }
  }
  return false;
}
