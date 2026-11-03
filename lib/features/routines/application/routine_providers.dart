import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/daos/routines_dao.dart';
import '../../../data/db/database_providers.dart';
import '../data/routine_repository.dart';

final routineRepositoryProvider = Provider<RoutineRepository>(
  (ref) => RoutineRepository(ref.watch(appDatabaseProvider)),
);

/// Rutinas activas en su orden, con la cantidad de ejercicios.
final routineSummariesProvider = StreamProvider<List<RoutineSummary>>(
  (ref) => ref.watch(routineRepositoryProvider).watchSummaries(),
);
