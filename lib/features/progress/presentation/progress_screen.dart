import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/section_label.dart';
import '../../../core/widgets/tab_page.dart';
import '../../../data/db/app_database.dart';
import '../../exercises/domain/exercise_names.dart';
import '../../history/application/history_providers.dart';
import '../../history/application/history_texts.dart';
import '../../history/domain/week.dart';
import '../../history/presentation/history_widgets.dart';
import '../../settings/application/settings_controller.dart';
import '../../strength/application/strength_texts.dart';
import '../../strength/domain/strength_rules.dart';
import '../application/progress_providers.dart';
import '../data/progress_repository.dart';
import 'charts.dart';

/// S14 Progreso (J4, alcance v0.2): la semana en curso (sesiones frente al
/// objetivo, minutos activos, racha y volumen), sesiones por semana de las
/// últimas 8 semanas con el objetivo, y la última marca por ejercicio e
/// intervalos. Tocar una barra muestra sus sesiones (R-P7).
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final settings = ref.watch(settingsControllerProvider);
    final entries = ref.watch(historyEntriesProvider).value ?? const [];
    final summary = ref.watch(weekSummaryProvider).value;
    final today = civilToday(ref.watch(clockProvider)());
    final weeks = lastWeeks(entries, today: today, start: settings.weekStart);
    final marks = ref.watch(exerciseProgressListProvider).value ?? const [];
    final records = ref.watch(allRecordsProvider).value ?? const [];
    final locale = context.locale;
    final unit = settings.weightUnit;
    final average = weeks.isEmpty
        ? 0.0
        : weeks.fold(0, (s, w) => s + w.sessions) / weeks.length;

    // Última sesión de cada entrenamiento de intervalos (la lista viene de
    // la más reciente a la más antigua).
    final intervalMarks = <String, HistoryEntry>{};
    for (final e in entries) {
      if (e.isStrength) continue;
      intervalMarks.putIfAbsent(
        e.session.templateId ?? e.title ?? e.id,
        () => e,
      );
    }

    return TabPage(
      children: [
        TabHeader(title: l10n.progressTitle),
        SectionLabel(l10n.homeWeekOverline),
        if (summary != null) ...[
          Row(
            children: [
              StatBox(
                label: l10n.progressSessions,
                value: l10n.numberValue(summary.week.sessions),
                suffix: l10n.progressGoalSuffix(summary.goal),
                valueKey: const Key('progress-sessions'),
              ),
              const SizedBox(width: TlSpace.s2),
              StatBox(
                label: l10n.progressMinutes,
                value: l10n.numberValue(summary.week.activeMinutes),
                valueKey: const Key('progress-minutes'),
              ),
              const SizedBox(width: TlSpace.s2),
              StatBox(
                label: l10n.progressStreak,
                value: l10n.numberValue(summary.streak),
                valueKey: const Key('progress-streak'),
              ),
            ],
          ),
          const SizedBox(height: TlSpace.s2),
          Text(
            l10n.progressWeekVolume(
              volumeText(l10n, summary.week.volumeGrams, unit),
            ),
            key: const Key('progress-volume'),
            style: t.bodySm.copyWith(color: c.inkMuted),
          ),
        ],
        SectionLabel(l10n.progressChartTitle),
        Text(
          l10n.progressChartSub(
            l10n.decimalText(l10n.decimal(round1(average))),
            settings.weeklyGoal,
          ),
          key: const Key('progress-average'),
          style: t.bodySm.copyWith(color: c.inkMuted),
        ),
        const SizedBox(height: TlSpace.s3),
        WeeklyBars(
          values: [for (final w in weeks) w.sessions],
          labels: [
            for (final (i, w) in weeks.indexed)
              i == weeks.length - 1
                  ? l10n.progressThisWeekShort
                  : l10n.historyDayName(dayMonth(locale, w.start)),
          ],
          goal: settings.weeklyGoal,
          goalLabel: l10n.progressGoalLine,
          valueText: l10n.numberValue,
          semanticsOf: (i) => l10n.progressBarLabel(
            dayMonth(locale, weeks[i].start),
            weeks[i].sessions,
          ),
          onTap: (i) => _showWeek(context, weeks[i]),
        ),
        const SizedBox(height: TlSpace.s2),
        Text(
          l10n.progressChartNote,
          style: t.caption.copyWith(color: c.inkMuted),
        ),
        SectionLabel(l10n.progressLastMarks),
        if (marks.isEmpty && intervalMarks.isEmpty)
          EmptyState(
            icon: Icons.show_chart,
            title: l10n.progressEmptyTitle,
            body: l10n.progressEmptyBody,
          ),
        for (final p in marks)
          if (p.last?.bestSet != null)
            _MarkTile(
              key: Key('mark-${p.exercise.catalogKey ?? p.exercise.id}'),
              title: exerciseName(p.exercise, locale).toUpperCase(),
              meta: l10n.summaryJoin(
                setValuesText(
                      l10n,
                      p.exercise.logType,
                      SetValues.ofLog(p.last!.bestSet!),
                      unit,
                    ) ??
                    l10n.strengthNoValue,
                shortDate(locale, sessionDay(p.last!.session)),
              ),
              badge: _badge(l10n, p, records),
              highlight: _isRecord(p, records),
              onTap: () => context.push(Routes.exerciseProgress(p.exercise.id)),
            ),
        for (final e in intervalMarks.values)
          _MarkTile(
            key: Key('mark-session-${e.id}'),
            title: entryTitle(l10n, e).toUpperCase(),
            meta: l10n.summaryJoin(
              l10n.progressIntervalMark(
                l10n.historyRounds(e.roundsDone, e.roundsPlanned),
                l10n.duration(e.workSeconds),
              ),
              shortDate(locale, e.day),
            ),
            badge: e.incomplete
                ? l10n.historyIncomplete
                : l10n.progressComplete,
            highlight: false,
            onTap: () => context.push(Routes.sessionDetail(e.id)),
          ),
      ],
    );
  }

  static bool _isRecord(ExerciseProgress p, List<PersonalRecord> records) =>
      records.any(
        (r) =>
            r.exerciseId == p.exercise.id &&
            r.sessionId == p.last?.session.id &&
            r.previousValue != null,
      );

  static String? _badge(
    AppLocalizations l10n,
    ExerciseProgress p,
    List<PersonalRecord> records,
  ) {
    if (_isRecord(p, records)) return l10n.progressRecordBadge;
    if (p.sameAsPrevious) return l10n.progressSameBadge;
    return null;
  }

  void _showWeek(BuildContext context, WeekStats week) {
    final l10n = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.colors.surface1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TlRadius.sheet),
        ),
      ),
      builder: (context) => ListView(
        key: const Key('week-sessions-sheet'),
        shrinkWrap: true,
        padding: const EdgeInsets.all(TlSpace.s4),
        children: [
          Text(
            l10n.historyWeekGroup(
              l10n.historyWeekOf(
                dayMonth(context.locale, week.start).toUpperCase(),
              ),
              week.sessions,
              week.activeMinutes,
            ),
            style: context.text.overline,
          ),
          const SizedBox(height: TlSpace.s3),
          if (week.entries.isEmpty)
            Text(l10n.historyDayEmpty, style: context.text.body),
          for (final e in week.entries.reversed) ...[
            EntryTile(e),
            const SizedBox(height: TlSpace.s2),
          ],
        ],
      ),
    );
  }
}

class _MarkTile extends StatelessWidget {
  const _MarkTile({
    required this.title,
    required this.meta,
    required this.badge,
    required this.highlight,
    required this.onTap,
    super.key,
  });

  final String title;
  final String meta;
  final String? badge;
  final bool highlight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Padding(
      padding: const EdgeInsets.only(bottom: TlSpace.s2),
      child: Material(
        color: c.surface1,
        borderRadius: BorderRadius.circular(TlRadius.lg),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(TlSpace.s3),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: t.title),
                      Text(meta, style: t.bodySm.copyWith(color: c.inkMuted)),
                    ],
                  ),
                ),
                if (badge != null)
                  Text(
                    badge!,
                    style: t.overline.copyWith(
                      color: highlight ? c.accent : c.inkMuted,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
