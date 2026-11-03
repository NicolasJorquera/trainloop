import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:trainloop/data/db/app_database.dart';

/// Base en memoria (SQLite nativo de la máquina de pruebas).
AppDatabase openTestDatabase() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase(NativeDatabase.memory());
}
