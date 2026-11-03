import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/core/l10n/pseudo.dart';
import 'package:trainloop/features/settings/domain/app_settings.dart';
import 'package:trainloop/platform/timer_engine_client.dart';

import '../helpers/fake_timer_engine.dart';
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

    // D3: biblioteca, ejercicio propio, editor de rutina y lista con datos.
    await tester.tap(find.byKey(const Key('open-library')));
    await tester.pumpAndSettle();
    screens['library'] = unlocalizedTexts(tester);
    await tester.enterText(find.byKey(const Key('library-search')), 'zzz');
    await tester.pumpAndSettle();
    screens['library-empty'] = unlocalizedTexts(tester);
    await tester.tap(find.byKey(const Key('library-create')));
    await tester.pumpAndSettle();
    screens['exercise-form'] = unlocalizedTexts(tester);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('new-routine')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('routine-add-exercises')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('chip-core')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('chip-core')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('exercise-plank')));
    await tester.tap(find.byKey(const Key('exercise-cable_crunch')));
    await tester.pumpAndSettle();
    screens['library-pick'] = unlocalizedTexts(tester);
    await tester.tap(find.byKey(const Key('library-add')));
    await tester.pumpAndSettle();
    screens['routine-editor'] = unlocalizedTexts(tester);
    await tester.tap(find.byKey(const Key('routine-save')));
    await settleDb(tester);
    screens['train-routine-list'] = unlocalizedTexts(tester);

    await tester.tap(find.byKey(const Key('nav-home')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('open-settings')));
    await tester.pumpAndSettle();
    screens['settings'] = unlocalizedTexts(tester);

    for (final MapEntry(key: screen, value: texts) in screens.entries) {
      expect(texts, isEmpty, reason: 'Textos sin localizar en $screen');
    }
  });

  testWidgets('con en-XA no hay textos fijos en los intervalos (D4)', (
    tester,
  ) async {
    useTallViewport(tester);
    final engine = FakeTimerEngine()
      ..granted = false
      ..promptShown = false
      ..restricted = true
      ..voice = false;
    await pumpTrainloop(
      tester,
      engine: engine,
      settings: const AppSettings(language: AppLanguage.pseudo, voice: true),
    );
    final screens = <String, List<String>>{};
    screens['home-templates'] = unlocalizedTexts(tester);

    await tester.tap(find.byKey(const Key('nav-train')));
    await tester.pumpAndSettle();
    screens['train-intervals'] = unlocalizedTexts(tester);

    await tester.tap(find.byKey(const Key('new-interval')));
    await tester.pumpAndSettle();
    screens['interval-editor'] = unlocalizedTexts(tester);
    await tester.tap(find.byKey(const Key('add-block')));
    await tester.pumpAndSettle();
    screens['interval-add-sheet'] = unlocalizedTexts(tester);
    await tester.tap(find.byKey(const Key('add-repeat')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('interval-save')));
    await settleDb(tester);
    screens['train-interval-list'] = unlocalizedTexts(tester);

    await tester.tap(find.byKey(const Key('template-walk_run')));
    await tester.pumpAndSettle();
    screens['template-detail'] = unlocalizedTexts(tester);
    await tester.tap(find.byKey(const Key('detail-start')));
    await tester.pumpAndSettle();
    screens['notify-dialog'] = unlocalizedTexts(tester);
    await tester.tap(find.byKey(const Key('notify-not-now')));
    await tester.pumpAndSettle();
    screens['battery-dialog'] = unlocalizedTexts(tester);
    await tester.tap(find.byKey(const Key('battery-later')));
    for (var i = 0; i < 6; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump(const Duration(milliseconds: 200));
    }
    screens['timer'] = unlocalizedTexts(tester);

    final id = engine.program!.sessionId;
    engine.emit(
      engineState(
        id,
        state: EngineRunState.paused,
        index: 2,
        count: engine.program!.phases.length,
        remainingMs: 60000,
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.byKey(const Key('timer-lock')));
    await tester.pump();
    screens['timer-paused-locked'] = unlocalizedTexts(tester);

    engine.emit(
      engineState(
        id,
        state: EngineRunState.stopped,
        index: 3,
        count: engine.program!.phases.length,
        remainingMs: 0,
        results: [
          phaseResult(0, 10000),
          phaseResult(1, 300000, actualMs: 9000),
        ],
      ),
    );
    for (var i = 0; i < 6; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.pumpAndSettle();
    screens['summary'] = unlocalizedTexts(tester);

    for (final MapEntry(key: screen, value: texts) in screens.entries) {
      expect(texts, isEmpty, reason: 'Textos sin localizar en $screen');
    }
    expect(find.byKey(const Key('summary-short')), findsOneWidget);
  });
}
