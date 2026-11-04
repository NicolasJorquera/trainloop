import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/units/weight_unit.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/section_label.dart';
import '../../../core/widgets/tab_page.dart';
import '../../../core/widgets/tl_chip.dart';
import '../../../data/db/enums.dart';
import '../../exercises/domain/exercise_names.dart';
import '../../exercises/presentation/exercise_labels.dart';
import '../../history/application/history_providers.dart';
import '../../history/application/history_texts.dart';
import '../../history/data/records_repository.dart';
import '../../history/domain/week.dart';
import '../../settings/application/settings_controller.dart';
import '../../strength/application/strength_texts.dart';
import '../../strength/domain/strength_rules.dart';
import '../application/progress_providers.dart';
import '../data/progress_repository.dart';
import 'charts.dart';

/// Rango del gráfico (R-P5): 12 semanas por defecto.
enum ChartRange {
  weeks4(28),
  weeks12(84),
  months6(183),
  year1(365),
  all(null);

  const ChartRange(this.days);

  final int? days;
}

/// S15 Detalle de ejercicio (J4): última marca con su 1RM estimado,
/// tendencia simple del 1RM estimado por sesión (CustomPaint), récords
/// (R-P3) y las sesiones con sus series (cada una abre S13).
class ExerciseDetailScreen extends ConsumerStatefulWidget {
  const ExerciseDetailScreen({required this.exerciseId, super.key});

  final String exerciseId;

  @override
  ConsumerState<ExerciseDetailScreen> createState() =>
      _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends ConsumerState<ExerciseDetailScreen> {
  var _range = ChartRange.weeks12;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final p = ref.watch(exerciseProgressProvider(widget.exerciseId)).value;
    final records = [
      ...?ref.watch(exerciseRecordsProvider(widget.exerciseId)).value,
    ]..sort(compareRecords);
    final unit = ref.watch(settingsControllerProvider).weightUnit;
    final locale = context.locale;
    final back = IconButton(
      key: const Key('exercise-back'),
      tooltip: l10n.backTooltip,
      icon: const Icon(Icons.arrow_back),
      onPressed: () =>
          context.canPop() ? context.pop() : context.go(Routes.progress),
    );
    if (p == null) {
      return Scaffold(
        body: TabPage(
          children: [ScreenHeader(title: '', leading: back)],
        ),
      );
    }
    final e = p.exercise;
    final type = e.logType;
    final last = p.last;
    final best = last?.bestSet;
    final equipment = e.equipment;
    final sub = equipment == null
        ? l10n.muscle(e.primaryMuscle)
        : l10n.summaryJoin(
            l10n.muscle(e.primaryMuscle),
            l10n.equipment(equipment),
          );

    final today = civilToday(ref.watch(clockProvider)());
    final from = _range.days == null
        ? null
        : today.subtract(Duration(days: _range.days!));
    final points = <(double, double)>[
      for (final s in p.sessions)
        if (s.bestOneRmGrams != null &&
            (from == null || !sessionDay(s.session).isBefore(from)))
          (
            s.session.startedAt.millisecondsSinceEpoch.toDouble(),
            s.bestOneRmGrams!,
          ),
    ];

    return Scaffold(
      body: TabPage(
        children: [
          ScreenHeader(
            title: exerciseName(e, locale).toUpperCase(),
            leading: back,
          ),
          Text(sub, style: t.bodySm.copyWith(color: c.inkMuted)),
          SectionLabel(l10n.exerciseLastMark),
          if (best == null)
            Text(l10n.exerciseNoHistory, style: t.body)
          else ...[
            Text(
              (setValuesText(l10n, type, SetValues.ofLog(best), unit) ??
                      l10n.strengthNoValue)
                  .toUpperCase(),
              key: const Key('exercise-last'),
              style: t.displayXl.copyWith(fontSize: 44),
            ),
            Text(
              last!.bestOneRmGrams == null
                  ? l10n.historyDate(
                      shortDate(locale, sessionDay(last.session)),
                    )
                  : l10n.summaryJoin(
                      shortDate(locale, sessionDay(last.session)),
                      l10n.exerciseOneRm(
                        gramsText(l10n, last.bestOneRmGrams!, unit),
                      ),
                    ),
              key: const Key('exercise-last-meta'),
              style: t.bodySm.copyWith(color: c.inkMuted),
            ),
          ],
          if (type.tracksWeight) ...[
            SectionLabel(l10n.exerciseTrendTitle),
            Wrap(
              spacing: TlSpace.s1,
              runSpacing: TlSpace.s1,
              children: [
                for (final r in ChartRange.values)
                  TlChip(
                    key: Key('range-${r.name}'),
                    label: _rangeLabel(l10n, r),
                    selected: _range == r,
                    onTap: () => setState(() => _range = r),
                  ),
              ],
            ),
            const SizedBox(height: TlSpace.s3),
            if (points.length < 2)
              Text(
                l10n.exerciseTrendMissing(2 - points.length),
                key: const Key('exercise-trend-missing'),
                style: t.bodySm.copyWith(color: c.inkMuted),
              )
            else ...[
              TrendLine(
                key: const Key('exercise-trend'),
                points: points,
                semanticLabel: _trendText(l10n, points, unit),
              ),
              const SizedBox(height: TlSpace.s2),
              Text(
                _trendText(l10n, points, unit),
                style: t.bodySm.copyWith(color: c.inkMuted),
              ),
            ],
          ],
          SectionLabel(l10n.exerciseRecords),
          if (records.isEmpty)
            Text(
              l10n.exerciseNoRecords,
              style: t.bodySm.copyWith(color: c.inkMuted),
            ),
          for (final r in records)
            Padding(
              key: Key('exercise-record-${r.type.name}-${r.weightGrams}'),
              padding: const EdgeInsets.symmetric(vertical: TlSpace.s1),
              child: Row(
                children: [
                  Expanded(
                    child: Text(recordName(l10n, r, unit), style: t.body),
                  ),
                  Text(
                    recordValue(l10n, r, unit),
                    style: t.body.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          SectionLabel(l10n.exerciseHistory),
          for (final s in p.sessions.reversed)
            _SessionRow(session: s, type: type),
        ],
      ),
    );
  }

  String _rangeLabel(AppLocalizations l10n, ChartRange r) => switch (r) {
    ChartRange.weeks4 => l10n.rangeWeeks(4),
    ChartRange.weeks12 => l10n.rangeWeeks(12),
    ChartRange.months6 => l10n.rangeMonths(6),
    ChartRange.year1 => l10n.rangeYear,
    ChartRange.all => l10n.rangeAll,
  };

  /// «De 96 kg a 107,7 kg (+12 %)».
  String _trendText(
    AppLocalizations l10n,
    List<(double, double)> points,
    WeightUnit unit,
  ) {
    final first = points.first.$2, last = points.last.$2;
    final pct = first <= 0 ? 0 : ((last - first) / first * 100).round();
    return l10n.exerciseTrendNote(
      gramsText(l10n, first, unit),
      gramsText(l10n, last, unit),
      pct > 0 ? '+$pct' : '$pct',
    );
  }
}

class _SessionRow extends ConsumerWidget {
  const _SessionRow({required this.session, required this.type});

  final ExerciseSession session;
  final ExerciseLogType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final unit = ref.watch(settingsControllerProvider).weightUnit;
    final sets = [
      for (final s in session.working)
        previousText(l10n, type, SetValues.ofLog(s), unit),
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: TlSpace.s2),
      child: Material(
        color: c.surface1,
        borderRadius: BorderRadius.circular(TlRadius.lg),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: Key('exercise-session-${session.session.id}'),
          onTap: () => context.push(Routes.sessionDetail(session.session.id)),
          child: Padding(
            padding: const EdgeInsets.all(TlSpace.s3),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.historyDate(
                      shortDate(context.locale, sessionDay(session.session)),
                    ),
                    style: t.body.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Text(
                    sets.isEmpty ? l10n.strengthNoValue : sets.join(' · '),
                    textAlign: TextAlign.end,
                    style: t.bodySm.copyWith(color: c.inkMuted),
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
