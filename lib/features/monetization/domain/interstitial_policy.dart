import 'package:flutter/foundation.dart';

import '../../../data/db/enums.dart';

/// La sesión cuyo resumen se cerró con «Listo».
@immutable
class FinishedSession {
  const FinishedSession({
    required this.status,
    required this.activeSeconds,
    required this.recovered,
  });

  final SessionStatus status;

  /// Duración sin pausas.
  final int activeSeconds;

  /// Pasó por la recuperación (S18-b) en este arranque.
  final bool recovered;
}

/// Historial que necesitan los topes de R-A3.
@immutable
class InterstitialHistory {
  const InterstitialHistory({
    required this.completedSessions,
    required this.firstSessionAt,
    required this.sessionsSinceInterstitial,
    required this.lastInterstitialAt,
  });

  /// Sesiones completadas, incluida la que acaba de terminar.
  final int completedSessions;
  final DateTime? firstSessionAt;
  final int sessionsSinceInterstitial;
  final DateTime? lastInterstitialAt;
}

/// Por qué no se muestra el intersticial (o `null` si se puede).
enum InterstitialSkip {
  /// Experimento apagado (por defecto).
  flagOff,

  /// R-A5: descartada, incompleta o recuperada.
  notCompleted,
  recovered,

  /// R-A2: menos de 5 minutos.
  tooShort,

  /// R-A3: topes del experimento.
  firstSessions,
  firstDays,
  everyThirdSession,
  oncePerDay,
}

/// Reglas del intersticial (S20) que se suman al guard central: R-A2 (solo
/// tras «Listo» en una sesión completada de al menos 5 min, nunca
/// automáticamente), R-A3 (topes) y R-A5. R-A4 (precargado; si no está
/// listo no se muestra) lo aplica el controlador.
abstract final class InterstitialPolicy {
  static const minSeconds = 5 * 60;
  static const minCompletedSessions = 6;
  static const minDays = 7;
  static const everySessions = 3;

  static InterstitialSkip? check({
    required bool experimentOn,
    required bool capsOn,
    required FinishedSession session,
    required InterstitialHistory history,
    required DateTime now,
  }) {
    if (!experimentOn) return InterstitialSkip.flagOff;
    if (session.status != SessionStatus.completed) {
      return InterstitialSkip.notCompleted;
    }
    if (session.recovered) return InterstitialSkip.recovered;
    if (session.activeSeconds < minSeconds) return InterstitialSkip.tooShort;
    if (!capsOn) return null;
    // «Ninguno en las primeras 5 sesiones»: desde la sexta.
    if (history.completedSessions < minCompletedSessions) {
      return InterstitialSkip.firstSessions;
    }
    final first = history.firstSessionAt;
    if (first == null || now.difference(first).inDays < minDays) {
      return InterstitialSkip.firstDays;
    }
    final last = history.lastInterstitialAt;
    if (last != null) {
      if (history.sessionsSinceInterstitial < everySessions) {
        return InterstitialSkip.everyThirdSession;
      }
      final a = last.toLocal();
      final b = now.toLocal();
      if (a.year == b.year && a.month == b.month && a.day == b.day) {
        return InterstitialSkip.oncePerDay;
      }
    }
    return null;
  }
}
