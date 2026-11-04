import 'package:drift/drift.dart';

import '../../../core/units/weight_unit.dart';
import '../../../data/db/app_database.dart';
import '../../../data/db/converters.dart';
import '../../../data/db/daos/routines_dao.dart';
import '../../../data/db/daos/sessions_dao.dart';
import '../../../data/db/enums.dart';
import '../../history/data/records_repository.dart';
import '../../routines/domain/routine_draft.dart';
import '../domain/strength_rules.dart';
import '../domain/strength_session.dart';

/// Qué hacer al terminar con las series sin marcar (R-G10).
enum PendingSets { discard, complete }

/// Resumen de una sesión de fuerza terminada (S06, variante fuerza).
class StrengthSummary {
  const StrengthSummary({
    required this.data,
    required this.records,
    required this.routineName,
    required this.routineChanged,
  });

  final StrengthSessionData data;

  /// Récords nuevos de la sesión por ejercicio, leídos de la caché que se
  /// recalcula al guardarla (R-P3). La primera marca no cuenta como récord.
  final List<ExerciseRecords> records;

  /// Rutina de origen si sigue activa, para ofrecer actualizarla (R-G12).
  final String? routineName;
  final bool routineChanged;

  Session get session => data.session;

  int get durationSeconds {
    final end = session.endedAt ?? DateTime.now().toUtc();
    return end.difference(session.startedAt).inSeconds.clamp(0, 1 << 31);
  }
}

/// Sesiones de fuerza en la base (F-08). La sesión copia la rutina al
/// empezar: ejercicios (`session_exercise`, con su descanso) y series sin
/// completar con el objetivo (`set_log`), además de la copia JSON en
/// `template_snapshot`. Cada serie marcada se guarda en su propia
/// transacción (NF-06): un cierre a la fuerza no pierde ninguna.
class StrengthSessionRepository {
  StrengthSessionRepository(this._db) : _records = RecordsRepository(_db);

  final AppDatabase _db;
  final RecordsRepository _records;

  SessionsDao get _dao => _db.sessionsDao;
  RoutinesDao get _routines => _db.routinesDao;

  // ------------------------------------------------------------- empezar

  /// Empieza desde una rutina (R-G1). La rutina no cambia: la sesión
  /// trabaja sobre su copia. Error si no existe o está vacía.
  Future<String> startFromRoutine(String routineId) =>
      _db.transaction(() async {
        final detail = await _routines.getDetail(routineId);
        if (detail == null || detail.exercises.isEmpty) {
          throw StateError('Rutina $routineId vacía o inexistente');
        }
        final id = await _dao.start(
          kind: SessionKind.strength,
          templateId: routineId,
          templateSnapshot: detail.toSnapshot(),
        );
        for (final (i, e) in detail.exercises.indexed) {
          final entryId = await _dao.addExercise(
            sessionId: id,
            exerciseId: e.exercise.id,
            sortOrder: i,
            restSeconds: restSecondsFor(
              routineRest: e.entry.restSeconds,
              libraryRest: e.exercise.defaultRestSeconds,
            ),
          );
          for (final (j, t) in e.targets.indexed) {
            await _dao.addPlannedSet(
              SetLogsCompanion.insert(
                sessionExerciseId: entryId,
                sessionId: id,
                exerciseId: e.exercise.id,
                sortOrder: j,
                setType: Value(t.setType),
                weightValue: Value(t.weightValue),
                weightUnit: Value(t.weightUnit),
                reps: Value(t.reps),
                rpe: const Value(null),
                durationSeconds: Value(t.durationSeconds),
                distanceMeters: Value(t.distanceMeters),
              ),
            );
          }
        }
        return id;
      });

  /// Entrenamiento libre: sesión vacía a la que se agregan ejercicios.
  Future<String> startFree() => _dao.start(
    kind: SessionKind.strength,
    templateSnapshot: const {'routine': null, 'exercises': []},
  );

  /// "Repetir la última" (R-G1): copia los ejercicios y las series
  /// completadas de la última sesión de fuerza como series por hacer.
  /// `null` si no hay ninguna.
  Future<String?> repeatLast() => _db.transaction(() async {
    final last = await _dao.watchLastStrength().first;
    if (last == null) return null;
    final exercises = await _dao.exercisesOf(last.id);
    final sets = (await _dao.setsOf(last.id)).where((s) => s.completed);
    final previous = last.templateSnapshot?['routine'];
    final id = await _dao.start(
      kind: SessionKind.strength,
      templateId: last.templateId,
      templateSnapshot: {
        'routine': previous,
        'repeatOf': last.id,
        'exercises': [
          for (final (entry, exercise) in exercises)
            {
              'exerciseId': exercise.id,
              'sortOrder': entry.sortOrder,
              'restSeconds': entry.restSeconds,
              'exercise': exercise.toJson(),
              'targets': [
                for (final s in sets)
                  if (s.sessionExerciseId == entry.id) s.toJson(),
              ],
            },
        ],
      },
    );
    var order = 0;
    for (final (entry, exercise) in exercises) {
      final done = [
        for (final s in sets)
          if (s.sessionExerciseId == entry.id) s,
      ]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      if (done.isEmpty) continue;
      final entryId = await _dao.addExercise(
        sessionId: id,
        exerciseId: exercise.id,
        sortOrder: order++,
        restSeconds: entry.restSeconds,
      );
      for (final (j, s) in done.indexed) {
        await _dao.addPlannedSet(
          SetLogsCompanion.insert(
            sessionExerciseId: entryId,
            sessionId: id,
            exerciseId: exercise.id,
            sortOrder: j,
            setType: Value(s.setType),
            weightValue: Value(s.weightValue),
            weightUnit: Value(s.weightUnit),
            reps: Value(s.reps),
            durationSeconds: Value(s.durationSeconds),
            distanceMeters: Value(s.distanceMeters),
          ),
        );
      }
    }
    return id;
  });

  // ------------------------------------------------------------- lectura

  Future<StrengthSessionData?> load(String sessionId) async {
    final session = await _dao.findById(sessionId);
    if (session == null || session.kind != SessionKind.strength) return null;
    final exercises = await _dao.exercisesOf(sessionId);
    final sets = await _dao.setsOf(sessionId);
    final previous = <String, List<SetLog>>{};
    for (final (_, e) in exercises) {
      previous[e.id] ??= await _dao.lastSetsForExercise(
        e.id,
        excludeSessionId: sessionId,
      );
    }
    return StrengthSessionData.build(
      session: session,
      title: titleOf(session),
      exercises: exercises,
      sets: sets,
      previousByExercise: previous,
    );
  }

  /// La sesión con cada cambio de sus ejercicios o series.
  Stream<StrengthSessionData?> watch(String sessionId) => _db
      .customSelect(
        'SELECT 1',
        readsFrom: {_db.sessions, _db.sessionExercises, _db.setLogs},
      )
      .watch()
      .asyncMap((_) => load(sessionId));

  /// Nombre de la rutina copiada; `null` en un entrenamiento libre.
  static String? titleOf(Session session) {
    final routine = session.templateSnapshot?['routine'];
    return routine is Map ? routine['name'] as String? : null;
  }

  /// Sesiones de fuerza sin terminar (recuperación al abrir).
  Future<List<Session>> findActive() => _dao.findActiveStrength();

  /// Última sesión de fuerza del historial ("repetir la última").
  Stream<Session?> watchLast() => _dao.watchLastStrength();

  // ------------------------------------------------------------- series

  /// Marca la serie como hecha con [values], en su propia transacción.
  Future<void> completeSet(String setId, SetValues values) =>
      _write(setId, values, completed: true);

  /// Cambia los valores de una serie sin cambiar si está hecha.
  Future<void> updateSet(String setId, SetValues values) async {
    final row = await _dao.findSet(setId);
    if (row == null) return;
    await _write(setId, values, completed: row.completed);
  }

  /// Desmarca una serie: vuelve a ser una serie por hacer con sus valores.
  Future<void> uncompleteSet(String setId) async {
    final row = await _dao.findSet(setId);
    if (row == null) return;
    await _write(setId, SetValues.ofLog(row), completed: false);
  }

  Future<void> _write(
    String setId,
    SetValues v, {
    required bool completed,
  }) async {
    final row = await _dao.findSet(setId);
    if (row == null) return;
    await _dao.logSet(
      SetLogsCompanion(
        id: Value(setId),
        sessionExerciseId: Value(row.sessionExerciseId),
        sessionId: Value(row.sessionId),
        exerciseId: Value(row.exerciseId),
        sortOrder: Value(row.sortOrder),
        setType: Value(v.type),
        weightValue: Value(v.weight),
        weightUnit: Value(v.weight == null ? null : v.unit ?? WeightUnit.kg),
        reps: Value(v.reps),
        rpe: Value(v.rpe),
        durationSeconds: Value(v.durationSeconds),
        completed: Value(completed),
        loggedAt: Value(completed ? nowUtc() : null),
      ),
    );
  }

  /// Agrega una serie por hacer al final del ejercicio, con los valores de
  /// la última (sin RPE). Devuelve su id.
  Future<String> addSet(String sessionExerciseId) => _db.transaction(() async {
    final entry = await (_db.select(
      _db.sessionExercises,
    )..where((t) => t.id.equals(sessionExerciseId))).getSingle();
    final sets =
        await (_db.select(_db.setLogs)
              ..where((t) => t.sessionExerciseId.equals(sessionExerciseId))
              ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
            .get();
    final last = sets.lastOrNull;
    return _dao.addPlannedSet(
      SetLogsCompanion.insert(
        sessionExerciseId: sessionExerciseId,
        sessionId: entry.sessionId,
        exerciseId: entry.exerciseId,
        sortOrder: (last?.sortOrder ?? -1) + 1,
        setType: Value(
          last == null || last.setType == SetType.warmup
              ? SetType.normal
              : last.setType,
        ),
        weightValue: Value(last?.weightValue),
        weightUnit: Value(last?.weightUnit),
        reps: Value(last?.reps),
        durationSeconds: Value(last?.durationSeconds),
      ),
    );
  });

  Future<void> removeSet(String setId) => _dao.deleteSet(setId);

  // ---------------------------------------------------------- ejercicios

  /// Agrega ejercicios al final: tantas series como la última vez (o 3), sin
  /// valores (se proponen los de la vez anterior al mostrarlas).
  Future<void> addExercises(String sessionId, List<Exercise> exercises) =>
      _db.transaction(() async {
        var order = (await _dao.exercisesOf(sessionId)).length;
        for (final e in exercises) {
          final previous = await _dao.lastSetsForExercise(
            e.id,
            excludeSessionId: sessionId,
          );
          final entryId = await _dao.addExercise(
            sessionId: sessionId,
            exerciseId: e.id,
            sortOrder: order++,
            restSeconds: restSecondsFor(libraryRest: e.defaultRestSeconds),
          );
          final count = previous.isEmpty
              ? RoutineEntryDraft.defaultSets
              : previous.length;
          for (var j = 0; j < count; j++) {
            await _dao.addPlannedSet(
              SetLogsCompanion.insert(
                sessionExerciseId: entryId,
                sessionId: sessionId,
                exerciseId: e.id,
                sortOrder: j,
                setType: Value(
                  j < previous.length ? previous[j].setType : SetType.normal,
                ),
              ),
            );
          }
        }
      });

  Future<void> removeExercise(String sessionExerciseId) =>
      _dao.deleteExercise(sessionExerciseId);

  /// Mueve el ejercicio [from] a la posición [to] (índices de la lista).
  Future<void> moveExercise(String sessionId, int from, int to) async {
    final ids = [for (final (e, _) in await _dao.exercisesOf(sessionId)) e.id];
    if (from < 0 || from >= ids.length || to < 0 || to >= ids.length) return;
    final id = ids.removeAt(from);
    ids.insert(to, id);
    await _dao.reorderExercises(sessionId, ids);
  }

  Future<void> setNotes(String sessionExerciseId, String? notes) =>
      _dao.setExerciseNotes(
        sessionExerciseId,
        notes == null || notes.trim().isEmpty ? null : notes.trim(),
      );

  // ------------------------------------------------------------- cierre

  /// Termina la sesión (R-G10): las series sin marcar se descartan o se
  /// dan por hechas con sus valores propuestos (las que no tienen valores
  /// se quitan). Los ejercicios sin series se quitan. Si no queda ninguna
  /// serie hecha, la sesión se descarta (R-G11). Devuelve el estado final.
  Future<SessionStatus> finish(
    String sessionId, {
    PendingSets pending = PendingSets.discard,
    SessionStatus status = SessionStatus.completed,
    DateTime? endedAt,
  }) async {
    final data = await load(sessionId);
    if (data == null) return SessionStatus.discarded;
    final saved = await _db.transaction(() async {
      for (final e in data.exercises) {
        for (final s in e.sets.where((s) => !s.completed)) {
          final v = s.proposed;
          if (pending == PendingSets.complete &&
              canLogDirectly(e.exercise.logType, v)) {
            await completeSet(s.id, v);
          } else {
            await _dao.deleteSet(s.id);
          }
        }
      }
      final left = await _dao.setsOf(sessionId);
      for (final (entry, _) in await _dao.exercisesOf(sessionId)) {
        if (!left.any((s) => s.sessionExerciseId == entry.id)) {
          await _dao.deleteExercise(entry.id);
        }
      }
      final result = left.any((s) => s.completed)
          ? status
          : SessionStatus.discarded;
      await _dao.finish(sessionId, status: result, endedAt: endedAt);
      return result;
    });
    // Récords al guardar la sesión (R-P3), en la caché.
    await _records.recomputeExercises({
      for (final e in data.exercises) e.exercise.id,
    });
    return saved;
  }

  /// Android cerró la app con la sesión abierta: queda para recuperar.
  Future<void> markRecoveryPending(String sessionId) =>
      _dao.setStatus(sessionId, SessionStatus.recoveryPending);

  Future<void> markResumed(String sessionId) =>
      _dao.setStatus(sessionId, SessionStatus.inProgress);

  /// "Guardar como incompleta" al recuperar: sus series hechas quedan en el
  /// historial y las demás se quitan. La hora de fin es la última serie.
  Future<SessionStatus> saveIncomplete(String sessionId) async {
    final sets = await _dao.setsOf(sessionId);
    final last = sets
        .map((s) => s.loggedAt)
        .whereType<DateTime>()
        .fold<DateTime?>(null, (a, b) => a == null || b.isAfter(a) ? b : a);
    return finish(sessionId, status: SessionStatus.incomplete, endedAt: last);
  }

  /// Descarta la sesión; si ya estaba guardada (el resumen ofrece
  /// descartarla), sus récords se recalculan sin ella.
  Future<void> discard(String sessionId) async {
    final saved = await _dao.findById(sessionId);
    await _dao.setStatus(sessionId, SessionStatus.discarded);
    if (saved != null && SessionsDao.historyStatuses.contains(saved.status)) {
      await _records.recomputeSession(sessionId);
    }
  }

  /// Esfuerzo percibido (1–10) y nota del resumen.
  Future<void> rate(String sessionId, {int? perceivedEffort, String? note}) =>
      _dao.rate(sessionId, perceivedEffort: perceivedEffort, note: note);

  // ------------------------------------------------------------ resumen

  Future<StrengthSummary?> summary(String sessionId) async {
    final data = await load(sessionId);
    if (data == null) return null;
    final records = await _records.newRecordsOf(sessionId);
    final routine = await _activeRoutine(data.session);
    return StrengthSummary(
      data: data,
      records: records,
      routineName: routine?.routine.name,
      routineChanged:
          routine != null &&
          structureChanged(_structureOf(routine), data.structure),
    );
  }

  /// "¿Actualizar la rutina?" (R-G12): copia a la rutina los ejercicios y el
  /// número de series de la sesión. Los pesos y reps objetivo de los
  /// ejercicios que ya estaban no cambian; los nuevos toman los valores por
  /// defecto, sin peso.
  Future<void> updateRoutineFromSession(String sessionId) =>
      _db.transaction(() async {
        final data = await load(sessionId);
        if (data == null) return;
        final routine = await _activeRoutine(data.session);
        if (routine == null) return;
        final pool = [...routine.exercises];
        await _routines.replaceExercises(routine.routine.id, [
          for (final e in data.exercises) _routineEntryFor(e, pool),
        ]);
      });

  RoutineExerciseDraft _routineEntryFor(
    SessionExerciseItem e,
    List<RoutineExerciseDetail> pool,
  ) {
    final i = pool.indexWhere((p) => p.exercise.id == e.exercise.id);
    final count = e.sets.length;
    if (i >= 0) {
      final old = pool.removeAt(i);
      final targets = old.targets;
      return RoutineExerciseDraft(
        exerciseId: e.exercise.id,
        restSeconds: old.entry.restSeconds,
        targets: [
          for (var j = 0; j < count; j++)
            _copyTarget(
              targets.isEmpty ? null : targets[j.clamp(0, targets.length - 1)],
            ),
        ],
      );
    }
    final base = RoutineEntryDraft.defaultsFor(e.exercise);
    return RoutineExerciseDraft(
      exerciseId: e.exercise.id,
      restSeconds: e.entry.restSeconds ?? base.restSeconds,
      targets: [
        for (var j = 0; j < count; j++)
          RoutineSetTargetsCompanion(
            reps: Value(base.reps),
            durationSeconds: Value(base.durationSeconds),
          ),
      ],
    );
  }

  static RoutineSetTargetsCompanion _copyTarget(RoutineSetTarget? t) =>
      RoutineSetTargetsCompanion(
        setType: Value(t?.setType ?? SetType.normal),
        reps: Value(t?.reps),
        weightValue: Value(t?.weightValue),
        weightUnit: Value(t?.weightUnit),
        rpe: Value(t?.rpe),
        durationSeconds: Value(t?.durationSeconds),
        distanceMeters: Value(t?.distanceMeters),
      );

  Future<RoutineDetail?> _activeRoutine(Session session) async {
    final id = session.templateId;
    if (id == null) return null;
    final detail = await _routines.getDetail(id);
    if (detail == null || detail.routine.archivedAt != null) return null;
    return detail;
  }

  static List<StructureEntry> _structureOf(RoutineDetail d) => [
    for (final e in d.exercises)
      (exerciseId: e.exercise.id, sets: e.targets.length),
  ];
}
