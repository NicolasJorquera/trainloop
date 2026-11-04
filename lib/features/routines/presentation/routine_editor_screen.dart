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
import '../../../core/widgets/tl_button.dart';
import '../../../data/db/app_database.dart';
import '../../exercises/domain/exercise_names.dart';
import '../../intervals/presentation/session_dialogs.dart';
import '../../settings/application/settings_controller.dart';
import '../application/routine_providers.dart';
import '../domain/routine_draft.dart';
import 'routine_entry_sheet.dart';

/// S07 Editor de rutina: nombre y ejercicios en orden con su objetivo
/// (series, reps o tiempo, peso y descanso). Arrastrar desde el asa
/// reordena; tocar abre el detalle. Sin [routineId] crea una rutina nueva.
class RoutineEditorScreen extends ConsumerStatefulWidget {
  const RoutineEditorScreen({this.routineId, super.key});

  final String? routineId;

  @override
  ConsumerState<RoutineEditorScreen> createState() =>
      _RoutineEditorScreenState();
}

class _RoutineEditorScreenState extends ConsumerState<RoutineEditorScreen> {
  final _name = TextEditingController();
  RoutineDraft? _draft;
  var _saving = false;

  /// Hay cambios sin guardar: volver pregunta antes de descartarlos (D3).
  var _dirty = false;

  void _edit(RoutineDraft next) => setState(() {
    _draft = next;
    _dirty = true;
  });

  @override
  void initState() {
    super.initState();
    final id = widget.routineId;
    if (id == null) {
      _draft = const RoutineDraft();
    } else {
      ref.read(routineRepositoryProvider).load(id).then((d) {
        if (!mounted) return;
        _name.text = d?.name ?? '';
        setState(() => _draft = d ?? const RoutineDraft());
      });
    }
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final draft = _draft;
    final unit = ref.watch(settingsControllerProvider).weightUnit;

    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmDiscard() && context.mounted) {
          setState(() => _dirty = false);
          context.pop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: draft == null
              ? const SizedBox.shrink()
              : ListView(
                  padding: const EdgeInsets.fromLTRB(
                    TlSpace.s4,
                    0,
                    TlSpace.s4,
                    TlSpace.s8,
                  ),
                  children: [
                    ScreenHeader(
                      title: widget.routineId == null
                          ? l10n.routineNewTitle
                          : l10n.routineEditTitle,
                      leading: IconButton(
                        tooltip: l10n.backTooltip,
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                    SectionLabel(l10n.fieldName),
                    TextField(
                      key: const Key('routine-name'),
                      controller: _name,
                      maxLength: 60,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: l10n.routineNameHint,
                        counterText: '',
                      ),
                      onChanged: (v) => _edit(draft.rename(v)),
                    ),
                    SectionLabel(
                      l10n.routineExercisesLabel(draft.entries.length),
                    ),
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      buildDefaultDragHandles: false,
                      itemCount: draft.entries.length,
                      onReorder: (from, to) => _edit(draft.move(from, to)),
                      itemBuilder: (context, i) {
                        final entry = draft.entries[i];
                        return Padding(
                          key: ValueKey('entry-$i-${entry.exercise.id}'),
                          padding: const EdgeInsets.only(bottom: TlSpace.s2),
                          child: _EntryRow(
                            index: i,
                            entry: entry,
                            unit: unit,
                            onTap: () => _openEntry(i),
                            onRemove: () => _edit(draft.removeAt(i)),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: TlSpace.s2),
                    TlButton(
                      key: const Key('routine-add-exercises'),
                      label: l10n.routineAddExercises,
                      icon: Icons.add,
                      variant: TlButtonVariant.secondary,
                      onPressed: _addExercises,
                    ),
                    const SizedBox(height: TlSpace.s4),
                    Text(
                      l10n.routineEditorHint,
                      textAlign: TextAlign.center,
                      style: context.text.caption.copyWith(color: c.inkMuted),
                    ),
                  ],
                ),
        ),
        bottomNavigationBar: draft == null
            ? null
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    TlSpace.s4,
                    TlSpace.s2,
                    TlSpace.s4,
                    TlSpace.s4,
                  ),
                  child: TlButton(
                    key: const Key('routine-save'),
                    label: l10n.routineSave,
                    onPressed: draft.canSave && !_saving
                        ? () => _save(draft)
                        : null,
                  ),
                ),
              ),
      ),
    );
  }

  /// «¿Descartar los cambios?»: `true` = salir sin guardar.
  Future<bool> _confirmDiscard() async {
    final l10n = context.l10n;
    final result = await showTlDialog<bool>(
      context,
      key: const Key('routine-discard-dialog'),
      icon: Icons.edit_off_outlined,
      title: l10n.routineDiscardTitle,
      body: [Text(l10n.routineDiscardBody)],
      actions: (pop) => [
        TlButton(
          key: const Key('routine-discard-confirm'),
          label: l10n.routineDiscardConfirm,
          onPressed: () => pop(true),
        ),
        TlButton(
          key: const Key('routine-discard-keep'),
          label: l10n.routineDiscardKeep,
          variant: TlButtonVariant.text,
          onPressed: () => pop(false),
        ),
      ],
    );
    return result ?? false;
  }

  Future<void> _addExercises() async {
    final picked = await context.push<List<Exercise>>(Routes.exercisesPick);
    if (picked == null || picked.isEmpty || !mounted) return;
    _edit(_draft!.addAll(picked));
  }

  Future<void> _openEntry(int index) async {
    final unit = ref.read(settingsControllerProvider).weightUnit;
    await showRoutineEntrySheet(
      context,
      entry: _draft!.entries[index],
      unit: unit,
      onChanged: (e) => _edit(_draft!.replaceAt(index, e)),
    );
  }

  Future<void> _save(RoutineDraft draft) async {
    setState(() => _saving = true);
    final l10n = context.l10n;
    final repo = ref.read(routineRepositoryProvider);
    final fallback = l10n.routineDefaultName(await repo.activeCount() + 1);
    await repo.save(draft, fallbackName: fallback);
    if (!mounted) return;
    setState(() => _dirty = false);
    context.pop();
  }
}

class _EntryRow extends StatelessWidget {
  const _EntryRow({
    required this.index,
    required this.entry,
    required this.unit,
    required this.onTap,
    required this.onRemove,
  });

  final int index;
  final RoutineEntryDraft entry;
  final WeightUnit unit;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final name = exerciseName(entry.exercise, context.locale);
    return Material(
      color: c.surface1,
      borderRadius: BorderRadius.circular(TlRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            ReorderableDragStartListener(
              index: index,
              child: Semantics(
                container: true,
                label: l10n.routineDragHandle,
                child: SizedBox(
                  width: TlSize.touchMin,
                  height: TlSize.touchSession,
                  child: Icon(Icons.drag_indicator, color: c.inkMuted),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: TlSpace.s2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: t.body.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      entrySummary(l10n, entry, unit),
                      style: t.caption.copyWith(color: c.inkMuted),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              key: Key('remove-entry-$index'),
              tooltip: l10n.routineRemoveExercise(name),
              icon: Icon(Icons.close, color: c.inkMuted),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

/// Resumen de un ejercicio de la rutina, p. ej. «3 × 10 · 60 kg ·
/// descanso 1:30». El peso se muestra en la unidad de la persona.
String entrySummary(
  AppLocalizations l10n,
  RoutineEntryDraft e,
  WeightUnit unit,
) {
  final weight = e.weight;
  return [
    if (e.countsReps && e.reps != null)
      l10n.summarySetsReps(e.sets, e.reps!)
    else if (e.countsTime && e.durationSeconds != null)
      l10n.summarySetsTime(e.sets, l10n.duration(e.durationSeconds!))
    else
      l10n.summarySets(e.sets),
    if (e.tracksWeight && weight != null)
      l10n.weight(unit.convertFrom(weight, e.weightUnit ?? unit), unit),
    l10n.summaryRest(l10n.duration(e.restSeconds)),
  ].reduce(l10n.summaryJoin);
}
