import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/data/db/app_database.dart';
import 'package:trainloop/features/backup/data/csv_export.dart';

import '../../fixtures/history_fixture.dart';
import '../../helpers/test_database.dart';

/// CSV → filas (sin BOM ni la línea final vacía). Sin comillas en estos
/// datos salvo las que se prueban aparte.
List<List<String>> parse(String csv) {
  expect(csv.startsWith('﻿'), isTrue);
  expect(csv.endsWith('\r\n'), isTrue);
  return [
    for (final line in csv.substring(1).split('\r\n'))
      if (line.isNotEmpty) line.split(','),
  ];
}

void main() {
  late AppDatabase db;
  late FixtureIds ids;

  setUp(() async {
    db = openTestDatabase();
    ids = await buildHistoryFixture(db);
  });

  tearDown(() => db.close());

  test('sesiones: una fila por sesión del historial, en orden', () async {
    final rows = parse(
      await CsvExport.sessions(db, titleOf: (e) => e.title ?? 'Libre'),
    );
    expect(rows.first, CsvExport.sessionHeader);
    final body = rows.skip(1).toList();
    // A, B, C y D (docs/pruebas-historial.md).
    expect(body, hasLength(4));
    final col = CsvExport.sessionHeader.indexOf;
    expect(body.map((r) => r[col('session_id')]), [
      ids['A'],
      ids['B'],
      ids['C'],
      ids['D'],
    ]);
    // Fechas ISO con el desfase local de la sesión.
    expect(body.first[col('started_at')], endsWith('-03:00'));
    expect(body.first[col('started_at')], startsWith('2026-10-26T'));
    expect(body.first[col('type')], 'strength');
    expect(body[1][col('type')], 'intervals');
    expect(body[2][col('status')], 'incomplete');
    // Fuerza con volumen en kg con punto decimal; intervalos con rondas.
    expect(body.first[col('volume_kg')], matches(RegExp(r'^\d+\.\d+$')));
    expect(body[1][col('volume_kg')], '');
    expect(body[1][col('rounds_planned')], '8');
  });

  test('series: solo las hechas, con peso, unidad y kg', () async {
    final rows = parse(
      await CsvExport.sets(db, exerciseName: (e) => e.catalogKey ?? e.name),
    );
    expect(rows.first, CsvExport.setHeader);
    final col = CsvExport.setHeader.indexOf;
    final body = rows.skip(1).toList();
    expect(body, isNotEmpty);
    final completed = await (db.select(
      db.setLogs,
    )..where((t) => t.completed.equals(true))).get();
    expect(body, hasLength(completed.length));
    for (final r in body) {
      expect(r[col('exercise')], r[col('exercise_key')]);
      expect(r[col('unit')], 'kg');
      expect(double.parse(r[col('weight_kg')]), double.parse(r[col('weight')]));
    }
    expect(
      body.map((r) => r[col('set_type')]).toSet(),
      containsAll(['warmup', 'normal']),
    );
  });

  test('escapa comas, comillas y saltos de línea', () {
    final csv = CsvExport.encode(
      ['a', 'b', 'c', 'd'],
      [
        ['uno, dos', 'dijo "hola"', 'línea\nnueva', 62.5],
        [null, 60.0, 0.1 + 0.2, 3],
      ],
    );
    expect(
      csv,
      '﻿a,b,c,d\r\n'
      '"uno, dos","dijo ""hola""","línea\nnueva",62.5\r\n'
      ',60.0,0.3,3\r\n',
    );
  });

  test('isoWithOffset usa la hora local de la sesión', () {
    expect(
      CsvExport.isoWithOffset(DateTime.utc(2026, 10, 26, 21, 5), -180),
      '2026-10-26T18:05:00-03:00',
    );
    expect(
      CsvExport.isoWithOffset(DateTime.utc(2026, 1, 1, 0, 0), 330),
      '2026-01-01T05:30:00+05:30',
    );
  });
}
