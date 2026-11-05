import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/app/app.dart';
import 'package:trainloop/core/units/weight_unit.dart';
import 'package:trainloop/data/catalog/exercise_catalog_seeder.dart';
import 'package:trainloop/data/db/app_database.dart';
import 'package:trainloop/features/monetization/application/ad_guard_provider.dart';
import 'package:trainloop/features/routines/data/routine_repository.dart';
import 'package:trainloop/features/routines/domain/routine_draft.dart';
import 'package:trainloop/features/settings/domain/app_settings.dart';
import 'package:trainloop/features/strength/data/strength_session_repository.dart';
import 'package:trainloop/platform/timer_engine_client.dart';

import '../../helpers/fake_monetization.dart';
import '../../helpers/fake_timer_engine.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/test_database.dart';

/// Criterio de D8: ningún anuncio en sesión (R-A1, R-A11). Recorre una
/// sesión de intervalos y una de fuerza desde «Empezar» hasta salir del
/// resumen y verifica, en cada cuadro, que el guard central no permite
/// ningún anuncio y que no hay ningún banner montado (ni siquiera debajo de
/// la pantalla visible).
void main() {
  late FakeTimerEngine engine;
  late FakeAdsPlatform ads;
  late AppDatabase db;
  late String routineId;

  const banner = Key('fake-ad-banner');

  setUp(() async {
    engine = FakeTimerEngine();
    // AdMob siempre tiene un banner listo: si el guard fallara, se vería.
    ads = FakeAdsPlatform(fillBanner: true);
    db = openTestDatabase();
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

  /// Decisiones del guard registradas mientras [inSession].
  late List<String> violations;
  var inSession = false;

  Future<ProviderContainer> pump(WidgetTester tester) async {
    useTallViewport(tester);
    await pumpTrainloop(
      tester,
      engine: engine,
      database: db,
      ads: ads,
      settings: const AppSettings(language: AppLanguage.es),
    );
    final container = ProviderScope.containerOf(
      tester.element(find.byType(TrainloopApp)),
    );
    violations = [];
    inSession = false;
    void watch(String name, ProviderListenable<AdDecision> p) {
      container.listen<AdDecision>(p, (_, d) {
        if (inSession && d.allowed) violations.add(name);
      }, fireImmediately: true);
    }

    watch('banner-tabs', bannerDecisionProvider(BannerPlacement.tabs));
    watch('banner-library', bannerDecisionProvider(BannerPlacement.library));
    watch('interstitial', interstitialDecisionProvider);
    return container;
  }

  Future<void> frames(WidgetTester tester, [int n = 6]) async {
    for (var i = 0; i < n; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  /// Ningún anuncio permitido ni montado (también fuera de escena).
  void expectNoAds(ProviderContainer c, String step) {
    for (final p in [
      bannerDecisionProvider(BannerPlacement.tabs),
      bannerDecisionProvider(BannerPlacement.library),
      interstitialDecisionProvider,
    ]) {
      expect(c.read(p).allowed, isFalse, reason: '$step: $p');
    }
    expect(find.byKey(banner, skipOffstage: false), findsNothing, reason: step);
    expect(ads.liveBanners, 0, reason: '$step: banner sin descartar');
    expect(violations, isEmpty, reason: step);
  }

  void expectBannerOnHome(ProviderContainer c) {
    expect(
      c.read(bannerDecisionProvider(BannerPlacement.tabs)).allowed,
      isTrue,
    );
    expect(find.byKey(banner), findsOneWidget);
  }

  testWidgets('intervalos: de EMPEZAR a salir del resumen, ningún anuncio', (
    tester,
  ) async {
    final c = await pump(tester);
    // Antes: Inicio tiene banner (el guard no está siempre cerrado).
    expectBannerOnHome(c);

    // S03 (detalle) tampoco lleva banner.
    await tester.tap(find.byKey(const Key('template-tabata')));
    await tester.pumpAndSettle();
    inSession = true;
    expectNoAds(c, 'S03');

    await tester.tap(find.byKey(const Key('detail-start')));
    await frames(tester);
    expectNoAds(c, 'EMPEZAR');
    await tester.pump(const Duration(milliseconds: 600));
    final id = engine.program!.sessionId;
    expect(find.byKey(const Key('timer-phase')), findsOneWidget);
    expectNoAds(c, 'S05 corriendo');

    engine.emit(
      engineState(
        id,
        state: EngineRunState.paused,
        index: 3,
        remainingMs: 5000,
        receivedAt: engine.now,
      ),
    );
    await frames(tester);
    expectNoAds(c, 'S05 en pausa');

    engine.emit(
      engineState(
        id,
        state: EngineRunState.finished,
        index: 16,
        remainingMs: 0,
        activeMs: 240000,
        results: [
          for (var i = 0; i < 16; i++)
            phaseResult(i, i == 0 ? 10000 : (i.isOdd ? 20000 : 10000)),
        ],
      ),
    );
    await frames(tester, 8);
    await tester.pumpAndSettle();
    expect(find.text('¡Sesión completa!'), findsOneWidget);
    expectNoAds(c, 'S06 resumen');

    // «Listo» sale del resumen: desde ahí vuelven a estar permitidos.
    inSession = false;
    await tester.tap(find.byKey(const Key('summary-done')));
    await frames(tester);
    await tester.pumpAndSettle();
    // Fuera del resumen, en Inicio, el banner vuelve.
    expectBannerOnHome(c);
    expect(ads.interstitialsShown, 0);
  });

  testWidgets('fuerza: de ▶ a salir del resumen (S10, S11, descanso), '
      'ningún anuncio', (tester) async {
    final c = await pump(tester);
    await tester.tap(find.byKey(const Key('nav-train')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fuerza'));
    await frames(tester);
    // Entrenar tiene banner.
    expectBannerOnHome(c);

    inSession = true;
    await tester.tap(find.byKey(Key('routine-start-$routineId')));
    await tester.pump();
    expectNoAds(c, '▶');
    await frames(tester, 10);
    expect(engine.calls, contains('startStrength'));
    final id = engine.strengthProgram!.sessionId;
    expect(find.byKey(const Key('strength-title')), findsOneWidget);
    expectNoAds(c, 'S10');

    final data = (await tester.runAsync(
      () => StrengthSessionRepository(db).load(id),
    ))!;
    final sets = data.exercises.single.sets;
    await tester.tap(find.byKey(Key('set-check-${sets[0].id}')));
    await frames(tester);
    expectNoAds(c, 'serie registrada');
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
    expectNoAds(c, 'descanso');

    await tester.tap(find.byKey(Key('set-weight-${sets[1].id}')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('set-editor')), findsOneWidget);
    expectNoAds(c, 'S11');
    await tester.ensureVisible(find.byKey(const Key('set-save')));
    await tester.tap(find.byKey(const Key('set-save')));
    await frames(tester);
    expectNoAds(c, 'S11 guardada');

    await tester.tap(find.byKey(const Key('strength-finish')));
    await frames(tester);
    expectNoAds(c, 'TERMINAR');
    await tester.tap(find.byKey(const Key('pending-discard')));
    await frames(tester, 15);
    await tester.pumpAndSettle();
    expect(find.text('¡Sesión completa!'), findsOneWidget);
    expectNoAds(c, 'resumen de fuerza');

    // «Listo» sale del resumen: desde ahí vuelven a estar permitidos.
    inSession = false;
    await tester.tap(find.byKey(const Key('summary-done')));
    await frames(tester);
    await tester.pumpAndSettle();
    expectBannerOnHome(c);
  });
}
