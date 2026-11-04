import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/app/app.dart';
import 'package:trainloop/core/router/app_router.dart';
import 'package:trainloop/data/db/app_database.dart';
import 'package:trainloop/data/db/database_providers.dart';
import 'package:trainloop/features/analytics/application/analytics_service.dart';
import 'package:trainloop/features/monetization/application/ad_guard_provider.dart';
import 'package:trainloop/features/monetization/application/ads_controller.dart';
import 'package:trainloop/features/monetization/application/remove_ads_controller.dart';
import 'package:trainloop/features/monetization/domain/monetization_config.dart';
import 'package:trainloop/features/settings/application/settings_controller.dart';
import 'package:trainloop/features/settings/data/settings_repository.dart';
import 'package:trainloop/features/settings/domain/app_settings.dart';

import '../../helpers/fake_monetization.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/test_database.dart';

/// Registra los eventos en memoria.
class RecordingSink implements AnalyticsSink {
  final events = <AnalyticsEvent>[];

  @override
  void log(AnalyticsEvent event) => events.add(event);

  @override
  void setEnabled(bool enabled) {}
}

/// Compra única «Sin anuncios» (F-15c) con un Play Billing falso.
void main() {
  late FakeInAppPurchase play;
  late List<AppDatabase> dbs;

  setUp(() {
    play = FakeInAppPurchase();
    dbs = [];
  });

  tearDown(() async {
    for (final db in dbs) {
      await db.close();
    }
    await play.close();
  });

  /// Una «instalación»: base propia y controlador nuevo; [play] es la
  /// cuenta de Google Play, compartida entre instalaciones.
  Future<ProviderContainer> install({RecordingSink? sink}) async {
    final db = openTestDatabase();
    dbs.add(db);
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        inAppPurchaseProvider.overrideWithValue(play),
        adsPlatformProvider.overrideWithValue(FakeAdsPlatform()),
        settingsRepositoryProvider.overrideWithValue(
          InMemorySettingsRepository(),
        ),
        if (sink != null) analyticsSinkProvider.overrideWithValue(sink),
      ],
    );
    addTearDown(c.dispose);
    c.listen(removeAdsControllerProvider, (_, _) {});
    // Consentimiento (para la analítica) y estado guardado.
    await c.read(adsControllerProvider.notifier).start(allowForm: true);
    await pumpEventQueue();
    return c;
  }

  RemoveAdsState state(ProviderContainer c) =>
      c.read(removeAdsControllerProvider);

  RemoveAdsController ctrl(ProviderContainer c) =>
      c.read(removeAdsControllerProvider.notifier);

  test('comprar quita los anuncios, se reconoce y se guarda', () async {
    final sink = RecordingSink();
    final c = await install(sink: sink);
    expect(state(c).owned, isFalse);

    await ctrl(c).loadProduct();
    expect(state(c).price, r'US$3.99');

    await ctrl(c).buy();
    await pumpEventQueue();
    expect(state(c).owned, isTrue);
    expect(state(c).flow, PurchaseFlow.purchased);
    expect(play.completed, [removeAdsProductId]);
    expect(play.calls, contains('buyNonConsumable'));
    final row = await c.read(adStateDaoProvider).read();
    expect(row.adsRemoved, isTrue);
    expect(sink.events, contains(AnalyticsEvent.removeAds('purchased')));

    // El guard ya no permite banner ni intersticial.
    final inputs = c.read(adGuardInputsProvider);
    expect(inputs.adsRemoved, isTrue);
  });

  test(
    'instalación nueva: se restaura al abrir y con «Restaurar compra»',
    () async {
      play.owned = true; // compró en otro teléfono
      final c = await install();
      expect(state(c).owned, isFalse);
      await ctrl(c).verifyWithStore();
      expect(state(c).owned, isTrue);
      expect(state(c).flow, PurchaseFlow.idle); // en silencio

      final c2 = await install();
      await ctrl(c2).restore();
      expect(state(c2).owned, isTrue);
      expect(state(c2).flow, PurchaseFlow.restored);
    },
  );

  test(
    'restaurar sin compra lo dice; Play revoca un estado local falso',
    () async {
      final c = await install();
      await ctrl(c).restore();
      expect(state(c).owned, isFalse);
      expect(state(c).flow, PurchaseFlow.nothingToRestore);

      // Un respaldo restaurado de otra cuenta trae ads_removed = true.
      await c
          .read(adStateDaoProvider)
          .write(const AdStatesCompanion(adsRemoved: Value(true)));
      c.invalidate(removeAdsControllerProvider);
      await pumpEventQueue();
      expect(state(c).owned, isTrue);
      // Al abrir, Play responde que esta cuenta no la tiene: su respuesta manda.
      await ctrl(c).verifyWithStore();
      expect(state(c).owned, isFalse);
      expect((await c.read(adStateDaoProvider).read()).adsRemoved, isFalse);
    },
  );

  test('sin red, quien compró sigue sin anuncios', () async {
    play.owned = true;
    final c = await install();
    await ctrl(c).verifyWithStore();
    expect(state(c).owned, isTrue);

    play
      ..available = false
      ..failRestore = true;
    final offline = await install();
    await offline
        .read(adStateDaoProvider)
        .write(const AdStatesCompanion(adsRemoved: Value(true)));
    offline.invalidate(removeAdsControllerProvider);
    await pumpEventQueue();
    await ctrl(offline).verifyWithStore();
    expect(state(offline).owned, isTrue);
    await ctrl(offline).restore();
    expect(state(offline).owned, isTrue);
    expect(state(offline).flow, PurchaseFlow.unavailable);
  });

  test('compra pendiente: anuncios hasta que Play la confirma', () async {
    play.buyResult = FakeBuyResult.pending;
    final c = await install();
    await ctrl(c).buy();
    await pumpEventQueue();
    expect(state(c).flow, PurchaseFlow.pending);
    expect(state(c).owned, isFalse);
    expect(play.completed, isEmpty);

    play.confirmPending();
    await pumpEventQueue();
    expect(state(c).owned, isTrue);
    expect(play.completed, [removeAdsProductId]);
  });

  test('cancelada o con error: nada cambia', () async {
    play.buyResult = FakeBuyResult.canceled;
    final c = await install();
    await ctrl(c).buy();
    await pumpEventQueue();
    expect(state(c).flow, PurchaseFlow.canceled);
    expect(state(c).owned, isFalse);

    play.buyResult = FakeBuyResult.error;
    await ctrl(c).buy();
    await pumpEventQueue();
    expect(state(c).flow, PurchaseFlow.error);
    expect(state(c).owned, isFalse);

    // Producto todavía sin crear en Play Console.
    play.productExists = false;
    final c2 = await install();
    await ctrl(c2).buy();
    expect(state(c2).flow, PurchaseFlow.unavailable);
  });

  testWidgets('S16: comprar oculta el banner de Inicio', (tester) async {
    final ads = FakeAdsPlatform(fillBanner: true);
    await pumpTrainloop(
      tester,
      ads: ads,
      iap: play,
      settings: const AppSettings(language: AppLanguage.es),
    );
    expect(find.byKey(const Key('fake-ad-banner')), findsOneWidget);
    final c = ProviderScope.containerOf(
      tester.element(find.byType(TrainloopApp)),
    );
    final router = c.read(routerProvider);
    unawaited(router.push('/settings'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('fake-ad-banner')), findsNothing);
    await tester.scrollUntilVisible(
      find.byKey(const Key('remove-ads-buy')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.byKey(const Key('remove-ads-buy')));
    await tester.pumpAndSettle();
    expect(find.text(r'QUITAR ANUNCIOS · US$3.99'), findsOneWidget);
    await tester.tap(find.byKey(const Key('remove-ads-buy')));
    await tester.pumpAndSettle();
    expect(
      find.text('Sin anuncios. ¡Gracias por apoyar Trainloop!'),
      findsOneWidget,
    );
    expect(find.byKey(const Key('remove-ads-buy')), findsNothing);

    router.pop();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('fake-ad-banner')), findsNothing);
    expect(ads.liveBanners, 0);
    expect(c.read(interstitialDecisionProvider).allowed, isFalse);
    expect(c.read(settingsControllerProvider).analytics, isTrue);
  });
}
