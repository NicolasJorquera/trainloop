import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/core/units/weight_unit.dart';
import 'package:trainloop/features/routines/presentation/routine_editor_screen.dart';
import 'package:trainloop/features/settings/application/settings_controller.dart';
import 'package:trainloop/features/settings/domain/app_settings.dart';
import 'package:trainloop/features/train/presentation/train_screen.dart';

import '../../helpers/pump_app.dart';
import '../exercises/library_screen_test.dart' show tapVisible;

const _chest = [
  'bench_press_barbell',
  'incline_bench_press_dumbbell',
  'fly_dumbbell',
  'cable_crossover',
  'push_up',
];

Future<void> _openRoutines(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('nav-train')));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Fuerza'));
  await tester.pumpAndSettle();
}

/// Crea una rutina con los 5 ejercicios de pecho: nombre, buscar/filtrar,
/// marcar varios, agregar y guardar.
Future<void> _createChestRoutine(WidgetTester tester, String name) async {
  await tester.tap(find.byKey(const Key('new-routine')));
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(const Key('routine-name')), name);
  await tester.tap(find.byKey(const Key('routine-add-exercises')));
  await tester.pumpAndSettle();
  await tapVisible(tester, find.byKey(const Key('chip-chest')));
  for (final key in _chest) {
    await tester.tap(find.byKey(Key('exercise-$key')));
  }
  await tester.pumpAndSettle();
  expect(find.text('Agregar 5'), findsOneWidget);
  await tester.tap(find.byKey(const Key('library-add')));
  await tester.pumpAndSettle();
  expect(find.text('EJERCICIOS · 5'), findsOneWidget);
  await tester.tap(find.byKey(const Key('routine-save')));
  await settleDb(tester);
}

void main() {
  testWidgets('crea una rutina de 5 ejercicios con valores por defecto', (
    tester,
  ) async {
    useTallViewport(tester);
    await pumpTrainloop(
      tester,
      settings: const AppSettings(language: AppLanguage.es),
    );
    await _openRoutines(tester);
    await _createChestRoutine(tester, 'Pecho A');

    expect(find.byType(RoutineEditorScreen), findsNothing);
    expect(find.text('Pecho A'), findsOneWidget);
    expect(find.text('5 ejercicios'), findsOneWidget);

    // Al reabrirla conserva el orden de selección y los valores por defecto.
    await tester.tap(find.text('Pecho A'));
    await tester.pumpAndSettle();
    final rows = find.textContaining('descanso');
    expect(rows, findsNWidgets(5));
    expect(find.text('3 × 10 · descanso 2:30'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Press de banca con barra')).dy,
      lessThan(tester.getTopLeft(find.text('Flexiones de brazos')).dy),
    );

    // Editar el objetivo en la hoja y quitar un ejercicio.
    await tester.tap(find.text('Press de banca con barra'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Más: Series'));
    await tester.enterText(find.byKey(const Key('sheet-weight')), '60,5');
    await tester.tap(find.byKey(const Key('sheet-done')));
    await tester.pumpAndSettle();
    expect(find.text('4 × 10 · 60,5 kg · descanso 2:30'), findsOneWidget);
    await tester.tap(find.byKey(const Key('remove-entry-4')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('routine-save')));
    await settleDb(tester);
    expect(find.text('4 ejercicios'), findsOneWidget);
  });

  testWidgets('el peso objetivo se muestra en la unidad de la persona', (
    tester,
  ) async {
    useTallViewport(tester);
    await pumpTrainloop(
      tester,
      settings: const AppSettings(
        language: AppLanguage.en,
        weightUnit: WeightUnit.lb,
      ),
    );
    await tester.tap(find.byKey(const Key('nav-train')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Strength'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('new-routine')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('routine-add-exercises')));
    await tester.pumpAndSettle();
    await tapVisible(tester, find.byKey(const Key('chip-chest')));
    await tester.tap(find.byKey(const Key('exercise-bench_press_barbell')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('library-add')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Barbell bench press'));
    await tester.pumpAndSettle();
    expect(find.text('lb'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('sheet-weight')), '225');
    await tester.tap(find.byKey(const Key('sheet-done')));
    await tester.pumpAndSettle();
    expect(find.textContaining('225 lb'), findsOneWidget);
    await tester.tap(find.byKey(const Key('routine-save')));
    await settleDb(tester);

    // Con kg, la misma rutina muestra el peso convertido.
    final container = ProviderScope.containerOf(
      tester.element(find.byType(TrainScreen)),
    );
    await container
        .read(settingsControllerProvider.notifier)
        .setWeightUnit(WeightUnit.kg);
    await tester.tap(find.text('Routine 1'));
    await settleDb(tester);
    expect(find.textContaining('102.06 kg'), findsOneWidget);
  });

  testWidgets('duplicar, archivar con deshacer', (tester) async {
    useTallViewport(tester);
    await pumpTrainloop(
      tester,
      settings: const AppSettings(language: AppLanguage.es),
    );
    await _openRoutines(tester);
    await _createChestRoutine(tester, 'Pecho A');

    Future<void> menu(String name, String action) async {
      await tester.tap(find.byTooltip('Opciones de $name'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(action).last);
      await settleDb(tester);
    }

    await menu('Pecho A', 'Duplicar');
    expect(find.text('Pecho A (copia)'), findsOneWidget);
    expect(find.text('5 ejercicios'), findsNWidgets(2));

    await menu('Pecho A (copia)', 'Archivar');
    expect(find.text('Pecho A (copia)'), findsNothing);
    expect(find.text('«Pecho A (copia)» archivada'), findsOneWidget);

    await tester.tap(find.byKey(const Key('undo-archive')));
    await settleDb(tester);
    expect(find.text('Pecho A (copia)'), findsOneWidget);
  });

  testWidgets('volver con cambios sin guardar pregunta antes de descartar', (
    tester,
  ) async {
    useTallViewport(tester);
    await pumpTrainloop(
      tester,
      settings: const AppSettings(language: AppLanguage.es),
    );
    await _openRoutines(tester);

    // Sin cambios: vuelve directo.
    await tester.tap(find.byKey(const Key('new-routine')));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Volver'));
    await tester.pumpAndSettle();
    expect(find.byType(RoutineEditorScreen), findsNothing);

    // Con un nombre escrito: pregunta.
    await tester.tap(find.byKey(const Key('new-routine')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('routine-name')), 'Piernas');
    await tester.pump();
    await tester.tap(find.byTooltip('Volver'));
    await tester.pumpAndSettle();
    expect(find.text('¿DESCARTAR LOS CAMBIOS?'), findsOneWidget);
    await tester.tap(find.byKey(const Key('routine-discard-keep')));
    await tester.pumpAndSettle();
    expect(find.byType(RoutineEditorScreen), findsOneWidget);

    // El botón atrás del sistema también pregunta; descartar sale.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('routine-discard-confirm')));
    await tester.pumpAndSettle();
    expect(find.byType(RoutineEditorScreen), findsNothing);
    expect(find.text('PIERNAS'), findsNothing);
  });
}
