import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/database_providers.dart';
import '../../../platform/timer_engine_client.dart';
import '../data/interval_session_repository.dart';
import '../data/interval_workout_repository.dart';

/// Motor nativo. Las pruebas lo sobrescriben con un doble.
final timerEngineClientProvider = Provider<TimerEngineClient>(
  (ref) => MethodChannelTimerEngine(),
);

final intervalWorkoutRepositoryProvider = Provider<IntervalWorkoutRepository>(
  (ref) => IntervalWorkoutRepository(ref.watch(appDatabaseProvider)),
);

final intervalSessionRepositoryProvider = Provider<IntervalSessionRepository>(
  (ref) => IntervalSessionRepository(ref.watch(appDatabaseProvider)),
);

/// Entrenamientos activos, por nombre, con su estructura.
final intervalSummariesProvider = StreamProvider<List<IntervalWorkoutSummary>>(
  (ref) => ref.watch(intervalWorkoutRepositoryProvider).watchSummaries(),
);
