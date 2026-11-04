import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/section_label.dart';
import '../../../data/db/enums.dart';
import '../../settings/application/settings_controller.dart';
import '../application/history_providers.dart';
import '../application/history_texts.dart';
import '../domain/week.dart';
import 'history_widgets.dart';

/// Calendario mensual (J4): días con sesiones marcados por tipo (F / I);
/// tocar un día muestra sus sesiones.
class CalendarView extends ConsumerStatefulWidget {
  const CalendarView({required this.entries, super.key});

  final List<HistoryEntry> entries;

  @override
  ConsumerState<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends ConsumerState<CalendarView> {
  DateTime? _month;
  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final locale = context.locale;
    final weekStart = ref.watch(settingsControllerProvider).weekStart;
    final today = civilToday(ref.watch(clockProvider)());
    final month = _month ?? DateTime.utc(today.year, today.month);
    final selected = _selected ?? today;
    final byDay = <DateTime, List<HistoryEntry>>{};
    for (final e in widget.entries) {
      (byDay[e.day] ??= []).add(e);
    }
    final first = weekStartOf(month, weekStart);
    final next = DateTime.utc(month.year, month.month + 1);
    final cells = <DateTime>[
      for (var d = first; d.isBefore(next); d = d.add(const Duration(days: 1)))
        d,
    ];
    while (cells.length % 7 != 0) {
      cells.add(cells.last.add(const Duration(days: 1)));
    }
    final dayEntries = [...?byDay[selected]]
      ..sort((a, b) => a.session.startedAt.compareTo(b.session.startedAt));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton(
              key: const Key('calendar-prev'),
              tooltip: l10n.historyPrevMonth,
              icon: const Icon(Icons.chevron_left),
              onPressed: () => setState(
                () => _month = DateTime.utc(month.year, month.month - 1),
              ),
            ),
            Expanded(
              child: Text(
                l10n.historyMonth(monthTitle(locale, month)),
                key: const Key('calendar-month'),
                textAlign: TextAlign.center,
                style: t.title,
              ),
            ),
            IconButton(
              key: const Key('calendar-next'),
              tooltip: l10n.historyNextMonth,
              icon: const Icon(Icons.chevron_right),
              onPressed: () => setState(
                () => _month = DateTime.utc(month.year, month.month + 1),
              ),
            ),
          ],
        ),
        const SizedBox(height: TlSpace.s2),
        Row(
          children: [
            for (final d in cells.take(7))
              Expanded(
                child: Text(
                  l10n.historyDayName(weekdayNarrow(locale, d)),
                  textAlign: TextAlign.center,
                  style: t.caption.copyWith(color: c.inkMuted),
                ),
              ),
          ],
        ),
        const SizedBox(height: TlSpace.s1),
        for (var row = 0; row < cells.length ~/ 7; row++)
          Row(
            children: [
              for (final d in cells.skip(row * 7).take(7))
                Expanded(
                  child: _DayCell(
                    day: d,
                    inMonth: d.month == month.month,
                    isToday: d == today,
                    isSelected: d == selected,
                    entries: byDay[d] ?? const [],
                    onTap: () => setState(() => _selected = d),
                  ),
                ),
            ],
          ),
        SectionLabel(
          l10n.historyDayTitle(shortDate(locale, selected).toUpperCase()),
        ),
        if (dayEntries.isEmpty)
          Text(
            l10n.historyDayEmpty,
            style: t.bodySm.copyWith(color: c.inkMuted),
          ),
        for (final e in dayEntries) ...[
          EntryTile(e, showDate: false),
          const SizedBox(height: TlSpace.s2),
        ],
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.inMonth,
    required this.isToday,
    required this.isSelected,
    required this.entries,
    required this.onTap,
  });

  final DateTime day;
  final bool inMonth;
  final bool isToday;
  final bool isSelected;
  final List<HistoryEntry> entries;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final kinds = {for (final e in entries) e.kind};
    final label = l10n.historyCalendarDay(
      shortDate(context.locale, day),
      entries.length,
    );
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        key: Key('calendar-day-${day.year}-${day.month}-${day.day}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(TlRadius.md),
        child: Container(
          height: 52,
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: isToday ? c.accentSoft : null,
            borderRadius: BorderRadius.circular(TlRadius.md),
            border: isSelected ? Border.all(color: c.ink, width: 2) : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.numberValue(day.day),
                style: t.bodySm.copyWith(
                  color: inMonth ? c.ink : c.inkMuted.withValues(alpha: 0.5),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final k in [SessionKind.strength, SessionKind.intervals])
                    if (kinds.contains(k))
                      Text(
                        kindLetter(l10n, k),
                        style: t.button.copyWith(
                          fontSize: 14,
                          color: kindColor(context, k),
                        ),
                      ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
