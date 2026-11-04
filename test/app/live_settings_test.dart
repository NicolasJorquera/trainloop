import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/core/theme/accent.dart';
import 'package:trainloop/features/home/presentation/home_screen.dart';
import 'package:trainloop/features/settings/domain/app_settings.dart';
import 'package:trainloop/features/settings/presentation/settings_screen.dart';

import '../helpers/pump_app.dart';

Future<void> _openSettings(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('open-settings')));
  await tester.pumpAndSettle();
}

Future<void> _tapAndSettle(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('tema, acento e idioma repintan sin reiniciar', (tester) async {
    useTallViewport(tester);
    // Configuración entera a la vista: el título no sale de pantalla.
    tester.view.physicalSize = const Size(420, 5000);
    final repo = await pumpTrainloop(tester);
    await _openSettings(tester);
    final settings = find.byType(SettingsScreen);
    final settingsState = tester.element(settings);

    // Tema: Sistema (claro en pruebas) → Oscuro.
    expect(themeOf(tester, settings).brightness, Brightness.light);
    await _tapAndSettle(tester, find.text('Dark'));
    expect(themeOf(tester, settings).brightness, Brightness.dark);
    expect(colorsOf(tester, settings).bg, const Color(0xFF0E0F11));

    // Acento: Orquídea → Lima, incluidas las fases.
    expect(
      colorsOf(tester, settings).accent,
      AccentPreset.orquidea.swatch.dark,
    );
    await _tapAndSettle(tester, find.byKey(const ValueKey('accent-lima')));
    final c = colorsOf(tester, settings);
    expect(c.accent, AccentPreset.lima.swatch.dark);
    expect(c.phases.work.background, AccentPreset.lima.swatch.dark);
    expect(c.phases.rest.background, const Color(0xFF4D9FFF));

    // Idioma: inglés → español → portugués.
    expect(find.text('SETTINGS'), findsOneWidget);
    await _tapAndSettle(tester, find.byKey(const ValueKey('language-es')));
    expect(find.text('AJUSTES'), findsOneWidget);
    expect(
      Localizations.localeOf(tester.element(settings)),
      const Locale('es', '419'),
    );
    await _tapAndSettle(tester, find.byKey(const ValueKey('language-ptBR')));
    expect(find.text('CONFIGURAÇÕES'), findsOneWidget);

    // Sin reinicio: la misma pantalla sigue montada y la pila se conserva.
    expect(tester.element(settings), same(settingsState));
    await tester.tap(find.byKey(const Key('settings-back')));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('INÍCIO'), findsOneWidget);
    expect(
      themeOf(tester, find.byType(HomeScreen)).brightness,
      Brightness.dark,
    );

    // Y quedó guardado.
    expect(
      repo.value,
      const AppSettings(
        theme: ThemePreference.dark,
        accent: AccentPreset.lima,
        language: AppLanguage.ptBR,
      ),
    );
  });

  testWidgets('arranca con las preferencias guardadas', (tester) async {
    await pumpTrainloop(
      tester,
      settings: const AppSettings(
        theme: ThemePreference.light,
        accent: AccentPreset.azul,
        language: AppLanguage.es,
      ),
    );
    final home = find.byType(HomeScreen);
    expect(find.text('INICIO'), findsOneWidget);
    expect(themeOf(tester, home).brightness, Brightness.light);
    expect(colorsOf(tester, home).accent, AccentPreset.azul.swatch.light);
  });
}
