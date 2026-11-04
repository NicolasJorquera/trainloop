import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:trainloop/core/units/weight_unit.dart';
import 'package:trainloop/data/catalog/exercise_catalog_seeder.dart';
import 'package:trainloop/data/db/app_database.dart';
import 'package:trainloop/data/db/enums.dart';
import 'package:trainloop/features/intervals/presentation/timer_screen.dart';
import 'package:trainloop/features/routines/data/routine_repository.dart';
import 'package:trainloop/features/routines/domain/routine_draft.dart';
import 'package:trainloop/features/strength/application/strength_session_controller.dart';
import 'package:trainloop/features/strength/data/strength_session_repository.dart';
import 'package:trainloop/platform/timer_engine_client.dart';

import 'helpers.dart';

/// Recorridos cortos con el motor nativo real (D9). Correr en un emulador o
/// teléfono: `flutter test integration_test/app_test.dart -d <id>`; en
/// Firebase Test Lab con `tool/test_lab.sh`.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('primera apertura → Tabata (fases saltadas) → resumen', (
    tester,
  ) async {
    final db = openDatabaseFile(await freshDatabaseFile('tabata'));
    addTearDown(db.close);
    await pumpRealApp(tester, database: db, settings: await firstRunSettings());

    // Primera apertura: Inicio con el aviso de datos locales y plantillas.
    await waitFor(tester, find.byKey(const Key('template-tabata')));
    await tapWhenVisible(tester, find.byKey(const Key('template-tabata')));
    await tapWhenVisible(tester, find.byKey(const Key('detail-start')));
    await skipNotificationRationale(tester);

    // S05 con el motor real: corre la preparación unos segundos.
    await waitFor(tester, find.byType(TimerScreen));
    await waitFor(tester, find.text('PREPÁRATE'));
    await settle(tester, const Duration(seconds: 3));
    // Las 16 fases se saltan con el botón (el motor responde en cada una).
    for (var i = 0; i < 16; i++) {
      final skip = find.byKey(const Key('timer-skip'));
      if (skip.evaluate().isEmpty) break;
      await tester.tap(skip);
      await settle(tester, const Duration(milliseconds: 700));
    }
    await waitFor(tester, find.byKey(const Key('summary-done')));
    expect(find.byKey(const Key('summary-title')), findsOneWidget);
    await tapWhenVisible(tester, find.byKey(const Key('summary-done')));
    await waitFor(tester, find.byKey(const Key('template-tabata')));

    final sessions = await db.select(db.sessions).get();
    expect(sessions.single.kind, SessionKind.intervals);
    expect(sessions.single.status, SessionStatus.completed);
    expect(await db.select(db.intervalPhaseLogs).get(), hasLength(16));
  });

  testWidgets('sesión de fuerza con una serie: se guarda al confirmarla', (
    tester,
  ) async {
    final db = openDatabaseFile(await freshDatabaseFile('strength'));
    addTearDown(db.close);
    final routineId = await _seedRoutine(db);
    await pumpRealApp(tester, database: db, settings: await firstRunSettings());

    final id = await _startRoutine(tester, routineId);
    final repo = StrengthSessionRepository(db);
    final first = (await repo.load(id))!.exercises.single.sets.first;
    await tapWhenVisible(tester, find.byKey(Key('set-check-${first.id}')));
    // NF-06: la serie ya está en la base, sin esperar a terminar.
    final saved = (await repo.load(id))!.exercises.single.sets.first;
    expect(saved.completed, isTrue);
    // El descanso corre en el servicio nativo.
    await waitFor(tester, find.byKey(const Key('rest-bar')));
    await tapWhenVisible(tester, find.byKey(const Key('rest-skip')));

    await tapWhenVisible(tester, find.byKey(const Key('strength-finish')));
    await tapWhenVisible(tester, find.byKey(const Key('pending-discard')));
    await tapWhenVisible(tester, find.byKey(const Key('summary-done')));
    await waitFor(tester, find.byKey(const Key('home-repeat-last')));
    final session = (await db.sessionsDao.findById(id))!;
    expect(session.status, SessionStatus.completed);
  });

  testWidgets('cierre forzado con una sesión de fuerza: al abrir se ofrece '
      'retomarla con su serie (NF-06)', (tester) async {
    final file = await freshDatabaseFile('recovery');
    var db = openDatabaseFile(file);
    final routineId = await _seedRoutine(db);
    final settings = await firstRunSettings();
    await pumpRealApp(tester, database: db, settings: settings);
    final id = await _startRoutine(tester, routineId);
    final first = (await StrengthSessionRepository(
      db,
    ).load(id))!.exercises.single.sets.first;
    await tapWhenVisible(tester, find.byKey(Key('set-check-${first.id}')));

    // «Android cierra la app»: se desmonta la interfaz, se cierra la base y
    // el servicio deja de existir. Lo único que queda es lo guardado.
    await tester.pumpWidget(const SizedBox.shrink());
    await db.close();
    await MethodChannelTimerEngine().stopStrength();
    await settle(tester);

    // Se vuelve a abrir con la misma base.
    db = openDatabaseFile(file);
    addTearDown(db.close);
    await pumpRealApp(tester, database: db, settings: settings);
    await waitFor(tester, find.byKey(const Key('strength-recovery-dialog')));
    expect(find.textContaining('1 serie hecha'), findsOneWidget);
    await tapWhenVisible(tester, find.byKey(const Key('recovery-resume')));
    await waitFor(tester, find.byKey(const Key('strength-title')));
    expect(find.textContaining('1/3 series'), findsOneWidget);

    // Se cierra limpia para no dejar el servicio vivo.
    await tapWhenVisible(tester, find.byKey(const Key('strength-finish')));
    await tapWhenVisible(tester, find.byKey(const Key('pending-discard')));
    await tapWhenVisible(tester, find.byKey(const Key('summary-done')));
    expect(
      (await db.sessionsDao.findById(id))!.status,
      SessionStatus.completed,
    );
  });
}

/// Rutina «Empuje»: press de banca 3 × 8 con 60 kg y 90 s de descanso.
Future<String> _seedRoutine(AppDatabase db) async {
  await seedExerciseCatalog(db.exercisesDao);
  final bench = (await db.exercisesDao.findByCatalogKey(
    'bench_press_barbell',
  ))!;
  final draft = const RoutineDraft(name: 'Empuje').addAll([bench]);
  return RoutineRepository(db).save(
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
}

/// Entrenar → Rutinas → ▶ y espera S10. Devuelve el id de la sesión.
Future<String> _startRoutine(WidgetTester tester, String routineId) async {
  await tapWhenVisible(tester, find.byKey(const Key('nav-train')));
  await tapWhenVisible(tester, find.text('Rutinas'));
  await tapWhenVisible(tester, find.byKey(Key('routine-start-$routineId')));
  await skipNotificationRationale(tester);
  await waitFor(tester, find.byKey(const Key('strength-title')));
  final container = ProviderScope.containerOf(
    tester.element(find.byKey(const Key('strength-title'))),
  );
  return container.read(strengthSessionProvider)!.sessionId;
}
