import 'dart:convert';
import 'dart:io';

import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/data/db/app_database.dart';
import 'package:trainloop/data/db/demo_seed.dart';
import 'package:trainloop/data/db/enums.dart';
import 'package:trainloop/features/backup/data/backup_codec.dart';
import 'package:trainloop/features/backup/data/backup_repository.dart';

import '../../drift/app_database/generated/schema.dart';
import '../../drift/app_database/generated/schema_v4.dart' as v4;
import '../../fixtures/history_fixture.dart';
import '../../helpers/test_database.dart';

/// Todas las filas de todas las tablas, para comparar dos bases.
Future<Map<String, List<Map<String, Object?>>>> dump(AppDatabase db) async => {
  for (final t in db.allTables)
    t.actualTableName: [
      for (final r
          in await db
              .customSelect('SELECT * FROM "${t.actualTableName}" ORDER BY id')
              .get())
        r.data,
    ],
};

void main() {
  late AppDatabase source;
  late AppDatabase target;

  setUp(() {
    source = openTestDatabase();
    target = openTestDatabase();
  });

  tearDown(() async {
    await source.close();
    await target.close();
  });

  test('ida y vuelta: una base con datos se restaura idéntica', () async {
    await buildHistoryFixture(source);
    await seedDemoData(source);
    await source.planDao.addReminder(
      RemindersCompanion.insert(weekday: 1, minuteOfDay: 7 * 60),
    );
    final before = await dump(source);
    expect(before['set_log'], isNotEmpty);
    expect(before['interval_phase_log'], isNotEmpty);
    expect(before['personal_record'], isNotEmpty);

    final backup = await BackupRepository(
      source,
      appVersion: '1.0.0+1',
    ).create(now: DateTime(2026, 11, 3));
    expect(backup.fileName, 'trainloop-2026-11-03.json.gz');
    // gzip
    expect(backup.bytes.take(2), [0x1f, 0x8b]);

    // El destino ya tenía otros datos: se reemplazan.
    await seedDemoData(target);
    final repo = BackupRepository(target, appVersion: '1.0.0+1');
    final file = repo.read(backup.bytes);
    expect(file.schemaVersion, target.schemaVersion);
    expect(file.summary.sessions, backup.sessions);
    expect(file.summary.routines, greaterThan(0));
    await repo.restore(file);

    expect(await dump(target), before);
  });

  test('guarda una copia de los datos actuales antes de restaurar', () async {
    await seedDemoData(source);
    await seedDemoData(target);
    final dir = await Directory.systemTemp.createTemp('tl_backup');
    addTearDown(() => dir.delete(recursive: true));
    final bytes = (await BackupRepository(
      source,
      appVersion: 'x',
    ).create()).bytes;
    final repo = BackupRepository(
      target,
      appVersion: 'x',
      preRestoreDirectory: () async => dir,
    );
    final targetBefore = await dump(target);
    await repo.restore(repo.read(bytes));
    final copy = File('${dir.path}/${BackupRepository.preRestoreFileName}');
    expect(copy.existsSync(), isTrue);

    // La copia automática restaura lo que había.
    await repo.restore(repo.read(copy.readAsBytesSync()));
    expect(await dump(target), targetBefore);
  });

  test('un respaldo del esquema v4 se migra al restaurar', () async {
    final verifier = SchemaVerifier(GeneratedHelper());
    final schema = await verifier.schemaAt(4);
    final old = v4.DatabaseAtV4(schema.newConnection());
    addTearDown(old.close);
    const t = 1761600000000; // 2025-10-27
    await old.customStatement(
      'INSERT INTO exercise (id, created_at, updated_at, name, '
      'normalized_name, log_type, primary_muscle, is_custom) VALUES '
      "('e1', $t, $t, 'Remo', 'remo', 'weightReps', 'back', 1)",
    );
    await old.customStatement(
      'INSERT INTO session (id, created_at, updated_at, kind, status, '
      'started_at, ended_at, utc_offset_minutes) VALUES '
      "('s1', $t, $t, 'strength', 'completed', $t, ${t + 1800000}, -180)",
    );
    await old.customStatement(
      'INSERT INTO session_exercise (id, created_at, updated_at, session_id, '
      'exercise_id, sort_order, rest_seconds) VALUES '
      "('se1', $t, $t, 's1', 'e1', 0, 90)",
    );
    await old.customStatement(
      'INSERT INTO set_log (id, created_at, updated_at, session_exercise_id, '
      'session_id, exercise_id, sort_order, weight_value, weight_unit, '
      'weight_grams, reps, completed) VALUES '
      "('l1', $t, $t, 'se1', 's1', 'e1', 0, 70, 'kg', 70000, 8, 1)",
    );
    // Caché de récords con la forma de v4: la migración la vacía.
    await old.customStatement(
      'INSERT INTO personal_record (id, created_at, updated_at, exercise_id, '
      'type, value, session_id, achieved_at) VALUES '
      "('r1', $t, $t, 'e1', 'maxWeight', 1, 's1', $t)",
    );

    final json = await BackupCodec.export(old, appVersion: 'old');
    expect(json['schemaVersion'], 4);
    final repo = BackupRepository(target, appVersion: 'x');
    final file = repo.read(BackupCodec.encode(json));
    expect(file.schemaVersion, 4);
    expect(file.summary.sessions, 1);
    await repo.restore(file);

    final sets = await target.select(target.setLogs).get();
    expect(sets.single.weightGrams, 70000);
    final session = await target.select(target.sessions).getSingle();
    expect(session.status, SessionStatus.completed);
    // Récords recalculados desde set_log en la forma de v5.
    final records = await target.select(target.personalRecords).get();
    expect(records, isNotEmpty);
    expect(records.any((r) => r.id == 'r1'), isFalse);
    final max = records.firstWhere((r) => r.type == RecordType.maxWeight);
    expect(max.value, 70000);
    expect(max.reps, 8);
  });

  group('validación', () {
    late BackupRepository repo;
    setUp(() => repo = BackupRepository(target, appVersion: 'x'));

    Future<Map<String, Object?>> valid() =>
        BackupCodec.export(source, appVersion: 'x');

    void expectError(List<int> bytes, BackupError error) => expect(
      () => repo.read(bytes),
      throwsA(isA<BackupException>().having((e) => e.error, 'error', error)),
    );

    test('un archivo cualquiera no es un respaldo', () {
      expectError(utf8.encode('hola'), BackupError.invalid);
      expectError(gzip.encode(utf8.encode('{"a":1}')), BackupError.invalid);
    });

    test('un respaldo de una versión más nueva se rechaza', () async {
      final json = await valid();
      json['schemaVersion'] = target.schemaVersion + 1;
      expectError(BackupCodec.encode(json), BackupError.newerVersion);
    });

    test('solo acepta sentencias CREATE en el esquema', () async {
      final json = await valid();
      json['schema'] = [...json['schema']! as List, 'DROP TABLE session'];
      expectError(BackupCodec.encode(json), BackupError.invalid);
      json['schema'] = ['CREATE TABLE x (a INT); DROP TABLE session'];
      expectError(BackupCodec.encode(json), BackupError.invalid);
    });

    test('nombres de columna raros se rechazan', () async {
      final json = await valid();
      final tables = json['tables']! as Map;
      (tables['exercise'] as Map)['columns'] = ['id"; DROP TABLE x; --'];
      expectError(BackupCodec.encode(json), BackupError.invalid);
    });

    test('una clave foránea rota no toca la base', () async {
      await seedDemoData(source);
      await seedDemoData(target);
      final before = await dump(target);
      final json = await valid();
      final tables = json['tables']! as Map;
      final sets = tables['set_log'] as Map;
      final columns = (sets['columns'] as List).cast<String>();
      final row = (sets['rows'] as List).first as List;
      row[columns.indexOf('exercise_id')] = 'no-existe';
      final file = repo.read(BackupCodec.encode(json));
      await expectLater(
        repo.restore(file),
        throwsA(
          isA<BackupException>().having(
            (e) => e.error,
            'error',
            BackupError.integrity,
          ),
        ),
      );
      expect(await dump(target), before);
    });

    test('no restaura con una sesión en curso', () async {
      await target.sessionsDao.start(kind: SessionKind.intervals);
      final file = repo.read(BackupCodec.encode(await valid()));
      await expectLater(
        repo.restore(file),
        throwsA(
          isA<BackupException>().having(
            (e) => e.error,
            'error',
            BackupError.activeSession,
          ),
        ),
      );
    });
  });
}
