import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/app_database.dart';
import '../../../data/db/database_providers.dart';
import '../data/progress_repository.dart';

final progressRepositoryProvider = Provider<ProgressRepository>(
  (ref) => ProgressRepository(ref.watch(appDatabaseProvider)),
);

/// Ejercicios con historial, el más reciente primero (última marca, S14).
final exerciseProgressListProvider = StreamProvider<List<ExerciseProgress>>(
  (ref) => ref.watch(progressRepositoryProvider).watchAll(),
);

/// Historial de un ejercicio (S15).
final exerciseProgressProvider = StreamProvider.autoDispose
    .family<ExerciseProgress?, String>(
      (ref, id) => ref.watch(progressRepositoryProvider).watchExercise(id),
    );

/// Todos los récords (para marcar "récord" en la última marca de S14).
final allRecordsProvider = StreamProvider<List<PersonalRecord>>(
  (ref) => ref.watch(appDatabaseProvider).recordsDao.watchAll(),
);
