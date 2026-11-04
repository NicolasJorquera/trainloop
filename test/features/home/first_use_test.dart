import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/features/settings/domain/app_settings.dart';

import '../../helpers/fake_timer_engine.dart';
import '../../helpers/pump_app.dart';

/// F-01 y NF-01: primer uso sin cuenta ni formularios. Desde la primera
/// apertura (sin permiso de notificaciones ni explicación vista) hasta el
/// temporizador corriendo se cuentan los toques dentro de la app.
void main() {
  testWidgets('primera apertura: Tabata corriendo en 3 toques, 0 formularios', (
    tester,
  ) async {
    useTallViewport(tester);
    final engine = FakeTimerEngine()
      ..granted = false
      ..promptShown = false;
    await pumpTrainloop(
      tester,
      engine: engine,
      settings: const AppSettings(language: AppLanguage.es),
    );

    // Inicio listo: accesos directos, plantillas y el aviso de una línea.
    expect(find.byKey(const Key('home-start-intervals')), findsOneWidget);
    expect(find.byKey(const Key('home-start-strength')), findsOneWidget);
    expect(find.byKey(const Key('template-tabata')), findsOneWidget);
    expect(find.byKey(const Key('home-local-data')), findsOneWidget);
    // Ningún formulario: no hay campos de texto.
    expect(find.byType(EditableText), findsNothing);

    var taps = 0;
    Future<void> tap(String key) async {
      taps++;
      expect(find.byType(EditableText), findsNothing);
      await tester.tap(find.byKey(Key(key)));
      await tester.pumpAndSettle();
    }

    await tap('template-tabata');
    await tap('detail-start');
    // Explicación única del permiso (S18-a) y luego el diálogo del sistema
    // (fuera de la app: +1 toque en el teléfono).
    await tap('notify-continue');
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(engine.calls, contains('start'));
    expect(find.byKey(const Key('timer-phase')), findsOneWidget);
    expect(taps, 3);
  });

  testWidgets('el aviso de datos locales se cierra para siempre', (
    tester,
  ) async {
    useTallViewport(tester);
    final settings = await pumpTrainloop(
      tester,
      settings: const AppSettings(language: AppLanguage.es),
    );
    expect(
      find.textContaining(
        'Tus datos viven solo en este teléfono.',
        findRichText: true,
      ),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('home-local-data-dismiss')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('home-local-data')), findsNothing);
    expect(settings.value.localDataNoticeDismissed, isTrue);
  });

  testWidgets('tocar el aviso abre Respaldo (S17)', (tester) async {
    useTallViewport(tester);
    await pumpTrainloop(
      tester,
      settings: const AppSettings(language: AppLanguage.es),
    );
    await tester.tap(find.byKey(const Key('home-local-data-open')));
    await tester.pumpAndSettle();
    expect(find.text('RESPALDO'), findsOneWidget);
  });
}
