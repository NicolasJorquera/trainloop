import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/features/diagnostics/application/error_handling.dart';
import 'package:trainloop/features/settings/domain/app_settings.dart';

import '../../helpers/fake_platform.dart';
import '../../helpers/pump_app.dart';

void main() {
  late ErrorLog log;
  late FakeDocumentsClient documents;

  // El registro se crea dentro de cada prueba: su cola de escrituras debe
  // vivir en la zona del reloj simulado.
  setUp(() => documents = FakeDocumentsClient());

  Future<void> openSettings(WidgetTester tester) async {
    useTallViewport(tester);
    // Configuración es larga: la fila queda casi al final.
    tester.view.physicalSize = const Size(420, 5000);
    await pumpTrainloop(
      tester,
      documents: documents,
      settings: const AppSettings(language: AppLanguage.es),
      overrides: [errorLogProvider.overrideWithValue(log)],
    );
    await tester.tap(find.byKey(const Key('open-settings')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('settings-error-log')));

    await tester.pumpAndSettle();
  }

  testWidgets('sin errores: lo dice y no abre el selector', (tester) async {
    log = ErrorLog.memory(appVersion: '1.0.0+1');
    await openSettings(tester);
    expect(find.text('Registro de errores'), findsOneWidget);
    expect(find.text('sin errores'), findsOneWidget);
    await tester.tap(find.byKey(const Key('settings-error-log')));
    await tester.pumpAndSettle();
    expect(find.text('No hay errores registrados.'), findsOneWidget);
    expect(documents.saved, isEmpty);
  });

  testWidgets('exporta el registro con el selector del sistema', (
    tester,
  ) async {
    log = ErrorLog.memory(appVersion: '1.0.0+1')
      ..record(StateError('uno'), null, source: ErrorSource.platform)
      ..record(StateError('dos'), null, source: ErrorSource.flutter);
    await openSettings(tester);
    expect(find.text('2 errores'), findsOneWidget);

    await tester.tap(find.byKey(const Key('settings-error-log')));
    await tester.pumpAndSettle();
    final name = documents.saved.keys.single;
    expect(name, matches(RegExp(r'^trainloop-errors-\d{4}-\d{2}-\d{2}\.txt$')));
    final text = utf8.decode(documents.saved[name]!);
    expect(text, contains('Bad state: uno'));
    expect(text, contains('Bad state: dos'));
    expect(find.text('Registro de errores guardado: $name'), findsOneWidget);
  });
}
