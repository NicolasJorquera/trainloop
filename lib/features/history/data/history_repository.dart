import 'package:drift/drift.dart';

import '../../../data/db/app_database.dart';
import '../../../data/db/daos/routines_dao.dart';
import '../../../data/db/daos/sessions_dao.dart';
import '../../../data/db/enums.dart';
import '../../intervals/data/interval_session_repository.dart';
import '../../intervals/domain/interval_templates.dart';
import '../../intervals/domain/workout_snapshot.dart';
import '../../strength/data/strength_session_repository.dart';
import '../../strength/domain/strength_rules.dart';
import '../domain/week.dart';
import 'records_repository.dart';

/// Historial unificado (F-10) y plan semanal (F-11): lectura de las
/// sesiones con sus totales, edición de sesiones pasadas (R-G14), borrado
/// con deshacer y plan por día. Toda edición recalcula los récords de los
/// ejercicios afectados (R-P3).
class HistoryRepository {
  HistoryRepository(this._db)
    : _strength = StrengthSessionRepository(_db),
      _records = RecordsRepository(_db);

  final AppDatabase _db;
  final StrengthSessionRepository _strength;
  final RecordsRepository _records;

  SessionsDao get _dao => _db.sessionsDao;

  // ------------------------------------------------------------- lectura

  /// Sesiones del historial con sus totales, la más reciente primero; se
  /// actualiza con cada cambio de sesiones, series o fases.
  Stream<List<HistoryEntry>> watchEntries() => _db
      .customSelect(
        'SELECT 1',
        readsFrom: {_db.sessions, _db.setLogs, _db.intervalPhaseLogs},
      )
      .watch()
      .asyncMap((_) => loadEntries());

  Future<List<HistoryEntry>> loadEntries() async {
    final sessions = await _dao.watchHistory().first;
    if (sessions.isEmpty) return const [];
    final strength = await _strengthTotals();
    final intervalIds = [
      for (final s in sessions)
        if (s.kind == SessionKind.intervals) s.id,
    ];
    final phases = <String, List<IntervalPhaseLog>>{};
    if (intervalIds.isNotEmpty) {
      final rows =
          await (_db.select(_db.intervalPhaseLogs)
                ..where((t) => t.sessionId.isIn(intervalIds))
                ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
              .get();
      for (final p in rows) {
        (phases[p.sessionId] ??= []).add(p);
      }
    }
    return [
      for (final s in sessions)
        s.kind == SessionKind.strength
            ? _strengthEntry(s, strength[s.id])
            : _intervalEntry(s, phases[s.id] ?? const []),
    ];
  }

  Future<HistoryEntry?> loadEntry(String sessionId) async {
    final all = await loadEntries();
    for (final e in all) {
      if (e.id == sessionId) return e;
    }
    return null;
  }

  /// Volumen sin calentamiento y series hechas por sesión, en la base.
  Future<Map<String, ({int volume, int sets})>> _strengthTotals() async {
    final rows = await _db
        .customSelect(
          'SELECT session_id, '
          "SUM(CASE WHEN set_type <> 'warmup' "
          'THEN COALESCE(weight_grams, 0) * COALESCE(reps, 0) ELSE 0 END) '
          'AS volume, COUNT(*) AS sets '
          'FROM set_log WHERE completed = 1 GROUP BY session_id',
          readsFrom: {_db.setLogs},
        )
        .get();
    return {
      for (final r in rows)
        r.read<String>('session_id'): (
          volume: r.read<int>('volume'),
          sets: r.read<int>('sets'),
        ),
    };
  }

  static HistoryEntry _strengthEntry(
    Session s,
    ({int volume, int sets})? totals,
  ) {
    final end = s.endedAt;
    final active = end == null
        ? 0
        : end.difference(s.startedAt).inSeconds - s.pausedSeconds;
    return HistoryEntry(
      session: s,
      title: StrengthSessionRepository.titleOf(s),
      activeSeconds: active < 0 ? 0 : active,
      volumeGrams: totals?.volume ?? 0,
      completedSets: totals?.sets ?? 0,
    );
  }

  static HistoryEntry _intervalEntry(Session s, List<IntervalPhaseLog> phases) {
    final json = s.templateSnapshot;
    if (json == null) {
      return HistoryEntry(
        session: s,
        title: null,
        activeSeconds: phases.fold(0, (t, p) => t + p.actualSeconds),
      );
    }
    final r = IntervalSessionRecord(s, WorkoutSnapshot.fromJson(json), phases);
    return HistoryEntry(
      session: s,
      title: r.snapshot.workout.name,
      activeSeconds: r.activeSeconds,
      roundsDone: r.roundsDone,
      roundsPlanned: r.roundsPlanned,
      workSeconds: r.workSeconds,
    );
  }

  // ------------------------------------------------------------ edición

  /// Cambia los valores de una serie de una sesión pasada.
  Future<void> updateSet(String setId, SetValues values) async {
    final row = await _dao.findSet(setId);
    if (row == null) return;
    await _strength.updateSet(setId, values);
    await _records.recomputeExercise(row.exerciseId);
  }

  /// Quita una serie de una sesión pasada.
  Future<void> deleteSet(String setId) async {
    final row = await _dao.findSet(setId);
    if (row == null) return;
    await _dao.deleteSet(setId);
    await _records.recomputeExercise(row.exerciseId);
  }

  /// Nombre de la sesión: se cambia en su copia de la plantilla (la rutina
  /// o el entrenamiento de origen no cambian).
  Future<void> rename(String sessionId, String name) async {
    final clean = name.trim();
    final s = await _dao.findById(sessionId);
    if (s == null || clean.isEmpty) return;
    final snap = {...?s.templateSnapshot};
    if (s.kind == SessionKind.intervals) {
      if (snap.isEmpty) return;
      snap['name'] = clean;
    } else {
      final routine = snap['routine'];
      snap['routine'] = {
        if (routine is Map) ...routine.cast<String, Object?>(),
        'name': clean,
      };
    }
    await (_db.update(
      _db.sessions,
    )..where((t) => t.id.equals(sessionId))).write(
      SessionsCompanion(
        templateSnapshot: Value(snap),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  /// Esfuerzo percibido (1–10) y nota.
  Future<void> rate(String sessionId, {int? perceivedEffort, String? note}) =>
      _dao.rate(
        sessionId,
        perceivedEffort: perceivedEffort,
        note: note == null || note.trim().isEmpty ? null : note.trim(),
      );

  /// Borra la sesión (borrado lógico) y recalcula los récords. Se puede
  /// deshacer con [restore].
  Future<void> delete(String sessionId) async {
    await _dao.archive(sessionId);
    await _records.recomputeSession(sessionId);
  }

  /// Deshace [delete].
  Future<void> restore(String sessionId) async {
    await _dao.unarchive(sessionId);
    await _records.recomputeSession(sessionId);
  }

  /// "Guardar como rutina" (S13): una rutina nueva con los ejercicios y las
  /// series hechas de la sesión como objetivo. Devuelve su id.
  Future<String?> saveAsRoutine(String sessionId, String name) =>
      _db.transaction(() async {
        final data = await _strength.load(sessionId);
        if (data == null) return null;
        final entries = [
          for (final e in data.exercises)
            if (e.sets.any((s) => s.completed))
              RoutineExerciseDraft(
                exerciseId: e.exercise.id,
                restSeconds: e.entry.restSeconds,
                targets: [
                  for (final s in e.sets.where((s) => s.completed))
                    RoutineSetTargetsCompanion(
                      setType: Value(s.type),
                      reps: Value(s.log.reps),
                      weightValue: Value(s.log.weightValue),
                      weightUnit: Value(s.log.weightUnit),
                      durationSeconds: Value(s.log.durationSeconds),
                      distanceMeters: Value(s.log.distanceMeters),
                    ),
                ],
              ),
        ];
        if (entries.isEmpty) return null;
        final id = await _db.routinesDao.create(
          StrengthRoutinesCompanion.insert(
            name: name.trim(),
            sortOrder: Value(await _db.routinesDao.nextSortOrder()),
          ),
        );
        await _db.routinesDao.replaceExercises(id, entries);
        return id;
      });

  // ---------------------------------------------------------------- plan

  /// Plan por día con los nombres resueltos. Las plantillas incluidas
  /// llevan `name == null` (su nombre sale de l10n).
  Stream<List<PlannedWorkout>> watchPlan() => _db
      .customSelect(
        'SELECT 1',
        readsFrom: {_db.planDays, _db.strengthRoutines, _db.intervalWorkouts},
      )
      .watch()
      .asyncMap((_) => loadPlan());

  Future<List<PlannedWorkout>> loadPlan() async {
    final rows = await _db.planDao.watchPlan().first;
    final out = <PlannedWorkout>[];
    for (final p in rows) {
      final name = await _planName(p);
      if (name == null && IntervalTemplate.bySourceId(p.templateId) == null) {
        continue;
      }
      out.add(
        PlannedWorkout(
          weekday: p.weekday,
          kind: p.kind,
          templateId: p.templateId,
          name: name,
        ),
      );
    }
    return out;
  }

  Future<String?> _planName(PlanDay p) async {
    if (p.kind == SessionKind.strength) {
      final r = await (_db.select(
        _db.strengthRoutines,
      )..where((t) => t.id.equals(p.templateId))).getSingleOrNull();
      return r?.name;
    }
    if (IntervalTemplate.bySourceId(p.templateId) != null) return null;
    final w = await (_db.select(
      _db.intervalWorkouts,
    )..where((t) => t.id.equals(p.templateId))).getSingleOrNull();
    return w?.name;
  }

  /// Fija (o quita, con `null`) el plan de un día ISO 1–7. El plan nunca
  /// abre una rutina sola (E12): solo se muestra en la semana.
  Future<void> setPlan(
    int weekday, {
    required SessionKind? kind,
    String? templateId,
  }) => _db.planDao.setDay(weekday, [
    if (kind != null && templateId != null)
      PlanDaysCompanion.insert(
        weekday: weekday,
        kind: kind,
        templateId: templateId,
      ),
  ]);
}
