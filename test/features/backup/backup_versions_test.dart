import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/data/db/app_database.dart';
import 'package:trainloop/data/db/enums.dart';
import 'package:trainloop/features/backup/data/backup_codec.dart';
import 'package:trainloop/features/backup/data/backup_repository.dart';

import '../../fixtures/backup_fixtures.dart';
import '../../helpers/test_database.dart';

/// NF-06: los respaldos de versiones anteriores del esquema se restauran en
/// la versión actual. Los archivos están en `test/fixtures/backups/` y no
/// se regeneran en cada corrida (ver `BackupFixtures`).
void main() {
  if (Platform.environment['TL_WRITE_BACKUP_FIXTURES'] == '1') {
    test('regenera los respaldos de prueba', () async {
      await Directory(BackupFixtures.directory).create(recursive: true);
      for (final v in BackupFixtures.versions) {
        final json = await buildBackupFixture(v);
        await BackupFixtures.file(v).writeAsBytes(BackupCodec.encode(json));
      }
    });
    return;
  }

  late AppDatabase target;

  setUp(() async {
    target = openTestDatabase();
    // El teléfono no compró «Sin anuncios» y UMP no pide consentimiento.
    await target.adStateDao.write(
      const AdStatesCompanion(
        adsRemoved: Value(false),
        consentStatus: Value(ConsentStatus.notRequired),
      ),
    );
  });

  tearDown(() => target.close());

  Future<int> count(String table) => target
      .customSelect('SELECT COUNT(*) AS c FROM "$table"')
      .map((r) => r.read<int>('c'))
      .getSingle();

  for (final version in BackupFixtures.versions) {
    test('un respaldo del esquema v$version se restaura en la versión '
        'actual', () async {
      final bytes = BackupFixtures.file(version).readAsBytesSync();
      final repo = BackupRepository(target, appVersion: 'actual');
      final file = repo.read(bytes);
      expect(file.schemaVersion, version);
      expect(file.summary.sessions, greaterThan(0));
      expect(file.tables.keys, contains('ad_state'));

      await repo.restore(file);

      // Todas las filas llegan, salvo `ad_state`.
      for (final MapEntry(key: table, value: data) in file.tables.entries) {
        if (BackupCodec.localOnlyTables.contains(table)) continue;
        if (table == 'personal_record') continue; // caché, ver abajo
        final rows = ((data! as Map)['rows'] as List).length;
        expect(await count(table), rows, reason: table);
      }
      expect(await count('set_log'), greaterThan(0));
      expect(await count('interval_phase_log'), greaterThan(0));
      expect(await count('reminder'), greaterThan(0));
      expect(await count('plan_day'), greaterThan(0));

      // Récords en la forma actual (v5: con peso y reps).
      final records = await target.select(target.personalRecords).get();
      expect(records, isNotEmpty);
      expect(
        records.where((r) => r.type == RecordType.maxWeight),
        everyElement(
          predicate<PersonalRecord>((r) => r.weightGrams > 0 && r.reps != null),
        ),
      );

      // La compra y el consentimiento del teléfono no se pisan.
      final ad = await target.adStateDao.read();
      expect(ad.adsRemoved, isFalse);
      expect(ad.consentStatus, ConsentStatus.notRequired);
      expect(ad.sessionsSinceInterstitial, 0);

      // Las sesiones migradas se leen con los DAOs actuales.
      final sessions = await target.select(target.sessions).get();
      expect(sessions.map((s) => s.kind).toSet(), {
        SessionKind.strength,
        SessionKind.intervals,
      });
    });
  }

  test('un respaldo nuevo no lleva ad_state', () async {
    await target.adStateDao.write(
      const AdStatesCompanion(adsRemoved: Value(true)),
    );
    final json = await BackupCodec.export(target, appVersion: 'x');
    expect((json['tables']! as Map).keys, isNot(contains('ad_state')));
    // El esquema sí (la base temporal lo necesita para migrar).
    expect(
      (json['schema']! as List).any((s) => '$s'.contains('"ad_state"')),
      isTrue,
    );
  });
}
