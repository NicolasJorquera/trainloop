import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/tokens.dart';
import '../application/ad_guard_provider.dart';
import '../application/ads_controller.dart';
import '../data/ads_platform.dart';

/// Banner adaptativo anclado (F-15a, diseño de Main): sobre la barra
/// inferior de las pestañas o al pie de la biblioteca.
///
/// * Lo decide el guard central ([bannerDecisionProvider]): con una sesión,
///   su resumen, un paso crítico o en otra pantalla, el banner se **desmonta
///   y se descarta** (no queda un anuncio vivo debajo de S05/S10).
/// * No reserva espacio: hasta que carga mide 0 y aparece con una animación
///   corta; si no carga o no hay red, no hay hueco (R-A4).
/// * Separado de los botones por un margen y oculto con el teclado (R-A6).
class AdBanner extends ConsumerWidget {
  const AdBanner({required this.placement, super.key});

  final BannerPlacement placement;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allowed = ref.watch(bannerDecisionProvider(placement)).allowed;
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      alignment: Alignment.bottomCenter,
      child: allowed
          ? _LoadedBannerSlot(key: ValueKey(placement), placement: placement)
          : const SizedBox(width: double.infinity),
    );
  }
}

class _LoadedBannerSlot extends ConsumerStatefulWidget {
  const _LoadedBannerSlot({required this.placement, super.key});

  final BannerPlacement placement;

  @override
  ConsumerState<_LoadedBannerSlot> createState() => _LoadedBannerSlotState();
}

class _LoadedBannerSlotState extends ConsumerState<_LoadedBannerSlot> {
  /// Esperas entre reintentos mientras el banner no carga (sin red o sin
  /// anuncio que dar). Sin escuchar la conectividad (pediría otro paquete):
  /// cuando vuelve la red, el banner aparece en el siguiente intento.
  static const retryDelays = [
    Duration(seconds: 30),
    Duration(minutes: 1),
    Duration(minutes: 2),
    Duration(minutes: 5),
  ];

  LoadedBanner? _banner;
  int? _width;
  bool _loading = false;
  Timer? _retry;
  int _failures = 0;
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // Al volver a la app se reintenta en el acto; en segundo plano, no.
    _lifecycle = AppLifecycleListener(
      onResume: _retryNow,
      onHide: () => _retry?.cancel(),
    );
  }

  void _retryNow() {
    final width = _width;
    if (mounted && _banner == null && width != null) {
      _load(width, MediaQuery.orientationOf(context));
    }
  }

  void _scheduleRetry() {
    _retry?.cancel();
    final delay = retryDelays[_failures.clamp(0, retryDelays.length - 1)];
    _failures++;
    _retry = Timer(delay, _retryNow);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final width = MediaQuery.sizeOf(context).width.truncate() - 2 * 16;
    if (width != _width && width > 0) {
      _width = width;
      _load(width, MediaQuery.orientationOf(context));
    }
  }

  Future<void> _load(int width, Orientation orientation) async {
    if (_loading) return;
    _retry?.cancel();
    _loading = true;
    LoadedBanner? banner;
    try {
      banner = await ref
          .read(adsPlatformProvider)
          .loadBanner(width: width, orientation: orientation);
    } catch (_) {
      banner = null;
    } finally {
      _loading = false;
    }
    if (!mounted) {
      banner?.dispose();
      return;
    }
    setState(() {
      _banner?.dispose();
      _banner = banner;
    });
    if (banner == null) {
      _scheduleRetry();
    } else {
      _failures = 0;
    }
  }

  @override
  void dispose() {
    _retry?.cancel();
    _lifecycle.dispose();
    _banner?.dispose();
    _banner = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banner = _banner;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom > 0;
    if (banner == null) return const SizedBox(width: double.infinity);
    return Visibility(
      visible: !keyboard,
      maintainState: true,
      child: Semantics(
        container: true,
        label: context.l10n.adBannerLabel,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: TlSpace.s4,
            vertical: TlSpace.s2,
          ),
          child: SizedBox(
            key: const Key('ad-banner'),
            width: banner.size.width,
            height: banner.size.height,
            child: banner.build(),
          ),
        ),
      ),
    );
  }
}
