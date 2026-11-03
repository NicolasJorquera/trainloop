import '../../../data/db/enums.dart';
import 'interval_workout_draft.dart';

/// Plantillas incluidas (F-03). Viven en el código, como la biblioteca de
/// ejercicios: el nombre visible sale de l10n y la sesión guarda
/// `template:<key>` como origen. Nunca cambies ni reutilices una clave.
enum IntervalTemplate {
  tabata('tabata'),
  hiit4020('hiit_40_20'),
  emom10('emom_10'),
  walkRun('walk_run'),
  hiit3030('hiit_30_30'),
  amrap12('amrap_12');

  const IntervalTemplate(this.key);

  final String key;

  /// Las 4 de Inicio, en orden (Main: Tabata, HIIT, EMOM y carrera).
  static const quickStart = [tabata, hiit4020, emom10, walkRun];

  static const _prefix = 'template:';

  /// Id de origen que guarda la sesión.
  String get sourceId => '$_prefix$key';

  static IntervalTemplate? byKey(String key) {
    for (final t in values) {
      if (t.key == key) return t;
    }
    return null;
  }

  /// Plantilla de un `templateId` de sesión, o `null` si es un entrenamiento
  /// propio.
  static IntervalTemplate? bySourceId(String? id) =>
      id != null && id.startsWith(_prefix)
      ? byKey(id.substring(_prefix.length))
      : null;

  /// Estructura con el nombre y las etiquetas en el idioma activo.
  /// [run] y [walk] etiquetan la plantilla de caminar/correr.
  IntervalWorkoutDraft build({
    required String name,
    required String run,
    required String walk,
  }) {
    IntervalRepeat repeat(int rounds, int work, int rest) =>
        IntervalRepeat(rounds, [
          IntervalStep(PhaseType.work, work),
          if (rest > 0) IntervalStep(PhaseType.rest, rest),
        ]);
    final blocks = switch (this) {
      // 0:10 + 8 × 0:20 + 7 × 0:10 = 4:00 en total (sin el último descanso).
      tabata => [repeat(8, 20, 10)],
      hiit4020 => [repeat(12, 40, 20)],
      hiit3030 => [repeat(10, 30, 30)],
      emom10 => [repeat(10, 60, 0)],
      amrap12 => const [IntervalStep(PhaseType.work, 12 * 60)],
      // 5:00 + 6 × (2:00 + 1:30) − 1:30 + 3:20 + 0:10 = 28:00.
      walkRun => [
        IntervalStep(PhaseType.warmup, 5 * 60, label: walk),
        IntervalRepeat(6, [
          IntervalStep(PhaseType.work, 120, label: run),
          IntervalStep(PhaseType.rest, 90, label: walk),
        ]),
        IntervalStep(PhaseType.cooldown, 200, label: walk),
      ],
    };
    return IntervalWorkoutDraft(name: name, blocks: blocks);
  }
}
