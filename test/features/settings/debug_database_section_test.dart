import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/data/catalog/exercise_catalog.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('en depuración, Configuración muestra los conteos de la base y '
      'siembra datos de prueba', (tester) async {
    useTallViewport(tester);
    await pumpTrainloop(tester);
    await tester.tap(find.byKey(const Key('open-settings')));
    await tester.pumpAndSettle();

    final counts = find.byKey(const Key('debug-db-counts'));
    String text() => tester.widget<Text>(counts).data!;
    expect(text(), startsWith('0 exercises'));

    // D6 sumó inicio de semana, objetivo y la variante H5: el botón queda
    // más abajo.
    await tester.ensureVisible(find.byKey(const Key('debug-db-seed')));
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await tester.tap(find.byKey(const Key('debug-db-seed')));
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });
    // D6: Inicio e Historial escuchan la base (semana, historial); sus
    // consultas corren en el reloj falso y se alternan con la siembra.
    for (var i = 0; i < 20 && text().startsWith('0 '); i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump(const Duration(milliseconds: 50));
    }
    await tester.pumpAndSettle();
    // La siembra de prueba usa la biblioteca incluida.
    expect(
      text(),
      '${exerciseCatalog.length} exercises · 1 routines · 1 timers · '
      '1 sessions · 2 sets',
    );
  });
}
