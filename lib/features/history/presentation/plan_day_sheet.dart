import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../data/db/database_providers.dart';
import '../../../data/db/enums.dart';
import '../../intervals/application/interval_texts.dart';
import '../../intervals/domain/interval_templates.dart';
import '../application/history_providers.dart';
import '../application/history_texts.dart';
import '../domain/week.dart';
import 'history_widgets.dart';

/// Plan opcional de un día de la semana (F-11): una rutina, un
/// entrenamiento de intervalos o una plantilla, o nada. Se repite cada
/// semana y solo se muestra: nunca abre una sesión sola (E12).
Future<void> showPlanDaySheet(
  BuildContext context,
  WidgetRef ref,
  int weekday,
) async {
  final db = ref.read(appDatabaseProvider);
  final routines = await db.routinesDao.watchActive().first;
  final workouts = await db.intervalWorkoutsDao.watchActive().first;
  if (!context.mounted) return;
  final current = (ref.read(weekPlanProvider).value ?? const [])
      .where((p) => p.weekday == weekday)
      .firstOrNull;
  final l10n = context.l10n;
  final options = [
    for (final r in routines)
      PlannedWorkout(
        weekday: weekday,
        kind: SessionKind.strength,
        templateId: r.id,
        name: r.name,
      ),
    for (final w in workouts)
      PlannedWorkout(
        weekday: weekday,
        kind: SessionKind.intervals,
        templateId: w.id,
        name: w.name,
      ),
    for (final t in IntervalTemplate.quickStart)
      PlannedWorkout(
        weekday: weekday,
        kind: SessionKind.intervals,
        templateId: t.sourceId,
        name: templateName(l10n, t),
      ),
  ];
  // Un lunes cualquiera + (weekday − 1) días: el nombre del día.
  final day = DateTime.utc(2024, 1, 1).add(Duration(days: weekday - 1));
  final choice = await showModalBottomSheet<PlannedWorkout?>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: context.colors.surface1,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(TlRadius.sheet)),
    ),
    builder: (context) => _PlanSheet(
      title: l10n.planTitle(capitalize(weekdayLong(context.locale, day))),
      options: options,
      current: current,
    ),
  );
  if (choice == null) return;
  await ref
      .read(historyRepositoryProvider)
      .setPlan(
        weekday,
        kind: choice.templateId.isEmpty ? null : choice.kind,
        templateId: choice.templateId.isEmpty ? null : choice.templateId,
      );
}

class _PlanSheet extends StatelessWidget {
  const _PlanSheet({
    required this.title,
    required this.options,
    required this.current,
  });

  final String title;
  final List<PlannedWorkout> options;
  final PlannedWorkout? current;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final none = PlannedWorkout(
      weekday: 0,
      kind: SessionKind.strength,
      templateId: '',
      name: l10n.planNone,
    );
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (context, controller) => ListView(
        key: const Key('plan-sheet'),
        controller: controller,
        padding: const EdgeInsets.all(TlSpace.s4),
        children: [
          Semantics(header: true, child: Text(title, style: t.headline)),
          const SizedBox(height: TlSpace.s1),
          Text(l10n.planHelp, style: t.bodySm.copyWith(color: c.inkMuted)),
          const SizedBox(height: TlSpace.s3),
          for (final o in [none, ...options])
            ListTile(
              key: Key(
                'plan-option-${o.templateId.isEmpty ? 'none' : o.templateId}',
              ),
              contentPadding: EdgeInsets.zero,
              leading: o.templateId.isEmpty
                  ? const KindBadge(kind: null, style: BadgeStyle.dotted)
                  : KindBadge(kind: o.kind, style: BadgeStyle.outline),
              title: Text(o.name ?? '', style: t.body),
              trailing: (current?.templateId ?? '') == o.templateId
                  ? Icon(Icons.check, color: c.accent)
                  : null,
              onTap: () => Navigator.of(context).pop(o),
            ),
        ],
      ),
    );
  }
}
