import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/tl_button.dart';
import '../../settings/application/settings_controller.dart';
import '../application/ads_controller.dart';
import '../application/remove_ads_controller.dart';

/// Filas de DATOS Y PRIVACIDAD de S16 (D8): el interruptor de analítica y
/// «Preferencias de privacidad» (solo cuando UMP lo pide).
class PrivacySettingsRows extends ConsumerWidget {
  const PrivacySettingsRows({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final analytics = ref.watch(
      settingsControllerProvider.select((s) => s.analytics),
    );
    final privacyOptions = ref.watch(
      adsControllerProvider.select((s) => s.consent.privacyOptionsRequired),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          key: const Key('settings-analytics'),
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.settingsAnalytics, style: t.body),
          subtitle: Text(
            l10n.settingsAnalyticsHelp,
            style: t.bodySm.copyWith(color: c.inkMuted),
          ),
          value: analytics,
          onChanged: ref.read(settingsControllerProvider.notifier).setAnalytics,
        ),
        if (privacyOptions)
          MergeSemantics(
            child: Semantics(
              button: true,
              child: InkWell(
                key: const Key('settings-privacy-options'),
                onTap: () => unawaited(
                  ref.read(adsControllerProvider.notifier).showPrivacyOptions(),
                ),
                child: Container(
                  constraints: const BoxConstraints(minHeight: TlSize.touchMin),
                  padding: const EdgeInsets.symmetric(vertical: TlSpace.s3),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: c.line)),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: TlSpace.s2,
                    children: [
                      Text(l10n.settingsPrivacyOptions, style: t.body),
                      Text(
                        l10n.settingsPrivacyOptionsMeta,
                        style: t.button.copyWith(color: c.accent),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Tarjeta «QUITAR ANUNCIOS · PAGO ÚNICO» de S16 (F-15c): comprar con el
/// precio de Play, restaurar y el estado de la compra.
class RemoveAdsCard extends ConsumerStatefulWidget {
  const RemoveAdsCard({super.key});

  @override
  ConsumerState<RemoveAdsCard> createState() => _RemoveAdsCardState();
}

class _RemoveAdsCardState extends ConsumerState<RemoveAdsCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(ref.read(removeAdsControllerProvider.notifier).loadProduct());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final s = ref.watch(removeAdsControllerProvider);
    final controller = ref.read(removeAdsControllerProvider.notifier);
    final owned = s.owned ?? false;
    final busy = s.flow == PurchaseFlow.busy;
    final status = switch (s.flow) {
      _ when owned && s.flow == PurchaseFlow.restored => l10n.removeAdsRestored,
      _ when owned => l10n.removeAdsOwned,
      PurchaseFlow.pending => l10n.removeAdsPending,
      PurchaseFlow.canceled => l10n.removeAdsCanceled,
      PurchaseFlow.error => l10n.removeAdsError,
      PurchaseFlow.unavailable => l10n.removeAdsUnavailable,
      PurchaseFlow.nothingToRestore => l10n.removeAdsNothing,
      _ => null,
    };
    final price = s.price;
    return Container(
      key: const Key('remove-ads-card'),
      padding: const EdgeInsets.all(TlSpace.s3 + 2),
      decoration: BoxDecoration(
        color: c.accentSoft,
        borderRadius: BorderRadius.circular(TlRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.removeAdsTitle,
            style: t.headline.copyWith(color: c.accent),
          ),
          const SizedBox(height: TlSpace.s1),
          Text(l10n.removeAdsBody, style: t.bodySm.copyWith(color: c.ink)),
          if (status != null) ...[
            const SizedBox(height: TlSpace.s2),
            Semantics(
              liveRegion: true,
              child: Text(
                status,
                key: const Key('remove-ads-status'),
                style: t.body.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
          if (!owned) ...[
            const SizedBox(height: TlSpace.s3),
            TlButton(
              key: const Key('remove-ads-buy'),
              label: price == null
                  ? l10n.removeAdsBuyNoPrice
                  : l10n.removeAdsBuy(price),
              onPressed: busy || s.flow == PurchaseFlow.pending
                  ? null
                  : () => unawaited(controller.buy()),
            ),
            TlButton(
              key: const Key('remove-ads-restore'),
              label: l10n.removeAdsRestore,
              variant: TlButtonVariant.text,
              onPressed: busy ? null : () => unawaited(controller.restore()),
            ),
          ],
        ],
      ),
    );
  }
}
