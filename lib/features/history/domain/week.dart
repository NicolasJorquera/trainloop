import '../../../data/db/app_database.dart';
import '../../../data/db/enums.dart';
import '../../settings/domain/app_settings.dart';

// Calendario de la persona (R-P1, R-P2). Los días se representan como
// fechas civiles en UTC a medianoche (sin hora ni zona), así sumar días no
// sufre los cambios de horario.

/// Fecha civil (medianoche UTC) de [t] tal como se lee en su reloj.
DateTime civilDay(DateTime t) => DateTime.utc(t.year, t.month, t.day);

/// Hoy en el reloj del teléfono.
DateTime civilToday([DateTime? now]) =>
    civilDay((now ?? DateTime.now()).toLocal());

/// Hora de inicio de la sesión en el reloj local de cuando empezó (R-P2:
/// la zona registrada al empezar), como fecha UTC "de pared".
DateTime sessionWallClock(Session s) =>
    s.startedAt.toUtc().add(Duration(minutes: s.utcOffsetMinutes));

/// Día local al que pertenece una sesión (R-P2).
DateTime sessionDay(Session s) => civilDay(sessionWallClock(s));

/// Primer día de la semana que contiene [day] según [start] (R-P1).
DateTime weekStartOf(DateTime day, WeekStart start) {
  final d = civilDay(day);
  final back = (d.weekday - start.weekday) % 7;
  return d.subtract(Duration(days: back));
}

/// Los 7 días de la semana que empieza en [weekStart].
List<DateTime> weekDays(DateTime weekStart) => [
  for (var i = 0; i < 7; i++) weekStart.add(Duration(days: i)),
];

/// Sesión del historial con lo que muestran las listas, la semana y el
/// progreso. Se arma en `HistoryRepository`.
class HistoryEntry {
  const HistoryEntry({
    required this.session,
    required this.title,
    required this.activeSeconds,
    this.volumeGrams = 0,
    this.completedSets = 0,
    this.roundsDone = 0,
    this.roundsPlanned = 0,
    this.workSeconds = 0,
  });

  final Session session;

  /// Rutina o entrenamiento copiado; `null` en un entrenamiento libre.
  final String? title;

  /// Duración activa, sin pausas: en fuerza fin − inicio − pausas; en
  /// intervalos la suma de las fases registradas (como el resumen de D4).
  final int activeSeconds;

  /// Fuerza: volumen sin calentamiento (gramos) y series hechas (todas).
  final int volumeGrams;
  final int completedSets;

  /// Intervalos: rondas hechas / planificadas y tiempo de trabajo.
  final int roundsDone;
  final int roundsPlanned;
  final int workSeconds;

  String get id => session.id;
  SessionKind get kind => session.kind;
  bool get isStrength => kind == SessionKind.strength;
  bool get incomplete => session.status == SessionStatus.incomplete;
  DateTime get day => sessionDay(session);
  DateTime get wallClock => sessionWallClock(session);
}

/// Totales de una semana: sesiones (sin descartadas ni borradas), minutos
/// activos y volumen.
class WeekStats {
  const WeekStats({required this.start, required this.entries});

  final DateTime start;

  /// Sesiones de la semana, de la más antigua a la más reciente.
  final List<HistoryEntry> entries;

  DateTime get end => start.add(const Duration(days: 7));
  int get sessions => entries.length;
  int get strength => entries.where((e) => e.isStrength).length;
  int get intervals => sessions - strength;
  int get activeSeconds => entries.fold(0, (t, e) => t + e.activeSeconds);

  /// Minutos activos: la suma de segundos redondeada al minuto.
  int get activeMinutes => (activeSeconds / 60).round();
  int get volumeGrams => entries.fold(0, (t, e) => t + e.volumeGrams);
}

/// Sesiones de la semana que empieza en [weekStart].
WeekStats statsForWeek(Iterable<HistoryEntry> entries, DateTime weekStart) {
  final end = weekStart.add(const Duration(days: 7));
  final list = [
    for (final e in entries)
      if (!e.day.isBefore(weekStart) && e.day.isBefore(end)) e,
  ]..sort((a, b) => a.session.startedAt.compareTo(b.session.startedAt));
  return WeekStats(start: weekStart, entries: list);
}

/// Las últimas [count] semanas hasta la actual (incluida), de la más
/// antigua a la más reciente.
List<WeekStats> lastWeeks(
  Iterable<HistoryEntry> entries, {
  required DateTime today,
  required WeekStart start,
  int count = 8,
}) {
  final current = weekStartOf(today, start);
  return [
    for (var i = count - 1; i >= 0; i--)
      statsForWeek(entries, current.subtract(Duration(days: 7 * i))),
  ];
}

/// Racha semanal: semanas seguidas que cumplen el objetivo [goal]. La
/// semana en curso suma si ya lo cumple y no la rompe mientras no termina.
int weeklyStreak(
  Iterable<HistoryEntry> entries, {
  required DateTime today,
  required WeekStart start,
  required int goal,
}) {
  final list = entries.toList();
  var week = weekStartOf(today, start);
  var streak = statsForWeek(list, week).sessions >= goal ? 1 : 0;
  final first = list.isEmpty
      ? week
      : list.map((e) => e.day).reduce((a, b) => a.isBefore(b) ? a : b);
  while (true) {
    week = week.subtract(const Duration(days: 7));
    // Semana que termina antes de la primera sesión: no hay más historial.
    if (!week.add(const Duration(days: 7)).isAfter(first)) break;
    if (statsForWeek(list, week).sessions < goal) break;
    streak++;
  }
  return streak;
}

/// Entrenamiento planificado para un día de la semana (plan_day), con su
/// nombre ya resuelto (`null` en las plantillas incluidas: lo da l10n).
class PlannedWorkout {
  const PlannedWorkout({
    required this.weekday,
    required this.kind,
    required this.templateId,
    required this.name,
  });

  /// ISO: 1 = lunes … 7 = domingo.
  final int weekday;
  final SessionKind kind;
  final String templateId;
  final String? name;
}

/// Qué muestra un día en la vista semanal (F-11).
enum DayState {
  /// Hay al menos una sesión.
  done,

  /// Sin sesión, con plan y aún no pasa.
  planned,

  /// Ya pasó sin sesiones: descanso.
  rest,

  /// Hoy o después, sin plan ni sesión.
  free,
}

/// Un día de la semana con sus sesiones y su plan.
class WeekDayPlan {
  const WeekDayPlan({
    required this.day,
    required this.entries,
    required this.planned,
    required this.today,
  });

  final DateTime day;
  final List<HistoryEntry> entries;
  final List<PlannedWorkout> planned;
  final DateTime today;

  bool get isToday => day == today;
  bool get isPast => day.isBefore(today);

  DayState get state {
    if (entries.isNotEmpty) return DayState.done;
    if (isPast) return DayState.rest;
    return planned.isEmpty ? DayState.free : DayState.planned;
  }

  /// Planificados que siguen pendientes: de hoy en adelante y sin una
  /// sesión del mismo tipo ese día.
  List<PlannedWorkout> get pending => [
    if (!isPast)
      for (final p in planned)
        if (!entries.any((e) => e.kind == p.kind)) p,
  ];
}

/// La semana día por día (vista unificada y separada).
List<WeekDayPlan> weekPlan({
  required WeekStats week,
  required List<PlannedWorkout> plan,
  required DateTime today,
}) => [
  for (final day in weekDays(week.start))
    WeekDayPlan(
      day: day,
      entries: [
        for (final e in week.entries)
          if (e.day == day) e,
      ],
      planned: [
        for (final p in plan)
          if (p.weekday == day.weekday) p,
      ],
      today: today,
    ),
];

/// Vista separada (H5): hechas y pendientes de un tipo en la semana.
class KindWeek {
  const KindWeek({required this.done, required this.pending});

  final List<HistoryEntry> done;
  final List<(DateTime, PlannedWorkout)> pending;

  int get total => done.length + pending.length;
}

KindWeek kindWeek(List<WeekDayPlan> days, SessionKind kind) => KindWeek(
  done: [
    for (final d in days)
      for (final e in d.entries)
        if (e.kind == kind) e,
  ],
  pending: [
    for (final d in days)
      for (final p in d.pending)
        if (p.kind == kind) (d.day, p),
  ],
);
