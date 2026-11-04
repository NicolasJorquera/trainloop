import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/app/app.dart';
import 'package:trainloop/core/theme/theme_context.dart';
import 'package:trainloop/core/theme/tokens.dart';
import 'package:trainloop/data/db/app_database.dart';
import 'package:trainloop/data/db/database_providers.dart';
import 'package:trainloop/features/intervals/application/interval_providers.dart';
import 'package:trainloop/features/monetization/application/ads_controller.dart';
import 'package:trainloop/features/settings/application/settings_controller.dart';
import 'package:trainloop/features/settings/data/settings_repository.dart';
import 'package:trainloop/features/settings/domain/app_settings.dart';
import 'package:trainloop/platform/documents_client.dart';
import 'package:trainloop/platform/reminder_client.dart';

import 'fake_monetization.dart';
import 'fake_platform.dart';
import 'fake_timer_engine.dart';
import 'test_database.dart';

/// Monta la app completa con preferencias, base en memoria, un motor del
/// temporizador de prueba ([engine]) y anuncios y compras de prueba ([ads],
/// [iap]: sin red ni canales nativos; por defecto AdMob no devuelve banner).
Future<InMemorySettingsRepository> pumpTrainloop(
  WidgetTester tester, {
  AppSettings settings = const AppSettings(),
  FakeTimerEngine? engine,
  AppDatabase? database,
  FakeReminderClient? reminders,
  FakeDocumentsClient? documents,
  FakeAdsPlatform? ads,
  FakeInAppPurchase? iap,
  List<Override> overrides = const [],
}) async {
  final repo = InMemorySettingsRepository(settings);
  final db = database ?? openTestDatabase();
  // Desmontar antes de cerrar la base evita que una prueba fallida deje el
  // archivo colgado (ver `closeTestDatabase`).
  addTearDown(
    database == null
        ? () => closeTestDatabase(tester, db)
        : () => tester.pumpWidget(const SizedBox.shrink()),
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(repo),
        appDatabaseProvider.overrideWithValue(db),
        timerEngineClientProvider.overrideWithValue(
          engine ?? FakeTimerEngine(),
        ),
        reminderClientProvider.overrideWithValue(
          reminders ?? FakeReminderClient(),
        ),
        documentsClientProvider.overrideWithValue(
          documents ?? FakeDocumentsClient(),
        ),
        adsPlatformProvider.overrideWithValue(ads ?? FakeAdsPlatform()),
        inAppPurchaseProvider.overrideWithValue(iap ?? FakeInAppPurchase()),
        ...overrides,
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

/// Como `pumpAndSettle`, pero avanza también los timers de las escrituras en
/// la base (transacciones de Drift) aunque no haya cuadros pendientes.
Future<void> settleDb(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump(const Duration(milliseconds: 20));
  }
  await tester.pumpAndSettle();
}
