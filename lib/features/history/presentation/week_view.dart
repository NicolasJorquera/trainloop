import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/section_label.dart';
import '../../../data/db/enums.dart';
import '../../settings/application/settings_controller.dart';
import '../../settings/domain/app_settings.dart';
import '../application/history_providers.dart';
import '../application/history_texts.dart';
import '../domain/week.dart';
import 'history_widgets.dart';
import 'plan_day_sheet.dart';

/// Vista semanal (F-11): la semana en curso con fuerza, intervalos,
/// descanso y planificado. Dos variantes para la prueba H5 según
/// [AppSettings.weekVariant]: unificada (un día por fila) o separada (un
/// bloque por tipo).
class WeekView extends ConsumerWidget {
  const WeekView({required this.entries, super.key});

  final List<HistoryEntry> entries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsControllerProvider);
    final today = civilToday(ref.watch(clockProvider)());
    final plan = ref.watch(weekPlanProvider).value ?? const [];
    final week = statsForWeek(entries, weekStartOf(today, settings.weekStart));
    final days = weekPlan(week: week, plan: plan, today: today);
    final unified = settings.weekVariant == WeekVariant.unified;
    return Column(
      key: Key(unified ? 'week-unified' : 'week-separate'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.historyWeekHead(week.sessions, settings.weeklyGoal),
          key: const Key('week-head'),
          style: context.text.title,
        ),
        const SizedBox(height: TlSpace.s3),
        if (unified)
          ..._unified(context, days)
        else
          ..._separate(context, days),
      ],
    );
  }

  List<Widget> _unified(BuildContext context, List<WeekDayPlan> days) {
    final l10n = context.l10n;
    final c = context.colors;
    return [
      for (final d in days) _DayRow(day: d),
      const SizedBox(height: TlSpace.s3),
      Text(
        l10n.historyWeekLegend,
        style: context.text.caption.copyWith(color: c.inkMuted),
      ),
    ];
  }

  List<Widget> _separate(BuildContext context, List<WeekDayPlan> days) => [
    for (final kind in [SessionKind.strength, SessionKind.intervals])
      _KindBlock(kind: kind, week: kindWeek(days, kind)),
  ];
}

/// Un día de la vista unificada.
class _DayRow extends ConsumerWidget {
  const _DayRow({required this.day});

  final WeekDayPlan day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final unit = ref.watch(settingsControllerProvider).weightUnit;
    final locale = context.locale;
    final lines =
        <
          ({
            SessionKind? kind,
            BadgeStyle style,
            String title,
            String meta,
            String? id,
          })
        >[
          for (final e in day.entries)
            (
              kind: e.kind,
              style: BadgeStyle.filled,
              title: entryTitle(l10n, e),
              meta: l10n.summaryJoin(
                e.incomplete
                    ? l10n.historyStateIncomplete
                    : l10n.historyStateDone,
                entryFacts(l10n, e, unit, withState: false),
              ),
              id: e.id,
            ),
          if (day.state == DayState.planned)
            for (final p in day.planned)
              (
                kind: p.kind,
                style: BadgeStyle.outline,
                title: plannedName(l10n, p),
                meta: l10n.historyStatePlanned,
                id: null,
              ),
          if (day.state == DayState.rest)
            (
              kind: null,
              style: BadgeStyle.dotted,
              title: l10n.historyDayRest,
              meta: '',
              id: null,
            ),
          if (day.state == DayState.free)
            (
              kind: null,
              style: BadgeStyle.dotted,
              title: l10n.historyDayFree,
              meta: '',
              id: null,
            ),
        ];
    final canPlan = !day.isPast;
    return Container(
      key: Key('week-day-${day.day.weekday}'),
      margin: const EdgeInsets.only(bottom: TlSpace.s2),
      decoration: BoxDecoration(
        color: day.isToday ? c.accentSoft : c.surface1,
        borderRadius: BorderRadius.circular(TlRadius.lg),
      ),
      child: Column(
        children: [
          for (final (i, line) in lines.indexed)
            InkWell(
              borderRadius: BorderRadius.circular(TlRadius.lg),
              onTap: line.id != null
                  ? () => context.push(Routes.sessionDetail(line.id!))
                  : canPlan
                  ? () => showPlanDaySheet(context, ref, day.day.weekday)
                  : null,
              child: Container(
                // NF-08: 48 dp de área táctil.
                constraints: const BoxConstraints(minHeight: TlSize.touchMin),
                padding: const EdgeInsets.symmetric(
                  horizontal: TlSpace.s3,
                  vertical: TlSpace.s2,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 44,
                      child: i == 0
                          ? Text(
                              l10n.historyDayName(
                                weekdayShort(locale, day.day),
                              ),
                              style: t.button.copyWith(fontSize: 16),
                            )
                          : null,
                    ),
                    KindBadge(kind: line.kind, style: line.style, size: 28),
                    const SizedBox(width: TlSpace.s3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            line.title,
                            style: t.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: line.kind == null ? c.inkMuted : c.ink,
                            ),
                          ),
                          if (line.meta.isNotEmpty)
                            Text(
                              line.meta,
                              style: t.bodySm.copyWith(color: c.inkMuted),
                            ),
                        ],
                      ),
                    ),
                    if (line.id == null && canPlan)
                      Icon(
                        Icons.edit_calendar_outlined,
                        color: c.inkMuted,
                        size: 20,
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Bloque de un tipo en la vista separada: «FUERZA · 1 DE 2», hechas (✓) y
/// planificadas pendientes (○).
class _KindBlock extends ConsumerWidget {
  const _KindBlock({required this.kind, required this.week});

  final SessionKind kind;
  final KindWeek week;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final locale = context.locale;
    final strength = kind == SessionKind.strength;
    final color = kindColor(context, kind);
    return Container(
      key: Key('week-block-${kind.name}'),
      margin: const EdgeInsets.only(bottom: TlSpace.s3),
      padding: const EdgeInsets.all(TlSpace.s4),
      decoration: BoxDecoration(
        color: c.surface1,
        borderRadius: BorderRadius.circular(TlRadius.lg),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strength
                ? l10n.historyBlockStrength(week.done.length, week.total)
                : l10n.historyBlockIntervals(week.done.length, week.total),
            style: t.overline.copyWith(color: color),
          ),
          const SizedBox(height: TlSpace.s2),
          if (week.total == 0)
            Text(
              l10n.historyBlockEmpty,
              style: t.bodySm.copyWith(color: c.inkMuted),
            ),
          for (final e in week.done)
            InkWell(
              onTap: () => context.push(Routes.sessionDetail(e.id)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: TlSpace.s1),
                child: Text(
                  l10n.historyBlockDone(
                    capitalize(weekdayShort(locale, e.day).toLowerCase()),
                    entryTitle(l10n, e),
                    l10n.historyMinutes((e.activeSeconds / 60).round()),
                  ),
                  style: t.body,
                ),
              ),
            ),
          for (final (day, p) in week.pending)
            InkWell(
              onTap: () => showPlanDaySheet(context, ref, day.weekday),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: TlSpace.s1),
                child: Text(
                  l10n.historyBlockPlanned(
                    capitalize(weekdayShort(locale, day).toLowerCase()),
                    plannedName(l10n, p),
                  ),
                  style: t.body.copyWith(color: c.inkMuted),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Encabezado de una semana de la lista: «ESTA SEMANA · 2 SESIONES · 71 MIN».
class WeekListHeader extends StatelessWidget {
  const WeekListHeader({
    required this.week,
    required this.currentWeek,
    super.key,
  });

  final WeekStats week;
  final DateTime currentWeek;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SectionLabel(
      l10n.historyWeekGroup(
        weekLabel(l10n, context.locale, week.start, currentWeek),
        week.sessions,
        week.activeMinutes,
      ),
    );
  }
}
