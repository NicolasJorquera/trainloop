import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/core/units/weight_unit.dart';
import 'package:trainloop/data/catalog/exercise_catalog_seeder.dart';
import 'package:trainloop/data/db/app_database.dart';
import 'package:trainloop/data/db/enums.dart';
import 'package:trainloop/features/routines/data/routine_repository.dart';
import 'package:trainloop/features/routines/domain/routine_draft.dart';
import 'package:trainloop/features/strength/data/strength_session_repository.dart';
import 'package:trainloop/features/strength/domain/strength_rules.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late StrengthSessionRepository repo;
  late RoutineRepository routines;
  late Map<String, Exercise> ex;

  setUp(() async {
    db = openTestDatabase();
    repo = StrengthSessionRepository(db);
    routines = RoutineRepository(db);
    await seedExerciseCatalog(db.exercisesDao);
    ex = {
      for (final e in await db.exercisesDao.watchActive().first)
        e.catalogKey!: e,
    };
  });
  tearDown(() => db.close());

  /// Piernas A: sentadilla 3 × 8 con 80 kg y descanso 120 s, peso muerto
  /// rumano 3 × 10 (descanso de la biblioteca) y plancha 3 × 0:45.
  Future<String> legs() {
    final draft = const RoutineDraft(name: 'Piernas A').addAll([
      ex['back_squat_barbell']!,
      ex['romanian_deadlift_barbell']!,
      ex['plank']!,
    ]);
    return routines.save(
      draft.replaceAt(
        0,
        draft.entries[0].copyWith(
          reps: 8,
          weight: () => 80,
          weightUnit: WeightUnit.kg,
          restSeconds: 120,
        ),
      ),
      fallbackName: 'Rutina 1',
    );
  }

  /// Hace todas las series con sus valores propuestos y termina.
  Future<void> doAll(String sessionId) async {
    final data = (await repo.load(sessionId))!;
    for (final e in data.exercises) {
      for (final s in e.sets) {
        final v = s.proposed;
        await repo.completeSet(
          s.id,
          e.exercise.logType.tracksWeight && v.weight == null
              ? v.copyWith(weight: () => 60, unit: WeightUnit.kg)
              : v,
        );
      }
    }
    await repo.finish(sessionId);
  }

  group('empezar', () {
    test('desde una rutina copia ejercicios, series y descanso', () async {
      final routineId = await legs();
      final id = await repo.startFromRoutine(routineId);
      final data = (await repo.load(id))!;

      expect(data.title, 'Piernas A');
      expect(data.session.status, SessionStatus.inProgress);
      expect(data.session.templateId, routineId);
      expect(data.exercises.map((e) => e.exercise.catalogKey), [
        'back_squat_barbell',
        'romanian_deadlift_barbell',
        'plank',
      ]);
      // R-G8: rutina (120) → biblioteca (150 y 60).
      expect(data.exercises.map((e) => e.restSeconds), [120, 150, 60]);
      expect(data.totalSets, 9);
      expect(data.completedSets, 0);
      final squat = data.exercises.first.sets.first;
      expect(squat.stored.weight, 80);
      expect(squat.stored.reps, 8);
      expect(data.exercises[2].sets.first.stored.durationSeconds, 45);
      final snapshot = data.session.templateSnapshot!;
      expect((snapshot['exercises']! as List).length, 3);
    });

    test('la sesión no cambia la rutina ni la rutina a la sesión', () async {
      final routineId = await legs();
      final id = await repo.startFromRoutine(routineId);
      var data = (await repo.load(id))!;

      // Cambios dentro de la sesión.
      await repo.addSet(data.exercises.first.id);
      await repo.removeExercise(data.exercises.last.id);
      await repo.completeSet(
        data.exercises.first.sets.first.id,
        const SetValues(weight: 100, unit: WeightUnit.kg, reps: 3),
      );
      final routine = (await routines.load(routineId))!;
      expect(routine.entries.length, 3);
      expect(routine.entries.first.sets, 3);
      expect(routine.entries.first.weight, 80);

      // Editar la rutina con la sesión abierta no altera la copia.
      await routines.save(routine.removeAt(0), fallbackName: 'x');
      data = (await repo.load(id))!;
      expect(data.exercises.first.exercise.catalogKey, 'back_squat_barbell');
      expect(data.exercises.first.sets.length, 4);
      expect(
        ((data.session.templateSnapshot!['exercises']! as List).first
            as Map)['exerciseId'],
        ex['back_squat_barbell']!.id,
      );
    });

    test('una rutina vacía no se puede empezar', () async {
      final empty = await routines.save(
        const RoutineDraft(name: 'Vacía'),
        fallbackName: 'x',
      );
      expect(() => repo.startFromRoutine(empty), throwsStateError);
    });

    test('entrenamiento libre: vacío, se agregan ejercicios', () async {
      final id = await repo.startFree();
      var data = (await repo.load(id))!;
      expect(data.title, isNull);
      expect(data.exercises, isEmpty);

      await repo.addExercises(id, [ex['bench_press_barbell']!]);
      data = (await repo.load(id))!;
      expect(data.exercises.single.sets.length, 3);
      expect(data.exercises.single.restSeconds, 150);
      expect(data.exercises.single.sets.first.proposed.isEmpty, isTrue);
    });

    test('repetir la última copia ejercicios y series hechas', () async {
      expect(await repo.repeatLast(), isNull);
      final first = await repo.startFromRoutine(await legs());
      var data = (await repo.load(first))!;
      // Solo 2 series de sentadilla, con 82,5 kg.
      for (final s in data.exercises.first.sets.take(2)) {
        await repo.completeSet(
          s.id,
          const SetValues(weight: 82.5, unit: WeightUnit.kg, reps: 8),
        );
      }
      await repo.finish(first);

      final again = (await repo.repeatLast())!;
      data = (await repo.load(again))!;
      expect(data.title, 'Piernas A');
      expect(data.exercises.single.exercise.catalogKey, 'back_squat_barbell');
      expect(data.exercises.single.sets.length, 2);
      expect(data.exercises.single.restSeconds, 120);
      expect(data.exercises.single.sets.first.proposed.weight, 82.5);
      expect(data.completedSets, 0);
    });
  });

  group('última marca y serie repetida', () {
    test('cada serie muestra la misma serie de la sesión anterior', () async {
      final routineId = await legs();
      final first = await repo.startFromRoutine(routineId);
      var data = (await repo.load(first))!;
      final squat = data.exercises.first.sets;
      await repo.completeSet(
        squat[0].id,
        const SetValues(weight: 80, unit: WeightUnit.kg, reps: 8),
      );
      await repo.completeSet(
        squat[1].id,
        const SetValues(weight: 80, unit: WeightUnit.kg, reps: 7),
      );
      await repo.finish(first);

      final second = await repo.startFromRoutine(routineId);
      data = (await repo.load(second))!;
      final sets = data.exercises.first.sets;
      expect(sets[0].previous?.reps, 8);
      expect(sets[1].previous?.reps, 7);
      // Sin la tercera la vez anterior: se propone el objetivo de la rutina.
      expect(sets[2].previous, isNull);
      expect(sets[1].proposed.reps, 7);
      expect(sets[2].proposed.reps, 8);
      expect(sets[2].proposed.weight, 80);
      // El peso muerto no se hizo: sin última marca.
      expect(data.exercises[1].sets.first.previous, isNull);
    });

    test(
      '✓ con valores propuestos guarda la serie tal cual (1 toque)',
      () async {
        final routineId = await legs();
        final first = await repo.startFromRoutine(routineId);
        await doAll(first);

        final second = await repo.startFromRoutine(routineId);
        var data = (await repo.load(second))!;
        final set = data.exercises.first.sets.first;
        await repo.completeSet(set.id, set.proposed);

        data = (await repo.load(second))!;
        final done = data.exercises.first.sets.first;
        expect(done.completed, isTrue);
        expect(done.log.weightValue, 80);
        expect(done.log.weightGrams, 80000);
        expect(done.log.reps, 8);
        expect(done.log.loggedAt, isNotNull);
        expect(data.completedSets, 1);
      },
    );

    test(
      'desmarcar devuelve la serie a por hacer sin perder valores',
      () async {
        final id = await repo.startFromRoutine(await legs());
        var set = (await repo.load(id))!.exercises.first.sets.first;
        await repo.completeSet(
          set.id,
          const SetValues(weight: 85, unit: WeightUnit.kg, reps: 6, rpe: 8.5),
        );
        await repo.uncompleteSet(set.id);
        set = (await repo.load(id))!.exercises.first.sets.first;
        expect(set.completed, isFalse);
        expect(set.stored.weight, 85);
        expect(set.log.loggedAt, isNull);
      },
    );

    test('el peso se guarda en su unidad original (R-G7)', () async {
      final id = await repo.startFromRoutine(await legs());
      final set = (await repo.load(id))!.exercises.first.sets.first;
      await repo.completeSet(
        set.id,
        const SetValues(weight: 185, unit: WeightUnit.lb, reps: 5),
      );
      final row = (await db.sessionsDao.findSet(set.id))!;
      expect(row.weightValue, 185);
      expect(row.weightUnit, WeightUnit.lb);
      expect(row.weightGrams, 83915);
      expect(SetValues.ofLog(row).weightIn(WeightUnit.kg), 83.92);
    });
  });

  group('ejercicios y series en la sesión', () {
    test('agregar serie copia la última; quitar y reordenar', () async {
      final id = await repo.startFromRoutine(await legs());
      var data = (await repo.load(id))!;
      final squatId = data.exercises.first.id;
      final newSet = await repo.addSet(squatId);
      data = (await repo.load(id))!;
      expect(data.exercises.first.sets.length, 4);
      expect(data.exercises.first.sets.last.id, newSet);
      expect(data.exercises.first.sets.last.stored.weight, 80);

      await repo.removeSet(newSet);
      await repo.moveExercise(id, 0, 2);
      await repo.setNotes(squatId, '  Rodilla bien  ');
      data = (await repo.load(id))!;
      expect(data.exercises.map((e) => e.exercise.catalogKey), [
        'romanian_deadlift_barbell',
        'plank',
        'back_squat_barbell',
      ]);
      expect(data.exercises.last.sets.length, 3);
      expect(data.exercises.last.entry.notes, 'Rodilla bien');
    });
  });

  group('terminar', () {
    test('series sin marcar: descartarlas o darlas por hechas', () async {
      final routineId = await legs();
      final a = await repo.startFromRoutine(routineId);
      var data = (await repo.load(a))!;
      await repo.completeSet(
        data.exercises.first.sets.first.id,
        data.exercises.first.sets.first.proposed,
      );
      expect(await repo.finish(a), SessionStatus.completed);
      data = (await repo.load(a))!;
      expect(data.totalSets, 1);
      // Los ejercicios sin series se quitan.
      expect(data.exercises.length, 1);
      expect(data.session.endedAt, isNotNull);

      final b = await repo.startFromRoutine(routineId);
      data = (await repo.load(b))!;
      await repo.completeSet(
        data.exercises.first.sets.first.id,
        data.exercises.first.sets.first.proposed,
      );
      await repo.finish(b, pending: PendingSets.complete);
      data = (await repo.load(b))!;
      // Sentadilla (con peso) y plancha (por tiempo) se dan por hechas; el
      // peso muerto no tiene peso propuesto y se quita.
      expect(data.exercises.map((e) => e.exercise.catalogKey), [
        'back_squat_barbell',
        'plank',
      ]);
      expect(data.completedSets, 6);
    });

    test('sin ninguna serie hecha la sesión se descarta (R-G11)', () async {
      final id = await repo.startFromRoutine(await legs());
      expect(await repo.finish(id), SessionStatus.discarded);
    });

    test('volumen sin calentamiento y récord del día', () async {
      final routineId = await legs();
      final first = await repo.startFromRoutine(routineId);
      await doAll(first);

      final second = await repo.startFromRoutine(routineId);
      final data = (await repo.load(second))!;
      final squat = data.exercises.first.sets;
      await repo.completeSet(
        squat[0].id,
        const SetValues(
          weight: 40,
          unit: WeightUnit.kg,
          reps: 10,
          type: SetType.warmup,
        ),
      );
      await repo.completeSet(
        squat[1].id,
        const SetValues(weight: 85, unit: WeightUnit.kg, reps: 8),
      );
      await repo.finish(second);
      final summary = (await repo.summary(second))!;
      // 85 × 8 = 680 kg; el calentamiento no cuenta.
      expect(summary.data.volumeGrams, 680000);
      expect(await db.sessionsDao.watchVolumeGrams(second).first, 680000);
      final record = summary.records.single;
      expect(record.exercise.catalogKey, 'back_squat_barbell');
      expect(record.weightRecord, isTrue);
      expect(record.set.reps, 8);
      expect(record.oneRmGrams!.round(), 107667);
      expect(summary.durationSeconds, greaterThanOrEqualTo(0));
      // Quitó ejercicios y series: se ofrece actualizar la rutina.
      expect(summary.routineName, 'Piernas A');
      expect(summary.routineChanged, isTrue);

      await repo.updateRoutineFromSession(second);
      final routine = (await routines.load(routineId))!;
      expect(routine.entries.single.exercise.catalogKey, 'back_squat_barbell');
      expect(routine.entries.single.sets, 2);
      // Los objetivos de peso no cambian.
      expect(routine.entries.single.weight, 80);
    });

    test('guardar como incompleta y descartar al recuperar', () async {
      final routineId = await legs();
      final a = await repo.startFromRoutine(routineId);
      final set = (await repo.load(a))!.exercises.first.sets.first;
      await repo.completeSet(set.id, set.proposed);
      await repo.markRecoveryPending(a);
      expect((await repo.findActive()).single.id, a);
      expect(await repo.saveIncomplete(a), SessionStatus.incomplete);
      final saved = (await repo.load(a))!;
      expect(saved.totalSets, 1);
      expect(saved.session.endedAt, saved.allSets.first.log.loggedAt);
      expect(await repo.findActive(), isEmpty);

      final b = await repo.startFromRoutine(routineId);
      await repo.discard(b);
      expect(await repo.findActive(), isEmpty);
    });
  });

  test('un cierre a la fuerza no pierde ninguna serie marcada', () async {
    // Base en un archivo: se cierra sin terminar la sesión (como un
    // `kill -9`) y se vuelve a abrir.
    final dir = await Directory.systemTemp.createTemp('trainloop');
    final file = File('${dir.path}/t.sqlite');
    final first = AppDatabase(NativeDatabase(file));
    await seedExerciseCatalog(first.exercisesDao);
    final squat = (await first.exercisesDao.findByCatalogKey(
      'back_squat_barbell',
    ))!;
    final r1 = StrengthSessionRepository(first);
    final routineId = await RoutineRepository(first).save(
      const RoutineDraft(name: 'Fuerza').addAll([squat]),
      fallbackName: 'x',
    );
    final id = await r1.startFromRoutine(routineId);
    final sets = (await r1.load(id))!.exercises.first.sets;
    for (final s in sets) {
      await r1.completeSet(
        s.id,
        const SetValues(weight: 100, unit: WeightUnit.kg, reps: 5),
      );
    }
    await first.close();

    final second = AppDatabase(NativeDatabase(file));
    final r2 = StrengthSessionRepository(second);
    final active = await r2.findActive();
    expect(active.single.id, id);
    final data = (await r2.load(id))!;
    expect(data.completedSets, 3);
    expect(data.volumeGrams, 1500000);
    await second.close();
    await dir.delete(recursive: true);
  });
}
