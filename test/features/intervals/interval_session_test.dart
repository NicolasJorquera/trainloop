import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/core/l10n/l10n.dart';
import 'package:trainloop/core/theme/accent.dart';
import 'package:trainloop/core/theme/phase_colors.dart';
import 'package:trainloop/data/db/app_database.dart';
import 'package:trainloop/data/db/database_providers.dart';
import 'package:trainloop/data/db/enums.dart';
import 'package:trainloop/features/intervals/application/interval_providers.dart';
import 'package:trainloop/features/intervals/application/interval_session_controller.dart';
import 'package:trainloop/features/intervals/data/interval_workout_repository.dart';
import 'package:trainloop/features/intervals/domain/interval_templates.dart';
import 'package:trainloop/features/intervals/domain/interval_workout_draft.dart';
import 'package:trainloop/features/settings/domain/app_settings.dart';
import 'package:trainloop/platform/timer_engine_client.dart';

import '../../helpers/fake_timer_engine.dart';
import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late FakeTimerEngine engine;
  late ProviderContainer container;
  final l10n = lookupAppLocalizations(const Locale('es'));
  final tabata = IntervalTemplate.tabata.build(
    name: 'Tabata 20/10',
    run: 'Correr',
    walk: 'Caminar',
  );

  setUp(() {
    db = openTestDatabase();
    engine = FakeTimerEngine();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        timerEngineClientProvider.overrideWithValue(engine),
      ],
    );
    // Activa el controlador (se suscribe a los estados del motor).
    container.listen(intervalSessionProvider, (_, _) {});
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  IntervalSessionController controller() =>
      container.read(intervalSessionProvider.notifier);

  Future<String> start() => controller().start(
    tabata,
    sourceId: IntervalTemplate.tabata.sourceId,
    l10n: l10n,
    settings: const AppSettings(),
    palette: phasePaletteFor(AccentPreset.orquidea),
    localeTag: 'es-419',
  );

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('empezar guarda la copia y envía el programa localizado', () async {
    final id = await start();
    final session = (await db.sessionsDao.findById(id))!;
    expect(session.kind, SessionKind.intervals);
    expect(session.status, SessionStatus.inProgress);
    expect(session.templateId, 'template:tabata');
    expect(session.templateSnapshot!['name'], 'Tabata 20/10');
    expect(session.templateSnapshot!['phases'], hasLength(16));

    final program = engine.program!;
    expect(program.sessionId, id);
    expect(program.locale, 'es-419');
    expect(program.phases, hasLength(16));
    expect(program.phases.fold(0, (t, p) => t + p.durationMs), 240000);
    expect(program.phases[1].title, 'Trabajo · Ronda 1/8');
    expect(program.phases[0].speech, 'Preparación. Sigue: Trabajo');
    expect(program.phases[1].speech, 'Trabajo, ronda 1 de 8');
    expect(program.strings['pause'], 'Pausar');
    expect(
      program.phases[1].color,
      AccentPreset.orquidea.swatch.dark.toARGB32(),
    );
    expect(container.read(intervalSessionProvider)!.active, isTrue);
  });

  test(
    'cada fase cerrada se guarda una vez y al terminar queda completada',
    () async {
      final id = await start();
      engine.emit(
        engineState(
          id,
          index: 1,
          results: [phaseResult(0, 10000, actualMs: 10002)],
        ),
      );
      await settle();
      // Reenviar el mismo resultado no duplica.
      engine.emit(
        engineState(
          id,
          index: 1,
          results: [phaseResult(0, 10000, actualMs: 10002)],
        ),
      );
      await settle();
      var logs = await db.sessionsDao.phasesOf(id);
      expect(logs, hasLength(1));
      expect(logs.single.phaseType, PhaseType.prepare);
      expect(logs.single.actualSeconds, 10);
      expect((await db.sessionsDao.findById(id))!.checkpointPhaseIndex, 1);

      final all = [
        for (var i = 0; i < 16; i++)
          phaseResult(
            i,
            i == 0 ? 10000 : (i.isOdd ? 20000 : 10000),
            skipped: i == 3,
          ),
      ];
      engine.emit(
        engineState(
          id,
          state: EngineRunState.finished,
          index: 16,
          pausedMs: 4200,
          results: all,
        ),
      );
      await settle();
      await settle();
      logs = await db.sessionsDao.phasesOf(id);
      expect(logs, hasLength(16));
      expect(logs.where((l) => l.skipped), hasLength(1));
      expect(logs[1].round, 1);
      expect(logs.last.round, 8);
      final session = (await db.sessionsDao.findById(id))!;
      expect(session.status, SessionStatus.completed);
      expect(session.pausedSeconds, 4);
      expect(session.endedAt, isNotNull);
      expect(engine.calls, contains('clear'));
      expect(container.read(intervalSessionProvider)!.saved, isTrue);
    },
  );

  test(
    'detener antes del final deja la sesión incompleta y quita fases a las que se volvió',
    () async {
      final id = await start();
      engine.emit(
        engineState(
          id,
          index: 3,
          results: [
            phaseResult(0, 10000),
            phaseResult(1, 20000),
            phaseResult(2, 10000),
          ],
        ),
      );
      await settle();
      expect(await db.sessionsDao.phasesOf(id), hasLength(3));
      // Volvió a la fase 2 y detuvo: la 2 queda parcial y no hay fase 3.
      engine.emit(
        engineState(
          id,
          state: EngineRunState.stopped,
          index: 16,
          results: [
            phaseResult(0, 10000),
            phaseResult(1, 20000, actualMs: 5000),
          ],
        ),
      );
      await settle();
      await settle();
      final logs = await db.sessionsDao.phasesOf(id);
      expect(logs.map((l) => l.sortOrder), [0, 1]);
      expect(logs.last.actualSeconds, 5);
      expect(
        (await db.sessionsDao.findById(id))!.status,
        SessionStatus.incomplete,
      );
    },
  );

  group('recuperación (F-16)', () {
    Future<String> killed() async {
      final id = await start();
      engine.live = null;
      engine.pendingState = engineState(
        id,
        index: 5,
        positionMs: 75000,
        activeMs: 75000,
        pausedMs: 3000,
        results: [for (var i = 0; i < 5; i++) phaseResult(i, 10000)],
        savedAt: DateTime(2026, 11, 3, 7, 12),
      );
      // La app se vuelve a abrir: el controlador empieza sin sesión.
      container.invalidate(intervalSessionProvider);
      container.listen(intervalSessionProvider, (_, _) {});
      return id;
    }

    test(
      'al abrir, la sesión queda pendiente con su avance guardado',
      () async {
        final id = await killed();
        final offer = (await controller().syncOnLaunch())!;
        expect(offer.sessionId, id);
        expect(offer.engine.index, 5);
        final session = (await db.sessionsDao.findById(id))!;
        expect(session.status, SessionStatus.recoveryPending);
        expect(session.checkpointPhaseIndex, 5);
        expect(session.checkpointElapsedMs, 75000);
        expect(session.pausedSeconds, 3);
        expect(await db.sessionsDao.phasesOf(id), hasLength(5));
      },
    );

    test('reanudar la deja en curso y en pausa en el motor', () async {
      final id = await killed();
      final offer = (await controller().syncOnLaunch())!;
      await controller().resumeRecovered(offer);
      expect(engine.calls.last, 'restore');
      expect(
        (await db.sessionsDao.findById(id))!.status,
        SessionStatus.inProgress,
      );
      final active = container.read(intervalSessionProvider)!;
      expect(active.engine.state, EngineRunState.paused);
      expect(active.engine.index, 5);
      // Fase 5 (trabajo, 2.ª ronda) termina en 90 s: faltan 15 s.
      expect(active.engine.remainingMs, 15000);
    });

    test(
      'guardar como incompleta o descartar cierran y borran el punto',
      () async {
        var id = await killed();
        var offer = (await controller().syncOnLaunch())!;
        await controller().saveRecoveredAsIncomplete(offer);
        expect(
          (await db.sessionsDao.findById(id))!.status,
          SessionStatus.incomplete,
        );
        expect(engine.pendingState, isNull);

        id = await killed();
        offer = (await controller().syncOnLaunch())!;
        await controller().discardRecovered(offer);
        expect(
          (await db.sessionsDao.findById(id))!.status,
          SessionStatus.discarded,
        );
        expect(engine.calls.where((c) => c == 'clear'), hasLength(2));
      },
    );

    test(
      'una sesión que terminó sin interfaz se guarda sin preguntar',
      () async {
        final id = await start();
        engine.live = null;
        engine.pendingState = engineState(
          id,
          state: EngineRunState.finished,
          index: 16,
          results: [for (var i = 0; i < 16; i++) phaseResult(i, 10000)],
        );
        expect(await controller().syncOnLaunch(), isNull);
        expect(
          (await db.sessionsDao.findById(id))!.status,
          SessionStatus.completed,
        );
        expect(await db.sessionsDao.phasesOf(id), hasLength(16));
      },
    );
  });

  test(
    'el repositorio guarda, copia, archiva y recupera la estructura',
    () async {
      final repo = IntervalWorkoutRepository(db);
      const draft = IntervalWorkoutDraft(
        name: '',
        prepareSeconds: 5,
        blocks: [
          IntervalStep(PhaseType.warmup, 300),
          IntervalRepeat(4, [
            IntervalRepeat(8, [
              IntervalStep(PhaseType.work, 20, label: 'Burpees'),
              IntervalStep(PhaseType.rest, 10),
            ]),
            IntervalStep(PhaseType.rest, 60),
          ], skipLastRest: false),
        ],
      );
      final id = await repo.save(draft, fallbackName: 'Intervalos 3 nov');
      final loaded = (await repo.load(id))!;
      expect(loaded.name, 'Intervalos 3 nov');
      expect(loaded.prepareSeconds, 5);
      expect(loaded.blocks, draft.blocks);

      final copy = await repo.duplicate(id, name: 'Copia');
      expect((await repo.load(copy))!.blocks, draft.blocks);
      expect((await repo.watchSummaries().first).map((s) => s.workout.name), [
        'Copia',
        'Intervalos 3 nov',
      ]);
      await repo.archive(id);
      expect(await repo.watchSummaries().first, hasLength(1));
      await repo.unarchive(id);
      expect(await repo.watchSummaries().first, hasLength(2));

      final long = await repo.save(draft.rename('x' * 60), fallbackName: 'y');
      expect((await repo.load(long))!.name, hasLength(40));
    },
  );
}
