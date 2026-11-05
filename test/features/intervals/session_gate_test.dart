import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/data/db/app_database.dart';
import 'package:trainloop/features/intervals/presentation/timer_screen.dart';
import 'package:trainloop/features/settings/domain/app_settings.dart';
import 'package:trainloop/features/strength/presentation/strength_session_screen.dart';

import '../../helpers/fake_timer_engine.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/test_database.dart';

/// Deuda 8 de `docs/pruebas-monetizacion.md`: con S05 abierta por `push`,
/// la ruta visible no es `/timer` según `currentConfiguration.uri` y volver
/// a la app apilaba otra S05.
void main() {
  late FakeTimerEngine engine;
  late AppDatabase db;

  setUp(() {
    engine = FakeTimerEngine();
    db = openTestDatabase();
  });

  tearDown(() => db.close());

  Future<void> frames(WidgetTester tester, [int n = 5]) async {
    for (var i = 0; i < n; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  Future<void> backToApp(WidgetTester tester) async {
    final binding = tester.binding;
    for (final state in [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ]) {
      binding.handleAppLifecycleStateChanged(state);
    }
    await frames(tester, 8);
  }

  testWidgets('volver a la app con S05 abierta no apila otra S05', (
    tester,
  ) async {
    useTallViewport(tester);
    await pumpTrainloop(
      tester,
      engine: engine,
      database: db,
      settings: const AppSettings(language: AppLanguage.es),
    );
    await tester.tap(find.byKey(const Key('template-tabata')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('detail-start')));
    await frames(tester);
    final id = engine.program!.sessionId;
    // El motor sigue corriendo: `current()` lo devuelve al volver.
    engine.emit(engineState(id, index: 1, remainingMs: 20000));
    await frames(tester);
    expect(find.byType(TimerScreen, skipOffstage: false), findsOneWidget);

    await backToApp(tester);
    await backToApp(tester);
    expect(find.byType(TimerScreen, skipOffstage: false), findsOneWidget);
  });

  testWidgets('volver a la app con S10 abierta no apila otra S10', (
    tester,
  ) async {
    useTallViewport(tester);
    await pumpTrainloop(
      tester,
      engine: engine,
      database: db,
      settings: const AppSettings(language: AppLanguage.es),
    );
    await tester.tap(find.byKey(const Key('nav-train')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fuerza'));
    await frames(tester);
    await tester.tap(find.byKey(const Key('free-workout')));
    await frames(tester, 10);
    expect(engine.calls, contains('startStrength'));
    expect(
      find.byType(StrengthSessionScreen, skipOffstage: false),
      findsOneWidget,
    );

    await backToApp(tester);
    await backToApp(tester);
    expect(
      find.byType(StrengthSessionScreen, skipOffstage: false),
      findsOneWidget,
    );
  });

  testWidgets('atrás minimiza S10: la barra lo muestra, vuelve y termina; '
      'empezar otra ofrece volver o terminar', (tester) async {
    useTallViewport(tester);
    await pumpTrainloop(
      tester,
      engine: engine,
      database: db,
      settings: const AppSettings(language: AppLanguage.es),
    );
    await tester.tap(find.byKey(const Key('nav-train')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fuerza'));
    await frames(tester);
    await tester.tap(find.byKey(const Key('free-workout')));
    await frames(tester, 10);
    expect(find.byKey(const Key('active-session-bar')), findsNothing);

    // Atrás sale de S10 y nada la vuelve a apilar al volver a la app.
    await tester.tap(find.byKey(const Key('strength-back')));
    await frames(tester);
    await backToApp(tester);
    expect(find.byType(StrengthSessionScreen), findsNothing);
    final bar = find.byKey(const Key('active-session-bar'));
    expect(bar, findsOneWidget);
    expect(find.textContaining('FUERZA · ENTRENAMIENTO LIBRE'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const Key('active-session-open'))).height,
      greaterThanOrEqualTo(48),
    );

    // La barra vuelve a la sesión.
    await tester.tap(find.byKey(const Key('active-session-open')));
    await frames(tester);
    expect(find.byType(StrengthSessionScreen), findsOneWidget);
    expect(bar, findsNothing);
    await tester.tap(find.byKey(const Key('strength-back')));
    await frames(tester);

    // Empezar otra: el diálogo ofrece volver o terminar y empezar nueva.
    await tester.ensureVisible(find.byKey(const Key('free-workout')));
    await frames(tester);
    await tester.tap(find.byKey(const Key('free-workout')));
    await frames(tester);
    expect(find.byKey(const Key('active-session-dialog')), findsOneWidget);
    expect(find.text('VOLVER A LA SESIÓN'), findsOneWidget);
    expect(find.text('TERMINAR Y EMPEZAR NUEVA'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await frames(tester);

    // Terminar desde la barra (sin series: propone descartarla).
    await tester.tap(find.byKey(const Key('active-session-bar-end')));
    await frames(tester);
    await tester.tap(find.byKey(const Key('no-sets-discard')));
    await frames(tester, 10);
    expect(bar, findsNothing);
  });
}
