import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:trainloop/data/db/app_database.dart';

/// Base en memoria (SQLite nativo de la máquina de pruebas). Cierra las
/// consultas reactivas sin temporizador para no dejar timers pendientes en
/// las pruebas de widgets.
AppDatabase openTestDatabase() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase(
    DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ),
  );
}
