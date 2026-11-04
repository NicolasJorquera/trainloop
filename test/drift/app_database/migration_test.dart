import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/data/db/app_database.dart';

import 'generated/schema.dart';
import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;
import 'generated/schema_v3.dart' as v3;
import 'generated/schema_v4.dart' as v4;
import 'generated/schema_v5.dart' as v5;

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

  test('v5 se crea limpia y coincide con drift_schema_v5.json', () async {
    final schema = await verifier.schemaAt(5);
    final db = AppDatabase(schema.newConnection());
    await verifier.migrateAndValidate(db, 5);
    await db.close();
  });

  for (final from in [1, 2, 3, 4]) {
    test('v$from migra a v5 y coincide con drift_schema_v5.json', () async {
      final schema = await verifier.schemaAt(from);
      final db = AppDatabase(schema.newConnection());
      await verifier.migrateAndValidate(db, 5);
      expect(db.recordsRebuildPending, isTrue);
      await db.close();
    });
  }

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
  test(
    'v2 → v3 agrega skip_last_rest (activado) y conserva los bloques',
    () async {
      await verifier.testWithDataIntegrity(
        oldVersion: 2,
        newVersion: 3,
        createOld: v2.DatabaseAtV2.new,
        createNew: v3.DatabaseAtV3.new,
        openTestedDatabase: AppDatabase.new,
        createItems: (batch, old) {
          batch
            ..insert(
              old.intervalWorkout,
              const v2.IntervalWorkoutData(
                id: 'w1',
                createdAt: 1,
                updatedAt: 1,
                name: 'Tabata',
                prepareSeconds: 10,
              ),
            )
            ..insert(
              old.intervalBlock,
              const v2.IntervalBlockData(
                id: 'g1',
                createdAt: 1,
                updatedAt: 1,
                workoutId: 'w1',
                sortOrder: 0,
                kind: 'group',
                rounds: 8,
              ),
            );
        },
        validateItems: (db) async {
          final rows = await db.select(db.intervalBlock).get();
          expect(rows.single.rounds, 8);
          expect(rows.single.skipLastRest, 1);
        },
      );
    },
  );

  test(
    'v3 → v4 agrega rest_seconds (vacío) y conserva sesiones y series',
    () async {
      await verifier.testWithDataIntegrity(
        oldVersion: 3,
        newVersion: 4,
        createOld: v3.DatabaseAtV3.new,
        createNew: v4.DatabaseAtV4.new,
        openTestedDatabase: AppDatabase.new,
        createItems: (batch, old) {
          batch
            ..insert(
              old.exercise,
              const v3.ExerciseData(
                id: 'e1',
                createdAt: 1,
                updatedAt: 1,
                name: 'Squat',
                normalizedName: 'squat',
                logType: 'weightReps',
                primaryMuscle: 'quads',
                isCustom: 0,
              ),
            )
            ..insert(
              old.session,
              const v3.SessionData(
                id: 's1',
                createdAt: 1,
                updatedAt: 1,
                kind: 'strength',
                status: 'completed',
                startedAt: 1,
                utcOffsetMinutes: -180,
                pausedSeconds: 0,
              ),
            )
            ..insert(
              old.sessionExercise,
              const v3.SessionExerciseData(
                id: 'se1',
                createdAt: 1,
                updatedAt: 1,
                sessionId: 's1',
                exerciseId: 'e1',
                sortOrder: 0,
              ),
            )
            ..insert(
              old.setLog,
              const v3.SetLogData(
                id: 'l1',
                createdAt: 1,
                updatedAt: 1,
                sessionExerciseId: 'se1',
                sessionId: 's1',
                exerciseId: 'e1',
                sortOrder: 0,
                setType: 'normal',
                weightValue: 80,
                weightUnit: 'kg',
                weightGrams: 80000,
                reps: 8,
                completed: 1,
              ),
            );
        },
        validateItems: (db) async {
          final exercises = await db.select(db.sessionExercise).get();
          expect(exercises.single.restSeconds, isNull);
          final sets = await db.select(db.setLog).get();
          expect(sets.single.weightGrams, 80000);
          expect(sets.single.reps, 8);
        },
      );
    },
  );

  test(
    'v4 → v5 vacía la caché de récords y conserva sesiones y series',
    () async {
      await verifier.testWithDataIntegrity(
        oldVersion: 4,
        newVersion: 5,
        createOld: v4.DatabaseAtV4.new,
        createNew: v5.DatabaseAtV5.new,
        openTestedDatabase: AppDatabase.new,
        createItems: (batch, old) {
          batch
            ..insert(
              old.exercise,
              const v4.ExerciseData(
                id: 'e1',
                createdAt: 1,
                updatedAt: 1,
                name: 'Squat',
                normalizedName: 'squat',
                logType: 'weightReps',
                primaryMuscle: 'quads',
                isCustom: 0,
              ),
            )
            ..insert(
              old.session,
              const v4.SessionData(
                id: 's1',
                createdAt: 1,
                updatedAt: 1,
                kind: 'strength',
                status: 'completed',
                startedAt: 1,
                utcOffsetMinutes: -180,
                pausedSeconds: 0,
              ),
            )
            ..insert(
              old.sessionExercise,
              const v4.SessionExerciseData(
                id: 'se1',
                createdAt: 1,
                updatedAt: 1,
                sessionId: 's1',
                exerciseId: 'e1',
                sortOrder: 0,
                restSeconds: 90,
              ),
            )
            ..insert(
              old.setLog,
              const v4.SetLogData(
                id: 'l1',
                createdAt: 1,
                updatedAt: 1,
                sessionExerciseId: 'se1',
                sessionId: 's1',
                exerciseId: 'e1',
                sortOrder: 0,
                setType: 'normal',
                weightValue: 80,
                weightUnit: 'kg',
                weightGrams: 80000,
                reps: 8,
                completed: 1,
              ),
            )
            ..insert(
              old.personalRecord,
              const v4.PersonalRecordData(
                id: 'r1',
                createdAt: 1,
                updatedAt: 1,
                exerciseId: 'e1',
                type: 'maxSetVolume',
                value: 640000,
                sessionId: 's1',
                achievedAt: 1,
              ),
            );
        },
        validateItems: (db) async {
          expect(await db.select(db.personalRecord).get(), isEmpty);
          final sets = await db.select(db.setLog).get();
          expect(sets.single.weightGrams, 80000);
          expect((await db.select(db.session).get()).single.id, 's1');
          // El índice único nuevo admite un récord por peso.
          for (final w in [80000, 85000]) {
            await db
                .into(db.personalRecord)
                .insert(
                  v5.PersonalRecordCompanion.insert(
                    id: 'r$w',
                    createdAt: 1,
                    updatedAt: 1,
                    exerciseId: 'e1',
                    type: 'maxReps',
                    value: 8,
                    achievedAt: 1,
                    weightGrams: Value(w),
                  ),
                );
          }
          expect(await db.select(db.personalRecord).get(), hasLength(2));
        },
      );
    },
  );
}
