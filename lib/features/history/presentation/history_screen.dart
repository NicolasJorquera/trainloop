import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/tab_page.dart';
import '../../../core/widgets/tl_segmented_control.dart';
import '../../settings/application/settings_controller.dart';
import '../application/history_providers.dart';
import '../domain/week.dart';
import 'calendar_view.dart';
import 'history_widgets.dart';
import 'week_view.dart';

/// Vista de S12.
enum HistoryTab { week, list, calendar }

/// Vista elegida en S12 (se conserva al cambiar de pestaña).
final historyTabProvider = NotifierProvider<HistoryTabController, HistoryTab>(
  HistoryTabController.new,
);

class HistoryTabController extends Notifier<HistoryTab> {
  @override
  HistoryTab build() => HistoryTab.week;

  // ignore: use_setters_to_change_properties
  void select(HistoryTab tab) => state = tab;
}

/// S12 Historial y calendario (F-10, F-11): semana (unificada o separada,
/// H5), lista de sesiones agrupadas por semana y calendario mensual. Fuerza
/// e intervalos juntos; cada sesión abre su detalle (S13).
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final tab = ref.watch(historyTabProvider);
    final entries = ref.watch(historyEntriesProvider).value ?? const [];
    return TabPage(
      children: [
        TabHeader(title: l10n.historyTitle),
        TlSegmentedControl<HistoryTab>(
          key: const Key('history-tabs'),
          semanticLabel: l10n.historyTabsLabel,
          selected: tab,
          onChanged: ref.read(historyTabProvider.notifier).select,
          segments: [
            TlSegment(HistoryTab.week, l10n.historyTabWeek),
            TlSegment(HistoryTab.list, l10n.historyTabList),
            TlSegment(HistoryTab.calendar, l10n.historyTabCalendar),
          ],
        ),
        const SizedBox(height: TlSpace.s4),
        switch (tab) {
          HistoryTab.week => WeekView(entries: entries),
          HistoryTab.list => _HistoryList(entries: entries),
          HistoryTab.calendar => CalendarView(entries: entries),
        },
      ],
    );
  }
}

/// Lista de sesiones agrupadas por semana, la más reciente primero.
class _HistoryList extends ConsumerWidget {
  const _HistoryList({required this.entries});

  final List<HistoryEntry> entries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    if (entries.isEmpty) {
      return EmptyState(
        icon: Icons.history,
        title: l10n.historyEmptyTitle,
        body: l10n.historyEmptyBody,
      );
    }
    final start = ref.watch(settingsControllerProvider).weekStart;
    final today = civilToday(ref.watch(clockProvider)());
    final current = weekStartOf(today, start);
    final weeks = <DateTime>[];
    for (final e in entries) {
      final w = weekStartOf(e.day, start);
      if (!weeks.contains(w)) weeks.add(w);
    }
    weeks.sort((a, b) => b.compareTo(a));
    return Column(
      key: const Key('history-list'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final w in weeks) ...[
          WeekListHeader(week: statsForWeek(entries, w), currentWeek: current),
          for (final e in entries.where((e) => weekStartOf(e.day, start) == w))
            Padding(
              padding: const EdgeInsets.only(bottom: TlSpace.s2),
              child: EntryTile(e),
            ),
        ],
      ],
    );
  }
}
