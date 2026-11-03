import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/data/db/app_database.dart';

import 'generated/schema.dart';
import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

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

  test('v2 se crea limpia y coincide con drift_schema_v2.json', () async {
    final schema = await verifier.schemaAt(2);
    final db = AppDatabase(schema.newConnection());
    await verifier.migrateAndValidate(db, 2);
    await db.close();
  });

  test('v1 migra a v2 y coincide con drift_schema_v2.json', () async {
    final schema = await verifier.schemaAt(1);
    final db = AppDatabase(schema.newConnection());
    await verifier.migrateAndValidate(db, 2);
    await db.close();
  });

  test('v1 → v2 agrega catalog_key y conserva los ejercicios', () async {
    const row = v1.ExerciseData(
      id: 'e1',
      createdAt: 1,
      updatedAt: 1,
      name: 'Sentadilla',
      normalizedName: 'sentadilla',
      logType: 'weightReps',
      primaryMuscle: 'quads',
      isCustom: 1,
    );
    await verifier.testWithDataIntegrity(
      oldVersion: 1,
      newVersion: 2,
      createOld: v1.DatabaseAtV1.new,
      createNew: v2.DatabaseAtV2.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, old) => batch.insert(old.exercise, row),
      validateItems: (db) async {
        final rows = await db.select(db.exercise).get();
        expect(rows.single.name, 'Sentadilla');
        expect(rows.single.catalogKey, isNull);
      },
    );
  });
}
