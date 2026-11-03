import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/core/theme/accent.dart';
import 'package:trainloop/data/db/app_database.dart';
import 'package:trainloop/data/db/enums.dart';
import 'package:trainloop/features/settings/domain/app_settings.dart';
import 'package:trainloop/platform/timer_engine_client.dart';

import '../../helpers/fake_timer_engine.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/test_database.dart';

void main() {
  late FakeTimerEngine engine;
  late AppDatabase db;

  setUp(() {
    engine = FakeTimerEngine();
    db = openTestDatabase();
  });

  tearDown(() => db.close());

  Future<void> pump(WidgetTester tester) async {
    useTallViewport(tester);
    await pumpTrainloop(
      tester,
      engine: engine,
      database: db,
      settings: const AppSettings(language: AppLanguage.es),
    );
  }

  /// Avanza sin esperar a que se asiente (S05 repinta mientras corre).
  Future<void> frames(WidgetTester tester, [int n = 5]) async {
    for (var i = 0; i < n; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  Future<String> startTabataFromHome(WidgetTester tester) async {
    // Toque 1: la plantilla en Inicio. Toque 2: EMPEZAR en S03.
    await tester.tap(find.byKey(const Key('template-tabata')));
    await tester.pumpAndSettle();
    expect(find.text('4:00 en total · 8 rondas · Plantilla'), findsOneWidget);
    await tester.tap(find.byKey(const Key('detail-start')));
    await frames(tester);
    await tester.pump(const Duration(milliseconds: 600));
    expect(engine.calls, contains('start'));
    return engine.program!.sessionId;
  }

  testWidgets(
    'Tabata desde Inicio en 2 toques y S05 muestra el estado del motor',
    (tester) async {
      await pump(tester);
      final id = await startTabataFromHome(tester);
      expect(find.byKey(const Key('timer-phase')), findsOneWidget);
      expect(find.text('PREPÁRATE'), findsOneWidget);
      expect(find.text('0:10'), findsOneWidget);
      expect(find.text('Siguiente: Trabajo 0:20'), findsOneWidget);

      // El motor pasa al primer trabajo: color del acento, ronda y siguiente.
      engine.now = const Duration(seconds: 10);
      engine.emit(
        engineState(
          id,
          index: 1,
          remainingMs: 20000,
          positionMs: 10000,
          results: [phaseResult(0, 10000)],
          receivedAt: engine.now,
        ),
      );
      await frames(tester);
      expect(find.text('TRABAJO'), findsOneWidget);
      expect(find.text('RONDA 1/8'), findsOneWidget);
      expect(find.text('0:20'), findsOneWidget);
      expect(find.text('Siguiente: Descanso 0:10'), findsOneWidget);
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).last);
      expect(scaffold.backgroundColor, AccentPreset.orquidea.swatch.dark);

      // El tiempo restante se calcula localmente desde el último estado.
      engine.now = const Duration(milliseconds: 15500);
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('0:15'), findsOneWidget);

      // Descanso: otro color; en pausa el centro lo dice con palabras.
      engine.emit(
        engineState(
          id,
          state: EngineRunState.paused,
          index: 2,
          remainingMs: 7000,
          receivedAt: engine.now,
        ),
      );
      await frames(tester);
      expect(find.text('EN PAUSA'), findsOneWidget);
      expect(find.text('TOCA PARA REANUDAR'), findsOneWidget);
      expect(find.text('0:07'), findsOneWidget);

      await tester.tap(find.byKey(const Key('timer-center')));
      await tester.tap(find.byKey(const Key('timer-skip')));
      await tester.tap(find.byKey(const Key('timer-previous')));
      await frames(tester, 2);
      expect(engine.calls.sublist(engine.calls.length - 3), [
        'resume',
        'skip',
        'previous',
      ]);
      // La fase de trabajo ya quedó guardada en la base.
      expect(
        (await db.sessionsDao.phasesOf(id)).single.phaseType,
        PhaseType.prepare,
      );
    },
  );

  testWidgets(
    'detener exige mantener 1 s; el bloqueo desactiva los controles',
    (tester) async {
      await pump(tester);
      await startTabataFromHome(tester);
      final hold = find.byKey(const Key('timer-hold-stop'));

      var gesture = await tester.startGesture(tester.getCenter(hold));
      await tester.pump(const Duration(milliseconds: 600));
      await gesture.up();
      await tester.pump(const Duration(milliseconds: 600));
      expect(engine.calls, isNot(contains('stop')));

      await tester.tap(find.byKey(const Key('timer-lock')));
      await tester.pump();
      expect(find.byKey(const Key('timer-locked')), findsOneWidget);
      await tester.tap(find.byKey(const Key('timer-skip')));
      gesture = await tester.startGesture(tester.getCenter(hold));
      await tester.pump(const Duration(milliseconds: 1100));
      await gesture.up();
      expect(engine.calls, isNot(contains('skip')));
      expect(engine.calls, isNot(contains('stop')));

      await tester.tap(find.byKey(const Key('timer-lock')));
      await tester.pump();
      gesture = await tester.startGesture(tester.getCenter(hold));
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 250));
      }
      await gesture.up();
      await tester.pump();
      expect(engine.calls.last, 'stop');
    },
  );

  testWidgets('al terminar abre el resumen y guarda esfuerzo y nota', (
    tester,
  ) async {
    await pump(tester);
    final id = await startTabataFromHome(tester);
    engine.emit(
      engineState(
        id,
        state: EngineRunState.finished,
        index: 16,
        remainingMs: 0,
        activeMs: 240000,
        pausedMs: 12000,
        results: [
          for (var i = 0; i < 16; i++)
            phaseResult(
              i,
              i == 0 ? 10000 : (i.isOdd ? 20000 : 10000),
              skipped: i == 4,
              actualMs: i == 4 ? 3000 : null,
            ),
        ],
      ),
    );
    await frames(tester, 8);
    await tester.pumpAndSettle();
    expect(find.text('¡Sesión completa!'), findsOneWidget);
    expect(find.byKey(const Key('summary-rounds')), findsOneWidget);
    expect(find.text('8/8'), findsOneWidget);
    expect(find.text('3:53'), findsOneWidget); // 240 s − 7 s omitidos
    expect(find.text('1 fase omitida · 0:12 en pausa'), findsOneWidget);
    expect(find.byKey(const Key('summary-short')), findsNothing);

    await tester.tap(find.byKey(const Key('rpe-7')));
    await tester.enterText(find.byKey(const Key('summary-note')), 'Bien');
    await tester.tap(find.byKey(const Key('summary-done')));
    await frames(tester);
    await tester.pumpAndSettle();
    final session = (await db.sessionsDao.findById(id))!;
    expect(session.status, SessionStatus.completed);
    expect(session.perceivedEffort, 7);
    expect(session.note, 'Bien');
    expect(find.byKey(const Key('template-tabata')), findsOneWidget);
  });

  testWidgets(
    'primera sesión: explica el permiso y guía si la batería está restringida',
    (tester) async {
      engine
        ..granted = false
        ..promptShown = false
        ..grantOnRequest = false
        ..restricted = true;
      await pump(tester);
      await tester.tap(find.byKey(const Key('template-tabata')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('detail-start')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('notify-dialog')), findsOneWidget);
      await tester.tap(find.byKey(const Key('notify-continue')));
      await tester.pumpAndSettle();
      expect(engine.calls, contains('requestNotifications'));

      expect(
        find.text('EVITA QUE GOOGLE PAUSE EL TEMPORIZADOR'),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const Key('battery-later')));
      await frames(tester);
      // Denegado y restringido: la sesión empieza igual.
      expect(engine.calls, contains('start'));
      expect(find.byKey(const Key('timer-phase')), findsOneWidget);
      expect(engine.promptShown, isTrue);
    },
  );

  testWidgets('al abrir tras un cierre ofrece recuperar y reanuda en pausa', (
    tester,
  ) async {
    final repoId = await db.sessionsDao.start(
      kind: SessionKind.intervals,
      templateId: 'template:tabata',
      templateSnapshot: {
        'kind': 'intervals',
        'version': 1,
        'name': 'Tabata 20/10',
        'prepareSeconds': 10,
        'blocks': [
          {
            'rounds': 8,
            'skipLastRest': true,
            'children': [
              {'type': 'work', 'seconds': 20},
              {'type': 'rest', 'seconds': 10},
            ],
          },
        ],
        'phases': [
          {'type': 'prepare', 'seconds': 10},
          for (var r = 1; r <= 8; r++) ...[
            {'type': 'work', 'seconds': 20, 'round': r, 'rounds': 8},
            if (r < 8) {'type': 'rest', 'seconds': 10, 'round': r, 'rounds': 8},
          ],
        ],
      },
    );
    engine.pendingState = engineState(
      repoId,
      index: 9,
      positionMs: 135000,
      activeMs: 135000,
      results: [for (var i = 0; i < 9; i++) phaseResult(i, 10000)],
      savedAt: DateTime.now().subtract(const Duration(minutes: 12)),
    );
    await pump(tester);
    expect(find.byKey(const Key('recovery-dialog')), findsOneWidget);
    expect(find.text('Tabata 20/10 · Ronda 5/8'), findsOneWidget);
    expect(find.text('interrumpido hace 12 min'), findsOneWidget);
    expect(
      (await db.sessionsDao.findById(repoId))!.status,
      SessionStatus.recoveryPending,
    );

    await tester.tap(find.byKey(const Key('recovery-resume')));
    await frames(tester);
    await tester.pumpAndSettle();
    expect(engine.calls, contains('restore'));
    expect(find.text('EN PAUSA'), findsOneWidget);
    expect(find.text('0:15'), findsOneWidget);
    expect(
      (await db.sessionsDao.findById(repoId))!.status,
      SessionStatus.inProgress,
    );
  });

  testWidgets(
    'si Android detiene el servicio con la app abierta, ofrece recuperar',
    (tester) async {
      await pump(tester);
      final id = await startTabataFromHome(tester);
      final interrupted = engineState(
        id,
        index: 3,
        positionMs: 45000,
        activeMs: 45000,
        results: [for (var i = 0; i < 3; i++) phaseResult(i, 10000)],
        savedAt: DateTime.now(),
      );
      engine
        ..pendingState = interrupted
        ..emit(
          EngineState(
            sessionId: id,
            state: EngineRunState.interrupted,
            index: 3,
            count: 16,
            remainingMs: 15000,
            positionMs: 45000,
            activeMs: 45000,
            pausedMs: 0,
            results: interrupted.results,
          ),
        );
      await frames(tester, 30);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('recovery-dialog')), findsOneWidget);
      expect(
        (await tester.runAsync(() => db.sessionsDao.findById(id)))!.status,
        SessionStatus.recoveryPending,
      );
      await tester.tap(find.byKey(const Key('recovery-discard')));
      await frames(tester);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('template-tabata')), findsOneWidget);
    },
  );

  testWidgets(
    'editor: bloques, rondas, total al instante y error sin trabajo',
    (tester) async {
      await pump(tester);
      await tester.tap(find.byKey(const Key('nav-train')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('new-interval')));
      await tester.pumpAndSettle();

      // Inicial: 0:10 + 8 × (0:20 + 0:10) − 0:10 = 4:00.
      expect(find.text('4:00'), findsOneWidget);
      await tester.tap(find.byKey(const Key('rounds-plus-0')));
      await tester.pump();
      expect(find.text('4:30'), findsOneWidget);
      await tester.tap(find.byKey(const Key('plus-0-0')));
      await tester.pump();
      expect(find.text('0:25'), findsOneWidget);
      expect(find.text('5:15'), findsOneWidget);
      await tester.tap(find.byKey(const Key('skip-last-0')));
      await tester.pump();
      expect(find.text('5:25'), findsOneWidget);
      await tester.tap(find.byKey(const Key('minus-prep')));
      await tester.pump();
      expect(find.text('5:20'), findsOneWidget);

      // Calentamiento al final del primer nivel.
      await tester.tap(find.byKey(const Key('add-block')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('add-warmup')));
      await tester.pumpAndSettle();
      expect(find.text('10:20'), findsOneWidget);

      // Sin trabajo no se puede guardar.
      await tester.tap(find.byKey(const Key('menu-0-0')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Quitar'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('editor-error')), findsOneWidget);
      final save = find.byKey(const Key('interval-save'));
      await tester.tap(save);
      await tester.pump();
      expect(find.byKey(const Key('editor-error')), findsOneWidget);

      await tester.tap(find.byKey(const Key('add-to-0')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('add-work')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('editor-error')), findsNothing);
      await tester.enterText(find.byKey(const Key('interval-name')), 'Mi HIIT');
      await tester.tap(save);
      await settleDb(tester);
      expect(find.text('Mi HIIT'), findsOneWidget);
      final workouts = (await tester.runAsync(
        () => db.intervalWorkoutsDao.watchActive().first,
      ))!;
      expect(workouts.single.prepareSeconds, 5);
    },
  );
}
