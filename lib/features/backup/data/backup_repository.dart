import 'dart:io';

import 'package:drift/drift.dart';

import '../../../data/db/app_database.dart';
import '../../../data/db/enums.dart';
import '../../history/data/records_repository.dart';
import 'backup_codec.dart';

/// Respaldo creado: bytes del archivo y su resumen.
class CreatedBackup {
  const CreatedBackup({
    required this.fileName,
    required this.bytes,
    required this.sessions,
  });

  final String fileName;
  final List<int> bytes;
  final int sessions;
}

/// Crea y restaura respaldos de la base de la app (S17).
class BackupRepository {
  BackupRepository(
    this._db, {
    required this.appVersion,
    this.preRestoreDirectory,
  });

  final AppDatabase _db;
  final String appVersion;

  /// Carpeta donde se guarda la copia automática antes de restaurar
  /// (`files/backups/` en Android). `null` en las pruebas que no la usan.
  final Future<Directory> Function()? preRestoreDirectory;

  static const preRestoreFileName = 'antes-de-restaurar.json.gz';

  Future<CreatedBackup> create({DateTime? now}) async {
    final at = now ?? DateTime.now();
    final json = await BackupCodec.export(_db, appVersion: appVersion, now: at);
    final summary = json['summary']! as Map;
    return CreatedBackup(
      fileName: BackupFormat.fileName(at),
      bytes: BackupCodec.encode(json),
      sessions: summary['sessions'] as int,
    );
  }

  /// Lee y valida un archivo; no toca la base.
  BackupFile read(List<int> bytes) =>
      BackupCodec.decode(bytes, currentSchema: _db.schemaVersion);

  /// Hay una sesión sin terminar (en curso o por recuperar): mientras tanto
  /// no se restaura (docs/arquitectura.md).
  Future<bool> hasActiveSession() async {
    final row =
        await (_db.select(_db.sessions)
              ..where(
                (t) =>
                    t.archivedAt.isNull() &
                    t.status.isInValues([
                      SessionStatus.inProgress,
                      SessionStatus.recoveryPending,
                    ]),
              )
              ..limit(1))
            .getSingleOrNull();
    return row != null;
  }

  /// Reemplaza los datos actuales por los del respaldo:
  /// 1. no hay sesión activa;
  /// 2. el respaldo se carga en una base temporal y se migra a la versión
  ///    actual, con revisión de integridad y claves;
  /// 3. se guarda una copia automática de los datos actuales;
  /// 4. se reemplaza todo en una transacción y se recalculan los récords si
  ///    la migración vació su caché.
  Future<void> restore(BackupFile file) async {
    if (await hasActiveSession()) {
      throw const BackupException(BackupError.activeSession);
    }
    final temp = await BackupCodec.openMigrated(file);
    try {
      await _savePreRestoreCopy();
      await BackupCodec.replaceAll(_db, temp);
      _db.notifyUpdates({
        for (final t in _db.allTables) TableUpdate.onTable(t),
      });
      if (temp.recordsRebuildPending) {
        await RecordsRepository(_db).rebuildAll();
      }
    } finally {
      await temp.close();
    }
  }

  Future<void> _savePreRestoreCopy() async {
    final dir = await preRestoreDirectory?.call();
    if (dir == null) return;
    await dir.create(recursive: true);
    final backup = await create();
    final file = File('${dir.path}/$preRestoreFileName');
    final tmp = File('${file.path}.tmp');
    await tmp.writeAsBytes(backup.bytes, flush: true);
    await tmp.rename(file.path);
  }
}
