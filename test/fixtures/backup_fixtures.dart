import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:trainloop/data/db/app_database.dart';
import 'package:trainloop/data/db/demo_seed.dart';
import 'package:trainloop/data/db/enums.dart';
import 'package:trainloop/features/backup/data/backup_codec.dart';

import '../drift/app_database/generated/schema.dart';
import '../drift/app_database/generated/schema_v3.dart' as v3;
import '../drift/app_database/generated/schema_v4.dart' as v4;
import '../helpers/test_database.dart';
import 'history_fixture.dart';

/// Respaldos de prueba de esquemas anteriores (NF-06: «los respaldos se
/// restauran entre versiones»), en `test/fixtures/backups/`.
///
/// Se generan con los generadores del repo: el conjunto de
/// `buildHistoryFixture` más `seedDemoData` y un recordatorio y un plan, en
/// la base actual; para v3 y v4 se copian las columnas que existían a una
/// base con ese esquema (helpers de `drift_dev` en
/// `test/drift/app_database/generated/`) y se exporta con `BackupCodec`.
/// Como hacía D8, cada archivo trae además la fila de `ad_state` (con
/// «Sin anuncios» comprado y consentimiento dado): la restauración debe
/// ignorarla.
///
/// Regenerar (solo si cambia el formato a propósito; los archivos viejos
/// deben seguir restaurándose tal cual):
///
/// ```sh
/// TL_WRITE_BACKUP_FIXTURES=1 flutter test test/features/backup/backup_versions_test.dart
/// ```
abstract final class BackupFixtures {
  static const versions = [3, 4, 5];
  static const directory = 'test/fixtures/backups';

  static File file(int version) =>
      File('$directory/trainloop-schema-v$version.json.gz');

  /// Fecha fija del respaldo, para que el archivo no cambie sin motivo.
  static final createdAt = DateTime.utc(2026, 10, 30, 12);

  /// La fila de `ad_state` que traían los respaldos de D8.
  static const adStateRow = {
    'id': 'ad_state',
    'created_at': 1761600000000,
    'updated_at': 1761600000000,
    'last_interstitial_at': null,
    'sessions_since_interstitial': 2,
    'consent_status': 'obtained',
    'ads_removed': 1,
  };
}

/// Arma el respaldo (sin comprimir) de la versión [version] del esquema.
Future<Map<String, Object?>> buildBackupFixture(int version) async {
  final current = openTestDatabase();
  try {
    await buildHistoryFixture(current);
    await seedDemoData(current);
    await current.planDao.addReminder(
      RemindersCompanion.insert(weekday: 3, minuteOfDay: 7 * 60 + 30),
    );
    await current.planDao.setDay(5, [
      PlanDaysCompanion.insert(
        weekday: 5,
        kind: SessionKind.intervals,
        templateId: 'template:tabata',
      ),
    ]);
    final Map<String, Object?> json;
    if (version == current.schemaVersion) {
      json = await BackupCodec.export(
        current,
        appVersion: '1.0.0+1',
        now: BackupFixtures.createdAt,
      );
    } else {
      final verifier = SchemaVerifier(GeneratedHelper());
      final schema = await verifier.schemaAt(version);
      final old = switch (version) {
        3 => v3.DatabaseAtV3(schema.newConnection()) as GeneratedDatabase,
        4 => v4.DatabaseAtV4(schema.newConnection()),
        _ => throw ArgumentError.value(version, 'version'),
      };
      try {
        await _copyDown(current, old);
        json = await BackupCodec.export(
          old,
          appVersion: '1.0.0+1',
          now: BackupFixtures.createdAt,
        );
      } finally {
        await old.close();
      }
    }
    // Como el formato de D8: `ad_state` viajaba en el archivo.
    const row = BackupFixtures.adStateRow;
    (json['tables']! as Map<String, Object?>)['ad_state'] = {
      'columns': row.keys.toList(),
      'rows': [row.values.toList()],
    };
    return json;
  } finally {
    await current.close();
  }
}

/// Copia a [old] las columnas de [current] que existen en su esquema.
Future<void> _copyDown(AppDatabase current, GeneratedDatabase old) async {
  for (final table in old.allTables) {
    final name = table.actualTableName;
    if (BackupCodec.localOnlyTables.contains(name)) continue;
    final columns = table.$columns.map((c) => c.name).toList();
    final rows = await current
        .customSelect(
          'SELECT ${columns.map((c) => '"$c"').join(', ')} FROM "$name"',
        )
        .get();
    // personal_record v4 no tenía el peso en la clave: basta una fila por
    // ejercicio y tipo (la migración a v5 vacía la caché igual).
    final verb = name == 'personal_record' ? 'INSERT OR IGNORE' : 'INSERT';
    final sql =
        '$verb INTO "$name" (${columns.map((c) => '"$c"').join(', ')}) '
        'VALUES (${List.filled(columns.length, '?').join(', ')})';
    for (final r in rows) {
      await old.customStatement(sql, [for (final c in columns) r.data[c]]);
    }
  }
}
