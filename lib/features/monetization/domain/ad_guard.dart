import 'package:flutter/foundation.dart';

/// Por qué no se puede mostrar un anuncio ahora (el primero que aplica).
enum AdBlockReason {
  /// La persona compró «Sin anuncios» (F-15c) o todavía no se sabe.
  adsRemoved,

  /// Anuncios apagados en este build (`TL_ADS=off`).
  disabled,

  /// UMP no permite pedir anuncios (sin red al primer arranque, formulario
  /// sin responder o error) o el SDK no terminó de iniciar.
  notReady,

  /// Hay una sesión de intervalos o de fuerza abierta, incluido el instante
  /// entre «Empezar» y S05/S10 (R-A1).
  sessionActive,

  /// El motor del temporizador está corriendo o en pausa (R-A1).
  timerRunning,

  /// Hay una sesión de fuerza registrando series (S10/S11, R-A1).
  loggingSets,

  /// El resumen (S06) está abierto (R-A1: hasta que la persona sale).
  summaryOpen,

  /// Un paso crítico sobre una pantalla permitida: los avisos antes de
  /// empezar, la recuperación de una sesión (R-A11) o el arranque, hasta que
  /// se sabe si hay una sesión viva.
  criticalStep,

  /// La pantalla actual no admite banner (R-A11 y tabla de ubicaciones).
  screenNotAllowed,
}

/// Lo que el guard necesita saber, sin Flutter ni plugins (se prueba solo).
@immutable
class AdGuardInputs {
  const AdGuardInputs({
    required this.adsRemoved,
    required this.adsEnabled,
    required this.adsReady,
    required this.sessionActive,
    required this.timerRunning,
    required this.loggingSets,
    required this.summaryOpen,
    required this.criticalStep,
    required this.path,
  });

  /// `null` mientras no se leyó el estado guardado: cuenta como comprado
  /// (mejor no mostrar a quien pagó).
  final bool? adsRemoved;
  final bool adsEnabled;
  final bool adsReady;
  final bool sessionActive;
  final bool timerRunning;
  final bool loggingSets;
  final bool summaryOpen;
  final bool criticalStep;

  /// Ruta actual de go_router (sin query).
  final String path;
}

/// Decisión del guard: permitido o el motivo del bloqueo.
@immutable
class AdDecision {
  const AdDecision.allowed() : reason = null;
  const AdDecision.blocked(AdBlockReason this.reason);

  final AdBlockReason? reason;

  bool get allowed => reason == null;

  @override
  bool operator ==(Object other) =>
      other is AdDecision && other.reason == reason;

  @override
  int get hashCode => reason.hashCode;

  @override
  String toString() => allowed ? 'AdDecision.allowed' : 'AdDecision($reason)';
}

/// Dónde puede ir un banner (PRD, «Ubicaciones por pantalla» y diseño de
/// Main): anclado abajo en Inicio, Entrenar (rutinas e intervalos), Historial
/// (con el calendario) y Progreso, y en la biblioteca de ejercicios fuera del
/// modo de elegir. Todo lo demás —S03, editores, S05, S06, S10, S11, S13,
/// S15, Configuración, respaldo— no tiene banner.
enum BannerPlacement {
  /// Sobre la barra inferior de las 4 pestañas.
  tabs({'/home', '/train', '/history', '/progress'}),

  /// Al pie de la biblioteca de ejercicios (S08) en modo consulta.
  library({'/exercises'});

  const BannerPlacement(this.paths);

  final Set<String> paths;
}

/// Pantallas de consulta: las únicas donde puede aparecer un anuncio.
final consultationPaths = {for (final p in BannerPlacement.values) ...p.paths};

/// Rutas de la sesión en curso o de su resumen (R-A1), por si el estado de
/// la sesión todavía no se actualizó.
bool isSessionPath(String path) =>
    path == '/timer' ||
    path == '/strength' ||
    (path.startsWith('/sessions/') && path.endsWith('/summary')) ||
    (path.startsWith('/strength/') && path.endsWith('/summary'));

bool isSummaryPath(String path) =>
    path.endsWith('/summary') &&
    (path.startsWith('/sessions/') || path.startsWith('/strength/'));

/// Guard central (R-A1, R-A11): decide si se puede mostrar **cualquier**
/// anuncio. Las reglas de sesión van primero y no tienen excepciones. Un
/// banner además exige que la pantalla visible sea la de su [banner]; el
/// intersticial (`banner == null`) tiene reglas propias encima de esta
/// (`InterstitialPolicy`) y solo sobre una pantalla de consulta.
AdDecision decideAd(AdGuardInputs i, {BannerPlacement? banner}) {
  AdDecision no(AdBlockReason r) => AdDecision.blocked(r);
  if (i.sessionActive) return no(AdBlockReason.sessionActive);
  if (i.timerRunning) return no(AdBlockReason.timerRunning);
  if (i.loggingSets) return no(AdBlockReason.loggingSets);
  if (i.summaryOpen || isSummaryPath(i.path)) {
    return no(AdBlockReason.summaryOpen);
  }
  if (isSessionPath(i.path)) return no(AdBlockReason.sessionActive);
  if (i.criticalStep) return no(AdBlockReason.criticalStep);
  if (i.adsRemoved ?? true) return no(AdBlockReason.adsRemoved);
  if (!i.adsEnabled) return no(AdBlockReason.disabled);
  if (!i.adsReady) return no(AdBlockReason.notReady);
  // El banner, solo en su pantalla; el intersticial, solo sobre una pantalla
  // de consulta (tras «Listo» se vuelve a Inicio), nunca sobre S03, un
  // editor o Configuración.
  final allowedPaths = banner?.paths ?? consultationPaths;
  if (!allowedPaths.contains(i.path)) {
    return no(AdBlockReason.screenNotAllowed);
  }
  return const AdDecision.allowed();
}
