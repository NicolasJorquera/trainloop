import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

/// Evento de analítica: un nombre y parámetros cerrados (enums, tramos).
///
/// Regla (PRD v0.2, NF-07): solo eventos agregados. Nunca datos personales
/// ni del entrenamiento: sin nombres de rutinas o ejercicios, pesos, reps,
/// notas, fechas, duraciones exactas ni identificadores de sesión. Por eso
/// los eventos solo se crean con los constructores de abajo.
@immutable
class AnalyticsEvent {
  const AnalyticsEvent._(this.name, [this.params = const {}]);

  /// Sesión empezada, por tipo (`intervals` o `strength`).
  factory AnalyticsEvent.sessionStarted(SessionKindParam kind) =>
      AnalyticsEvent._('session_start', {'type': kind.name});

  /// Sesión terminada (resumen cerrado), por tipo, si se completó y el tramo
  /// de duración.
  factory AnalyticsEvent.sessionFinished(
    SessionKindParam kind, {
    required bool completed,
    required int activeSeconds,
  }) => AnalyticsEvent._('session_complete', {
    'type': kind.name,
    'completed': completed ? 'yes' : 'no',
    'duration': durationBucket(activeSeconds),
  });

  /// Uso de una plantilla incluida (clave estable: `tabata`, `emom10`…).
  /// Las plantillas propias no se registran.
  factory AnalyticsEvent.templateUsed(String builtInKey) =>
      AnalyticsEvent._('template_used', {'template': builtInKey});

  /// Compra «Sin anuncios»: `purchased`, `restored`, `pending`, `canceled`
  /// o `error`.
  factory AnalyticsEvent.removeAds(String result) =>
      AnalyticsEvent._('purchase_remove_ads', {'result': result});

  final String name;
  final Map<String, String> params;

  /// Tramos gruesos: nunca la duración exacta.
  static String durationBucket(int seconds) {
    final minutes = seconds ~/ 60;
    if (minutes < 5) return 'lt5';
    if (minutes < 15) return '5_15';
    if (minutes < 30) return '15_30';
    if (minutes < 60) return '30_60';
    return 'gte60';
  }

  @override
  bool operator ==(Object other) =>
      other is AnalyticsEvent &&
      other.name == name &&
      mapEquals(other.params, params);

  @override
  int get hashCode => Object.hash(name, Object.hashAllUnordered(params.keys));

  @override
  String toString() => '$name $params';
}

enum SessionKindParam { intervals, strength }

/// Destino de los eventos. Listo para conectar un proveedor (p. ej. Google
/// Analytics for Firebase) cuando Gestión cree el proyecto y la cuenta:
/// basta con otra implementación y sobrescribir `analyticsSinkProvider`.
/// El interruptor de Configuración y el consentimiento se aplican antes
/// (`AnalyticsService`), así que el destino no decide nada.
abstract interface class AnalyticsSink {
  void log(AnalyticsEvent event);

  /// Se llama al apagar el interruptor o retirar el consentimiento: el
  /// proveedor real debe dejar de recolectar (p. ej.
  /// `setAnalyticsCollectionEnabled(false)`).
  void setEnabled(bool enabled);
}

/// Destino por defecto: no envía nada. En depuración escribe en la consola
/// (salvo en `flutter test`).
class DebugLogAnalyticsSink implements AnalyticsSink {
  const DebugLogAnalyticsSink();

  static final bool _print =
      kDebugMode && !Platform.environment.containsKey('FLUTTER_TEST');

  @override
  void log(AnalyticsEvent event) {
    if (_print) debugPrint('[analytics] $event');
  }

  @override
  void setEnabled(bool enabled) {
    if (_print) debugPrint('[analytics] enabled=$enabled');
  }
}
