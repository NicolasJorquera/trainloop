import '../../../data/db/enums.dart';
import 'interval_workout_draft.dart';

/// Fase concreta de una sesión: lo que el motor nativo cuenta.
class PlannedPhase {
  const PlannedPhase({
    required this.type,
    required this.seconds,
    this.label,
    this.round = 0,
    this.rounds = 0,
    this.set = 0,
    this.sets = 0,
  });

  final PhaseType type;
  final int seconds;
  final String? label;

  /// Ronda dentro de la repetición más interna (0 fuera de repeticiones).
  final int round;
  final int rounds;

  /// Ronda de la repetición externa cuando hay anidamiento (p. ej. serie 2
  /// de 4 con 8 rondas cada una); 0 si no la hay.
  final int set;
  final int sets;

  @override
  bool operator ==(Object other) =>
      other is PlannedPhase &&
      other.type == type &&
      other.seconds == seconds &&
      other.label == label &&
      other.round == round &&
      other.rounds == rounds &&
      other.set == set &&
      other.sets == sets;

  @override
  int get hashCode =>
      Object.hash(type, seconds, label, round, rounds, set, sets);

  @override
  String toString() =>
      'PlannedPhase(${type.name} ${seconds}s r$round/$rounds s$set/$sets)';
}

/// Expande el entrenamiento en la lista de fases que recorre la sesión:
/// preparación (si dura más de 0 s), repeticiones desplegadas y sin el
/// descanso final de la última ronda cuando corresponde (R-I4).
List<PlannedPhase> expandPhases(IntervalWorkoutDraft draft) {
  final out = <PlannedPhase>[
    if (draft.prepareSeconds > 0)
      PlannedPhase(type: PhaseType.prepare, seconds: draft.prepareSeconds),
  ];
  _expand(draft.blocks, out, const _Ctx());
  return out;
}

class _Ctx {
  const _Ctx({this.round = 0, this.rounds = 0, this.set = 0, this.sets = 0});

  final int round;
  final int rounds;
  final int set;
  final int sets;
}

void _expand(List<IntervalNode> nodes, List<PlannedPhase> out, _Ctx ctx) {
  for (final node in nodes) {
    switch (node) {
      case IntervalStep():
        out.add(
          PlannedPhase(
            type: node.type,
            seconds: node.seconds,
            label: node.label,
            round: ctx.round,
            rounds: ctx.rounds,
            set: ctx.set,
            sets: ctx.sets,
          ),
        );
      case IntervalRepeat(:final rounds):
        for (var r = 1; r <= rounds; r++) {
          final children = r == rounds
              ? lastRoundChildren(node)
              : node.children;
          // Dentro de otra repetición, la externa pasa a ser la serie.
          final inner = ctx.rounds > 0
              ? _Ctx(round: r, rounds: rounds, set: ctx.round, sets: ctx.rounds)
              : _Ctx(round: r, rounds: rounds);
          _expand(children, out, inner);
        }
    }
  }
}

/// Totales de un entrenamiento (S02, S03, Inicio).
class WorkoutTotals {
  const WorkoutTotals({
    required this.totalSeconds,
    required this.workSeconds,
    required this.workPhases,
    required this.phaseCount,
  });

  factory WorkoutTotals.of(List<PlannedPhase> phases) => WorkoutTotals(
    totalSeconds: phases.fold(0, (t, p) => t + p.seconds),
    workSeconds: phases
        .where((p) => p.type == PhaseType.work)
        .fold(0, (t, p) => t + p.seconds),
    workPhases: phases.where((p) => p.type == PhaseType.work).length,
    phaseCount: phases.length,
  );

  /// Incluye la preparación: Tabata = 0:10 + 8 × 0:20 + 7 × 0:10 = 4:00.
  final int totalSeconds;
  final int workSeconds;

  /// Rondas = intervalos de trabajo (Tabata: 8).
  final int workPhases;
  final int phaseCount;
}
