import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/core/units/weight_unit.dart';
import 'package:trainloop/data/catalog/exercise_catalog_seeder.dart';
import 'package:trainloop/data/db/app_database.dart';
import 'package:trainloop/data/db/enums.dart';
import 'package:trainloop/features/routines/data/routine_repository.dart';
import 'package:trainloop/features/routines/domain/routine_draft.dart';
import 'package:trainloop/features/settings/domain/app_settings.dart';
import 'package:trainloop/features/strength/data/strength_session_repository.dart';
import 'package:trainloop/features/strength/domain/strength_session.dart';
import 'package:trainloop/platform/timer_engine_client.dart';

import '../../helpers/fake_timer_engine.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/test_database.dart';

void main() {
  late FakeTimerEngine engine;
  late AppDatabase db;
  late StrengthSessionRepository repo;
  late String routineId;

  setUp(() async {
    engine = FakeTimerEngine();
    db = openTestDatabase();
    repo = StrengthSessionRepository(db);
    await seedExerciseCatalog(db.exercisesDao);
    final bench = (await db.exercisesDao.findByCatalogKey(
      'bench_press_barbell',
    ))!;
    final draft = const RoutineDraft(name: 'Empuje').addAll([bench]);
    routineId = await RoutineRepository(db).save(
      draft.replaceAt(
        0,
        draft.entries[0].copyWith(
          reps: 8,
          weight: () => 60,
          weightUnit: WeightUnit.kg,
          restSeconds: 90,
        ),
      ),
      fallbackName: 'x',
    );
  });

  tearDown(() => db.close());

  Future<void> pump(
    WidgetTester tester, {
    AppSettings settings = const AppSettings(language: AppLanguage.es),
  }) async {
    useTallViewport(tester);
    await pumpTrainloop(
      tester,
      engine: engine,
      database: db,
      settings: settings,
    );
  }

  /// Avanza la interfaz y las escrituras en la base sin esperar a que se
  /// asiente (S10 repinta cada segundo).
  Future<void> frames(WidgetTester tester, [int n = 6]) async {
    for (var i = 0; i < n; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  Future<StrengthSessionData> load(WidgetTester tester, String id) async =>
      (await tester.runAsync<StrengthSessionData?>(() => repo.load(id)))!;

  Future<String> startFromTrain(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('nav-train')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rutinas'));
    await frames(tester);
    await tester.tap(find.byKey(Key('routine-start-$routineId')));
    await frames(tester, 10);
    expect(engine.calls, contains('startStrength'));
    return engine.strengthProgram!.sessionId;
  }

  testWidgets('empezar una rutina: la serie repetida se guarda en 1 toque y '
      'arranca el descanso del ejercicio', (tester) async {
    await pump(tester);
    final id = await startFromTrain(tester);
    expect(find.byKey(const Key('strength-title')), findsOneWidget);
    expect(find.text('EMPUJE'), findsOneWidget);
    expect(engine.strengthProgram!.title, 'Empuje');
    expect(
      engine.strengthProgram!.strings['restOver'],
      '¡A la siguiente serie!',
    );

    var data = await load(tester, id);
    final first = data.exercises.single.sets.first;
    expect(first.completed, isFalse);

    // 1 toque.
    await tester.tap(find.byKey(Key('set-check-${first.id}')));
    await frames(tester, 10);
    data = await load(tester, id);
    final done = data.exercises.single.sets.first;
    expect(done.completed, isTrue);
    expect(done.log.weightValue, 60);
    expect(done.log.reps, 8);
    expect(engine.rests.single.$1, 90000);
    expect(
      engine.rests.single.$2,
      'Siguiente: Press de banca con barra, serie 2 · 60 kg × 8',
    );
    expect(find.text('1/3 series'), findsNothing); // el texto lleva el tiempo
    expect(find.textContaining('1/3 series'), findsOneWidget);

    // El servicio publica el descanso: franja con −15, +15 y SALTAR.
    engine.emitStrength(
      StrengthEngineState(
        sessionId: id,
        rest: RestRunState.running,
        restRemainingMs: 89000,
        restDurationMs: 90000,
        receivedAt: engine.now,
      ),
    );
    await frames(tester);
    expect(find.byKey(const Key('rest-bar')), findsOneWidget);
    expect(find.text('1:29'), findsOneWidget);
    await tester.tap(find.byKey(const Key('rest-plus')));
    await tester.tap(find.byKey(const Key('rest-minus')));
    await tester.tap(find.byKey(const Key('rest-skip')));
    await frames(tester);
    expect(
      engine.calls,
      containsAll(['adjustRest:15000', 'adjustRest:-15000', 'skipRest']),
    );

    // Al terminar el descanso: "¡A la siguiente serie!".
    engine.emitStrength(
      StrengthEngineState(sessionId: id, rest: RestRunState.done),
    );
    await frames(tester);
    expect(find.byKey(const Key('rest-bar')), findsNothing);
    expect(find.byKey(const Key('rest-done')), findsOneWidget);
    engine.now += const Duration(seconds: 4);
    await tester.pump(const Duration(seconds: 1));
    expect(find.byKey(const Key('rest-done')), findsNothing);

    // Tocar ✓ otra vez la desmarca.
    await tester.tap(find.byKey(Key('set-check-${first.id}')));
    await frames(tester, 10);
    data = await load(tester, id);
    expect(data.completedSets, 0);
    expect(engine.rests.length, 1);
  });

  testWidgets('S11 edita peso (con coma), reps, RPE y tipo; terminar con '
      'series pendientes abre el resumen', (tester) async {
    await pump(tester);
    final id = await startFromTrain(tester);
    var data = await load(tester, id);
    final second = data.exercises.single.sets[1];

    await tester.tap(find.byKey(Key('set-weight-${second.id}')));
    await frames(tester);
    expect(find.byKey(const Key('set-editor')), findsOneWidget);
    expect(find.text('Press de banca con barra · serie 2'), findsOneWidget);
    // Sin sesión anterior no hay "la vez anterior".
    expect(find.byKey(const Key('set-previous')), findsNothing);
    await tester.tap(find.byKey(const Key('weight-plus')));
    await tester.pump();
    expect(find.text('62,5'), findsOneWidget);
    expect(find.text('−2,5'), findsOneWidget);
    await tester.tap(find.byKey(const Key('reps-minus')));
    await tester.tap(find.byKey(const Key('rpe-8.5')));
    await tester.tap(find.byKey(const Key('set-type-failure')));
    await tester.pump();
    // Validación: 0,1 no es múltiplo de 0,25.
    await tester.enterText(find.byKey(const Key('weight-field')), '62,6');
    await tester.pump();
    expect(find.byKey(const Key('set-error')), findsOneWidget);
    await tester.enterText(find.byKey(const Key('weight-field')), '62,75');
    await tester.pump();
    expect(find.byKey(const Key('set-error')), findsNothing);
    await tester.tap(find.byKey(const Key('set-save')));
    await frames(tester, 10);

    data = await load(tester, id);
    final saved = data.exercises.single.sets[1];
    expect(saved.completed, isTrue);
    expect(saved.log.weightValue, 62.75);
    expect(saved.log.reps, 7);
    expect(saved.log.rpe, 8.5);
    expect(saved.type, SetType.failure);
    expect(find.text('2F'), findsOneWidget);
    expect(engine.rests.length, 1);

    // TERMINAR con 2 series sin marcar: R-G10.
    await tester.tap(find.byKey(const Key('strength-finish')));
    await frames(tester);
    expect(find.text('Hay 2 series sin completar'), findsOneWidget);
    await tester.tap(find.byKey(const Key('pending-discard')));
    await frames(tester, 15);
    await tester.pumpAndSettle();
    expect(engine.calls, contains('stopStrength'));
    expect(find.text('¡Sesión completa!'), findsOneWidget);
    // 62,75 × 7 = 439,25 kg.
    expect(find.text('439,25 KG'), findsOneWidget);
    expect(find.byKey(const Key('summary-sets')), findsOneWidget);

    await tester.tap(find.byKey(const Key('rpe-7')));
    await tester.tap(find.byKey(const Key('summary-done')));
    await frames(tester);
    await tester.pumpAndSettle();
    final session = (await tester.runAsync(() => db.sessionsDao.findById(id)))!;
    expect(session.status, SessionStatus.completed);
    expect(session.perceivedEffort, 7);
    // Inicio ofrece repetir la última.
    expect(find.byKey(const Key('home-repeat-last')), findsOneWidget);
  });

  testWidgets('sin ninguna serie hecha, terminar propone descartarla', (
    tester,
  ) async {
    await pump(tester);
    final id = await startFromTrain(tester);
    await tester.tap(find.byKey(const Key('strength-finish')));
    await frames(tester);
    expect(find.byKey(const Key('no-sets-dialog')), findsOneWidget);
    await tester.tap(find.byKey(const Key('no-sets-discard')));
    await frames(tester, 10);
    await tester.pumpAndSettle();
    final session = (await tester.runAsync(() => db.sessionsDao.findById(id)))!;
    expect(session.status, SessionStatus.discarded);
    expect(engine.calls, contains('stopStrength'));
  });

  testWidgets('con kg/lb en lb el peso se muestra y se escribe en libras', (
    tester,
  ) async {
    await pump(
      tester,
      settings: const AppSettings(
        language: AppLanguage.es,
        weightUnit: WeightUnit.lb,
      ),
    );
    final id = await startFromTrain(tester);
    final data = await load(tester, id);
    final first = data.exercises.single.sets.first;
    // 60 kg = 132,28 lb.
    expect(find.text('132,28'), findsNWidgets(3));
    expect(find.text('LB'), findsOneWidget);
    await tester.tap(find.byKey(Key('set-weight-${first.id}')));
    await frames(tester);
    expect(find.text('PESO (LB)'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('weight-field')), '135');
    await tester.pump();
    await tester.ensureVisible(find.byKey(const Key('set-save')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('set-save')));
    await frames(tester, 10);
    final row = (await tester.runAsync(
      () => db.sessionsDao.findSet(first.id),
    ))!;
    expect(row.weightValue, 135);
    expect(row.weightUnit, WeightUnit.lb);
    expect(row.weightGrams, 61235);
  });

  testWidgets('tras un cierre forzado ofrece retomar la sesión con su '
      'descanso recalculado', (tester) async {
    final id = await repo.startFromRoutine(routineId);
    final set = (await repo.load(id))!.exercises.single.sets.first;
    await repo.completeSet(set.id, set.proposed);
    engine.strengthPendingState = StrengthPending(
      sessionId: id,
      restRemainingMs: 40000,
      next: 'Siguiente: Press de banca con barra, serie 2',
      savedAt: DateTime.now().subtract(const Duration(minutes: 3)),
    );
    await pump(tester);
    await frames(tester);
    expect(find.byKey(const Key('strength-recovery-dialog')), findsOneWidget);
    expect(find.text('Empuje · 1 serie hecha'), findsOneWidget);
    expect(find.text('interrumpido hace 3 min'), findsOneWidget);
    expect(
      (await tester.runAsync(() => db.sessionsDao.findById(id)))!.status,
      SessionStatus.recoveryPending,
    );

    await tester.tap(find.byKey(const Key('recovery-resume')));
    await frames(tester, 12);
    expect(engine.calls, contains('startStrength'));
    expect(engine.rests.single.$1, 40000);
    expect(find.byKey(const Key('strength-title')), findsOneWidget);
    expect(find.textContaining('1/3 series'), findsOneWidget);
    expect(
      (await tester.runAsync(() => db.sessionsDao.findById(id)))!.status,
      SessionStatus.inProgress,
    );
  });

  testWidgets('recuperar: guardar como incompleta conserva sus series', (
    tester,
  ) async {
    final id = await repo.startFromRoutine(routineId);
    final set = (await repo.load(id))!.exercises.single.sets.first;
    await repo.completeSet(set.id, set.proposed);
    await pump(tester);
    await frames(tester);
    await tester.tap(find.byKey(const Key('recovery-save')));
    await frames(tester, 10);
    final data = await load(tester, id);
    expect(data.session.status, SessionStatus.incomplete);
    expect(data.totalSets, 1);
    expect(engine.calls, contains('clearStrength'));
  });

  testWidgets('entrenamiento libre: vacío y se agregan ejercicios', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.byKey(const Key('nav-train')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rutinas'));
    await frames(tester);
    await tester.tap(find.byKey(const Key('free-workout')));
    await frames(tester, 10);
    expect(
      tester.widget<Text>(find.byKey(const Key('strength-title'))).data,
      'ENTRENAMIENTO LIBRE',
    );
    expect(engine.strengthProgram!.title, 'Entrenamiento libre');
    await tester.tap(find.byKey(const Key('strength-add-exercise')));
    await frames(tester, 10);
    await tester.enterText(
      find.byKey(const Key('library-search')),
      'press de banca con barra',
    );
    await frames(tester);
    await tester.tap(find.byKey(const Key('exercise-bench_press_barbell')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('library-add')));
    await frames(tester, 12);
    expect(
      find.byKey(const Key('exercise-card-bench_press_barbell')),
      findsOneWidget,
    );
    expect(find.textContaining('0/3 series'), findsOneWidget);
  });
}
