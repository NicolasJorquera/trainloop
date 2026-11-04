import 'dart:async';

import 'package:trainloop/platform/timer_engine_client.dart';

/// Doble del motor nativo: registra los comandos y publica los estados que
/// la prueba le indica.
class FakeTimerEngine implements TimerEngineClient {
  final _states = StreamController<EngineState>.broadcast();
  final _strength = StreamController<StrengthEngineState>.broadcast();
  final calls = <String>[];

  StrengthProgram? strengthProgram;
  StrengthEngineState? strengthLive;
  StrengthPending? strengthPendingState;

  /// Descansos pedidos: (duración en ms, serie siguiente).
  final rests = <(int, String)>[];
  String? progress;
  String? next;

  Duration now = Duration.zero;
  TimerProgram? program;
  EngineState? live;
  EngineState? pendingState;
  bool restricted = false;
  bool granted = true;
  bool promptShown = true;
  bool grantOnRequest = true;
  bool volumeZero = false;
  bool voice = true;

  /// Publica [s] como lo haría el EventChannel.
  void emit(EngineState s) {
    live = s.state.active ? s : null;
    _states.add(s);
  }

  @override
  Stream<EngineState> get states => _states.stream;

  /// Publica un estado de fuerza como lo haría el EventChannel.
  void emitStrength(StrengthEngineState s) {
    strengthLive = s.state.active ? s : null;
    _strength.add(s);
  }

  @override
  Stream<StrengthEngineState> get strengthStates => _strength.stream;

  @override
  Future<void> startStrength(StrengthProgram program) async {
    calls.add('startStrength');
    strengthProgram = program;
    strengthLive = StrengthEngineState(sessionId: program.sessionId);
  }

  @override
  Future<void> updateStrength({
    required String progress,
    required String next,
  }) async {
    this.progress = progress;
    this.next = next;
  }

  @override
  Future<void> startRest(int durationMs, {required String next}) async {
    calls.add('startRest');
    rests.add((durationMs, next));
  }

  @override
  Future<void> adjustRest(int deltaMs) async =>
      calls.add('adjustRest:$deltaMs');

  @override
  Future<void> skipRest() async => calls.add('skipRest');

  @override
  Future<void> stopStrength() async {
    calls.add('stopStrength');
    strengthLive = null;
  }

  @override
  Future<StrengthEngineState?> strengthCurrent() async => strengthLive;

  @override
  Future<StrengthPending?> strengthPending() async => strengthPendingState;

  @override
  Future<void> clearStrength() async {
    calls.add('clearStrength');
    strengthPendingState = null;
  }

  @override
  Duration clock() => now;

  @override
  Future<void> start(TimerProgram program) async {
    calls.add('start');
    this.program = program;
  }

  @override
  Future<void> pause() async => calls.add('pause');

  @override
  Future<void> resume() async => calls.add('resume');

  @override
  Future<void> skip() async => calls.add('skip');

  @override
  Future<void> previous() async => calls.add('previous');

  @override
  Future<void> stop() async => calls.add('stop');

  @override
  Future<EngineState?> current() async => live;

  @override
  Future<EngineState?> pending() async => pendingState;

  @override
  Future<void> restore() async => calls.add('restore');

  @override
  Future<void> clear() async {
    calls.add('clear');
    pendingState = null;
  }

  @override
  Future<bool> prewarmVoice(String localeTag) async {
    calls.add('prewarm:$localeTag');
    return voice;
  }

  @override
  Future<bool> backgroundRestricted() async => restricted;

  @override
  Future<void> openAppSettings() async => calls.add('openAppSettings');

  @override
  Future<String> manufacturer() async => 'Google';

  @override
  Future<bool> notificationsGranted() async => granted;

  @override
  Future<bool> requestNotifications() async {
    calls.add('requestNotifications');
    granted = grantOnRequest;
    return granted;
  }

  @override
  Future<bool> notificationPromptShown() async => promptShown;

  @override
  Future<void> markNotificationPromptShown() async => promptShown = true;

  @override
  Future<bool> mediaVolumeZero() async => volumeZero;
}

/// Estado de prueba con valores razonables.
EngineState engineState(
  String sessionId, {
  EngineRunState state = EngineRunState.running,
  int index = 0,
  int count = 16,
  int remainingMs = 10000,
  int positionMs = 0,
  int activeMs = 0,
  int pausedMs = 0,
  List<EnginePhaseResult> results = const [],
  DateTime? savedAt,
  Duration receivedAt = Duration.zero,
}) => EngineState(
  sessionId: sessionId,
  state: state,
  index: index,
  count: count,
  remainingMs: remainingMs,
  positionMs: positionMs,
  activeMs: activeMs,
  pausedMs: pausedMs,
  results: results,
  savedAt: savedAt,
  receivedAt: receivedAt,
);

EnginePhaseResult phaseResult(
  int index,
  int plannedMs, {
  int? actualMs,
  bool skipped = false,
}) => EnginePhaseResult(
  index: index,
  plannedMs: plannedMs,
  actualMs: actualMs ?? plannedMs,
  skipped: skipped,
);
