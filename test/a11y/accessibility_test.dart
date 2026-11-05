import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/data/db/app_database.dart';
import 'package:trainloop/data/db/demo_seed.dart';
import 'package:trainloop/features/history/application/history_providers.dart';
import 'package:trainloop/features/settings/domain/app_settings.dart';
import 'package:trainloop/platform/timer_engine_client.dart';

import '../fixtures/history_fixture.dart';
import '../helpers/fake_timer_engine.dart';
import '../helpers/pump_app.dart';
import '../helpers/test_database.dart';

// NF-08: texto al 200 % sin cortes, áreas táctiles (48 dp; 64 dp en S05 y
// S10) y etiquetas para TalkBack en las pantallas de J1–J3 y las de D7.
//
// Teléfono de 411 × 914 dp (1080 × 2400 a 2,625). Un desborde de un Row o
// Column al 200 % hace fallar la prueba (FlutterError de RenderFlex).

const _es = AppSettings(language: AppLanguage.es);

void phone(WidgetTester tester, {double textScale = 1}) {
  tester.view
    ..physicalSize = const Size(1080, 2400)
    ..devicePixelRatio = 2.625;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(() {
    tester.view.reset();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });
}

/// Recorre la lista principal de arriba abajo para construir todo (y
/// detectar desbordes en lo que está más abajo). Vuelve arriba al final.
Future<void> scrollThrough(WidgetTester tester) async {
  final lists = find.byWidgetPredicate(
    (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
  );
  if (lists.evaluate().isEmpty) return;
  final state = tester.state<ScrollableState>(lists.first);
  final position = state.position;
  final clipped = <String>{...clippedTexts(tester)};
  while (position.pixels < position.maxScrollExtent) {
    position.jumpTo(
      (position.pixels + 400).clamp(0, position.maxScrollExtent).toDouble(),
    );
    await tester.pump();
    clipped.addAll(clippedTexts(tester));
  }
  expect(clipped, isEmpty, reason: 'Textos cortados');
  position.jumpTo(0);
  await tester.pump();
}

/// Textos cortados (con «…» o líneas de menos): al 200 % no debe haber.
List<String> clippedTexts(WidgetTester tester) => [
  for (final p in tester.allRenderObjects.whereType<RenderParagraph>())
    if (p.didExceedMaxLines) p.text.toPlainText(),
];

/// 48 dp (Android) y una etiqueta en todo lo que se puede tocar.
Future<void> expectTapTargets(WidgetTester tester, {double min = 48}) async {
  await expectLater(
    tester,
    meetsGuideline(
      min == 48
          ? androidTapTargetGuideline
          : MinimumTapTargetGuideline(
              size: Size(min, min),
              link: 'NF-08: 64 dp durante la sesión',
            ),
    ),
  );
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
}

Future<void> settle(WidgetTester tester, [int n = 6]) async {
  for (var i = 0; i < n; i++) {
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump(const Duration(milliseconds: 50));
  }
}

/// Fuentes reales de la app (las pruebas usan por defecto una fuente de
/// cuadrados que mide distinto): así «cortado» significa lo mismo que en el
/// teléfono.
Future<void> loadAppFonts() async {
  for (final (family, files) in [
    ('Inter', ['Regular', 'Medium', 'SemiBold', 'Bold']),
    (
      'BarlowCondensed',
      ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold', 'ExtraBoldItalic'],
    ),
  ]) {
    final loader = FontLoader(family);
    for (final f in files) {
      loader.addFont(rootBundle.load('assets/fonts/$family-$f.ttf'));
    }
    await loader.load();
  }
}

void main() {
  setUpAll(loadAppFonts);

  late AppDatabase db;
  late FakeTimerEngine engine;

  setUp(() async {
    db = openTestDatabase();
    engine = FakeTimerEngine();
  });

  tearDown(() => db.close());

  Future<void> pump(WidgetTester tester, {double textScale = 1}) async {
    phone(tester, textScale: textScale);
    await tester.runAsync(() async {
      await buildHistoryFixture(db);
      await seedDemoData(db); // rutina «Empuje» con 3 series
    });
    await pumpTrainloop(
      tester,
      engine: engine,
      database: db,
      settings: _es,
      overrides: [clockProvider.overrideWithValue(() => HistoryFixture.now)],
    );
    await settle(tester);
  }

  Future<void> go(WidgetTester tester, String key) async {
    final target = find.byKey(Key(key));
    if (target.evaluate().isEmpty) {
      await tester.scrollUntilVisible(
        target,
        300,
        scrollable: find
            .byWidgetPredicate(
              (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
            )
            .first,
      );
    } else {
      await tester.ensureVisible(target);
    }
    await tester.pumpAndSettle();
    await tester.tap(target);
    await settle(tester);
    await tester.pumpAndSettle();
  }

  for (final scale in [1.0, 2.0]) {
    final pct = '${(scale * 100).round()} %';

    testWidgets('pestañas, Configuración y Respaldo al $pct', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(tester, textScale: scale);
      // Inicio (J1), Entrenar (J2, J3), Historial y Progreso.
      await scrollThrough(tester);
      if (scale == 1) await expectTapTargets(tester);
      for (final tab in ['nav-train', 'nav-history', 'nav-progress']) {
        await go(tester, tab);
        await scrollThrough(tester);
        if (scale == 1) await expectTapTargets(tester);
      }
      await go(tester, 'nav-train');
      await tester.tap(find.text('Fuerza'));
      await settle(tester);
      await scrollThrough(tester);
      // S07 editor de rutina (J3).
      await go(tester, 'new-routine');
      await scrollThrough(tester);
      if (scale == 1) await expectTapTargets(tester);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      // S16 y S17.
      await go(tester, 'nav-home');
      await go(tester, 'open-settings');
      await scrollThrough(tester);
      if (scale == 1) await expectTapTargets(tester);
      await tester.scrollUntilVisible(
        find.byKey(const Key('settings-backup')),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await go(tester, 'settings-backup');
      await scrollThrough(tester);
      if (scale == 1) await expectTapTargets(tester);
      handle.dispose();
    });

    testWidgets('J1: Tabata (S03 y S05) al $pct', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(tester, textScale: scale);
      await go(tester, 'template-tabata');
      await scrollThrough(tester);
      if (scale == 1) await expectTapTargets(tester);
      await tester.tap(find.byKey(const Key('detail-start')));
      await settle(tester, 12);
      expect(find.byKey(const Key('timer-phase')), findsOneWidget);
      final id = engine.program!.sessionId;
      engine.emit(
        engineState(
          id,
          index: 1,
          remainingMs: 20000,
          positionMs: 10000,
          results: [phaseResult(0, 10000)],
        ),
      );
      await settle(tester);
      expect(clippedTexts(tester), isEmpty, reason: 'Textos cortados en S05');
      // S05: controles de la sesión de 64 dp y con etiqueta.
      await expectTapTargets(tester, min: 64);
      // La fase se anuncia con su nombre, no solo con el color.
      expect(
        find.bySemanticsLabel(RegExp('TRABAJO', caseSensitive: false)),
        findsWidgets,
      );
      handle.dispose();
    });

    testWidgets('J3: sesión de fuerza (S10) al $pct', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(tester, textScale: scale);
      await go(tester, 'nav-train');
      await tester.tap(find.text('Fuerza'));
      await settle(tester);
      final routine = await tester.runAsync(
        () => db.select(db.strengthRoutines).getSingle(),
      );
      await go(tester, 'routine-start-${routine!.id}');
      await settle(tester, 12);
      expect(find.byKey(const Key('strength-title')), findsOneWidget);
      final id = engine.strengthProgram!.sessionId;
      engine.emitStrength(
        StrengthEngineState(
          sessionId: id,
          rest: RestRunState.running,
          restRemainingMs: 60000,
          restDurationMs: 90000,
          receivedAt: engine.now,
        ),
      );
      await settle(tester);
      expect(clippedTexts(tester), isEmpty, reason: 'Textos cortados en S10');
      await scrollThrough(tester);
      await expectTapTargets(tester, min: 64);
      handle.dispose();
    });
  }
}
