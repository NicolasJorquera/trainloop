import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/section_label.dart';
import '../../../core/widgets/tl_button.dart';
import '../../../core/widgets/tl_segmented_control.dart';
import '../../../data/db/database_providers.dart';
import '../../../data/db/demo_seed.dart';
import '../application/settings_controller.dart';
import '../domain/app_settings.dart';

/// Filas por tabla de la base local.
final dbRowCountsProvider = FutureProvider.autoDispose<Map<String, int>>(
  (ref) => ref.watch(appDatabaseProvider).rowCounts(),
);

/// Sección solo de depuración en Configuración: conteos de la base y un
/// botón para sembrar datos, para comprobar que persisten tras reiniciar.
class DebugDatabaseSection extends ConsumerWidget {
  const DebugDatabaseSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.colors;
    final counts = ref.watch(dbRowCountsProvider).value;
    int n(String table) => counts?[table] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionLabel(l10n.debugDatabaseSection),
        Text(
          l10n.debugDatabaseCounts(
            n('exercise'),
            n('strength_routine'),
            n('interval_workout'),
            n('session'),
            n('set_log'),
          ),
          key: const Key('debug-db-counts'),
          style: context.text.body,
        ),
        const SizedBox(height: TlSpace.s2),
        Text(
          l10n.debugDatabaseHelp,
          style: context.text.bodySm.copyWith(color: c.inkMuted),
        ),
        const SizedBox(height: TlSpace.s3),
        SectionLabel(l10n.debugWeekVariant),
        Text(
          l10n.debugWeekVariantHelp,
          style: context.text.bodySm.copyWith(color: c.inkMuted),
        ),
        const SizedBox(height: TlSpace.s2),
        TlSegmentedControl<WeekVariant>(
          key: const Key('debug-week-variant'),
          semanticLabel: l10n.debugWeekVariant,
          selected: ref.watch(settingsControllerProvider).weekVariant,
          onChanged: ref
              .read(settingsControllerProvider.notifier)
              .setWeekVariant,
          segments: [
            TlSegment(WeekVariant.unified, l10n.weekVariantUnified),
            TlSegment(WeekVariant.separate, l10n.weekVariantSeparate),
          ],
        ),
        const SizedBox(height: TlSpace.s4),
        TlButton(
          key: const Key('debug-db-seed'),
          label: l10n.debugSeedDemo,
          variant: TlButtonVariant.secondary,
          onPressed: () async {
            await seedDemoData(ref.read(appDatabaseProvider));
            ref.invalidate(dbRowCountsProvider);
          },
        ),
      ],
    );
  }
}
