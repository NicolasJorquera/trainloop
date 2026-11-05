import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:trainloop/features/intervals/presentation/timer_screen.dart';

import 'helpers.dart';

/// Rendimiento de S05 en marcha (~20 s) con la línea de tiempo de Flutter.
/// Solo tiene sentido en modo profile:
///
/// ```sh
/// flutter drive --profile --driver=test_driver/perf_driver.dart \
///   --target=integration_test/perf_test.dart -d <id>
/// ```
///
/// El resumen queda en `build/s05_timeline.timeline_summary.json`.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('S05 en marcha 20 s', (tester) async {
    final db = openDatabaseFile(await freshDatabaseFile('perf'));
    addTearDown(db.close);
    await pumpRealApp(tester, database: db, settings: await firstRunSettings());
    await tapWhenVisible(tester, find.byKey(const Key('template-tabata')));
    await tapWhenVisible(tester, find.byKey(const Key('detail-start')));
    await skipNotificationRationale(tester);
    await waitFor(tester, find.byType(TimerScreen));

    // Cuadros reales: la app dibuja a su ritmo, sin el reloj de la prueba.
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
    await binding.traceAction(() async {
      await Future<void>.delayed(const Duration(seconds: 20));
    }, reportKey: 's05_timeline');

    // Detener: mantener 1,5 s.
    final hold = await tester.startGesture(
      tester.getCenter(find.byKey(const Key('timer-hold-stop'))),
    );
    await Future<void>.delayed(const Duration(seconds: 2));
    await hold.up();
    await settle(tester, const Duration(seconds: 2));
  });
}
