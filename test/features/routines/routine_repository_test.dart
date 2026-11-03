import 'dart:convert';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/core/units/weight_unit.dart';
import 'package:trainloop/data/catalog/exercise_catalog_seeder.dart';
import 'package:trainloop/data/db/app_database.dart';
import 'package:trainloop/data/db/daos/routines_dao.dart';
import 'package:trainloop/data/db/enums.dart';
import 'package:trainloop/features/routines/data/routine_repository.dart';
import 'package:trainloop/features/routines/domain/routine_draft.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late RoutineRepository repo;
  late Map<String, Exercise> ex;

  setUp(() async {
    db = openTestDatabase();
    repo = RoutineRepository(db);
    await seedExerciseCatalog(db.exercisesDao);
    ex = {
      for (final e in await db.exercisesDao.watchActive().first)
        e.catalogKey!: e,
    };
  });
  tearDown(() => db.close());

  Future<String> legs({String name = 'Piernas A'}) {
    final draft = RoutineDraft(name: name).addAll([
      ex['back_squat_barbell']!,
      ex['romanian_deadlift_barbell']!,
      ex['plank']!,
    ]);
    return repo.save(
      draft.replaceAt(
        0,
        draft.entries[0].copyWith(
          sets: 5,
          reps: 5,
          weight: () => 100,
          weightUnit: WeightUnit.kg,
        ),
      ),
      fallbackName: 'Rutina 1',
    );
  }

  test('guarda y vuelve a cargar la rutina con sus objetivos', () async {
    final id = await legs();
    final draft = (await repo.load(id))!;
    expect(draft.name, 'Piernas A');
    expect(draft.entries.map((e) => e.exercise.catalogKey), [
      'back_squat_barbell',
      'romanian_deadlift_barbell',
      'plank',
    ]);
    final squat = draft.entries.first;
    expect((squat.sets, squat.reps, squat.weight), (5, 5, 100));
    expect(squat.restSeconds, 180);
    expect(draft.entries.last.durationSeconds, 45);
    expect(draft.entries.last.reps, isNull);
    final detail = (await db.routinesDao.getDetail(id))!;
    expect(detail.exercises.first.targets.first.weightGrams, 100000);
  });

  test('un nombre vacío usa el nombre por defecto', () async {
    final id = await repo.save(
      const RoutineDraft(name: '  ').addAll([ex['plank']!]),
      fallbackName: 'Rutina 1',
    );
    expect((await repo.load(id))!.name, 'Rutina 1');
  });

  test(
    'duplicar copia rutina, ejercicios y series sin compartir filas',
    () async {
      final id = await legs();
      final copyId = await repo.duplicate(id, name: 'Piernas A (copia)');
      final source = (await db.routinesDao.getDetail(id))!;
      final copy = (await db.routinesDao.getDetail(copyId))!;
      expect(copy.routine.name, 'Piernas A (copia)');
      expect(copy.routine.sortOrder, greaterThan(source.routine.sortOrder));
      expect(
        copy.exercises.map((e) => (e.exercise.id, e.entry.restSeconds)),
        source.exercises.map((e) => (e.exercise.id, e.entry.restSeconds)),
      );
      expect(
        copy.exercises.map(
          (e) => e.targets.map((t) => (t.reps, t.weightGrams)),
        ),
        source.exercises.map(
          (e) => e.targets.map((t) => (t.reps, t.weightGrams)),
        ),
      );
      final sourceIds = {
        for (final e in source.exercises) ...[
          e.entry.id,
          ...e.targets.map((t) => t.id),
        ],
      };
      for (final e in copy.exercises) {
        expect(sourceIds, isNot(contains(e.entry.id)));
        expect(
          sourceIds.intersection(e.targets.map((t) => t.id).toSet()),
          isEmpty,
        );
      }
      // Editar la copia no toca el original.
      await repo.save((await repo.load(copyId))!.removeAt(0), fallbackName: '');
      expect((await db.routinesDao.getDetail(id))!.exercises, hasLength(3));
    },
  );

  test(
    'lista en orden con conteo; reordenar y archivar con deshacer',
    () async {
      final a = await legs(name: 'A');
      final b = await legs(name: 'B');
      final c = await repo.save(
        const RoutineDraft(name: 'C').addAll([ex['plank']!]),
        fallbackName: '',
      );
      List<String> names(List<RoutineSummary> s) => [
        for (final r in s) r.routine.name,
      ];

      var list = await repo.watchSummaries().first;
      expect(names(list), ['A', 'B', 'C']);
      expect(list.map((s) => s.exerciseCount), [3, 3, 1]);

      await repo.reorder([c, a, b]);
      expect(names(await repo.watchSummaries().first), ['C', 'A', 'B']);

      await repo.archive(a);
      list = await repo.watchSummaries().first;
      expect(names(list), ['C', 'B']);
      await repo.unarchive(a);
      expect(names(await repo.watchSummaries().first), ['C', 'A', 'B']);
    },
  );

  test('editar o archivar la rutina no altera sesiones pasadas', () async {
    final id = await legs();
    final squat = ex['back_squat_barbell']!;

    // Sesión con la copia de la plantilla y una serie registrada.
    final snapshot = (await db.routinesDao.getDetail(id))!.toSnapshot();
    final sessionId = await db.sessionsDao.start(
      kind: SessionKind.strength,
      templateId: id,
      templateSnapshot: snapshot,
    );
    final seId = await db.sessionsDao.addExercise(
      sessionId: sessionId,
      exerciseId: squat.id,
      sortOrder: 0,
    );
    await db.sessionsDao.logSet(
      SetLogsCompanion.insert(
        sessionExerciseId: seId,
        sessionId: sessionId,
        exerciseId: squat.id,
        sortOrder: 0,
        weightValue: const Value(100),
        weightUnit: const Value(WeightUnit.kg),
        reps: const Value(5),
        completed: const Value(true),
      ),
    );
    await db.sessionsDao.finish(sessionId, status: SessionStatus.completed);
    final before = (await db.sessionsDao.findById(sessionId))!;
    final setsBefore = await db.sessionsDao.watchSets(sessionId).first;

    // Renombrar, quitar el ejercicio registrado, archivar la rutina y el
    // ejercicio.
    final draft = (await repo.load(id))!.rename('Piernas B').removeAt(0);
    await repo.save(draft, fallbackName: '');
    await repo.archive(id);
    await db.exercisesDao.archive(squat.id);

    final after = (await db.sessionsDao.findById(sessionId))!;
    expect(
      jsonEncode(after.templateSnapshot),
      jsonEncode(before.templateSnapshot),
    );
    expect((after.templateSnapshot!['routine']! as Map)['name'], 'Piernas A');
    expect(after.templateSnapshot!['exercises'], hasLength(3));
    expect(after.status, SessionStatus.completed);
    final setsAfter = await db.sessionsDao.watchSets(sessionId).first;
    expect(setsAfter.map((s) => s.toJson()), setsBefore.map((s) => s.toJson()));
    expect(await db.sessionsDao.watchHistory().first, hasLength(1));

    // Lo archivado sigue legible desde el historial.
    final archivedExercise = (await db.exercisesDao.findById(
      setsAfter.single.exerciseId,
    ))!;
    expect(archivedExercise.archivedAt, isNotNull);
    expect(archivedExercise.catalogKey, 'back_squat_barbell');
    final archivedRoutine = (await db.routinesDao.getDetail(id))!;
    expect(archivedRoutine.routine.archivedAt, isNotNull);
    expect(archivedRoutine.routine.name, 'Piernas B');
  });
}
