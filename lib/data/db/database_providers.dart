import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import 'daos/ad_state_dao.dart';
import 'daos/exercises_dao.dart';
import 'daos/interval_workouts_dao.dart';
import 'daos/plan_dao.dart';
import 'daos/records_dao.dart';
import 'daos/routines_dao.dart';
import 'daos/sessions_dao.dart';

/// Instancia única de la base; se cierra al desechar el ProviderScope.
/// Las pruebas la sobrescriben con una base en memoria.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final exercisesDaoProvider = Provider<ExercisesDao>(
  (ref) => ref.watch(appDatabaseProvider).exercisesDao,
);

final routinesDaoProvider = Provider<RoutinesDao>(
  (ref) => ref.watch(appDatabaseProvider).routinesDao,
);

final intervalWorkoutsDaoProvider = Provider<IntervalWorkoutsDao>(
  (ref) => ref.watch(appDatabaseProvider).intervalWorkoutsDao,
);

final sessionsDaoProvider = Provider<SessionsDao>(
  (ref) => ref.watch(appDatabaseProvider).sessionsDao,
);

final recordsDaoProvider = Provider<RecordsDao>(
  (ref) => ref.watch(appDatabaseProvider).recordsDao,
);

final planDaoProvider = Provider<PlanDao>(
  (ref) => ref.watch(appDatabaseProvider).planDao,
);

final adStateDaoProvider = Provider<AdStateDao>(
  (ref) => ref.watch(appDatabaseProvider).adStateDao,
);
