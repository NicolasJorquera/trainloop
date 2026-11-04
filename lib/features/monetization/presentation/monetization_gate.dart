import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/ad_guard_provider.dart';
import '../application/ads_controller.dart';
import '../application/interstitial_controller.dart';
import '../application/remove_ads_controller.dart';

/// Arranque de la monetización, después del primer cuadro (no retrasa el
/// arranque en frío):
///
/// 1. Reverifica «Sin anuncios» con Play.
/// 2. Consentimiento UMP y, solo si lo permite, el SDK de anuncios. El
///    formulario no aparece con una sesión o un resumen abiertos: espera a
///    que la persona salga.
/// 3. Al volver a la app, si UMP todavía no respondió (sin red al abrir),
///    lo intenta de nuevo.
///
/// Todo es opcional: si algo falla, la app sigue igual y sin anuncios.
class MonetizationGate extends ConsumerStatefulWidget {
  const MonetizationGate({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<MonetizationGate> createState() => _MonetizationGateState();
}

class _MonetizationGateState extends ConsumerState<MonetizationGate> {
  late final AppLifecycleListener _lifecycle;
  var _verified = false;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _onResume);
    WidgetsBinding.instance.addPostFrameCallback((_) => _boot());
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  void _boot() {
    if (!mounted) return;
    if (!_verified) {
      _verified = true;
      unawaited(
        ref.read(removeAdsControllerProvider.notifier).verifyWithStore(),
      );
    }
    _startAds();
  }

  void _onResume() {
    if (!mounted) return;
    if (!ref.read(adsControllerProvider).consentChecked) _startAds();
  }

  void _startAds() {
    final free = ref.read(sessionFreeProvider);
    final ads = ref.read(adsControllerProvider);
    // Con una sesión abierta se piden solo los datos (sin formulario) y se
    // vuelve a intentar al quedar libre.
    if (ads.consentChecked && ads.sdkReady) return;
    unawaited(ref.read(adsControllerProvider.notifier).start(allowForm: free));
  }

  @override
  Widget build(BuildContext context) {
    // Precarga del intersticial (solo con el experimento activo).
    ref.watch(interstitialControllerProvider);
    ref.listen(sessionFreeProvider, (was, free) {
      final ads = ref.read(adsControllerProvider);
      if (free && was == false && !(ads.consentChecked && ads.sdkReady)) {
        _startAds();
      }
    });
    return widget.child;
  }
}
