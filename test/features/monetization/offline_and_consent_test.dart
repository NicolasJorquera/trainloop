import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/app/app.dart';
import 'package:trainloop/core/router/app_router.dart';
import 'package:trainloop/data/db/enums.dart';
import 'package:trainloop/features/analytics/application/analytics_service.dart';
import 'package:trainloop/features/monetization/data/ads_platform.dart';
import 'package:trainloop/features/monetization/presentation/ad_banner.dart';
import 'package:trainloop/features/settings/domain/app_settings.dart';
import 'package:trainloop/platform/timer_engine_client.dart';

import '../../helpers/fake_monetization.dart';
import '../../helpers/fake_timer_engine.dart';
import '../../helpers/pump_app.dart';

/// Sin red, sin consentimiento o con el SDK fallando, la app funciona igual
/// (NF-05): sin errores, sin huecos y la sesión corre.
void main() {
  const banner = Key('fake-ad-banner');

  Future<ProviderContainer> pump(
    WidgetTester tester, {
    required FakeAdsPlatform ads,
    FakeInAppPurchase? iap,
    FakeTimerEngine? engine,
  }) async {
    useTallViewport(tester);
    await pumpTrainloop(
      tester,
      ads: ads,
      iap: iap,
      engine: engine,
      settings: const AppSettings(language: AppLanguage.es),
    );
    return ProviderScope.containerOf(tester.element(find.byType(TrainloopApp)));
  }

  Future<void> frames(WidgetTester tester, [int n = 6]) async {
    for (var i = 0; i < n; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  testWidgets('modo avión: UMP, SDK y Play fallan; la app abre y una sesión '
      'corre sin errores ni huecos', (tester) async {
    final engine = FakeTimerEngine();
    final ads = FakeAdsPlatform(
      fillBanner: true,
      failConsent: true,
      failInit: true,
      failLoad: true,
    );
    final play = FakeInAppPurchase(available: false, failRestore: true);
    addTearDown(play.close);
    final c = await pump(tester, ads: ads, iap: play, engine: engine);
    expect(tester.takeException(), isNull);
    expect(find.byKey(const Key('template-tabata')), findsOneWidget);
    expect(find.byKey(banner), findsNothing);
    expect(tester.getSize(find.byType(AdBanner)).height, 0);
    expect(ads.calls, isNot(contains('initialize')));
    expect(ads.calls, isNot(contains('loadBanner')));
    // Sin respuesta de UMP, la analítica queda apagada.
    expect(c.read(analyticsEnabledProvider), isFalse);

    // Tabata de principio a fin.
    await tester.tap(find.byKey(const Key('template-tabata')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('detail-start')));
    await frames(tester);
    await tester.pump(const Duration(milliseconds: 600));
    final id = engine.program!.sessionId;
    expect(find.byKey(const Key('timer-phase')), findsOneWidget);
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
    await tester.tap(find.byKey(const Key('summary-done')));
    await frames(tester);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('template-tabata')), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Comprar sin Play: un aviso, no un error.
    unawaited(c.read(routerProvider).push('/settings'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('remove-ads-buy')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.byKey(const Key('remove-ads-buy')));
    await tester.pumpAndSettle();
    expect(find.text('QUITAR ANUNCIOS'), findsOneWidget);
    await tester.tap(find.byKey(const Key('remove-ads-buy')));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Google Play no está disponible ahora. Revisa la conexión e '
        'inténtalo de nuevo.',
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('el SDK no inicia: sin banner y sin hueco', (tester) async {
    final ads = FakeAdsPlatform(fillBanner: true, failInit: true);
    await pump(tester, ads: ads);
    expect(ads.calls, contains('initialize'));
    expect(ads.calls, isNot(contains('loadBanner')));
    expect(tester.getSize(find.byType(AdBanner)).height, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('AdMob sin anuncio que dar: no queda hueco', (tester) async {
    final ads = FakeAdsPlatform();
    await pump(tester, ads: ads);
    expect(ads.calls, contains('loadBanner'));
    expect(find.byKey(banner), findsNothing);
    expect(tester.getSize(find.byType(AdBanner)).height, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('EEE: sin responder el formulario no hay anuncios ni '
      'analítica; «Preferencias de privacidad» lo vuelve a abrir', (
    tester,
  ) async {
    final ads =
        FakeAdsPlatform(
            fillBanner: true,
            consent: const ConsentSnapshot(
              state: ConsentStatus.required,
              canRequestAds: false,
              privacyOptionsRequired: true,
            ),
          )
          ..afterPrivacyOptions = const ConsentSnapshot(
            state: ConsentStatus.obtained,
            canRequestAds: true,
            privacyOptionsRequired: true,
          );
    final c = await pump(tester, ads: ads);
    // El formulario se pidió al abrir (sin sesión en curso).
    expect(ads.calls, contains('gatherConsent(form: true)'));
    expect(ads.calls, isNot(contains('initialize')));
    expect(find.byKey(banner), findsNothing);
    expect(c.read(analyticsEnabledProvider), isFalse);

    unawaited(c.read(routerProvider).push('/settings'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('settings-privacy-options')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(
      find.byKey(const Key('settings-privacy-options')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Preferencias de privacidad'), findsOneWidget);
    await tester.tap(find.byKey(const Key('settings-privacy-options')));
    await tester.pumpAndSettle();
    expect(ads.calls, contains('privacyOptions'));
    expect(ads.calls, contains('initialize'));
    expect(c.read(analyticsEnabledProvider), isTrue);

    // El interruptor de analítica la apaga aunque haya consentimiento.
    await tester.tap(find.byKey(const Key('settings-analytics')));
    await tester.pumpAndSettle();
    expect(c.read(analyticsEnabledProvider), isFalse);

    c.read(routerProvider).pop();
    await tester.pumpAndSettle();
    expect(find.byKey(banner), findsOneWidget);
  });
}
