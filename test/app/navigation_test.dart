import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/features/history/presentation/history_screen.dart';
import 'package:trainloop/features/home/presentation/home_screen.dart';
import 'package:trainloop/features/progress/presentation/progress_screen.dart';
import 'package:trainloop/features/settings/presentation/settings_screen.dart';
import 'package:trainloop/features/train/presentation/train_screen.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('las 4 pestañas navegan', (tester) async {
    await pumpTrainloop(tester);
    expect(find.byType(HomeScreen), findsOneWidget);

    final tabs = <String, Type>{
      'nav-train': TrainScreen,
      'nav-history': HistoryScreen,
      'nav-progress': ProgressScreen,
      'nav-home': HomeScreen,
    };
    for (final MapEntry(key: key, value: screen) in tabs.entries) {
      await tester.tap(find.byKey(Key(key)));
      await tester.pumpAndSettle();
      expect(find.byType(screen), findsOneWidget, reason: key);
      for (final other in tabs.values.where((s) => s != screen)) {
        expect(find.byType(other), findsNothing, reason: '$key/$other');
      }
    }
  });

  testWidgets('cada pestaña conserva su estado al volver', (tester) async {
    await pumpTrainloop(tester);
    await tester.tap(find.byKey(const Key('nav-train')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Strength'));
    await tester.pumpAndSettle();
    expect(find.text('Your strength routines'), findsOneWidget);

    await tester.tap(find.byKey(const Key('nav-history')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav-train')));
    await tester.pumpAndSettle();
    expect(find.text('Your strength routines'), findsOneWidget);
  });

  testWidgets('cada botón de Inicio abre su vista de Entrenar', (tester) async {
    // Regresión: tras abrir FUERZA, INTERVALOS mostraba las rutinas (la
    // pestaña conservaba la vista anterior).
    await pumpTrainloop(tester);
    for (var i = 0; i < 2; i++) {
      await tester.tap(find.byKey(const Key('home-start-strength')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('new-routine')), findsOneWidget);
      expect(find.byKey(const Key('new-interval')), findsNothing);

      await tester.tap(find.byKey(const Key('nav-home')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('home-start-intervals')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('new-interval')), findsOneWidget);
      expect(find.byKey(const Key('new-routine')), findsNothing);

      // Elegir fuerza a mano tampoco se arrastra al botón INTERVALOS.
      await tester.tap(find.text('Strength'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('nav-home')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('home-start-intervals')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('new-interval')), findsOneWidget);
      await tester.tap(find.byKey(const Key('nav-home')));
      await tester.pumpAndSettle();
    }
  });

  testWidgets('Inicio lleva a Entrenar y abre Configuración', (tester) async {
    await pumpTrainloop(tester);
    await tester.tap(find.byKey(const Key('home-start-intervals')));
    await tester.pumpAndSettle();
    expect(find.byType(TrainScreen), findsOneWidget);

    await tester.tap(find.byKey(const Key('nav-home')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('open-settings')));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(find.byKey(const Key('nav-home')), findsNothing);

    await tester.tap(find.byKey(const Key('settings-back')));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
