import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/data/db/app_database.dart';
import 'package:trainloop/features/monetization/application/ads_controller.dart';
import 'package:trainloop/features/monetization/domain/monetization_config.dart';
import 'package:trainloop/features/settings/domain/app_settings.dart';
import 'package:trainloop/platform/timer_engine_client.dart';

import '../../helpers/fake_monetization.dart';
import '../../helpers/fake_timer_engine.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/test_database.dart';

/// Intersticial S20 (R-A2, R-A4, R-A5): solo con el indicador, tras
/// «Listo» en una sesión completada de 5 min o más, y solo si ya cargó.
void main() {
  late FakeTimerEngine engine;
  late FakeAdsPlatform ads;
  late AppDatabase db;

  setUp(() {
    engine = FakeTimerEngine();
    ads = FakeAdsPlatform();
    db = openTestDatabase();
  });

  tearDown(() => db.close());

  Future<void> pump(WidgetTester tester, {required bool flag}) async {
    useTallViewport(tester);
    await pumpTrainloop(
      tester,
      engine: engine,
      database: db,
      ads: ads,
      settings: const AppSettings(language: AppLanguage.es),
      overrides: [
        monetizationConfigProvider.overrideWithValue(
          // Sin los topes de R-A3 (se prueban aparte): una base nueva no
          // tiene 5 sesiones ni 7 días.
          MonetizationConfig(
            interstitialExperiment: flag,
            interstitialCaps: false,
          ),
        ),
      ],
    );
  }

  Future<void> frames(WidgetTester tester, [int n = 6]) async {
    for (var i = 0; i < n; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  /// Tabata hasta el resumen; [minutes] fija la duración guardada.
  Future<String> runToSummary(
    WidgetTester tester, {
    required int minutes,
    EngineRunState end = EngineRunState.finished,
  }) async {
    await tester.tap(find.byKey(const Key('template-tabata')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('detail-start')));
    await frames(tester);
    await tester.pump(const Duration(milliseconds: 600));
    final id = engine.program!.sessionId;
    engine.emit(
      engineState(
        id,
        state: end,
        index: end == EngineRunState.finished ? 16 : 3,
        remainingMs: 0,
        activeMs: 240000,
        results: [
          for (var i = 0; i < (end == EngineRunState.finished ? 16 : 3); i++)
            phaseResult(i, i == 0 ? 10000 : (i.isOdd ? 20000 : 10000)),
        ],
      ),
    );
    await frames(tester, 8);
    await tester.pumpAndSettle();
    await tester.runAsync(() async {
      final s = (await db.sessionsDao.findById(id))!;
      await (db.update(db.sessions)..where((t) => t.id.equals(id))).write(
        SessionsCompanion(
          startedAt: Value(s.endedAt!.subtract(Duration(minutes: minutes))),
          pausedSeconds: const Value(0),
        ),
      );
    });
    return id;
  }

  Future<void> tapDone(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('summary-done')));
    await frames(tester, 10);
    await tester.pumpAndSettle();
  }

  testWidgets('apagado por defecto: no se carga ni se muestra', (tester) async {
    await pump(tester, flag: false);
    await runToSummary(tester, minutes: 30);
    await tapDone(tester);
    expect(ads.calls, isNot(contains('loadInterstitial')));
    expect(ads.interstitialsShown, 0);
  });

  testWidgets('con el indicador: precargado y mostrado tras «Listo» en una '
      'sesión completada de 5 min', (tester) async {
    await pump(tester, flag: true);
    // R-A4: se precarga al abrir, no al terminar.
    expect(ads.calls, contains('loadInterstitial'));
    await runToSummary(tester, minutes: 5);
    // En el resumen todavía no (nunca automáticamente).
    expect(ads.interstitialsShown, 0);
    await tapDone(tester);
    expect(ads.interstitialsShown, 1);
    expect(find.byKey(const Key('template-tabata')), findsOneWidget);
    // Se vuelve a precargar para la próxima.
    expect(
      ads.calls.where((c) => c == 'loadInterstitial').length,
      greaterThanOrEqualTo(2),
    );
  });

  testWidgets('con el indicador: no tras menos de 5 min, ni al descartar, '
      'ni tras una incompleta', (tester) async {
    await pump(tester, flag: true);
    await runToSummary(tester, minutes: 4);
    await tapDone(tester);
    expect(ads.interstitialsShown, 0);

    await runToSummary(tester, minutes: 20);
    await tester.tap(find.byKey(const Key('summary-discard')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('discard-confirm')));
    await frames(tester);
    await tester.pumpAndSettle();
    expect(ads.interstitialsShown, 0);

    await runToSummary(tester, minutes: 20, end: EngineRunState.stopped);
    await tapDone(tester);
    expect(ads.interstitialsShown, 0);
  });

  testWidgets('con el indicador, si no cargó no se muestra ni se espera', (
    tester,
  ) async {
    ads.fillInterstitial = false;
    await pump(tester, flag: true);
    await runToSummary(tester, minutes: 30);
    await tapDone(tester);
    expect(ads.interstitialsShown, 0);
    expect(find.byKey(const Key('template-tabata')), findsOneWidget);
  });
}
