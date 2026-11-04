import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/section_label.dart';
import '../../../core/widgets/tab_page.dart';
import '../../../core/widgets/tl_button.dart';
import '../../history/application/history_providers.dart';
import '../../intervals/domain/interval_templates.dart';
import '../../intervals/presentation/interval_widgets.dart';
import '../../settings/application/settings_controller.dart';
import '../../settings/domain/app_settings.dart';
import '../../strength/application/strength_session_controller.dart';
import '../../strength/application/strength_texts.dart';
import '../../strength/data/strength_session_repository.dart';
import '../../strength/presentation/strength_launcher.dart';

/// S01 Inicio: semana en curso (D6: sesiones frente al objetivo según el
/// inicio de semana de Configuración, minutos activos y racha; abre
/// Progreso), accesos a Entrenar, la sesión de
/// fuerza en curso, "repetir último" (D5) y plantillas rápidas. Tabata en 2
/// toques: la plantilla abre S03 y "Empezar" arranca.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(strengthSessionProvider);
    final last = ref.watch(lastStrengthSessionProvider).value;
    final l10n = context.l10n;
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
        if (!ref.watch(
          settingsControllerProvider.select((s) => s.localDataNoticeDismissed),
        ))
          const _LocalDataNotice(),
        SectionLabel(l10n.homeWeekOverline),
        _WeekCard(summary: ref.watch(weekSummaryProvider).value),
        if (active != null) ...[
          const SizedBox(height: TlSpace.s4),
          _SessionCard(
            key: const Key('home-active-strength'),
            overline: l10n.homeActiveSession,
            title: l10n.homeActiveStrength,
            highlighted: true,
            onTap: () => context.push(Routes.strength),
          ),
        ],
        const SizedBox(height: TlSpace.s6),
        TlButton(
          key: const Key('home-start-intervals'),
          label: l10n.homeStartIntervals,
          icon: Icons.timer_outlined,
          onPressed: () => context.go(Routes.train),
        ),
        const SizedBox(height: TlSpace.s3),
        TlButton(
          key: const Key('home-start-strength'),
          label: l10n.homeStartStrength,
          icon: Icons.fitness_center,
          variant: TlButtonVariant.secondary,
          onPressed: () => context.go(Routes.trainRoutines),
        ),
        if (last != null && active == null) ...[
          SectionLabel(l10n.homeRepeatLast),
          _SessionCard(
            key: const Key('home-repeat-last'),
            title: sessionTitle(
              l10n,
              StrengthSessionRepository.titleOf(last),
            ).toUpperCase(),
            subtitle: l10n.homeRepeatMeta(
              DateFormat.MMMd(
                context.locale.toLanguageTag(),
              ).format(last.startedAt.toLocal()),
            ),
            onTap: () =>
                startStrengthSession(context, ref, const StartRepeatLast()),
          ),
        ],
        SectionLabel(l10n.homeQuickTemplates),
        const TemplateGrid(IntervalTemplate.quickStart),
      ],
    );
  }
}

/// Aviso de una línea de F-01: los datos viven solo en el teléfono. Tocarlo
/// abre S17; la X lo cierra para siempre.
class _LocalDataNotice extends ConsumerWidget {
  const _LocalDataNotice();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    return Padding(
      padding: const EdgeInsets.only(top: TlSpace.s2),
      child: Material(
        key: const Key('home-local-data'),
        color: c.surface1,
        borderRadius: BorderRadius.circular(TlRadius.md),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                key: const Key('home-local-data-open'),
                onTap: () => context.push(Routes.backup),
                child: Container(
                  constraints: const BoxConstraints(minHeight: TlSize.touchMin),
                  padding: const EdgeInsets.fromLTRB(
                    TlSpace.s3,
                    TlSpace.s2,
                    0,
                    TlSpace.s2,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Icon(Icons.smartphone, size: 20, color: c.warning),
                      const SizedBox(width: TlSpace.s2),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: l10n.homeLocalDataNotice),
                              const TextSpan(text: ' '),
                              TextSpan(
                                text: l10n.homeLocalDataAction,
                                style: TextStyle(
                                  color: c.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          style: t.bodySm,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              key: const Key('home-local-data-dismiss'),
              tooltip: l10n.homeLocalDataDismiss,
              icon: Icon(Icons.close, color: c.inkMuted),
              onPressed: () => ref
                  .read(settingsControllerProvider.notifier)
                  .dismissLocalDataNotice(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tarjeta de la semana (Main): «2/4 sesiones de tu objetivo», la barra,
/// minutos activos y racha. Toda la tarjeta abre Progreso.
class _WeekCard extends StatelessWidget {
  const _WeekCard({required this.summary});

  final WeekSummary? summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final s = summary;
    final done = s?.week.sessions ?? 0;
    final goal = s?.goal ?? AppSettings.defaultWeeklyGoal;
    return Material(
      color: c.surface1,
      borderRadius: BorderRadius.circular(TlRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: const Key('home-week'),
        onTap: () => context.go(Routes.progress),
        child: Padding(
          padding: const EdgeInsets.all(TlSpace.s4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text.rich(
                    TextSpan(
                      text: l10n.numberValue(done),
                      children: [
                        TextSpan(
                          text: l10n.progressGoalSuffix(goal),
                          style: t.title.copyWith(color: c.inkMuted),
                        ),
                      ],
                    ),
                    key: const Key('home-week-count'),
                    style: t.displayXl.copyWith(fontSize: 44, height: 1),
                  ),
                  const SizedBox(width: TlSpace.s2),
                  Expanded(
                    child: Text(
                      l10n.homeWeekSessions,
                      style: t.bodySm.copyWith(color: c.inkMuted),
                    ),
                  ),
                  const SizedBox(width: TlSpace.s2),
                  // Con letra grande se achica en vez de partir la palabra.
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        l10n.homeSeeProgress,
                        textAlign: TextAlign.end,
                        style: t.overline.copyWith(color: c.accent),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TlSpace.s3),
              Semantics(
                label: l10n.homeWeekProgressLabel(done, goal),
                child: _GoalBar(done: done, goal: goal),
              ),
              const SizedBox(height: TlSpace.s3),
              if (done == 0)
                Text(
                  l10n.homeWeekEmptyBody,
                  style: t.bodySm.copyWith(color: c.inkMuted),
                )
              else
                Text(
                  l10n.summaryJoin(
                    l10n.homeWeekMinutes(s?.week.activeMinutes ?? 0),
                    l10n.homeWeekStreak(s?.streak ?? 0),
                  ),
                  key: const Key('home-week-meta'),
                  style: t.bodySm,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Barra segmentada del objetivo semanal.
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

/// Tarjeta con ▶: la sesión en curso o la última para repetir.
class _SessionCard extends StatelessWidget {
  const _SessionCard({
    required this.title,
    required this.onTap,
    this.overline,
    this.subtitle,
    this.highlighted = false,
    super.key,
  });

  final String title;
  final String? overline;
  final String? subtitle;
  final bool highlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Material(
      color: highlighted ? c.accentSoft : c.surface1,
      borderRadius: BorderRadius.circular(TlRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(TlSpace.s4),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (overline != null)
                      Text(
                        overline!,
                        style: t.overline.copyWith(color: c.accent),
                      ),
                    Text(title, style: t.title),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: t.bodySm.copyWith(color: c.inkMuted),
                      ),
                  ],
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: c.primaryBg,
                  borderRadius: BorderRadius.circular(TlRadius.md),
                ),
                child: Icon(Icons.play_arrow, color: c.primaryInk),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
