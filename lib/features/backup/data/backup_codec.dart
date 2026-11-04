import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import '../../../data/db/app_database.dart';

/// Respaldo en archivo (F-14): JSON versionado y comprimido con gzip
/// (`trainloop-AAAA-MM-DD.json.gz`, docs/arquitectura.md).
///
/// Se eligió JSON en vez de copiar el archivo SQLite porque:
/// - se puede validar antes de tocar nada (formato, versión, tablas,
///   columnas e integridad) sin abrir un archivo ajeno como base viva;
/// - lleva `schemaVersion` y el esquema (CREATE TABLE/INDEX) de esa versión:
///   la restauración crea una base temporal con ese esquema y deja que las
///   migraciones de Drift la suban a la versión actual (NF-06: «los
///   respaldos se restauran entre versiones»);
/// - es un formato abierto y legible para quien lo quiera revisar.
abstract final class BackupFormat {
  static const id = 'trainloop-backup';

  /// Versión del sobre JSON (no del esquema de la base).
  static const formatVersion = 1;

  static const extension = 'json.gz';
  static const mimeType = 'application/gzip';

  /// Tamaño máximo aceptado al restaurar (descomprimido): 64 MB.
  static const maxBytes = 64 * 1024 * 1024;

  static String fileName(DateTime now) => 'trainloop-${_date(now)}.$extension';
}

String _date(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

/// Por qué un archivo no se puede restaurar.
enum BackupError {
  /// No es un respaldo de Trainloop (o está dañado).
  invalid,

  /// Viene de una versión más nueva de la app.
  newerVersion,

  /// Los datos no pasan la revisión de integridad.
  integrity,

  /// Hay una sesión en curso: primero hay que terminarla.
  activeSession,
}

class BackupException implements Exception {
  const BackupException(this.error, [this.detail]);

  final BackupError error;
  final String? detail;

  @override
  String toString() => 'BackupException(${error.name}: $detail)';
}

/// Resumen que muestra la confirmación (S17): sesiones, rutinas, fecha.
class BackupSummary {
  const BackupSummary({
    required this.createdAt,
    required this.schemaVersion,
    required this.sessions,
    required this.routines,
    required this.intervalWorkouts,
  });

  final DateTime createdAt;
  final int schemaVersion;
  final int sessions;
  final int routines;
  final int intervalWorkouts;
}

/// Respaldo leído y validado (todavía sin aplicar).
class BackupFile {
  BackupFile._(this.json, this.summary);

  final Map<String, Object?> json;
  final BackupSummary summary;

  int get schemaVersion => summary.schemaVersion;

  List<String> get schema => (json['schema']! as List).cast<String>();

  Map<String, Object?> get tables =>
      (json['tables']! as Map).cast<String, Object?>();
}

/// Lee y escribe respaldos. Trabaja con SQL directo sobre cualquier base
/// Drift (la de la app o, en las pruebas, una de un esquema anterior).
abstract final class BackupCodec {
  /// Tablas internas que nunca se respaldan.
  static bool _internal(String name) =>
      name.startsWith('sqlite_') || name == 'android_metadata';

  /// Tablas propias del teléfono que no viajan en el archivo ni se pisan al
  /// restaurar. `ad_state` guarda la compra «Sin anuncios» (Play la
  /// reverifica), el consentimiento de UMP y los topes del intersticial:
  /// copiarlos a otro teléfono sería incorrecto. Los respaldos viejos
  /// (D8) la traen: se acepta y se ignora (se conserva la del teléfono).
  static const localOnlyTables = {'ad_state'};

  /// Todas las tablas de [db] con su esquema y versión, como mapa JSON.
  static Future<Map<String, Object?>> export(
    GeneratedDatabase db, {
    required String appVersion,
    DateTime? now,
  }) async {
    final version = await db
        .customSelect('PRAGMA user_version')
        .map((r) => r.data.values.first as int)
        .getSingle();
    final master = await db
        .customSelect(
          'SELECT type, name, sql FROM sqlite_master WHERE type IN '
          "('table', 'index') AND sql IS NOT NULL ORDER BY "
          "CASE type WHEN 'table' THEN 0 ELSE 1 END, rowid",
        )
        .get();
    final schema = <String>[];
    final tables = <String, Object?>{};
    final counts = <String, int>{};
    for (final row in master) {
      final name = row.read<String>('name');
      if (_internal(name)) continue;
      // El esquema va completo (la base temporal lo necesita para migrar);
      // las filas de las tablas locales, no.
      schema.add(row.read<String>('sql'));
      if (row.read<String>('type') != 'table') continue;
      if (localOnlyTables.contains(name)) continue;
      final rows = await db.customSelect('SELECT * FROM "$name"').get();
      final columns = rows.isEmpty
          ? await _columns(db, name)
          : rows.first.data.keys.toList();
      tables[name] = {
        'columns': columns,
        'rows': [
          for (final r in rows) [for (final c in columns) r.data[c]],
        ],
      };
      counts[name] = rows.length;
    }
    return {
      'format': BackupFormat.id,
      'formatVersion': BackupFormat.formatVersion,
      'schemaVersion': version,
      'appVersion': appVersion,
      'createdAt': (now ?? DateTime.now()).toUtc().toIso8601String(),
      'summary': {
        'sessions': await _activeCount(db, 'session', counts),
        'routines': await _activeCount(db, 'strength_routine', counts),
        'intervalWorkouts': await _activeCount(db, 'interval_workout', counts),
      },
      'schema': schema,
      'tables': tables,
    };
  }

  static Future<List<String>> _columns(GeneratedDatabase db, String table) => db
      .customSelect('PRAGMA table_info("$table")')
      .map((r) => r.read<String>('name'))
      .get();

  /// Filas sin archivar (y sesiones que cuentan en el historial).
  static Future<int> _activeCount(
    GeneratedDatabase db,
    String table,
    Map<String, int> counts,
  ) async {
    if (!counts.containsKey(table)) return 0;
    final where = table == 'session'
        ? "archived_at IS NULL AND status IN ('completed', 'incomplete')"
        : 'archived_at IS NULL';
    return db
        .customSelect('SELECT COUNT(*) AS c FROM "$table" WHERE $where')
        .map((r) => r.read<int>('c'))
        .getSingle();
  }

  static List<int> encode(Map<String, Object?> json) =>
      gzip.encode(utf8.encode(jsonEncode(json)));

  /// Decodifica y valida el sobre: formato, versión y forma de las tablas.
  /// No toca la base.
  static BackupFile decode(List<int> bytes, {required int currentSchema}) {
    Object? json;
    try {
      final raw = _looksGzip(bytes) ? gzip.decode(bytes) : bytes;
      if (raw.length > BackupFormat.maxBytes) {
        throw const BackupException(BackupError.invalid, 'too large');
      }
      json = jsonDecode(utf8.decode(raw));
    } on BackupException {
      rethrow;
    } catch (e) {
      throw BackupException(BackupError.invalid, '$e');
    }
    if (json is! Map<String, Object?> || json['format'] != BackupFormat.id) {
      throw const BackupException(BackupError.invalid, 'format');
    }
    final format = json['formatVersion'];
    final version = json['schemaVersion'];
    if (format is! int || version is! int || version < 1) {
      throw const BackupException(BackupError.invalid, 'version');
    }
    if (format > BackupFormat.formatVersion || version > currentSchema) {
      throw const BackupException(BackupError.newerVersion);
    }
    final schema = json['schema'];
    final tables = json['tables'];
    if (schema is! List || tables is! Map<String, Object?>) {
      throw const BackupException(BackupError.invalid, 'shape');
    }
    for (final sql in schema) {
      if (sql is! String || !_isCreate(sql)) {
        throw const BackupException(BackupError.invalid, 'schema');
      }
    }
    for (final entry in tables.entries) {
      final t = entry.value;
      if (t is! Map ||
          t['columns'] is! List ||
          t['rows'] is! List ||
          !_isIdentifier(entry.key)) {
        throw BackupException(BackupError.invalid, 'table ${entry.key}');
      }
      final columns = (t['columns'] as List);
      if (!columns.every((c) => c is String && _isIdentifier(c))) {
        throw BackupException(BackupError.invalid, 'columns ${entry.key}');
      }
      for (final row in t['rows'] as List) {
        if (row is! List || row.length != columns.length) {
          throw BackupException(BackupError.invalid, 'row ${entry.key}');
        }
      }
    }
    DateTime createdAt;
    try {
      createdAt = DateTime.parse(json['createdAt']! as String);
    } catch (_) {
      throw const BackupException(BackupError.invalid, 'createdAt');
    }
    final summary = json['summary'];
    int n(String key) =>
        summary is Map && summary[key] is int ? summary[key] as int : 0;
    return BackupFile._(
      json,
      BackupSummary(
        createdAt: createdAt,
        schemaVersion: version,
        sessions: n('sessions'),
        routines: n('routines'),
        intervalWorkouts: n('intervalWorkouts'),
      ),
    );
  }

  static bool _looksGzip(List<int> b) =>
      b.length > 2 && b[0] == 0x1f && b[1] == 0x8b;

  /// Solo se aceptan sentencias CREATE TABLE / CREATE [UNIQUE] INDEX, sin
  /// más de una sentencia.
  static bool _isCreate(String sql) {
    final s = sql.trimLeft().toUpperCase();
    final ok =
        s.startsWith('CREATE TABLE ') ||
        s.startsWith('CREATE INDEX ') ||
        s.startsWith('CREATE UNIQUE INDEX ');
    return ok && !sql.contains(';');
  }

  static final _identifier = RegExp(r'^[A-Za-z_][A-Za-z0-9_]*$');

  static bool _isIdentifier(String s) => _identifier.hasMatch(s);

  /// Abre el respaldo como una base temporal en memoria con su esquema
  /// original y la versión del respaldo; al abrirla, Drift corre las
  /// migraciones hasta la versión actual. Revisa la integridad y las claves
  /// foráneas. Quien llama la cierra.
  static Future<AppDatabase> openMigrated(BackupFile file) async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final db = AppDatabase(
      NativeDatabase.memory(
        setup: (raw) {
          for (final sql in file.schema) {
            raw.execute(sql);
          }
          for (final entry in file.tables.entries) {
            final t = entry.value! as Map;
            final columns = (t['columns'] as List).cast<String>();
            final rows = t['rows'] as List;
            if (rows.isEmpty) continue;
            final stmt = raw.prepare(
              'INSERT INTO "${entry.key}" '
              '(${columns.map((c) => '"$c"').join(', ')}) '
              'VALUES (${List.filled(columns.length, '?').join(', ')})',
            );
            try {
              for (final row in rows) {
                stmt.execute((row as List).cast<Object?>());
              }
            } finally {
              stmt.close();
            }
          }
          raw.execute('PRAGMA user_version = ${file.schemaVersion}');
        },
      ),
    );
    try {
      // Abrir corre la migración (y `beforeOpen` activa las claves).
      final check = await db
          .customSelect('PRAGMA integrity_check')
          .map((r) => r.data.values.first)
          .get();
      final fk = await db.customSelect('PRAGMA foreign_key_check').get();
      if (check.length != 1 || check.first != 'ok' || fk.isNotEmpty) {
        throw BackupException(
          BackupError.integrity,
          'integrity=$check fk=${fk.length}',
        );
      }
      return db;
    } on BackupException {
      await db.close();
      rethrow;
    } catch (e) {
      await db.close();
      throw BackupException(BackupError.integrity, '$e');
    }
  }

  /// Reemplaza todos los datos de [target] por los de [source] (ambas en la
  /// versión actual) en una sola transacción. Las [localOnlyTables] de
  /// [target] no se tocan.
  static Future<void> replaceAll(AppDatabase target, AppDatabase source) =>
      target.transaction(() async {
        await target.customStatement('PRAGMA defer_foreign_keys = ON');
        final tables = target.allTables
            .where((t) => !localOnlyTables.contains(t.actualTableName))
            .toList();
        for (final t in tables.reversed) {
          await target.customStatement('DELETE FROM "${t.actualTableName}"');
        }
        for (final t in tables) {
          final name = t.actualTableName;
          final rows = await source.customSelect('SELECT * FROM "$name"').get();
          if (rows.isEmpty) continue;
          final columns = rows.first.data.keys.toList();
          final sql =
              'INSERT INTO "$name" (${columns.map((c) => '"$c"').join(', ')}) '
              'VALUES (${List.filled(columns.length, '?').join(', ')})';
          await target.batch((b) {
            for (final r in rows) {
              b.customStatement(sql, [for (final c in columns) r.data[c]]);
            }
          });
        }
      });
}
