import 'dart:async';

import 'package:flutter/services.dart';

/// Estado de la sesión en el motor nativo.
enum EngineRunState {
  running,
  paused,
  finished,
  stopped;

  bool get active => this == running || this == paused;

  static EngineRunState fromName(Object? name) => values.firstWhere(
    (s) => s.name == name,
    orElse: () => EngineRunState.stopped,
  );
}

/// Fase al dejarla: planificado frente a tiempo activo real.
class EnginePhaseResult {
  const EnginePhaseResult({
    required this.index,
    required this.plannedMs,
    required this.actualMs,
    required this.skipped,
  });

  factory EnginePhaseResult.fromMap(Map<Object?, Object?> m) =>
      EnginePhaseResult(
        index: (m['index']! as num).toInt(),
        plannedMs: (m['plannedMs']! as num).toInt(),
        actualMs: (m['actualMs']! as num).toInt(),
        skipped: m['skipped']! as bool,
      );

  final int index;
  final int plannedMs;
  final int actualMs;
  final bool skipped;

  @override
  bool operator ==(Object other) =>
      other is EnginePhaseResult &&
      other.index == index &&
      other.plannedMs == plannedMs &&
      other.actualMs == actualMs &&
      other.skipped == skipped;

  @override
  int get hashCode => Object.hash(index, plannedMs, actualMs, skipped);
}

/// Estado que publica el motor en cada cambio (no por fotograma). La
/// interfaz calcula el tiempo restante desde [receivedAt].
class EngineState {
  const EngineState({
    required this.sessionId,
    required this.state,
    required this.index,
    required this.count,
    required this.remainingMs,
    required this.positionMs,
    required this.activeMs,
    required this.pausedMs,
    this.results = const [],
    this.voiceReady = true,
    this.savedAt,
    this.receivedAt = Duration.zero,
  });

  factory EngineState.fromMap(
    Map<Object?, Object?> m, {
    Duration receivedAt = Duration.zero,
  }) {
    final saved = m['savedAtWallMs'] as num?;
    return EngineState(
      sessionId: m['sessionId']! as String,
      state: EngineRunState.fromName(m['state']),
      index: (m['index']! as num).toInt(),
      count: (m['count']! as num).toInt(),
      remainingMs: (m['remainingMs']! as num).toInt(),
      positionMs: (m['positionMs']! as num).toInt(),
      activeMs: (m['activeMs']! as num).toInt(),
      pausedMs: (m['pausedMs']! as num).toInt(),
      results: [
        for (final r in (m['results'] as List<Object?>? ?? const []))
          EnginePhaseResult.fromMap(r! as Map<Object?, Object?>),
      ],
      voiceReady: m['voiceReady'] as bool? ?? true,
      savedAt: saved == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(saved.toInt()),
      receivedAt: receivedAt,
    );
  }

  final String sessionId;
  final EngineRunState state;
  final int index;
  final int count;

  /// Tiempo restante de la fase al publicarse el estado.
  final int remainingMs;
  final int positionMs;

  /// Tiempo entrenado (sin pausas) y tiempo en pausa.
  final int activeMs;
  final int pausedMs;
  final List<EnginePhaseResult> results;
  final bool voiceReady;

  /// Hora del último punto guardado (solo en sesiones pendientes).
  final DateTime? savedAt;

  /// Instante (reloj monotónico de [TimerEngineClient.clock]) en que llegó.
  final Duration receivedAt;

  /// Tiempo restante de la fase en el instante [now] del mismo reloj.
  int remainingAt(Duration now) => state == EngineRunState.running
      ? (remainingMs - (now - receivedAt).inMilliseconds).clamp(0, remainingMs)
      : remainingMs;
}

/// Fase tal como la cuenta el motor: textos ya localizados.
class TimerPhaseSpec {
  const TimerPhaseSpec({
    required this.type,
    required this.title,
    required this.speech,
    required this.durationMs,
    required this.color,
  });

  final String type;

  /// Título de la notificación (p. ej. «Trabajo · Ronda 3/8»).
  final String title;

  /// Lo que dice la voz al empezar la fase.
  final String speech;
  final int durationMs;

  /// Color de fondo de la fase (ARGB), también para la notificación.
  final int color;

  Map<String, Object?> toMap() => {
    'type': type,
    'title': title,
    'speech': speech,
    'durationMs': durationMs,
    'color': color,
  };
}

/// Programa que recibe el motor: fases, avisos y textos de la notificación.
class TimerProgram {
  const TimerProgram({
    required this.sessionId,
    required this.title,
    required this.locale,
    required this.sounds,
    required this.voice,
    required this.vibration,
    required this.strings,
    required this.phases,
  });

  final String sessionId;
  final String title;
  final String locale;
  final bool sounds;
  final bool voice;
  final bool vibration;

  /// pause, resume, skip, paused, channel y finishSpeech.
  final Map<String, String> strings;
  final List<TimerPhaseSpec> phases;

  Map<String, Object?> toMap() => {
    'sessionId': sessionId,
    'title': title,
    'locale': locale,
    'sounds': sounds,
    'voice': voice,
    'vibration': vibration,
    'strings': strings,
    'phases': [for (final p in phases) p.toMap()],
  };
}

/// Puente con el motor nativo (android/…/timer/TimerBridge.kt). Las pruebas
/// usan un doble que implementa esta interfaz.
abstract interface class TimerEngineClient {
  /// Estados del motor: uno por cambio (inicio, fase, pausa, fin).
  Stream<EngineState> get states;

  /// Reloj monotónico con el que se sellan los estados.
  Duration clock();

  Future<void> start(TimerProgram program);
  Future<void> pause();
  Future<void> resume();
  Future<void> skip();
  Future<void> previous();
  Future<void> stop();

  /// Sesión del servicio vivo, o `null`.
  Future<EngineState?> current();

  /// Sesión guardada sin servicio vivo (en curso tras un cierre, o terminada
  /// sin interfaz), o `null`.
  Future<EngineState?> pending();

  /// Retoma la sesión pendiente, en pausa.
  Future<void> restore();

  /// Borra el punto guardado (ya está en la base).
  Future<void> clear();

  /// Precalienta la voz; `true` si hay voz para [localeTag].
  Future<bool> prewarmVoice(String localeTag);

  /// La app está "Restringida" en batería (el servicio no duraría).
  Future<bool> backgroundRestricted();
  Future<void> openAppSettings();
  Future<String> manufacturer();

  /// Permiso de notificaciones (Android 13+).
  Future<bool> notificationsGranted();

  /// Muestra el diálogo del sistema; `true` si lo concede.
  Future<bool> requestNotifications();

  /// La explicación previa al permiso se muestra una sola vez (T-07).
  Future<bool> notificationPromptShown();
  Future<void> markNotificationPromptShown();
  Future<bool> mediaVolumeZero();
}

/// Implementación con canales de plataforma.
class MethodChannelTimerEngine implements TimerEngineClient {
  MethodChannelTimerEngine();

  static const _methods = MethodChannel('trainloop/timer');
  static const _events = EventChannel('trainloop/timer/events');

  final _stopwatch = Stopwatch()..start();
  Stream<EngineState>? _states;

  @override
  Duration clock() => _stopwatch.elapsed;

  @override
  Stream<EngineState> get states => _states ??= _events
      .receiveBroadcastStream()
      .map(
        (e) => EngineState.fromMap(
          e as Map<Object?, Object?>,
          receivedAt: clock(),
        ),
      )
      .asBroadcastStream();

  @override
  Future<void> start(TimerProgram program) =>
      _methods.invokeMethod('start', program.toMap());

  @override
  Future<void> pause() => _methods.invokeMethod('pause');

  @override
  Future<void> resume() => _methods.invokeMethod('resume');

  @override
  Future<void> skip() => _methods.invokeMethod('skip');

  @override
  Future<void> previous() => _methods.invokeMethod('previous');

  @override
  Future<void> stop() => _methods.invokeMethod('stop');

  @override
  Future<EngineState?> current() => _state('state');

  @override
  Future<EngineState?> pending() => _state('pending');

  Future<EngineState?> _state(String method) async {
    final m = await _methods.invokeMethod<Map<Object?, Object?>>(method);
    return m == null ? null : EngineState.fromMap(m, receivedAt: clock());
  }

  @override
  Future<void> restore() => _methods.invokeMethod('restore');

  @override
  Future<void> clear() => _methods.invokeMethod('clear');

  @override
  Future<bool> prewarmVoice(String localeTag) async =>
      await _methods.invokeMethod<bool>('prewarmVoice', {
        'locale': localeTag,
      }) ??
      false;

  @override
  Future<bool> backgroundRestricted() async =>
      await _methods.invokeMethod<bool>('backgroundRestricted') ?? false;

  @override
  Future<void> openAppSettings() => _methods.invokeMethod('openAppSettings');

  @override
  Future<String> manufacturer() async =>
      await _methods.invokeMethod<String>('manufacturer') ?? 'Android';

  @override
  Future<bool> notificationsGranted() async =>
      await _methods.invokeMethod<bool>('notificationsGranted') ?? true;

  @override
  Future<bool> requestNotifications() async =>
      await _methods.invokeMethod<bool>('requestNotifications') ?? false;

  @override
  Future<bool> notificationPromptShown() async =>
      await _methods.invokeMethod<bool>('notificationPromptShown') ?? true;

  @override
  Future<void> markNotificationPromptShown() =>
      _methods.invokeMethod('markNotificationPromptShown');

  @override
  Future<bool> mediaVolumeZero() async =>
      await _methods.invokeMethod<bool>('mediaVolumeZero') ?? false;
}
