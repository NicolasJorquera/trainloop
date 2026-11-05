import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainloop/app/app.dart';
import 'package:trainloop/data/db/app_database.dart';
import 'package:trainloop/data/db/database_providers.dart';
import 'package:trainloop/features/monetization/application/ads_controller.dart';
import 'package:trainloop/features/settings/application/settings_controller.dart';
import 'package:trainloop/features/settings/data/settings_repository.dart';
import 'package:trainloop/features/settings/domain/app_settings.dart';

import '../test/helpers/fake_monetization.dart';

/// Base de un recorrido: un archivo propio en el teléfono (no toca
/// `trainloop.sqlite`), para empezar «de cero» o reabrir la misma.
Future<File> freshDatabaseFile(String name) async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/it-$name.sqlite');
  if (file.existsSync()) file.deleteSync();
  return file;
}

AppDatabase openDatabaseFile(File file) {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase(NativeDatabase.createInBackground(file));
}

/// Preferencias reales, vacías (primera apertura) y en español.
Future<SettingsRepository> firstRunSettings() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  final repo = SharedPreferencesSettingsRepository(prefs);
  await repo.save(const AppSettings(language: AppLanguage.es));
  return repo;
}

/// Monta la app como `main`, con el motor nativo, el SAF y los
/// recordatorios reales. Por defecto AdMob y Play Billing son de prueba
/// (sin red, deterministas); [realAds] usa los de verdad (NF-05).
Future<void> pumpRealApp(
  WidgetTester tester, {
  required AppDatabase database,
  required SettingsRepository settings,
  bool realAds = false,
  List<Override> overrides = const [],
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(settings),
        appDatabaseProvider.overrideWithValue(database),
        if (!realAds) ...[
          adsPlatformProvider.overrideWithValue(FakeAdsPlatform()),
          inAppPurchaseProvider.overrideWithValue(FakeInAppPurchase()),
        ],
        ...overrides,
      ],
      child: const TrainloopApp(),
    ),
  );
  await settle(tester);
}

/// Espera a que aparezca [finder] (hasta [timeout]) dejando correr la app:
/// el motor nativo y la base responden en tiempo real.
Future<void> waitFor(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 20),
}) async {
  final end = DateTime.now().add(timeout);
  while (finder.evaluate().isEmpty) {
    if (DateTime.now().isAfter(end)) {
      throw TestFailure('No apareció: $finder');
    }
    await tester.pump(const Duration(milliseconds: 200));
  }
}

/// Deja correr la app un rato (S05 y S10 repintan siempre: no se asientan).
Future<void> settle(
  WidgetTester tester, [
  Duration d = const Duration(seconds: 1),
]) async {
  final end = DateTime.now().add(d);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Toca [finder] tras esperarlo.
Future<void> tapWhenVisible(WidgetTester tester, Finder finder) async {
  await waitFor(tester, finder);
  await tester.ensureVisible(finder);
  await tester.pump();
  await tester.tap(finder);
  await settle(tester, const Duration(milliseconds: 600));
}

/// Si aparece la explicación del permiso de notificaciones (primera
/// sesión sin permiso), sigue sin pedirlo: el diálogo del sistema no se
/// puede tocar desde Flutter. En Test Lab se conceden con
/// `--grant-permissions=all` y no aparece.
Future<void> skipNotificationRationale(WidgetTester tester) async {
  await settle(tester, const Duration(seconds: 2));
  final rationale = find.byKey(const Key('notify-not-now'));
  if (rationale.evaluate().isNotEmpty) {
    await tester.tap(rationale);
    await settle(tester, const Duration(seconds: 2));
  }
}
