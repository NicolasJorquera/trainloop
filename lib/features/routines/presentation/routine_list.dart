import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/tl_button.dart';
import '../../../data/db/daos/routines_dao.dart';
import '../../strength/application/strength_session_controller.dart';
import '../../strength/presentation/strength_launcher.dart';
import '../application/routine_providers.dart';
import '../domain/reorder.dart';

enum _RoutineAction { edit, duplicate, archive, start }

/// Lista de rutinas de S02: ▶ empieza la sesión (D5), tocar edita, mantener
/// presionado reordena y el menú duplica o archiva (con "Deshacer"). Debajo,
/// ENTRENAMIENTO LIBRE empieza una sesión vacía.
class RoutineList extends ConsumerStatefulWidget {
  const RoutineList({super.key});

  @override
  ConsumerState<RoutineList> createState() => _RoutineListState();
}

class _RoutineListState extends ConsumerState<RoutineList> {
  /// Orden local mientras se guarda un reordenamiento (evita un salto).
  List<RoutineSummary>? _pending;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final routines =
        _pending ?? ref.watch(routineSummariesProvider).value ?? const [];
    final library = TlButton(
      key: const Key('open-library'),
      label: l10n.trainExerciseLibrary,
      icon: Icons.menu_book_outlined,
      variant: TlButtonVariant.text,
      onPressed: () => context.push(Routes.exercises),
    );

    final free = _FreeWorkoutButton(
      onTap: () => startStrengthSession(context, ref, const StartFree()),
    );

    if (routines.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EmptyState(
            icon: Icons.fitness_center,
            title: l10n.trainRoutinesEmptyTitle,
            body: l10n.trainRoutinesEmptyBody,
          ),
          const SizedBox(height: TlSpace.s2),
          free,
          const SizedBox(height: TlSpace.s2),
          library,
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          itemCount: routines.length,
          onReorder: (from, to) => _reorder(routines, from, to),
          itemBuilder: (context, i) => ReorderableDelayedDragStartListener(
            key: ValueKey(routines[i].routine.id),
            index: i,
            child: Padding(
              padding: const EdgeInsets.only(bottom: TlSpace.s2),
              child: _RoutineCard(
                summary: routines[i],
                onAction: (a) => _act(a, routines[i]),
              ),
            ),
          ),
        ),
        free,
        const SizedBox(height: TlSpace.s2),
        Text(
          l10n.trainRoutinesHint,
          textAlign: TextAlign.center,
          style: context.text.caption.copyWith(color: c.inkMuted),
        ),
        const SizedBox(height: TlSpace.s2),
        library,
      ],
    );
  }

  Future<void> _reorder(List<RoutineSummary> list, int from, int to) async {
    final next = reorderList(list, from, to);
    setState(() => _pending = next);
    await ref.read(routineRepositoryProvider).reorder([
      for (final r in next) r.routine.id,
    ]);
    if (mounted) setState(() => _pending = null);
  }

  Future<void> _act(_RoutineAction action, RoutineSummary summary) async {
    final l10n = context.l10n;
    final repo = ref.read(routineRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    final routine = summary.routine;
    switch (action) {
      case _RoutineAction.start:
        if (summary.exerciseCount == 0) {
          // Rutina vacía: no se puede empezar; se invita a agregar ejercicios.
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(l10n.strengthEmptyRoutine)));
          await context.push(Routes.routineEdit(routine.id));
          return;
        }
        await startStrengthSession(context, ref, StartFromRoutine(routine.id));
      case _RoutineAction.edit:
        await context.push(Routes.routineEdit(routine.id));
      case _RoutineAction.duplicate:
        final name = l10n.routineCopyName(routine.name);
        await repo.duplicate(routine.id, name: name);
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.routineDuplicated(name))));
      case _RoutineAction.archive:
        await repo.archive(routine.id);
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(l10n.routineArchived(routine.name)),
              action: SnackBarAction(
                key: const Key('undo-archive'),
                label: l10n.undo,
                onPressed: () => repo.unarchive(routine.id),
              ),
            ),
          );
    }
  }
}

class _RoutineCard extends StatelessWidget {
  const _RoutineCard({required this.summary, required this.onAction});

  final RoutineSummary summary;
  final ValueChanged<_RoutineAction> onAction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final name = summary.routine.name;
    return Material(
      color: c.surface1,
      borderRadius: BorderRadius.circular(TlRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onAction(_RoutineAction.edit),
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
                    Text(name, style: t.title),
                    const SizedBox(height: TlSpace.s1),
                    Text(
                      l10n.routineExerciseCount(summary.exerciseCount),
                      style: t.bodySm.copyWith(color: c.inkMuted),
                    ),
                  ],
                ),
              ),
              _StartButton(
                key: Key('routine-start-${summary.routine.id}'),
                tooltip: l10n.routineStart(name),
                onTap: () => onAction(_RoutineAction.start),
              ),
              PopupMenuButton<_RoutineAction>(
                key: Key('routine-menu-${summary.routine.id}'),
                tooltip: l10n.routineActions(name),
                icon: const Icon(Icons.more_vert),
                onSelected: onAction,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: _RoutineAction.edit,
                    child: Text(l10n.routineEdit),
                  ),
                  PopupMenuItem(
                    value: _RoutineAction.duplicate,
                    child: Text(l10n.routineDuplicate),
                  ),
                  PopupMenuItem(
                    value: _RoutineAction.archive,
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

/// ▶ de la tarjeta: empieza la rutina (S02 → S10).
class _StartButton extends StatelessWidget {
  const _StartButton({required this.tooltip, required this.onTap, super.key});

  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      label: tooltip,
      excludeSemantics: true,
      child: Material(
        color: c.primaryBg,
        borderRadius: BorderRadius.circular(TlRadius.md),
        child: InkWell(
          borderRadius: BorderRadius.circular(TlRadius.md),
          onTap: onTap,
          child: SizedBox(
            width: 52,
            height: 52,
            child: Icon(Icons.play_arrow, color: c.primaryInk, size: 26),
          ),
        ),
      ),
    );
  }
}

/// ENTRENAMIENTO LIBRE: sesión de fuerza vacía.
class _FreeWorkoutButton extends StatelessWidget {
  const _FreeWorkoutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      child: InkWell(
        key: const Key('free-workout'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(TlRadius.lg),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TlRadius.lg),
            border: Border.all(color: c.line, width: 2),
          ),
          alignment: Alignment.center,
          child: Text(
            context.l10n.strengthFreeWorkout,
            style: context.text.button.copyWith(color: c.accent),
          ),
        ),
      ),
    );
  }
}
