import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/app_database.dart';
import '../../../data/db/database_providers.dart';
import '../data/exercise_repository.dart';

final exerciseRepositoryProvider = Provider<ExerciseRepository>(
  (ref) => ExerciseRepository(ref.watch(exercisesDaoProvider)),
);

/// Ejercicios activos (incluidos y propios), sin ordenar: el orden depende
/// del idioma y lo aplica `filterExercises`.
final exerciseLibraryProvider = StreamProvider<List<Exercise>>(
  (ref) => ref.watch(exerciseRepositoryProvider).watchLibrary(),
);
