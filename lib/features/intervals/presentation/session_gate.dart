import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/app_router.dart';
import '../../../core/router/routes.dart';
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
        final offer = await controller.syncOnLaunch();
        if (offer != null) {
          await _offerRecovery(controller, offer);
          return;
        }
      } else {
        await controller.refresh();
      }
      final active = ref.read(intervalSessionProvider)?.active ?? false;
      final path = router.routerDelegate.currentConfiguration.uri.path;
      if (active && path != Routes.timer) await router.push(Routes.timer);
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
      case RecoveryChoice.resume:
        await controller.resumeRecovered(offer);
        await router.push(Routes.timer);
      case RecoveryChoice.saveIncomplete:
        await controller.saveRecoveredAsIncomplete(offer);
      case RecoveryChoice.discard:
        await controller.discardRecovered(offer);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
