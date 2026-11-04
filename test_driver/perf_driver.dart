import 'package:flutter_driver/flutter_driver.dart' as driver;
import 'package:integration_test/integration_test_driver.dart';

/// Guarda la línea de tiempo de `integration_test/perf_test.dart` y su
/// resumen (cuadros lentos, percentiles de build y raster) en `build/`.
Future<void> main() => integrationDriver(
  responseDataCallback: (data) async {
    if (data == null) return;
    for (final key in data.keys) {
      final timeline = driver.Timeline.fromJson(
        data[key] as Map<String, dynamic>,
      );
      final summary = driver.TimelineSummary.summarize(timeline);
      await summary.writeTimelineToFile(
        key,
        pretty: true,
        includeSummary: true,
      );
    }
  },
);
