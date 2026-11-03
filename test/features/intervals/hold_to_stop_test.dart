import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/core/theme/accent.dart';
import 'package:trainloop/core/theme/app_theme.dart';
import 'package:trainloop/features/intervals/presentation/timer_screen.dart';

void main() {
  Future<List<int>> pump(WidgetTester tester, {bool enabled = true}) async {
    final stops = <int>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTrainloopTheme(Brightness.dark, AccentPreset.orquidea),
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 300,
              child: HoldToStopButton(
                label: 'STOP',
                semanticLabel: 'Hold',
                color: Colors.white,
                enabled: enabled,
                onStop: () => stops.add(1),
              ),
            ),
          ),
        ),
      ),
    );
    return stops;
  }

  testWidgets('soltar antes de 1 s no detiene', (tester) async {
    final stops = await pump(tester);
    final g = await tester.startGesture(tester.getCenter(find.text('STOP')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));
    await g.up();
    await tester.pump(const Duration(seconds: 1));
    expect(stops, isEmpty);
  });

  testWidgets('mantener 1 s detiene una vez', (tester) async {
    final stops = await pump(tester);
    final g = await tester.startGesture(tester.getCenter(find.text('STOP')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1050));
    await g.up();
    await tester.pump();
    expect(stops, [1]);
  });

  testWidgets('desactivado (controles bloqueados) no detiene', (tester) async {
    final stops = await pump(tester, enabled: false);
    final g = await tester.startGesture(tester.getCenter(find.text('STOP')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1500));
    await g.up();
    expect(stops, isEmpty);
  });
}
