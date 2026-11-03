import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/phase_colors.dart';
import '../../../platform/timer_engine_client.dart';
import '../../settings/domain/app_settings.dart';
import '../data/interval_session_repository.dart';
import '../domain/interval_workout_draft.dart';
import '../domain/phase_plan.dart';
import '../domain/workout_snapshot.dart';
import 'interval_providers.dart';
import 'interval_texts.dart';

/// Sesión de intervalos activa (o recién terminada) vista desde la interfaz.
class ActiveSession {
  const ActiveSession({
    required this.sessionId,
    required this.snapshot,
    required this.engine,
    this.saved = false,
  });

  final String sessionId;
  final WorkoutSnapshot snapshot;
  final EngineState engine;

  /// Terminada y ya guardada en la base: se puede abrir el resumen.
  final bool saved;

  List<PlannedPhase> get phases => snapshot.phases;

  PlannedPhase get phase =>
      phases[engine.index.clamp(0, phases.length - 1).toInt()];

  PlannedPhase? get next =>
      engine.index + 1 < phases.length ? phases[engine.index + 1] : null;

  bool get active => engine.state.active;
}

/// Sesión que quedó en curso cuando Android cerró la app (S18-b, F-16).
class RecoveryOffer {
  const RecoveryOffer(this.sessionId, this.snapshot, this.engine);

  final String sessionId;
  final WorkoutSnapshot snapshot;
  final EngineState engine;
}

final intervalSessionProvider =
    NotifierProvider<IntervalSessionController, ActiveSession?>(
      IntervalSessionController.new,
    );

/// Orquesta la sesión: crea la fila en la base con la copia de la
/// estructura, envía el programa al motor nativo, guarda cada fase que el
/// motor cierra (una transacción por fase) y cierra la sesión al terminar.
/// Una sola sesión activa a la vez (R-I13).
class IntervalSessionController extends Notifier<ActiveSession?> {
  StreamSubscription<EngineState>? _sub;
  Future<void> _queue = Future.value();
  final _saved = <int, EnginePhaseResult>{};
  int? _checkpointIndex;

  TimerEngineClient get _engine => ref.read(timerEngineClientProvider);
  IntervalSessionRepository get _repo =>
      ref.read(intervalSessionRepositoryProvider);

  @override
  ActiveSession? build() {
    _sub = ref.watch(timerEngineClientProvider).states.listen(_enqueue);
    ref.onDispose(() => _sub?.cancel());
    return null;
  }

  /// Empieza [workout] y devuelve el id de la sesión.
  Future<String> start(
    IntervalWorkoutDraft workout, {
    String? sourceId,
    required AppLocalizations l10n,
    required AppSettings settings,
    required PhasePalette palette,
    required String localeTag,
  }) async {
    final snapshot = WorkoutSnapshot.of(workout);
    final id = await _repo.start(workout, sourceId: sourceId);
    _saved.clear();
    _checkpointIndex = 0;
    state = ActiveSession(
      sessionId: id,
      snapshot: snapshot,
      engine: EngineState(
        sessionId: id,
        state: EngineRunState.running,
        index: 0,
        count: snapshot.phases.length,
        remainingMs: snapshot.phases.first.seconds * 1000,
        positionMs: 0,
        activeMs: 0,
        pausedMs: 0,
        receivedAt: _engine.clock(),
      ),
    );
    await _engine.start(
      buildTimerProgram(
        sessionId: id,
        snapshot: snapshot,
        l10n: l10n,
        settings: settings,
        palette: palette,
        localeTag: localeTag,
      ),
    );
    return id;
  }

  Future<void> pause() => _engine.pause();
  Future<void> resume() => _engine.resume();
  Future<void> skip() => _engine.skip();
  Future<void> previous() => _engine.previous();
  Future<void> stop() => _engine.stop();

  /// Pide el estado al motor (al volver a la app).
  Future<void> refresh() async {
    final s = await _engine.current();
    if (s != null) await _enqueue(s);
  }

  /// Al abrir la app: se engancha a una sesión viva, guarda una terminada
  /// sin interfaz o devuelve la que hay que ofrecer recuperar.
  Future<RecoveryOffer?> syncOnLaunch() async {
    final live = await _engine.current();
    if (live != null) {
      await _enqueue(live);
      return null;
    }
    final pending = await _engine.pending();
    if (pending == null) return null;
    final record = await _repo.load(pending.sessionId);
    if (record == null) {
      await _engine.clear();
      return null;
    }
    if (pending.state.active) {
      await _repo.markRecoveryPending(
        pending.sessionId,
        record.snapshot,
        pending,
      );
      return RecoveryOffer(pending.sessionId, record.snapshot, pending);
    }
    await _repo.finish(pending.sessionId, record.snapshot, pending);
    await _engine.clear();
    return null;
  }

  /// Reanuda la sesión recuperada, en pausa.
  Future<void> resumeRecovered(RecoveryOffer offer) async {
    await _repo.markResumed(offer.sessionId);
    _saved
      ..clear()
      ..addEntries(offer.engine.results.map((r) => MapEntry(r.index, r)));
    _checkpointIndex = offer.engine.index;
    state = ActiveSession(
      sessionId: offer.sessionId,
      snapshot: offer.snapshot,
      engine: EngineState(
        sessionId: offer.sessionId,
        state: EngineRunState.paused,
        index: offer.engine.index,
        count: offer.engine.count,
        remainingMs: _remainingFor(offer),
        positionMs: offer.engine.positionMs,
        activeMs: offer.engine.activeMs,
        pausedMs: offer.engine.pausedMs,
        results: offer.engine.results,
        receivedAt: _engine.clock(),
      ),
    );
    await _engine.restore();
  }

  Future<void> saveRecoveredAsIncomplete(RecoveryOffer offer) async {
    await _repo.finish(
      offer.sessionId,
      offer.snapshot,
      EngineState(
        sessionId: offer.sessionId,
        state: EngineRunState.stopped,
        index: offer.engine.index,
        count: offer.engine.count,
        remainingMs: 0,
        positionMs: offer.engine.positionMs,
        activeMs: offer.engine.activeMs,
        pausedMs: offer.engine.pausedMs,
        results: offer.engine.results,
      ),
    );
    await _engine.clear();
  }

  Future<void> discardRecovered(RecoveryOffer offer) async {
    await _repo.discard(offer.sessionId);
    await _engine.clear();
  }

  /// Olvida la sesión terminada (después de abrir el resumen).
  void dismiss() {
    if (state?.active == false) state = null;
  }

  /// Lo que faltaba de la fase en el punto guardado.
  static int _remainingFor(RecoveryOffer offer) {
    final phases = offer.snapshot.phases;
    var end = 0;
    for (var i = 0; i <= offer.engine.index && i < phases.length; i++) {
      end += phases[i].seconds * 1000;
    }
    return (end - offer.engine.positionMs).clamp(0, end);
  }

  Future<void> _enqueue(EngineState s) =>
      _queue = _queue.then((_) => _handle(s)).catchError((Object _) {});

  Future<void> _handle(EngineState s) async {
    var current = state;
    if (current == null || current.sessionId != s.sessionId) {
      // La interfaz se reinició con el servicio vivo: se toma la copia de
      // la base.
      final record = await _repo.load(s.sessionId);
      if (record == null) return;
      _saved
        ..clear()
        ..addEntries(
          record.phases.map(
            (p) => MapEntry(
              p.sortOrder,
              EnginePhaseResult(
                index: p.sortOrder,
                plannedMs: p.plannedSeconds * 1000,
                actualMs: p.actualSeconds * 1000,
                skipped: p.skipped,
              ),
            ),
          ),
        );
      current = ActiveSession(
        sessionId: s.sessionId,
        snapshot: record.snapshot,
        engine: s,
      );
    }
    state = ActiveSession(
      sessionId: s.sessionId,
      snapshot: current.snapshot,
      engine: s,
    );

    final fresh = [
      for (final r in s.results)
        if (_saved[r.index] != r) r,
    ];
    if (s.state.active) {
      if (fresh.isNotEmpty) {
        await _repo.savePhases(s.sessionId, current.snapshot, fresh);
        for (final r in fresh) {
          _saved[r.index] = r;
        }
      }
      if (_checkpointIndex != s.index) {
        _checkpointIndex = s.index;
        await _repo.checkpoint(s.sessionId, s);
      }
      return;
    }
    await _repo.finish(s.sessionId, current.snapshot, s);
    await _engine.clear();
    _saved.clear();
    _checkpointIndex = null;
    state = ActiveSession(
      sessionId: s.sessionId,
      snapshot: current.snapshot,
      engine: s,
      saved: true,
    );
  }
}
