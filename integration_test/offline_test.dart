import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:trainloop/data/db/enums.dart';
import 'package:trainloop/features/intervals/presentation/timer_screen.dart';
import 'package:trainloop/features/monetization/presentation/ad_banner.dart';

import 'helpers.dart';

/// NF-05: sin red, todo funciona. Usa AdMob, UMP y Play Billing **reales**.
/// Correr con el modo avión activado:
///
/// ```sh
/// adb shell cmd connectivity airplane-mode enable
/// flutter test integration_test/offline_test.dart -d <id>
/// adb shell cmd connectivity airplane-mode disable
/// ```
///
/// Con red (p. ej. en Test Lab) el recorrido pasa igual, pero no prueba
/// NF-05: lo avisa en el registro.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('sin red: abre, corre una sesión y la guarda, sin huecos', (
    tester,
  ) async {
    final online = await _online();
    if (online) {
      debugPrint('AVISO: hay red; este recorrido no prueba NF-05.');
    }
    final db = openDatabaseFile(await freshDatabaseFile('offline'));
    addTearDown(db.close);
    await pumpRealApp(
      tester,
      database: db,
      settings: await firstRunSettings(),
      realAds: true,
    );
    await waitFor(tester, find.byKey(const Key('template-tabata')));
    // UMP y el SDK fallan sin red: sin banner y sin hueco.
    await settle(tester, const Duration(seconds: 5));
    if (!online) {
      expect(find.byKey(const Key('ad-banner')), findsNothing);
      for (final slot in find.byType(AdBanner).evaluate()) {
        expect(tester.getSize(find.byWidget(slot.widget)).height, 0);
      }
    }

    await tapWhenVisible(tester, find.byKey(const Key('template-tabata')));
    await tapWhenVisible(tester, find.byKey(const Key('detail-start')));
    await skipNotificationRationale(tester);
    await waitFor(tester, find.byType(TimerScreen));
    await settle(tester, const Duration(seconds: 2));
    for (var i = 0; i < 16; i++) {
      final skip = find.byKey(const Key('timer-skip'));
      if (skip.evaluate().isEmpty) break;
      await tester.tap(skip);
      await settle(tester, const Duration(milliseconds: 700));
    }
    await tapWhenVisible(tester, find.byKey(const Key('summary-done')));
    await waitFor(tester, find.byKey(const Key('template-tabata')));
    final session = (await db.select(db.sessions).get()).single;
    expect(session.status, SessionStatus.completed);
    expect(tester.takeException(), isNull);
  });
}

Future<bool> _online() async {
  try {
    final r = await InternetAddress.lookup(
      'googleads.g.doubleclick.net',
    ).timeout(const Duration(seconds: 3));
    return r.isNotEmpty;
  } catch (_) {
    return false;
  }
}
