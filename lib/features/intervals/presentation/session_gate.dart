import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/router/routes.dart';
import '../../../platform/timer_engine_client.dart';
import '../application/interval_providers.dart';
import '../application/interval_session_controller.dart';
import 'session_dialogs.dart';

/// Al abrir la app y al volver a ella: precalienta la voz, se engancha a
/// una sesión que sigue corriendo (abre S05, p. ej. al tocar la
/// notificación), guarda una que terminó sin interfaz y ofrece recuperar la
/// que Android cerró (S18-b, F-16). Nunca se reanuda sola (T-11).
class SessionGate extends ConsumerStatefulWidget {
  const SessionGate({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends ConsumerState<SessionGate> {
  late final AppLifecycleListener _lifecycle;
  var _busy = false;
  var _launched = false;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _sync);
    WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  Future<void> _sync() async {
    if (_busy || !mounted) return;
    _busy = true;
    try {
      final router = ref.read(routerProvider);
      final context = router.routerDelegate.navigatorKey.currentContext;
      if (context == null) return;
      final engine = ref.read(timerEngineClientProvider);
      final controller = ref.read(intervalSessionProvider.notifier);
      if (!_launched) {
        _launched = true;
        unawaited(
          engine.prewarmVoice(Localizations.localeOf(context).toLanguageTag()),
        );
      }
      final offer = await controller.syncOnLaunch();
      if (offer != null) {
        await _offerRecovery(controller, offer);
        return;
      }
      final active = ref.read(intervalSessionProvider)?.active ?? false;
      final path = router.routerDelegate.currentConfiguration.uri.path;
      // Sin esperar: push termina recién al cerrar S05.
      if (active && path != Routes.timer) unawaited(router.push(Routes.timer));
    } finally {
      _busy = false;
    }
  }

  Future<void> _offerRecovery(
    IntervalSessionController controller,
    RecoveryOffer offer,
  ) async {
    final router = ref.read(routerProvider);
    final context = router.routerDelegate.navigatorKey.currentContext;
    if (context == null) return;
    final choice = await showRecoveryDialog(context, offer);
    switch (choice) {
      case null:
        // El diálogo se cerró sin elegir: la sesión sigue pendiente.
        return;
      case RecoveryChoice.resume:
        await controller.resumeRecovered(offer);
        if (!_onTimer(router)) unawaited(router.push(Routes.timer));
        return;
      case RecoveryChoice.saveIncomplete:
        await controller.saveRecoveredAsIncomplete(offer);
      case RecoveryChoice.discard:
        await controller.discardRecovered(offer);
    }
    // Si Android detuvo el servicio con S05 abierta, se vuelve a Inicio.
    controller.dismiss();
    if (_onTimer(router)) router.go(Routes.home);
  }

  static bool _onTimer(GoRouter router) =>
      router.routerDelegate.currentConfiguration.uri.path == Routes.timer;

  @override
  Widget build(BuildContext context) {
    // Android detuvo el servicio con la app abierta: se ofrece recuperar.
    ref.listen(intervalSessionProvider, (_, next) {
      if (next?.engine.state == EngineRunState.interrupted) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
      }
    });
    return widget.child;
  }
}
