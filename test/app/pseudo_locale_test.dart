import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/core/l10n/pseudo.dart';
import 'package:trainloop/features/settings/domain/app_settings.dart';

import '../helpers/pump_app.dart';

/// Textos visibles que no vienen de l10n: con en-XA activo, todo texto
/// localizado lleva las marcas `[` `]`. Se ignoran los glifos de íconos.
List<String> unlocalizedTexts(WidgetTester tester) => [
  for (final rt in tester.widgetList<RichText>(find.byType(RichText)))
    if (rt.text.style?.fontFamily != 'MaterialIcons')
      if (rt.text.toPlainText() case final text when text.trim().isNotEmpty)
        if (!text.contains(pseudoOpen) || !text.contains(pseudoClose)) text,
];

void main() {
  testWidgets('el detector encuentra textos sin localizar', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Column(
          children: [Text('[Ļöçáļîžéð]'), Text('Hardcoded'), Icon(Icons.add)],
        ),
      ),
    );
    expect(unlocalizedTexts(tester), ['Hardcoded']);
  });

  testWidgets('con en-XA no hay textos fijos en pestañas ni Configuración', (
    tester,
  ) async {
    useTallViewport(tester);
    await pumpTrainloop(
      tester,
      settings: const AppSettings(language: AppLanguage.pseudo),
    );

    final screens = <String, List<String>>{};
    for (final tab in [
      'nav-home',
      'nav-train',
      'nav-history',
      'nav-progress',
    ]) {
      await tester.tap(find.byKey(Key(tab)));
      await tester.pumpAndSettle();
      screens[tab] = unlocalizedTexts(tester);
    }
    // Segunda vista de Entrenar.
    await tester.tap(find.byKey(const Key('nav-train')));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Ŕöûţîñéš'));
    await tester.pumpAndSettle();
    screens['train-routines'] = unlocalizedTexts(tester);

    await tester.tap(find.byKey(const Key('nav-home')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('open-settings')));
    await tester.pumpAndSettle();
    screens['settings'] = unlocalizedTexts(tester);

    for (final MapEntry(key: screen, value: texts) in screens.entries) {
      expect(texts, isEmpty, reason: 'Textos sin localizar en $screen');
    }
  });
}
