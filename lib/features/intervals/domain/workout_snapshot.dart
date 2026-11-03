import '../../../data/db/enums.dart';
import 'interval_workout_draft.dart';
import 'phase_plan.dart';

/// Copia de la estructura que guarda la sesión al empezar
/// (`session.template_snapshot`, R-I13): editar o archivar el entrenamiento
/// después no altera el historial. Incluye las fases expandidas para leer
/// los registros de fase y recuperar la sesión sin la plantilla.
class WorkoutSnapshot {
  const WorkoutSnapshot({required this.workout, required this.phases});

  factory WorkoutSnapshot.of(IntervalWorkoutDraft workout) =>
      WorkoutSnapshot(workout: workout, phases: expandPhases(workout));

  factory WorkoutSnapshot.fromJson(Map<String, Object?> json) =>
      WorkoutSnapshot(
        workout: IntervalWorkoutDraft(
          id: json['workoutId'] as String?,
          name: json['name']! as String,
          prepareSeconds: (json['prepareSeconds']! as num).toInt(),
          blocks: [
            for (final b in json['blocks']! as List<Object?>)
              _nodeFromJson(b! as Map<String, Object?>),
          ],
        ),
        phases: [
          for (final p in json['phases']! as List<Object?>)
            _phaseFromJson(p! as Map<String, Object?>),
        ],
      );

  static const version = 1;

  final IntervalWorkoutDraft workout;
  final List<PlannedPhase> phases;

  Map<String, Object?> toJson() => {
    'kind': 'intervals',
    'version': version,
    'workoutId': workout.id,
    'name': workout.name,
    'prepareSeconds': workout.prepareSeconds,
    'blocks': [for (final b in workout.blocks) _nodeToJson(b)],
    'phases': [for (final p in phases) _phaseToJson(p)],
  };
}

Map<String, Object?> _nodeToJson(IntervalNode n) => switch (n) {
  IntervalStep() => {
    'type': n.type.name,
    'seconds': n.seconds,
    if (n.label != null) 'label': n.label,
  },
  IntervalRepeat() => {
    'rounds': n.rounds,
    'skipLastRest': n.skipLastRest,
    if (n.label != null) 'label': n.label,
    'children': [for (final c in n.children) _nodeToJson(c)],
  },
};

IntervalNode _nodeFromJson(Map<String, Object?> j) => j.containsKey('rounds')
    ? IntervalRepeat(
        (j['rounds']! as num).toInt(),
        [
          for (final c in j['children']! as List<Object?>)
            _nodeFromJson(c! as Map<String, Object?>),
        ],
        skipLastRest: j['skipLastRest'] as bool? ?? true,
        label: j['label'] as String?,
      )
    : IntervalStep(
        PhaseType.values.byName(j['type']! as String),
        (j['seconds']! as num).toInt(),
        label: j['label'] as String?,
      );

Map<String, Object?> _phaseToJson(PlannedPhase p) => {
  'type': p.type.name,
  'seconds': p.seconds,
  if (p.label != null) 'label': p.label,
  if (p.rounds > 0) 'round': p.round,
  if (p.rounds > 0) 'rounds': p.rounds,
  if (p.sets > 0) 'set': p.set,
  if (p.sets > 0) 'sets': p.sets,
};

PlannedPhase _phaseFromJson(Map<String, Object?> j) => PlannedPhase(
  type: PhaseType.values.byName(j['type']! as String),
  seconds: (j['seconds']! as num).toInt(),
  label: j['label'] as String?,
  round: (j['round'] as num?)?.toInt() ?? 0,
  rounds: (j['rounds'] as num?)?.toInt() ?? 0,
  set: (j['set'] as num?)?.toInt() ?? 0,
  sets: (j['sets'] as num?)?.toInt() ?? 0,
);
