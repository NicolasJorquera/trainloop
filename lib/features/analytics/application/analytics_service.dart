import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/application/settings_controller.dart';
import '../domain/analytics_service.dart';

export '../domain/analytics_service.dart';

/// Destino de los eventos. Por defecto no envía nada (log en depuración):
/// conectar un proveedor es sobrescribir este provider en `main`.
final analyticsSinkProvider = Provider<AnalyticsSink>(
  (ref) => const DebugLogAnalyticsSink(),
);

/// Lo que dice el consentimiento sobre la analítica. Lo actualiza el módulo
/// de anuncios tras consultar UMP: `true` si no hace falta consentimiento o
/// la persona ya respondió el formulario; `false` mientras se desconoce
/// (sin red al primer arranque) o si falta responder. Validar con
/// Legal/Administración si «respondió» basta o hay que leer los propósitos
/// TCF (deuda en docs/pruebas-monetizacion.md).
final analyticsConsentProvider = NotifierProvider<AnalyticsConsent, bool>(
  AnalyticsConsent.new,
);

class AnalyticsConsent extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool allowed) {
    if (state != allowed) state = allowed;
  }
}

/// `true` si se pueden registrar eventos: interruptor de Configuración
/// encendido y consentimiento.
final analyticsEnabledProvider = Provider<bool>(
  (ref) =>
      ref.watch(settingsControllerProvider.select((s) => s.analytics)) &&
      ref.watch(analyticsConsentProvider),
);

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final sink = ref.watch(analyticsSinkProvider);
  final service = AnalyticsService(sink, ref.read(analyticsEnabledProvider));
  ref.listen(analyticsEnabledProvider, (_, on) => service.enabled = on);
  return service;
});

/// Eventos mínimos del PRD con el interruptor y el consentimiento aplicados.
/// Nunca lanza: la analítica no puede romper un flujo.
class AnalyticsService {
  AnalyticsService(this._sink, bool enabled) : _enabled = enabled {
    _safe(() => _sink.setEnabled(enabled));
  }

  final AnalyticsSink _sink;
  bool _enabled;

  bool get enabled => _enabled;

  set enabled(bool value) {
    if (value == _enabled) return;
    _enabled = value;
    _safe(() => _sink.setEnabled(value));
  }

  void log(AnalyticsEvent event) {
    if (!_enabled) return;
    _safe(() => _sink.log(event));
  }

  static void _safe(void Function() f) {
    try {
      f();
    } catch (_) {
      // Sin red o proveedor caído: se ignora.
    }
  }
}
