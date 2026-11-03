import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/section_label.dart';
import '../../../core/widgets/tab_page.dart';
import '../../../core/widgets/tl_button.dart';
import '../../intervals/domain/interval_templates.dart';
import '../../intervals/presentation/interval_widgets.dart';

/// S01 Inicio: semana (vacía hasta D6), accesos a Entrenar y plantillas
/// rápidas. Tabata en 2 toques: la plantilla abre S03 y "Empezar" arranca.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    return TabPage(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: TlSpace.s3),
          child: Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(l10n.logoWordmark, style: t.logo),
                ),
              ),
              IconButton(
                key: const Key('open-settings'),
                tooltip: l10n.settingsTooltip,
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => context.push(Routes.settings),
              ),
            ],
          ),
        ),
        SectionLabel(l10n.homeWeekOverline),
        Container(
          padding: const EdgeInsets.all(TlSpace.s4),
          decoration: BoxDecoration(
            color: c.surface1,
            borderRadius: BorderRadius.circular(TlRadius.lg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.homeWeekEmptyTitle, style: t.title),
              const SizedBox(height: TlSpace.s2),
              Text(
                l10n.homeWeekEmptyBody,
                style: t.bodySm.copyWith(color: c.inkMuted),
              ),
              const SizedBox(height: TlSpace.s4),
              const _GoalBar(done: 0, goal: 4),
            ],
          ),
        ),
        const SizedBox(height: TlSpace.s6),
        TlButton(
          key: const Key('home-start-intervals'),
          label: l10n.homeStartIntervals,
          icon: Icons.timer_outlined,
          onPressed: () => context.go(Routes.train),
        ),
        const SizedBox(height: TlSpace.s3),
        TlButton(
          label: l10n.homeStartStrength,
          icon: Icons.fitness_center,
          variant: TlButtonVariant.secondary,
          onPressed: () => context.go(Routes.train),
        ),
        SectionLabel(l10n.homeQuickTemplates),
        const TemplateGrid(IntervalTemplate.quickStart),
      ],
    );
  }
}

/// Barra segmentada del objetivo semanal (decorativa en D1).
class _GoalBar extends StatelessWidget {
  const _GoalBar({required this.done, required this.goal});

  final int done;
  final int goal;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ExcludeSemantics(
      child: Row(
        children: [
          for (var i = 0; i < goal; i++) ...[
            if (i > 0) const SizedBox(width: TlSpace.s1),
            Expanded(
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: i < done ? c.accent : c.barOff,
                  borderRadius: BorderRadius.circular(TlRadius.sm),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
