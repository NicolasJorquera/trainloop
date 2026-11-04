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
  LoadedBanner? _banner;
  int? _width;
  bool _loading = false;

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
  }

  @override
  void dispose() {
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
