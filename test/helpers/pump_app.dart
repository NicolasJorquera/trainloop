import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/app/app.dart';
import 'package:trainloop/core/theme/theme_context.dart';
import 'package:trainloop/core/theme/tokens.dart';
import 'package:trainloop/data/db/database_providers.dart';
import 'package:trainloop/features/settings/application/settings_controller.dart';
import 'package:trainloop/features/settings/data/settings_repository.dart';
import 'package:trainloop/features/settings/domain/app_settings.dart';

import 'test_database.dart';

/// Monta la app completa con preferencias y base en memoria.
Future<InMemorySettingsRepository> pumpTrainloop(
  WidgetTester tester, {
  AppSettings settings = const AppSettings(),
}) async {
  final repo = InMemorySettingsRepository(settings);
  final db = openTestDatabase();
  addTearDown(db.close);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(repo),
        appDatabaseProvider.overrideWithValue(db),
      ],
      child: const TrainloopApp(),
    ),
  );
  await tester.pumpAndSettle();
  return repo;
}

/// Viewport alto para que las listas construyan todo su contenido.
void useTallViewport(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(420, 2400)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

ThemeData themeOf(WidgetTester tester, Finder finder) =>
    Theme.of(tester.element(finder));

TlColors colorsOf(WidgetTester tester, Finder finder) =>
    tester.element(finder).colors;
