import 'dart:convert';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/core/units/weight_unit.dart';
import 'package:trainloop/data/db/app_database.dart';
import 'package:trainloop/data/db/daos/exercises_dao.dart';
import 'package:trainloop/data/db/daos/interval_workouts_dao.dart';
import 'package:trainloop/data/db/daos/routines_dao.dart';
import 'package:trainloop/data/db/enums.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = openTestDatabase());
  tearDown(() => db.close());

  Future<String> bench() => db.exercisesDao.create(
    name: 'Press de Banca',
    logType: ExerciseLogType.weightReps,
    primaryMuscle: Muscle.chest,
    equipment: Equipment.barbell,
    incrementValue: 2.5,
    incrementUnit: WeightUnit.kg,
  );

  group('base', () {
    test('crea las 14 tablas con claves foráneas activas', () async {
      expect((await db.rowCounts()).keys, hasLength(14));
      final fk = await db.customSelect('PRAGMA foreign_keys').getSingle();
      expect(fk.data.values.single, 1);
    });

    test('ids UUID y fechas en milisegundos UTC', () async {
      final id = await bench();
      expect(id, matches(RegExp(r'^[0-9a-f-]{36}$')));
      final raw = await db
          .customSelect('SELECT created_at FROM exercise')
          .getSingle();
      expect(raw.data['created_at'], isA<int>());
      final row = await db.exercisesDao.findById(id);
      expect(row!.createdAt.isUtc, isTrue);
    });

    test('rechaza una referencia a un ejercicio inexistente', () async {
      final routineId = await db.routinesDao.create(
        StrengthRoutinesCompanion.insert(name: 'A'),
      );
      expect(
        () => db.routinesDao.replaceExercises(routineId, [
          const RoutineExerciseDraft(exerciseId: 'no-existe'),
        ]),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('ejercicios', () {
    test('normaliza el nombre y detecta duplicados', () async {
      final id = await bench();
      final row = (await db.exercisesDao.findById(id))!;
      expect(row.normalizedName, 'press de banca');
      expect(row.incrementGrams, 2500);
      expect(normalizeName('  Elevación   Única '), 'elevacion unica');
      expect(await db.exercisesDao.findByName('press DE banca'), hasLength(1));
    });

    test('archivar lo oculta de la lista; filtra por músculo', () async {
      final id = await bench();
      await db.exercisesDao.create(
        name: 'Sentadilla',
        logType: ExerciseLogType.weightReps,
        primaryMuscle: Muscle.quads,
      );
      expect(await db.exercisesDao.watchActive().first, hasLength(2));
      expect(
        await db.exercisesDao.watchActive(muscle: Muscle.quads).first,
        hasLength(1),
      );
      await db.exercisesDao.archive(id);
      final active = await db.exercisesDao.watchActive().first;
      expect(active.map((e) => e.name), ['Sentadilla']);
      expect((await db.exercisesDao.findById(id))!.archivedAt, isNotNull);
    });
  });

  group('rutinas', () {
    test('guarda ejercicios y series en orden, con gramos', () async {
      final ex = await bench();
      final routineId = await db.routinesDao.create(
        StrengthRoutinesCompanion.insert(name: 'Empuje'),
      );
      final targets = [
        const RoutineSetTargetsCompanion(
          reps: Value(8),
          weightValue: Value(135),
          weightUnit: Value(WeightUnit.lb),
        ),
        const RoutineSetTargetsCompanion(reps: Value(6)),
      ];
      await db.routinesDao.replaceExercises(routineId, [
        RoutineExerciseDraft(exerciseId: ex, restSeconds: 90, targets: targets),
      ]);
      // Reemplazar no duplica filas.
      await db.routinesDao.replaceExercises(routineId, [
        RoutineExerciseDraft(exerciseId: ex, restSeconds: 90, targets: targets),
      ]);
      final detail = (await db.routinesDao.getDetail(routineId))!;
      expect(detail.exercises, hasLength(1));
      final sets = detail.exercises.single.targets;
      expect(sets.map((s) => s.sortOrder), [0, 1]);
      expect(sets.first.weightGrams, 61235);
      expect(sets.last.weightGrams, isNull);
      expect((await db.rowCounts())['routine_set_target'], 2);
      expect(jsonEncode(detail.toSnapshot()), contains('Press de Banca'));
    });
  });

  group('intervalos', () {
    test('guarda un árbol de bloques con grupos anidados', () async {
      final id = await db.intervalWorkoutsDao.create(
        IntervalWorkoutsCompanion.insert(name: 'Tabata'),
      );
      await db.intervalWorkoutsDao.replaceBlocks(id, [
        const IntervalBlockDraft.interval(
          phaseType: PhaseType.warmup,
          durationSeconds: 300,
        ),
        const IntervalBlockDraft.group(
          rounds: 8,
          children: [
            IntervalBlockDraft.interval(
              phaseType: PhaseType.work,
              durationSeconds: 20,
            ),
            IntervalBlockDraft.interval(
              phaseType: PhaseType.rest,
              durationSeconds: 10,
            ),
          ],
        ),
      ]);
      final detail = (await db.intervalWorkoutsDao.getDetail(id))!;
      final top = detail.childrenOf(null);
      expect(top.map((b) => b.kind), [
        IntervalBlockKind.interval,
        IntervalBlockKind.group,
      ]);
      expect(top.last.rounds, 8);
      expect(detail.childrenOf(top.last.id).map((b) => b.phaseType), [
        PhaseType.work,
        PhaseType.rest,
      ]);
    });
  });

  group('sesiones', () {
    test('copia la plantilla, registra series y calcula volumen', () async {
      final ex = await bench();
      final sessionId = await db.sessionsDao.start(
        kind: SessionKind.strength,
        templateSnapshot: {'name': 'Empuje', 'sets': 3},
        timeZoneId: 'America/Santiago',
      );
      final session = (await db.sessionsDao.findById(sessionId))!;
      expect(session.templateSnapshot, {'name': 'Empuje', 'sets': 3});
      expect(session.status, SessionStatus.inProgress);
      expect(session.utcOffsetMinutes, DateTime.now().timeZoneOffset.inMinutes);
      expect(await db.sessionsDao.findRecoverable(), hasLength(1));

      final seId = await db.sessionsDao.addExercise(
        sessionId: sessionId,
        exerciseId: ex,
        sortOrder: 0,
      );
      SetLogsCompanion set(int order, double kg, int reps) =>
          SetLogsCompanion.insert(
            sessionExerciseId: seId,
            sessionId: sessionId,
            exerciseId: ex,
            sortOrder: order,
            weightValue: Value(kg),
            weightUnit: const Value(WeightUnit.kg),
            reps: Value(reps),
            completed: const Value(true),
          );
      final first = await db.sessionsDao.logSet(set(0, 100, 5));
      await db.sessionsDao.logSet(set(1, 102.5, 5));
      // Corregir una serie la reescribe en vez de duplicarla.
      await db.sessionsDao.logSet(set(0, 100, 6).copyWith(id: Value(first)));

      final sets = await db.sessionsDao.watchSets(sessionId).first;
      expect(sets, hasLength(2));
      expect(sets.first.reps, 6);
      expect(sets.first.weightGrams, 100000);
      expect(
        await db.sessionsDao.watchVolumeGrams(sessionId).first,
        100000 * 6 + 102500 * 5,
      );

      // En curso no aparece en el historial ni en el gráfico.
      expect(await db.sessionsDao.watchHistory().first, isEmpty);
      expect(await db.sessionsDao.watchSetsForExercise(ex).first, isEmpty);

      await db.sessionsDao.finish(
        sessionId,
        status: SessionStatus.completed,
        perceivedEffort: 8,
      );
      expect(await db.sessionsDao.watchHistory().first, hasLength(1));
      expect(await db.sessionsDao.watchSetsForExercise(ex).first, hasLength(2));
      expect(await db.sessionsDao.findRecoverable(), isEmpty);
    });

    test('guarda fases y el punto de recuperación', () async {
      final id = await db.sessionsDao.start(kind: SessionKind.intervals);
      await db.sessionsDao.logPhase(
        IntervalPhaseLogsCompanion.insert(
          sessionId: id,
          sortOrder: 0,
          phaseType: PhaseType.work,
          plannedSeconds: 20,
          actualSeconds: 19,
        ),
      );
      await db.sessionsDao.saveCheckpoint(
        id,
        phaseIndex: 1,
        elapsedMs: 4200,
        pausedSeconds: 3,
      );
      final phases = await db.sessionsDao.watchPhases(id).first;
      expect(phases.single.actualSeconds, 19);
      final s = (await db.sessionsDao.findById(id))!;
      expect([s.checkpointPhaseIndex, s.checkpointElapsedMs], [1, 4200]);
      expect(s.pausedSeconds, 3);
    });

    test('el esfuerzo percibido va de 1 a 10', () async {
      final id = await db.sessionsDao.start(kind: SessionKind.intervals);
      expect(
        () => db.sessionsDao.finish(
          id,
          status: SessionStatus.completed,
          perceivedEffort: 11,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('récords, plan y anuncios', () {
    test('un récord por ejercicio y tipo', () async {
      final ex = await bench();
      final at = DateTime.utc(2026, 11, 1);
      for (final value in [100000.0, 105000.0]) {
        await db.recordsDao.upsert(
          exerciseId: ex,
          type: RecordType.maxWeight,
          value: value,
          achievedAt: at,
        );
      }
      final records = await db.recordsDao.watchForExercise(ex).first;
      expect(records.single.value, 105000);
      expect(await db.recordsDao.clearForExercise(ex), 1);
    });

    test('plan por día y recordatorios', () async {
      PlanDaysCompanion entry(String id) => PlanDaysCompanion.insert(
        weekday: 1,
        kind: SessionKind.strength,
        templateId: id,
      );
      await db.planDao.setDay(1, [entry('a'), entry('b')]);
      await db.planDao.setDay(1, [entry('c')]);
      expect((await db.planDao.watchPlan().first).map((d) => d.templateId), [
        'c',
      ]);

      final id = await db.planDao.addReminder(
        RemindersCompanion.insert(weekday: 3, minuteOfDay: 7 * 60),
      );
      await db.planDao.editReminder(
        id,
        const RemindersCompanion(enabled: Value(false)),
      );
      expect((await db.planDao.watchReminders().first).single.enabled, false);
      expect(
        () => db.planDao.addReminder(
          RemindersCompanion.insert(weekday: 3, minuteOfDay: 1500),
        ),
        throwsA(isA<Exception>()),
      );
      expect(await db.planDao.deleteReminder(id), 1);
    });

    test('estado de anuncios en una fila única', () async {
      final initial = await db.adStateDao.read();
      expect(initial.consentStatus, ConsentStatus.unknown);
      await db.adStateDao.countSession();
      await db.adStateDao.countSession();
      expect((await db.adStateDao.read()).sessionsSinceInterstitial, 2);
      await db.adStateDao.markInterstitialShown();
      final after = await db.adStateDao.read();
      expect(after.sessionsSinceInterstitial, 0);
      expect(after.lastInterstitialAt, isNotNull);
      expect((await db.rowCounts())['ad_state'], 1);
    });
  });
}
