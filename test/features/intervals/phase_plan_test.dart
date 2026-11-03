import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/data/db/enums.dart';
import 'package:trainloop/features/intervals/domain/interval_templates.dart';
import 'package:trainloop/features/intervals/domain/interval_workout_draft.dart';
import 'package:trainloop/features/intervals/domain/phase_plan.dart';

IntervalWorkoutDraft _template(IntervalTemplate t) =>
    t.build(name: t.key, run: 'Run', walk: 'Walk');

void main() {
  group('expandPhases', () {
    test('Tabata: preparación + 8 trabajos + 7 descansos = 4:00', () {
      final phases = expandPhases(_template(IntervalTemplate.tabata));
      expect(phases, hasLength(16));
      expect(phases.first.type, PhaseType.prepare);
      expect(phases.last.type, PhaseType.work);
      expect(phases.where((p) => p.type == PhaseType.rest), hasLength(7));
      expect(
        phases[1],
        const PlannedPhase(
          type: PhaseType.work,
          seconds: 20,
          round: 1,
          rounds: 8,
        ),
      );
      expect(phases.last.round, 8);
      final totals = WorkoutTotals.of(phases);
      expect(totals.totalSeconds, 240);
      expect(totals.workSeconds, 160);
      expect(totals.workPhases, 8);
    });

    test('sin omitir el último descanso, la última ronda lo conserva', () {
      const draft = IntervalWorkoutDraft(
        prepareSeconds: 0,
        blocks: [
          IntervalRepeat(2, [
            IntervalStep(PhaseType.work, 20),
            IntervalStep(PhaseType.rest, 10),
          ], skipLastRest: false),
        ],
      );
      final phases = expandPhases(draft);
      expect(phases.map((p) => p.type), [
        PhaseType.work,
        PhaseType.rest,
        PhaseType.work,
        PhaseType.rest,
      ]);
      expect(WorkoutTotals.of(phases).totalSeconds, 60);
    });

    test('preparación de 0 s no genera fase', () {
      final phases = expandPhases(
        _template(IntervalTemplate.amrap12).withPrepare(0),
      );
      expect(phases.single.type, PhaseType.work);
      expect(phases.single.round, 0);
    });

    test('anidamiento: 2 series × 3 rondas con descanso entre series', () {
      const draft = IntervalWorkoutDraft(
        prepareSeconds: 5,
        blocks: [
          IntervalStep(PhaseType.warmup, 60),
          IntervalRepeat(2, [
            IntervalRepeat(3, [
              IntervalStep(PhaseType.work, 20),
              IntervalStep(PhaseType.rest, 10),
            ]),
            IntervalStep(PhaseType.rest, 60, label: 'Entre series'),
          ]),
          IntervalStep(PhaseType.cooldown, 120),
        ],
      );
      final phases = expandPhases(draft);
      // prep, warm, [w r w r w] rest60, [w r w r w], cool (sin el último
      // descanso entre series).
      expect(phases, hasLength(1 + 1 + 5 + 1 + 5 + 1));
      final works = phases.where((p) => p.type == PhaseType.work).toList();
      expect(works, hasLength(6));
      expect(
        [for (final w in works) (w.set, w.round)],
        [(1, 1), (1, 2), (1, 3), (2, 1), (2, 2), (2, 3)],
      );
      expect(works.first.sets, 2);
      expect(works.first.rounds, 3);
      final between = phases.firstWhere((p) => p.label == 'Entre series');
      expect((between.round, between.rounds, between.set), (1, 2, 0));
      expect(phases.where((p) => p.label == 'Entre series'), hasLength(1));
      expect(
        WorkoutTotals.of(phases).totalSeconds,
        5 + 60 + 2 * (3 * 20 + 2 * 10) + 60 + 120,
      );
    });

    test('repeatSeconds coincide con la suma de las fases expandidas', () {
      for (final t in IntervalTemplate.values) {
        final draft = _template(t);
        final expected =
            draft.prepareSeconds +
            draft.blocks.fold(
              0,
              (s, n) =>
                  s +
                  switch (n) {
                    IntervalStep(:final seconds) => seconds,
                    IntervalRepeat() => repeatSeconds(n),
                  },
            );
        expect(
          WorkoutTotals.of(expandPhases(draft)).totalSeconds,
          expected,
          reason: t.key,
        );
      }
    });
  });

  group('catálogo de plantillas', () {
    test('totales y rondas de cada plantilla', () {
      final totals = {
        for (final t in IntervalTemplate.values)
          t: WorkoutTotals.of(expandPhases(_template(t))),
      };
      String fmt(int s) => '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';
      expect(
        {
          for (final e in totals.entries)
            e.key.key: '${e.value.workPhases}×${fmt(e.value.totalSeconds)}',
        },
        {
          'tabata': '8×4:00',
          'hiit_40_20': '12×11:50',
          'emom_10': '10×10:10',
          'walk_run': '6×28:00',
          'hiit_30_30': '10×9:40',
          'amrap_12': '1×12:10',
        },
      );
    });

    test('claves únicas, Inicio muestra 4 y el origen se resuelve', () {
      final keys = IntervalTemplate.values.map((t) => t.key).toSet();
      expect(keys, hasLength(IntervalTemplate.values.length));
      expect(IntervalTemplate.quickStart, hasLength(4));
      expect(IntervalTemplate.quickStart.first, IntervalTemplate.tabata);
      expect(
        IntervalTemplate.bySourceId('template:emom_10'),
        IntervalTemplate.emom10,
      );
      expect(IntervalTemplate.bySourceId('uuid-123'), isNull);
      expect(IntervalTemplate.bySourceId(null), isNull);
    });

    test('todas las plantillas son válidas y caminar/correr usa etiquetas', () {
      for (final t in IntervalTemplate.values) {
        expect(_template(t).errors, isEmpty, reason: t.key);
      }
      final labels = expandPhases(
        _template(IntervalTemplate.walkRun),
      ).map((p) => p.label).toSet();
      expect(labels, {null, 'Run', 'Walk'});
    });
  });

  group('validación y edición (R-I1, R-I3)', () {
    test('sin trabajo, repetición vacía, más de 2 niveles y más de 4 h', () {
      expect(
        const IntervalWorkoutDraft(
          blocks: [IntervalStep(PhaseType.rest, 30)],
        ).errors,
        [IntervalDraftError.noWork],
      );
      expect(
        const IntervalWorkoutDraft(
          blocks: [IntervalStep(PhaseType.work, 30), IntervalRepeat(2, [])],
        ).errors,
        [IntervalDraftError.emptyRepeat],
      );
      expect(
        const IntervalWorkoutDraft(
          blocks: [
            IntervalRepeat(2, [
              IntervalRepeat(2, [
                IntervalRepeat(2, [IntervalStep(PhaseType.work, 5)]),
              ]),
            ]),
          ],
        ).errors,
        [IntervalDraftError.tooDeep],
      );
      expect(
        const IntervalWorkoutDraft(
          blocks: [
            IntervalRepeat(99, [IntervalStep(PhaseType.work, 300)]),
          ],
        ).errors,
        [IntervalDraftError.tooLong],
      );
    });

    test('límites: intervalo 1 s a 99:59, rondas 1–99, preparación 0–30', () {
      const step = IntervalStep(PhaseType.work, 20);
      expect(step.copyWith(seconds: 0).seconds, 1);
      expect(step.copyWith(seconds: 10000).seconds, 5999);
      const r = IntervalRepeat(8, [step]);
      expect(r.copyWith(rounds: 0).rounds, 1);
      expect(r.copyWith(rounds: 120).rounds, 99);
      final d = IntervalWorkoutDraft.starter();
      expect(d.withPrepare(45).prepareSeconds, 30);
      expect(d.withPrepare(-1).prepareSeconds, 0);
    });

    test('editar por ruta: reemplazar, agregar, mover y quitar', () {
      var d = IntervalWorkoutDraft.starter();
      d = d.replaceAt([0, 0], const IntervalStep(PhaseType.work, 45));
      expect((d.nodeAt([0, 0]) as IntervalStep).seconds, 45);
      d = d.append([0], const IntervalStep(PhaseType.rest, 60, label: 'x'));
      expect((d.nodeAt([0]) as IntervalRepeat).children, hasLength(3));
      d = d.append(null, const IntervalStep(PhaseType.cooldown, 120));
      d = d.move([1], -1);
      expect(d.blocks.first, const IntervalStep(PhaseType.cooldown, 120));
      d = d.move([1, 2], -2);
      expect((d.nodeAt([1, 0]) as IntervalStep).label, 'x');
      d = d.removeAt([0]);
      expect(d.blocks.single, isA<IntervalRepeat>());
    });
  });
}
