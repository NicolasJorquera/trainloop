import '../../../data/db/app_database.dart';
import '../../../data/db/enums.dart';
import '../../strength/domain/strength_rules.dart';

// Récords personales (PRD, flujo 3, R-P3), sin Flutter ni base: se prueban
// solos. Se recalculan desde cero con todas las series del ejercicio en el
// historial, en orden cronológico; la tabla personal_record es su caché.

/// Serie hecha que entra al cálculo, con la hora de inicio de su sesión.
class RecordSet {
  const RecordSet({required this.set, required this.sessionStartedAt});

  final SetLog set;
  final DateTime sessionStartedAt;

  String get sessionId => set.sessionId;
}

/// Récord vigente de un ejercicio. [weightGrams] identifica el peso en
/// [RecordType.maxReps] (0 en los demás tipos y en peso corporal).
class ComputedRecord {
  const ComputedRecord({
    required this.type,
    required this.value,
    required this.sessionId,
    required this.achievedAt,
    this.weightGrams = 0,
    this.reps,
    this.previousValue,
  });

  final RecordType type;

  /// Gramos (peso, 1RM, volumen), repeticiones, segundos o metros.
  final double value;
  final String sessionId;
  final DateTime achievedAt;
  final int weightGrams;

  /// Repeticiones de la serie que lo logró (peso máximo y 1RM).
  final int? reps;

  /// Lo que superó; `null` si fue la primera marca de ese tipo.
  final double? previousValue;

  /// Superó una marca anterior: se destaca como récord nuevo. La primera
  /// vez que se hace un ejercicio (o un peso) no se destaca.
  bool get isNew => previousValue != null;

  String get key => '${type.name}:$weightGrams';

  @override
  String toString() =>
      'ComputedRecord(${type.name}${weightGrams > 0 ? '@$weightGrams' : ''} '
      '= $value, session $sessionId, prev $previousValue)';
}

/// La serie cuenta para récords: hecha y no de calentamiento (R-G6).
bool countsForRecords(SetLog s) => s.completed && s.setType != SetType.warmup;

/// Calcula los récords vigentes de un ejercicio de tipo [logType] a partir
/// de sus series en el historial.
///
/// - Peso máximo: la serie más pesada con al menos 1 repetición (a igual
///   peso, la de más repeticiones).
/// - 1RM estimado: Epley con la mejor serie de 1 a 12 repeticiones.
/// - Más repeticiones con un peso dado: uno por peso (0 = peso corporal).
/// - Mayor volumen en una sesión: Σ peso × reps de las series del ejercicio
///   en la sesión, sin calentamiento.
/// - Mayor duración y mayor distancia de una serie (tiempo y distancia).
///
/// Un récord cambia solo si una sesión posterior lo supera estrictamente;
/// [ComputedRecord.previousValue] es el mejor valor antes de esa sesión.
List<ComputedRecord> computeRecords(
  ExerciseLogType logType,
  Iterable<RecordSet> sets,
) {
  final bySession = <String, List<RecordSet>>{};
  for (final s in sets) {
    if (!countsForRecords(s.set)) continue;
    (bySession[s.sessionId] ??= []).add(s);
  }
  final sessions = bySession.values.toList()
    ..sort(
      (a, b) => a.first.sessionStartedAt.compareTo(b.first.sessionStartedAt),
    );

  final best = <String, ComputedRecord>{};
  for (final list in sessions) {
    final sessionId = list.first.sessionId;
    final at = list.first.sessionStartedAt;
    final today = <String, ComputedRecord>{};

    void offer(RecordType type, double value, {int weight = 0, int? reps}) {
      if (value <= 0) return;
      final key = '${type.name}:$weight';
      final current = today[key];
      final better =
          current == null ||
          value > current.value + 1e-9 ||
          // A igual peso máximo, la serie con más repeticiones.
          (type == RecordType.maxWeight &&
              (value - current.value).abs() < 1e-9 &&
              (reps ?? 0) > (current.reps ?? 0));
      if (!better) return;
      today[key] = ComputedRecord(
        type: type,
        value: value,
        sessionId: sessionId,
        achievedAt: at,
        weightGrams: weight,
        reps: reps,
      );
    }

    var volume = 0;
    for (final r in list) {
      final s = r.set;
      final grams = s.weightGrams ?? 0;
      final reps = s.reps ?? 0;
      if (logType.tracksWeight && grams > 0 && reps >= 1) {
        offer(RecordType.maxWeight, grams.toDouble(), reps: reps);
        final rm = estimatedOneRmGrams(grams, reps);
        if (rm != null) offer(RecordType.estimatedOneRm, rm, reps: reps);
      }
      if (logType.tracksReps && reps >= 1) {
        offer(RecordType.maxReps, reps.toDouble(), weight: grams);
      }
      if (logType.tracksWeight) volume += grams * reps;
      final d = s.durationSeconds ?? 0;
      if (logType.tracksTime && d > 0) {
        offer(RecordType.maxDuration, d.toDouble());
      }
      final m = s.distanceMeters ?? 0;
      if (m > 0) offer(RecordType.maxDistance, m);
    }
    if (volume > 0) offer(RecordType.maxSessionVolume, volume.toDouble());

    for (final MapEntry(:key, value: candidate) in today.entries) {
      final before = best[key];
      if (before != null && candidate.value <= before.value + 1e-9) {
        // Igualar no es récord; con el mismo peso máximo, más reps tampoco
        // cambia el récord de peso (sí el de reps con ese peso).
        continue;
      }
      best[key] = ComputedRecord(
        type: candidate.type,
        value: candidate.value,
        sessionId: candidate.sessionId,
        achievedAt: candidate.achievedAt,
        weightGrams: candidate.weightGrams,
        reps: candidate.reps,
        previousValue: before?.value,
      );
    }
  }
  final out = best.values.toList()
    ..sort((a, b) {
      final t = a.type.index.compareTo(b.type.index);
      return t != 0 ? t : a.weightGrams.compareTo(b.weightGrams);
    });
  return out;
}
