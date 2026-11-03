import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/core/l10n/l10n.dart';
import 'package:trainloop/data/db/enums.dart';
import 'package:trainloop/features/intervals/application/interval_texts.dart';
import 'package:trainloop/features/intervals/domain/interval_templates.dart';
import 'package:trainloop/features/intervals/domain/phase_plan.dart';

/// Voz y textos de la notificación en los 3 idiomas (R-I7).
void main() {
  List<String> speech(String lang, IntervalTemplate t) {
    final l10n = lookupAppLocalizations(Locale(lang));
    final phases = expandPhases(templateWorkout(l10n, t));
    return [for (var i = 0; i < phases.length; i++) cueSpeech(l10n, phases, i)];
  }

  test('Tabata en español, inglés y portugués', () {
    expect(speech('es', IntervalTemplate.tabata).take(3), [
      'Preparación. Sigue: Trabajo',
      'Trabajo, ronda 1 de 8',
      'Descanso. Sigue: Trabajo',
    ]);
    expect(speech('en', IntervalTemplate.tabata).take(3), [
      'Get ready. Next: Work',
      'Work, round 1 of 8',
      'Rest. Next: Work',
    ]);
    expect(speech('pt', IntervalTemplate.tabata).take(3), [
      'Preparação. A seguir: Trabalho',
      'Trabalho, rodada 1 de 8',
      'Descanso. A seguir: Trabalho',
    ]);
    expect(speech('es', IntervalTemplate.tabata).last, 'Trabajo, ronda 8 de 8');
  });

  test('las etiquetas propias reemplazan al tipo (caminar/correr)', () {
    expect(speech('es', IntervalTemplate.walkRun).take(4), [
      'Preparación. Sigue: Caminar',
      'Caminar',
      'Correr, ronda 1 de 6',
      'Caminar. Sigue: Correr',
    ]);
    expect(speech('en', IntervalTemplate.walkRun)[2], 'Run, round 1 of 6');
  });

  test('un trabajo sin rondas solo dice su nombre', () {
    expect(speech('pt', IntervalTemplate.amrap12), [
      'Preparação. A seguir: Trabalho',
      'Trabalho',
    ]);
  });

  test('notificación, nombres de fase y metadatos', () {
    final es = lookupAppLocalizations(const Locale('es'));
    const work = PlannedPhase(
      type: PhaseType.work,
      seconds: 20,
      round: 3,
      rounds: 8,
    );
    expect(notificationTitle(es, work), 'Trabajo · Ronda 3/8');
    expect(
      notificationTitle(
        lookupAppLocalizations(const Locale('en')),
        const PlannedPhase(type: PhaseType.cooldown, seconds: 60),
      ),
      'Cool-down',
    );
    expect(phaseBigLabel(es, work), 'TRABAJO');
    expect(
      phaseBigLabel(
        es,
        const PlannedPhase(type: PhaseType.work, seconds: 5, label: 'Correr'),
      ),
      'CORRER',
    );
    final totals = WorkoutTotals.of(
      expandPhases(templateWorkout(es, IntervalTemplate.tabata)),
    );
    expect(workoutMeta(es, totals), '8 rondas · 4:00');
    expect(es.detailMeta('4:00', 8), '4:00 en total · 8 rondas');
    for (final t in IntervalTemplate.values) {
      expect(templateName(es, t), isNotEmpty);
    }
  });
}
