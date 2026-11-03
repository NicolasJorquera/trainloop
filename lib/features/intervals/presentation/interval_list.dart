import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/section_label.dart';
import '../application/interval_providers.dart';
import '../application/interval_texts.dart';
import '../data/interval_workout_repository.dart';
import '../domain/interval_templates.dart';
import '../domain/phase_plan.dart';
import 'interval_widgets.dart';
import 'session_launcher.dart';

enum _IntervalAction { edit, duplicate, archive }

/// Intervalos de S02: entrenamientos propios (tocar abre el detalle, ▶
/// empieza, el menú edita, duplica o archiva con "Deshacer") y plantillas.
class IntervalList extends ConsumerWidget {
  const IntervalList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final workouts = ref.watch(intervalSummariesProvider).value ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (workouts.isEmpty)
          EmptyState(
            icon: Icons.timer_outlined,
            title: l10n.trainIntervalsEmptyTitle,
            body: l10n.trainIntervalsEmptyBody,
          )
        else ...[
          SectionLabel(l10n.trainMyIntervals),
          for (final w in workouts)
            Padding(
              padding: const EdgeInsets.only(bottom: TlSpace.s2),
              child: _WorkoutCard(
                summary: w,
                onAction: (a) => _act(context, ref, a, w),
              ),
            ),
        ],
        SectionLabel(l10n.trainTemplates),
        const TemplateGrid(IntervalTemplate.values),
      ],
    );
  }

  Future<void> _act(
    BuildContext context,
    WidgetRef ref,
    _IntervalAction action,
    IntervalWorkoutSummary summary,
  ) async {
    final l10n = context.l10n;
    final repo = ref.read(intervalWorkoutRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    final name = summary.workout.name;
    switch (action) {
      case _IntervalAction.edit:
        await context.push(Routes.intervalEdit(summary.id));
      case _IntervalAction.duplicate:
        final copy = l10n.routineCopyName(name);
        await repo.duplicate(summary.id, name: copy);
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.routineDuplicated(copy))));
      case _IntervalAction.archive:
        await repo.archive(summary.id);
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(l10n.intervalArchived(name)),
              action: SnackBarAction(
                key: const Key('undo-archive-interval'),
                label: l10n.undo,
                onPressed: () => repo.unarchive(summary.id),
              ),
            ),
          );
    }
  }
}

class _WorkoutCard extends ConsumerWidget {
  const _WorkoutCard({required this.summary, required this.onAction});

  final IntervalWorkoutSummary summary;
  final ValueChanged<_IntervalAction> onAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final workout = summary.workout;
    final phases = expandPhases(workout);
    return Material(
      color: c.surface1,
      borderRadius: BorderRadius.circular(TlRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: Key('interval-${summary.id}'),
        onTap: () => context.push(Routes.intervalDetail(summary.id)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            TlSpace.s4,
            TlSpace.s3,
            TlSpace.s1,
            TlSpace.s3,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(workout.name, style: t.title),
                    const SizedBox(height: TlSpace.s1),
                    Text(
                      workoutMeta(l10n, WorkoutTotals.of(phases)),
                      style: t.bodySm.copyWith(color: c.inkMuted),
                    ),
                    const SizedBox(height: TlSpace.s2),
                    PhaseStrip(phases, height: 4),
                  ],
                ),
              ),
              const SizedBox(width: TlSpace.s2),
              IconButton.filled(
                key: Key('start-${summary.id}'),
                tooltip: l10n.intervalStart(workout.name),
                icon: const Icon(Icons.play_arrow),
                style: IconButton.styleFrom(
                  backgroundColor: c.primaryBg,
                  foregroundColor: c.primaryInk,
                  minimumSize: const Size.square(TlSize.touchMin),
                ),
                onPressed: () => startIntervalSession(context, ref, workout),
              ),
              PopupMenuButton<_IntervalAction>(
                key: Key('interval-menu-${summary.id}'),
                tooltip: l10n.intervalActions(workout.name),
                icon: const Icon(Icons.more_vert),
                onSelected: onAction,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: _IntervalAction.edit,
                    child: Text(l10n.routineEdit),
                  ),
                  PopupMenuItem(
                    value: _IntervalAction.duplicate,
                    child: Text(l10n.routineDuplicate),
                  ),
                  PopupMenuItem(
                    value: _IntervalAction.archive,
                    child: Text(l10n.routineArchive),
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
