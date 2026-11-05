import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/features/exercises/presentation/exercise_library_screen.dart';
import 'package:trainloop/features/settings/application/settings_controller.dart';
import 'package:trainloop/features/settings/domain/app_settings.dart';

import '../../helpers/pump_app.dart';

/// Abre la biblioteca desde Entrenar > Rutinas.
Future<void> openLibrary(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('nav-train')));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Fuerza'));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('open-library')));
  await tester.pumpAndSettle();
}

/// Toca un elemento que puede estar fuera de la vista (fila de chips).
Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('busca sin tildes y filtra por músculo, equipo y registro', (
    tester,
  ) async {
    useTallViewport(tester);
    await pumpTrainloop(
      tester,
      settings: const AppSettings(language: AppLanguage.es),
    );
    await openLibrary(tester);
    expect(find.byType(ExerciseLibraryScreen), findsOneWidget);

    await tester.enterText(find.byKey(const Key('library-search')), 'CUADRI');
    await tester.pumpAndSettle();
    expect(find.text('Extensión de cuádriceps'), findsOneWidget);
    expect(find.text('Plancha'), findsNothing);

    // Sin resultados: ofrece crear ese nombre.
    await tester.enterText(find.byKey(const Key('library-search')), 'zzz');
    await tester.pumpAndSettle();
    expect(find.text('No encontramos «zzz»'), findsOneWidget);
    expect(find.byKey(const Key('library-create-named')), findsOneWidget);

    await tester.enterText(find.byKey(const Key('library-search')), '');
    await tapVisible(tester, find.byKey(const Key('chip-core')));
    expect(find.text('Plancha'), findsOneWidget);
    expect(find.text('Press militar'), findsNothing);

    await tester.tap(find.byKey(const Key('filter-equipment')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Polea').last);
    await tester.pumpAndSettle();
    expect(find.text('Crunch en polea'), findsOneWidget);
    expect(find.text('Plancha'), findsNothing);

    await tester.tap(find.byKey(const Key('filter-equipment')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Todos').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('filter-logtype')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tiempo').last);
    await tester.pumpAndSettle();
    expect(find.text('Plancha'), findsOneWidget);
    expect(find.text('Plancha lateral'), findsOneWidget);
    expect(find.text('Abdominales'), findsNothing);
  });

  testWidgets('cambiar de idioma renombra la biblioteca al instante', (
    tester,
  ) async {
    useTallViewport(tester);
    await pumpTrainloop(
      tester,
      settings: const AppSettings(language: AppLanguage.es),
    );
    await openLibrary(tester);
    await tapVisible(tester, find.byKey(const Key('chip-chest')));
    expect(find.text('Press de banca con barra'), findsOneWidget);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(ExerciseLibraryScreen)),
    );
    await container
        .read(settingsControllerProvider.notifier)
        .setLanguage(AppLanguage.en);
    await tester.pumpAndSettle();
    expect(find.text('Press de banca con barra'), findsNothing);
    expect(find.text('Barbell bench press'), findsOneWidget);

    // La búsqueda usa el nombre visible del idioma activo.
    await tester.enterText(find.byKey(const Key('library-search')), 'bench');
    await tester.pumpAndSettle();
    expect(find.text('Barbell bench press'), findsOneWidget);
  });

  testWidgets('un ejercicio propio duplicado avisa y ofrece el existente', (
    tester,
  ) async {
    useTallViewport(tester);
    await pumpTrainloop(
      tester,
      settings: const AppSettings(language: AppLanguage.es),
    );
    await openLibrary(tester);
    await tester.enterText(find.byKey(const Key('library-search')), 'plank');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('library-create-named')));
    await tester.pumpAndSettle();

    // "plank" es el nombre en inglés de «Plancha».
    expect(find.byKey(const Key('exercise-duplicate')), findsOneWidget);
    expect(
      find.text('Ya existe «Plancha». ¿Usar el existente?'),
      findsOneWidget,
    );
    final save = tester.widget<InkWell>(
      find.descendant(
        of: find.byKey(const Key('exercise-save')),
        matching: find.byType(InkWell),
      ),
    );
    expect(save.onTap, isNull);

    await tester.enterText(
      find.byKey(const Key('exercise-name')),
      'Plancha con peso',
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('exercise-duplicate')), findsNothing);
    await tester.tap(find.byKey(const Key('exercise-save')));
    await settleDb(tester);

    // Vuelve a la biblioteca y el nuevo aparece como propio.
    await tester.enterText(find.byKey(const Key('library-search')), 'con peso');
    await tester.pumpAndSettle();
    expect(find.text('Plancha con peso'), findsOneWidget);
    expect(find.textContaining('Propio'), findsOneWidget);
  });
}
