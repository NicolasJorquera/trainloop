import 'package:drift/drift.dart';

import '../../../data/db/app_database.dart';
import '../../../data/db/daos/sessions_dao.dart';
import '../../../data/db/enums.dart';
import '../../../platform/timer_engine_client.dart';
import '../domain/interval_workout_draft.dart';
import '../domain/workout_snapshot.dart';

/// Sesión de intervalos guardada, para el resumen (S06) y la recuperación.
class IntervalSessionRecord {
  const IntervalSessionRecord(this.session, this.snapshot, this.phases);

  final Session session;
  final WorkoutSnapshot snapshot;
  final List<IntervalPhaseLog> phases;

  int get activeSeconds => phases.fold(0, (t, p) => t + p.actualSeconds);

  int get workSeconds => phases
      .where((p) => p.phaseType == PhaseType.work)
      .fold(0, (t, p) => t + p.actualSeconds);

  /// Rondas hechas: intervalos de trabajo terminados sin saltar.
  int get roundsDone => phases
      .where(
        (p) =>
            p.phaseType == PhaseType.work &&
            !p.skipped &&
            p.actualSeconds >= p.plannedSeconds,
      )
      .length;

  int get roundsPlanned =>
      snapshot.phases.where((p) => p.type == PhaseType.work).length;

  int get skippedCount => phases.where((p) => p.skipped).length;
}

/// Sesiones de intervalos en la base: inicio con copia de la estructura,
/// una fase por transacción (NF-06), cierre, recuperación y resumen.
class IntervalSessionRepository {
  IntervalSessionRepository(this._db);

  final AppDatabase _db;

  SessionsDao get _dao => _db.sessionsDao;

  /// Crea la sesión en curso con su copia (R-I13). [sourceId] es el id del
  /// entrenamiento o `template:<clave>`.
  Future<String> start(IntervalWorkoutDraft workout, {String? sourceId}) =>
      _dao.start(
        kind: SessionKind.intervals,
        templateId: sourceId ?? workout.id,
        templateSnapshot: WorkoutSnapshot.of(workout).toJson(),
      );

  Future<IntervalSessionRecord?> load(String sessionId) async {
    final session = await _dao.findById(sessionId);
    final json = session?.templateSnapshot;
    if (session == null || json == null) return null;
    return IntervalSessionRecord(
      session,
      WorkoutSnapshot.fromJson(json),
      await _dao.phasesOf(sessionId),
    );
  }

  /// Guarda los resultados de fase que publica el motor. Cada uno en su
  /// propia transacción; reenviar uno igual no duplica nada.
  Future<void> savePhases(
    String sessionId,
    WorkoutSnapshot snapshot,
    Iterable<EnginePhaseResult> results,
  ) async {
    for (final r in results) {
      if (r.index >= snapshot.phases.length) continue;
      final planned = snapshot.phases[r.index];
      await _dao.replacePhase(
        IntervalPhaseLogsCompanion.insert(
          sessionId: sessionId,
          sortOrder: r.index,
          phaseType: planned.type,
          label: Value(planned.label),
          round: Value(planned.round == 0 ? 1 : planned.round),
          plannedSeconds: planned.seconds,
          actualSeconds: (r.actualMs / 1000).round(),
          skipped: Value(r.skipped),
        ),
      );
    }
  }

  /// Punto de recuperación también en la base (fase, posición y pausas).
  Future<void> checkpoint(String sessionId, EngineState s) =>
      _dao.saveCheckpoint(
        sessionId,
        phaseIndex: s.index,
        elapsedMs: s.positionMs,
        pausedSeconds: s.pausedMs ~/ 1000,
      );

  /// Cierra la sesión (R-I12): completada si recorrió todas las fases (las
  /// saltadas cuentan como omitidas), incompleta si se detuvo antes.
  Future<void> finish(
    String sessionId,
    WorkoutSnapshot snapshot,
    EngineState s, {
    SessionStatus? status,
  }) async {
    await savePhases(sessionId, snapshot, s.results);
    await _dao.deletePhasesExcept(sessionId, {
      for (final r in s.results) r.index,
    });
    await _dao.finish(
      sessionId,
      status:
          status ??
          (s.state == EngineRunState.finished
              ? SessionStatus.completed
              : SessionStatus.incomplete),
      pausedSeconds: s.pausedMs ~/ 1000,
    );
  }

  /// Android cerró la app con la sesión en curso: queda pendiente de
  /// recuperación con el último punto guardado por el motor.
  Future<void> markRecoveryPending(
    String sessionId,
    WorkoutSnapshot snapshot,
    EngineState s,
  ) async {
    await savePhases(sessionId, snapshot, s.results);
    await _dao.markRecoveryPending(
      sessionId,
      phaseIndex: s.index,
      elapsedMs: s.positionMs,
      pausedSeconds: s.pausedMs ~/ 1000,
      checkpointAt: s.savedAt,
    );
  }

  Future<void> markResumed(String sessionId) =>
      _dao.setStatus(sessionId, SessionStatus.inProgress);

  Future<void> discard(String sessionId) =>
      _dao.setStatus(sessionId, SessionStatus.discarded);

  Future<void> rate(String sessionId, {int? perceivedEffort, String? note}) =>
      _dao.rate(sessionId, perceivedEffort: perceivedEffort, note: note);
}
