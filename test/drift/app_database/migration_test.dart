import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/data/db/app_database.dart';

import 'generated/schema.dart';

// Pruebas de migración. Al subir `schemaVersion`: correr
// `dart run drift_dev make-migrations` (guarda drift_schemas/…/vN.json y
// regenera generated/) y agregar aquí una prueba que parta de vN-1.
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  test('schemaVersion es la última versión guardada', () async {
    final db = AppDatabase(NativeDatabase.memory());
    expect(db.schemaVersion, GeneratedHelper.versions.last);
    await db.close();
  });

  test('v1 se crea limpia y coincide con drift_schema_v1.json', () async {
    final schema = await verifier.schemaAt(1);
    final db = AppDatabase(schema.newConnection());
    await verifier.migrateAndValidate(db, 1);
    await db.close();
  });
}
