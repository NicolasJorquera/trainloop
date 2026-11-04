import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/app_database.dart';
import '../../../data/db/database_providers.dart';
import '../../../data/db/enums.dart';
import '../../../platform/timer_engine_client.dart';
import '../../intervals/application/interval_providers.dart';
import '../data/strength_session_repository.dart';
import '../domain/strength_rules.dart';
import '../domain/strength_session.dart';
import 'strength_texts.dart';

final strengthSessionRepositoryProvider = Provider<StrengthSessionRepository>(
  (ref) => StrengthSessionRepository(ref.watch(appDatabaseProvider)),
);

/// La sesión con sus ejercicios y series, al día con cada cambio.
final strengthSessionDataProvider = StreamProvider.autoDispose
    .family<StrengthSessionData?, String>(
      (ref, id) => ref.watch(strengthSessionRepositoryProvider).watch(id),
    );

/// Última sesión de fuerza del historial ("repetir la última", Inicio).
final lastStrengthSessionProvider = StreamProvider<Session?>(
  (ref) => ref.watch(strengthSessionRepositoryProvider).watchLast(),
);

/// Cómo empieza una sesión de fuerza (R-G1).
sealed class StrengthStart {
  const StrengthStart();
}

class StartFromRoutine extends StrengthStart {
  const StartFromRoutine(this.routineId);

  final String routineId;
}

class StartFree extends StrengthStart {
  const StartFree();
}

class StartRepeatLast extends StrengthStart {
  const StartRepeatLast();
}

/// Sesión de fuerza activa vista desde la interfaz: su id y el último
/// estado del servicio (descanso).
class ActiveStrength {
  const ActiveStrength({
    required this.sessionId,
    this.engine,
    this.restEndedAt,
  });

  final String sessionId;
  final StrengthEngineState? engine;

  /// Cuándo terminó el último descanso, en el reloj de
  /// [TimerEngineClient.clock] (S10 muestra "¡A la siguiente serie!" unos
  /// segundos).
  final Duration? restEndedAt;

  bool get resting => engine?.resting ?? false;

  bool get interrupted => engine?.state == EngineRunState.interrupted;

  ActiveStrength copyWith({
    StrengthEngineState? engine,
    Duration? Function()? restEndedAt,
  }) => ActiveStrength(
    sessionId: sessionId,
    engine: engine ?? this.engine,
    restEndedAt: restEndedAt != null ? restEndedAt() : this.restEndedAt,
  );
}

/// Sesión de fuerza que quedó abierta cuando Android cerró la app (S18-b).
class StrengthRecoveryOffer {
  const StrengthRecoveryOffer({
    required this.session,
    required this.title,
    required this.completedSets,
    this.pending,
  });

  final Session session;
  final String? title;
  final int completedSets;

  /// Lo que guardó el servicio (descanso recalculado), si es de esta sesión.
  final StrengthPending? pending;

  String get sessionId => session.id;

  /// Último instante guardado: el del servicio o la última serie.
  DateTime get savedAt => pending?.savedAt ?? session.updatedAt;
}

final strengthSessionProvider =
    NotifierProvider<StrengthSessionController, ActiveStrength?>(
      StrengthSessionController.new,
    );

/// Orquesta la sesión de fuerza: la crea en la base con la copia de la
/// rutina, guarda cada serie en su transacción (NF-06), arranca el descanso
/// del ejercicio en el servicio nativo (F-09) y la cierra. Una sola sesión
/// activa a la vez (R-I13).
class StrengthSessionController extends Notifier<ActiveStrength?> {
  StreamSubscription<StrengthEngineState>? _sub;
  Future<void> _queue = Future.value();

  TimerEngineClient get _engine => ref.read(timerEngineClientProvider);
  StrengthSessionRepository get _repo =>
      ref.read(strengthSessionRepositoryProvider);

  @override
  ActiveStrength? build() {
    _sub = ref
        .watch(timerEngineClientProvider)
        .strengthStates
        .listen(
          (s) =>
              _queue = _queue.then((_) => _handle(s)).catchError((Object _) {}),
        );
    ref.onDispose(() => _sub?.cancel());
    return null;
  }

  /// Empieza la sesión y devuelve su id. Error si la rutina está vacía.
  Future<String> start(StrengthStart how, StrengthEnv env) async {
    final id = switch (how) {
      StartFromRoutine(:final routineId) => await _repo.startFromRoutine(
        routineId,
      ),
      StartFree() => await _repo.startFree(),
      StartRepeatLast() => await _repo.repeatLast() ?? await _repo.startFree(),
    };
    await _begin(id, env);
    return id;
  }

  Future<void> _begin(String id, StrengthEnv env) async {
    final data = await _repo.load(id);
    if (data == null) return;
    state = ActiveStrength(
      sessionId: id,
      engine: StrengthEngineState(sessionId: id, receivedAt: _engine.clock()),
    );
    await _engine.startStrength(
      buildStrengthProgram(
        sessionId: id,
        title: sessionTitle(env.l10n, data.title),
        startedAt: data.session.startedAt,
        env: env,
      ),
    );
    await syncNotification(data, env);
  }

  /// Marca la serie como hecha con [values] (1 toque con los propuestos) y
  /// arranca el descanso del ejercicio. Editar una serie ya hecha solo
  /// cambia sus valores.
  Future<void> completeSet(
    StrengthSessionData data,
    SessionExerciseItem exercise,
    SessionSet set,
    SetValues values,
    StrengthEnv env,
  ) async {
    if (set.completed) {
      await _repo.updateSet(set.id, values);
      return;
    }
    await _repo.completeSet(set.id, values);
    final next = nextSetText(
      env.l10n,
      data,
      env.unit,
      env.locale,
      afterSetId: set.id,
    );
    final seconds = exercise.restSeconds;
    if (seconds > 0) {
      state = state?.copyWith(restEndedAt: () => null);
      await _engine.startRest(seconds * 1000, next: next);
    }
  }

  /// Desmarca una serie hecha (tocar ✓ otra vez).
  Future<void> uncompleteSet(SessionSet set) => _repo.uncompleteSet(set.id);

  /// Guarda los valores de una serie sin marcarla.
  Future<void> updateSet(SessionSet set, SetValues values) =>
      _repo.updateSet(set.id, values);

  Future<void> adjustRest(int seconds) => _engine.adjustRest(seconds * 1000);

  Future<void> skipRest() => _engine.skipRest();

  /// Progreso y serie siguiente en la notificación sin descanso.
  Future<void> syncNotification(StrengthSessionData data, StrengthEnv env) =>
      _engine.updateStrength(
        progress: progressText(env.l10n, data),
        next: nextSetText(env.l10n, data, env.unit, env.locale),
      );

  /// Termina la sesión (R-G10/R-G11) y apaga el servicio. Devuelve el
  /// estado final: `discarded` si no quedó ninguna serie hecha.
  Future<SessionStatus> finish({
    PendingSets pending = PendingSets.discard,
  }) async {
    final id = state?.sessionId;
    if (id == null) return SessionStatus.discarded;
    final status = await _repo.finish(id, pending: pending);
    await _engine.stopStrength();
    state = null;
    return status;
  }

  /// Descarta la sesión en curso (sin series hechas, R-G11).
  Future<void> discard() async {
    final id = state?.sessionId;
    if (id == null) return;
    await _repo.discard(id);
    await _engine.stopStrength();
    state = null;
  }

  /// Al abrir la app o volver a ella: se engancha a la sesión del servicio
  /// vivo o devuelve la que hay que ofrecer recuperar (nunca se reanuda
  /// sola).
  Future<StrengthRecoveryOffer?> syncOnLaunch() async {
    final live = await _engine.strengthCurrent();
    if (live != null) {
      if (state?.sessionId != live.sessionId || state?.engine == null) {
        state = ActiveStrength(sessionId: live.sessionId, engine: live);
      }
      return null;
    }
    final active = await _repo.findActive();
    if (active.isEmpty) {
      if (state != null && !state!.interrupted) state = null;
      return null;
    }
    final session = active.first;
    final data = await _repo.load(session.id);
    final pending = await _engine.strengthPending();
    await _repo.markRecoveryPending(session.id);
    return StrengthRecoveryOffer(
      session: session,
      title: data?.title,
      completedSets: data?.completedSets ?? 0,
      pending: pending?.sessionId == session.id ? pending : null,
    );
  }

  /// "Reanudar": la sesión sigue donde estaba (sus series ya están en la
  /// base) y el descanso que quedaba, si no venció.
  Future<void> resumeRecovered(
    StrengthRecoveryOffer offer,
    StrengthEnv env,
  ) async {
    await _repo.markResumed(offer.sessionId);
    await _begin(offer.sessionId, env);
    final rest = offer.pending?.restRemainingAt(_engine.clock()) ?? 0;
    if (rest > 0) {
      await _engine.startRest(rest, next: offer.pending?.next ?? '');
    }
  }

  Future<SessionStatus> saveRecoveredAsIncomplete(
    StrengthRecoveryOffer offer,
  ) async {
    final status = await _repo.saveIncomplete(offer.sessionId);
    await _engine.clearStrength();
    state = null;
    return status;
  }

  Future<void> discardRecovered(StrengthRecoveryOffer offer) async {
    await _repo.discard(offer.sessionId);
    await _engine.clearStrength();
    state = null;
  }

  Future<void> _handle(StrengthEngineState s) async {
    final current = state;
    if (s.state == EngineRunState.stopped) return;
    if (s.state == EngineRunState.interrupted) {
      // Android detuvo el servicio con la app abierta: SessionGate ofrece
      // recuperarla (las series ya están en la base).
      state = ActiveStrength(sessionId: s.sessionId, engine: s);
      return;
    }
    final ended =
        current?.engine?.rest == RestRunState.running &&
        s.rest == RestRunState.done;
    state = ActiveStrength(
      sessionId: s.sessionId,
      engine: s,
      restEndedAt: ended
          ? s.receivedAt
          : s.rest == RestRunState.done
          ? current?.restEndedAt
          : null,
    );
  }
}
