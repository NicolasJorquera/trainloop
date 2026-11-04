import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../app/app_info.dart';
import '../../../data/db/database_providers.dart';
import '../data/backup_repository.dart';

/// Respaldo de la base de la app. La copia previa a restaurar queda en
/// `files/backups/` (fuera del respaldo automático de Android).
final backupRepositoryProvider = Provider<BackupRepository>(
  (ref) => BackupRepository(
    ref.watch(appDatabaseProvider),
    appVersion: appVersion,
    preRestoreDirectory: () async =>
        Directory('${(await getApplicationSupportDirectory()).path}/backups'),
  ),
);
