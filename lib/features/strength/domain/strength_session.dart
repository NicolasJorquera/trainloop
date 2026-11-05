import '../../../data/db/app_database.dart';
import '../../../data/db/enums.dart';
import 'strength_rules.dart';

/// Serie de la sesión tal como la muestra S10: la fila guardada, la serie
/// con el mismo número la vez anterior (la "última marca") y los valores
/// propuestos (R-G2).
class SessionSet {
  const SessionSet({
    required this.log,
    required this.index,
    required this.number,
    this.previous,
  });

  final SetLog log;

  /// Posición entre las series del ejercicio (0, 1, 2…).
  final int index;

  /// Número visible: cuenta solo las que no son de calentamiento (1, 2…);
  /// `null` en el calentamiento (se marca con una letra).
  final int? number;

  /// La misma serie en la última sesión con este ejercicio.
  final SetLog? previous;

  String get id => log.id;
  bool get completed => log.completed;
  SetType get type => log.setType;

  /// Lo guardado: lo registrado si está completa, el objetivo si no.
  SetValues get stored => SetValues.ofLog(log);

  /// Lo que se guarda con 1 toque (R-G3): lo registrado o lo propuesto.
  SetValues get proposed => completed
      ? stored
      : proposeSet(index: 0, previous: [?previous], target: stored);
}

/// Ejercicio de la sesión con sus series.
class SessionExerciseItem {
  const SessionExerciseItem({
    required this.entry,
    required this.exercise,
    required this.sets,
  });

  final SessionExercise entry;
  final Exercise exercise;
  final List<SessionSet> sets;

  String get id => entry.id;

  int get restSeconds => restSecondsFor(
    routineRest: entry.restSeconds,
    libraryRest: exercise.defaultRestSeconds,
  );

  int get completedCount => sets.where((s) => s.completed).length;

  /// Fuente de «Igual que antes»: la última serie efectiva hecha; el
  /// calentamiento solo si todavía no hay ninguna efectiva.
  SessionSet? get repeatSource {
    final done = sets.where((s) => s.completed);
    return done.where((s) => s.type != SetType.warmup).lastOrNull ??
        done.lastOrNull;
  }

  /// Serie que llena «Igual que antes»: la primera efectiva sin hacer
  /// (`null` si hay que agregar una).
  SessionSet? get repeatTarget =>
      sets.where((s) => !s.completed && s.type != SetType.warmup).firstOrNull;
}

/// Sesión de fuerza completa para S10 y el resumen.
class StrengthSessionData {
  const StrengthSessionData({
    required this.session,
    required this.title,
    required this.exercises,
  });

  final Session session;

  /// Nombre de la rutina copiada; `null` en un entrenamiento libre.
  final String? title;
  final List<SessionExerciseItem> exercises;

  String get id => session.id;

  Iterable<SessionSet> get allSets => exercises.expand((e) => e.sets);

  int get totalSets => allSets.length;

  int get completedSets => allSets.where((s) => s.completed).length;

  int get pendingSets => totalSets - completedSets;

  int get volumeGrams => _volume();

  int _volume() => exercises.fold(
    0,
    (t, e) =>
        t +
        e.sets
            .where((s) => s.completed && s.type != SetType.warmup)
            .fold(
              0,
              (u, s) => u + (s.log.weightGrams ?? 0) * (s.log.reps ?? 0),
            ),
  );

  /// Primera serie sin completar a partir de la serie [afterSetId] (o desde
  /// el principio): la "siguiente serie" del descanso y la notificación.
  ({SessionExerciseItem exercise, SessionSet set})? nextPending({
    String? afterSetId,
  }) {
    final flat = [
      for (final e in exercises)
        for (final s in e.sets) (exercise: e, set: s),
    ];
    var start = 0;
    if (afterSetId != null) {
      final i = flat.indexWhere((x) => x.set.id == afterSetId);
      if (i >= 0) start = i + 1;
    }
    for (var i = 0; i < flat.length; i++) {
      final x = flat[(start + i) % flat.length];
      if (!x.set.completed) return x;
    }
    return null;
  }

  /// Estructura actual (ejercicios y número de series) para R-G12.
  List<StructureEntry> get structure => [
    for (final e in exercises) (exerciseId: e.exercise.id, sets: e.sets.length),
  ];

  /// Arma la vista desde las filas de la base y la última marca de cada
  /// ejercicio ([previousByExercise], por id de ejercicio).
  static StrengthSessionData build({
    required Session session,
    required String? title,
    required List<(SessionExercise, Exercise)> exercises,
    required List<SetLog> sets,
    required Map<String, List<SetLog>> previousByExercise,
  }) {
    final byEntry = <String, List<SetLog>>{};
    for (final s in sets) {
      (byEntry[s.sessionExerciseId] ??= []).add(s);
    }
    // Si el mismo ejercicio aparece dos veces, la segunda continúa la
    // numeración de la vez anterior.
    final usedPrevious = <String, int>{};
    return StrengthSessionData(
      session: session,
      title: title,
      exercises: [
        for (final (entry, exercise) in exercises)
          SessionExerciseItem(
            entry: entry,
            exercise: exercise,
            sets: _sets(
              byEntry[entry.id] ?? const [],
              previousByExercise[exercise.id] ?? const [],
              usedPrevious,
              exercise.id,
            ),
          ),
      ],
    );
  }

  static List<SessionSet> _sets(
    List<SetLog> logs,
    List<SetLog> previous,
    Map<String, int> used,
    String exerciseId,
  ) {
    final sorted = [...logs]
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    final offset = used[exerciseId] ?? 0;
    used[exerciseId] = offset + sorted.length;
    var number = 0;
    return [
      for (final (i, log) in sorted.indexed)
        SessionSet(
          log: log,
          index: i,
          number: log.setType == SetType.warmup ? null : ++number,
          previous: offset + i < previous.length ? previous[offset + i] : null,
        ),
    ];
  }
}
