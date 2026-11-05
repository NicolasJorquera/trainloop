import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/data/db/app_database.dart';
import 'package:trainloop/data/db/demo_seed.dart';
import 'package:trainloop/features/backup/application/backup_providers.dart';
import 'package:trainloop/features/backup/data/backup_repository.dart';
import 'package:trainloop/features/settings/data/settings_repository.dart';
import 'package:trainloop/features/settings/domain/app_settings.dart';

import '../../helpers/fake_platform.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late FakeDocumentsClient docs;

  setUp(() {
    db = openTestDatabase();
    docs = FakeDocumentsClient();
  });

  Future<InMemorySettingsRepository> open(WidgetTester tester) async {
    useTallViewport(tester);
    final repo = await pumpTrainloop(
      tester,
      database: db,
      documents: docs,
      settings: const AppSettings(language: AppLanguage.es),
      overrides: [
        backupRepositoryProvider.overrideWithValue(
          BackupRepository(db, appVersion: 'test'),
        ),
      ],
    );
    addTearDown(() => tester.runAsync(db.close));
    await tester.tap(find.byKey(const Key('open-settings')));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('settings-backup')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('sin respaldos'), findsOneWidget);
    await tester.tap(find.byKey(const Key('settings-backup')));
    await tester.pumpAndSettle();
    return repo;
  }

  testWidgets('crear respaldo guarda el archivo y la fecha', (tester) async {
    await tester.runAsync(() => seedDemoData(db));
    final settings = await open(tester);
    expect(find.text('RESPALDO'), findsOneWidget);
    expect(find.text('Todavía no creaste un respaldo.'), findsOneWidget);

    await tester.tap(find.byKey(const Key('backup-create')));
    await settleDb(tester);
    final name = docs.saved.keys.single;
    expect(name, matches(RegExp(r'^trainloop-\d{4}-\d{2}-\d{2}\.json\.gz$')));
    expect(find.text('Respaldo creado: $name'), findsOneWidget);
    expect(settings.value.lastBackup!.sessions, 1);
    expect(
      find.textContaining(RegExp(r'^Último respaldo: .* · 1 sesión · ')),
      findsOneWidget,
    );
  });

  testWidgets('cancelar el selector no cambia nada', (tester) async {
    docs.cancel = true;
    final settings = await open(tester);
    await tester.tap(find.byKey(const Key('backup-create')));
    await settleDb(tester);
    expect(docs.saved, isEmpty);
    expect(settings.value.lastBackup, isNull);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('restaurar muestra el resumen y pide confirmación', (
    tester,
  ) async {
    // Respaldo de otra base con 1 sesión y 1 rutina.
    final other = openTestDatabase();
    final bytes = await tester.runAsync(() async {
      await seedDemoData(other);
      final b = await BackupRepository(other, appVersion: 'x').create();
      await other.close();
      return b.bytes;
    });
    docs.toOpen = bytes;
    await open(tester);

    await tester.tap(find.byKey(const Key('backup-restore')));
    await settleDb(tester);
    expect(find.byKey(const Key('restore-dialog')), findsOneWidget);
    expect(
      find.textContaining('1 sesión, 1 rutina, 1 temporizador'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('restore-confirm')));
    await settleDb(tester);
    expect(find.text('Respaldo restaurado'), findsOneWidget);
    final routines = await tester.runAsync(
      () => db.select(db.strengthRoutines).get(),
    );
    expect(routines!.single.name, 'Empuje');
  });

  testWidgets('un archivo que no es respaldo se rechaza sin tocar nada', (
    tester,
  ) async {
    docs.toOpen = [1, 2, 3];
    await open(tester);
    await tester.tap(find.byKey(const Key('backup-restore')));
    await settleDb(tester);
    expect(find.byKey(const Key('restore-dialog')), findsNothing);
    expect(
      find.textContaining('no es un respaldo de Trainloop'),
      findsOneWidget,
    );
  });

  testWidgets('exportar CSV guarda sesiones y series', (tester) async {
    await tester.runAsync(() => seedDemoData(db));
    await open(tester);
    await tester.ensureVisible(find.byKey(const Key('backup-csv')));
    await tester.tap(find.byKey(const Key('backup-csv')));
    await settleDb(tester);
    expect(docs.saved.keys, hasLength(2));
    expect(docs.saved.keys.first, startsWith('trainloop-sessions-'));
    expect(docs.saved.keys.last, startsWith('trainloop-sets-'));
    expect(find.text('CSV exportado: sesiones y series'), findsOneWidget);
  });
}
