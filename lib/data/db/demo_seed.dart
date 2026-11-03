import 'package:drift/drift.dart';

import '../../core/units/weight_unit.dart';
import 'app_database.dart';
import 'daos/interval_workouts_dao.dart';
import 'daos/routines_dao.dart';
import 'enums.dart';

/// Datos de prueba para depuración: un ejercicio, una rutina, un
/// temporizador y una sesión completada con dos series. Cada llamada suma
/// filas nuevas, así se ve si los conteos sobreviven a reiniciar la app.
Future<void> seedDemoData(AppDatabase db) => db.transaction(() async {
  final exerciseId = await db.exercisesDao.create(
    name: 'Press de banca',
    logType: ExerciseLogType.weightReps,
    primaryMuscle: Muscle.chest,
    equipment: Equipment.barbell,
    incrementValue: 2.5,
    incrementUnit: WeightUnit.kg,
    isCustom: false,
  );

  final routineId = await db.routinesDao.create(
    StrengthRoutinesCompanion.insert(name: 'Empuje'),
  );
  await db.routinesDao.replaceExercises(routineId, [
    RoutineExerciseDraft(
      exerciseId: exerciseId,
      restSeconds: 120,
      targets: [
        for (var i = 0; i < 3; i++)
          const RoutineSetTargetsCompanion(
            reps: Value(8),
            weightValue: Value(60),
            weightUnit: Value(WeightUnit.kg),
          ),
      ],
    ),
  ]);

  final workoutId = await db.intervalWorkoutsDao.create(
    IntervalWorkoutsCompanion.insert(name: 'Tabata'),
  );
  await db.intervalWorkoutsDao.replaceBlocks(workoutId, [
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

  final routine = await db.routinesDao.getDetail(routineId);
  final sessionId = await db.sessionsDao.start(
    kind: SessionKind.strength,
    templateId: routineId,
    templateSnapshot: routine?.toSnapshot(),
  );
  final entryId = await db.sessionsDao.addExercise(
    sessionId: sessionId,
    exerciseId: exerciseId,
    sortOrder: 0,
  );
  for (var i = 0; i < 2; i++) {
    await db.sessionsDao.logSet(
      SetLogsCompanion.insert(
        sessionExerciseId: entryId,
        sessionId: sessionId,
        exerciseId: exerciseId,
        sortOrder: i,
        weightValue: const Value(60),
        weightUnit: const Value(WeightUnit.kg),
        reps: const Value(8),
        completed: const Value(true),
        loggedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }
  await db.sessionsDao.finish(sessionId, status: SessionStatus.completed);
});
