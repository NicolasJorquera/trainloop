import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/app_database.dart';
import '../../../data/db/database_providers.dart';
import '../../settings/application/settings_controller.dart';
import '../data/history_repository.dart';
import '../data/records_repository.dart';
import '../domain/week.dart';

final historyRepositoryProvider = Provider<HistoryRepository>(
  (ref) => HistoryRepository(ref.watch(appDatabaseProvider)),
);

final recordsRepositoryProvider = Provider<RecordsRepository>(
  (ref) => RecordsRepository(ref.watch(appDatabaseProvider)),
);

/// Reloj de la app; las pruebas lo fijan para que "hoy" no dependa del día.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Sesiones del historial (completadas e incompletas, sin borradas), la más
/// reciente primero.
final historyEntriesProvider = StreamProvider<List<HistoryEntry>>(
  (ref) => ref.watch(historyRepositoryProvider).watchEntries(),
);

/// Plan por día (F-11).
final weekPlanProvider = StreamProvider<List<PlannedWorkout>>(
  (ref) => ref.watch(historyRepositoryProvider).watchPlan(),
);

/// Resumen de la semana en curso para Inicio y Progreso.
class WeekSummary {
  const WeekSummary({
    required this.week,
    required this.goal,
    required this.streak,
    required this.today,
  });

  final WeekStats week;
  final int goal;
  final int streak;
  final DateTime today;
}

/// Semana actual según el inicio de semana y el objetivo de Configuración.
final weekSummaryProvider = Provider<AsyncValue<WeekSummary>>((ref) {
  final settings = ref.watch(settingsControllerProvider);
  final today = civilToday(ref.watch(clockProvider)());
  return ref
      .watch(historyEntriesProvider)
      .whenData(
        (entries) => WeekSummary(
          week: statsForWeek(entries, weekStartOf(today, settings.weekStart)),
          goal: settings.weeklyGoal,
          streak: weeklyStreak(
            entries,
            today: today,
            start: settings.weekStart,
            goal: settings.weeklyGoal,
          ),
          today: today,
        ),
      );
});

/// Una sesión del historial por id (detalle S13); `null` si se borró.
final historyEntryProvider = Provider.family<AsyncValue<HistoryEntry?>, String>(
  (ref, id) => ref
      .watch(historyEntriesProvider)
      .whenData((all) => all.where((e) => e.id == id).firstOrNull),
);

/// Récords de un ejercicio (S15).
final exerciseRecordsProvider = StreamProvider.autoDispose
    .family<List<PersonalRecord>, String>(
      (ref, id) => ref.watch(recordsRepositoryProvider).watchForExercise(id),
    );
