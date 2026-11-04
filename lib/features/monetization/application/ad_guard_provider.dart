import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/app_router.dart';
import '../../../core/router/visible_path.dart';
import '../../intervals/application/interval_session_controller.dart';
import '../../strength/application/strength_session_controller.dart';
import '../domain/ad_guard.dart';
import 'ads_controller.dart';
import 'remove_ads_controller.dart';

export '../domain/ad_guard.dart';

/// Pasos críticos que no son una ruta propia (diálogos sobre una pantalla
/// con banner).
enum AdHold {
  /// Desde que la app abre hasta que `SessionGate` sabe si hay una sesión
  /// viva (al abrir puede saltar directo a S05/S10).
  launch,

  /// Desde «Empezar» (▶ o EMPEZAR) hasta que la sesión existe: avisos de
  /// permiso, batería y volumen (R-A1).
  starting,

  /// Ofrecer recuperar una sesión (S18-b, R-A11).
  recovery,
}

final adHoldsProvider = NotifierProvider<AdHolds, Set<AdHold>>(AdHolds.new);

class AdHolds extends Notifier<Set<AdHold>> {
  @override
  Set<AdHold> build() => const {AdHold.launch};

  void hold(AdHold h) {
    if (!state.contains(h)) state = {...state, h};
  }

  void release(AdHold h) {
    if (state.contains(h)) state = {...state}..remove(h);
  }

  /// Ejecuta [body] con [h] puesto.
  Future<T> during<T>(AdHold h, Future<T> Function() body) async {
    hold(h);
    try {
      return await body();
    } finally {
      if (ref.mounted) release(h);
    }
  }
}

/// Ruta visible (sin query), al día con cada navegación. Con `push`,
/// go_router deja `uri` en la ruta de abajo: se toma la de la última ruta
/// apilada.
final currentPathProvider = NotifierProvider<CurrentPath, String>(
  CurrentPath.new,
);

class CurrentPath extends Notifier<String> {
  @override
  String build() {
    final delegate = ref.watch(routerProvider).routerDelegate;
    String read() => visiblePath(delegate.currentConfiguration);
    void listener() {
      // Si go_router avisa en medio de un build, se aplica al terminar el
      // cuadro (Riverpod no deja cambiar estado durante un build).
      if (SchedulerBinding.instance.schedulerPhase ==
          SchedulerPhase.persistentCallbacks) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (ref.mounted) state = read();
        });
      } else {
        state = read();
      }
    }

    delegate.addListener(listener);
    ref.onDispose(() => delegate.removeListener(listener));
    return read();
  }
}

/// Entradas del guard, leídas del estado vivo de la app.
final adGuardInputsProvider = Provider<AdGuardInputs>((ref) {
  final interval = ref.watch(intervalSessionProvider);
  final strength = ref.watch(strengthSessionProvider);
  final holds = ref.watch(adHoldsProvider);
  final path = ref.watch(currentPathProvider);
  return AdGuardInputs(
    adsRemoved: ref.watch(adsRemovedProvider),
    adsEnabled: ref.watch(monetizationConfigProvider).adsEnabled,
    adsReady: ref.watch(adsControllerProvider.select((s) => s.ready)),
    // Una sesión de intervalos sigue «abierta» desde que se crea hasta que
    // se abre su resumen (también terminada o detenida).
    sessionActive: interval != null || strength != null,
    timerRunning: interval?.active ?? false,
    loggingSets: strength != null,
    summaryOpen: isSummaryPath(path),
    criticalStep: holds.isNotEmpty,
    path: path,
  );
});

/// Guard central: ¿se puede mostrar un banner en [placement] ahora?
final bannerDecisionProvider = Provider.family<AdDecision, BannerPlacement>(
  (ref, placement) =>
      decideAd(ref.watch(adGuardInputsProvider), banner: placement),
);

/// Guard central para el intersticial (sin restricción de pantalla; tiene
/// sus propias reglas encima).
final interstitialDecisionProvider = Provider<AdDecision>(
  (ref) => decideAd(ref.watch(adGuardInputsProvider)),
);

/// No hay ninguna sesión ni resumen abiertos: se puede mostrar el
/// formulario de consentimiento.
final sessionFreeProvider = Provider<bool>((ref) {
  final i = ref.watch(adGuardInputsProvider);
  return !i.sessionActive &&
      !i.summaryOpen &&
      !isSessionPath(i.path) &&
      !i.criticalStep;
});
