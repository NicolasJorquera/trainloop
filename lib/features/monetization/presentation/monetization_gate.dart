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
/// 2. Consentimiento UMP y, solo si lo permite, el SDK de anuncios. Nada
///    de esto ocurre con una sesión o un resumen abiertos (ni antes de
///    saber si al abrir había una sesión viva): espera a que queden libres.
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

  /// UMP y el SDK solo sin sesión ni resumen abiertos (y después de saber
  /// si al abrir había una sesión viva): si no, espera a que quede libre.
  void _startAds() {
    final ads = ref.read(adsControllerProvider);
    if (ads.consentChecked && ads.sdkReady) return;
    if (!ref.read(sessionFreeProvider)) return;
    unawaited(ref.read(adsControllerProvider.notifier).start(allowForm: true));
  }

  @override
  Widget build(BuildContext context) {
    // Precarga del intersticial (solo con el experimento activo).
    ref.watch(interstitialControllerProvider);
    ref.listen(sessionFreeProvider, (was, free) {
      if (free && was == false) _startAds();
    });
    return widget.child;
  }
}
