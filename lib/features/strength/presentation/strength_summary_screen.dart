import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/units/weight_unit.dart';
import '../../../core/widgets/section_label.dart';
import '../../../core/widgets/tl_button.dart';
import '../../../data/db/enums.dart';
import '../../exercises/domain/exercise_names.dart';
import '../../history/application/history_texts.dart';
import '../../history/data/records_repository.dart';
import '../../settings/application/settings_controller.dart';
import '../application/strength_session_controller.dart';
import '../application/strength_texts.dart';
import '../data/strength_session_repository.dart';
import '../domain/strength_rules.dart';

/// S06 Resumen, variante fuerza: duración, volumen (sin calentamiento) y
/// series hechas; récords simples del día; "¿Actualizar la rutina?" si la
/// estructura cambió (R-G12); esfuerzo de la sesión 1–10 y nota opcionales.
class StrengthSummaryScreen extends ConsumerStatefulWidget {
  const StrengthSummaryScreen({required this.sessionId, super.key});

  final String sessionId;

  @override
  ConsumerState<StrengthSummaryScreen> createState() =>
      _StrengthSummaryScreenState();
}

class _StrengthSummaryScreenState extends ConsumerState<StrengthSummaryScreen> {
  final _note = TextEditingController();
  StrengthSummary? _summary;
  int? _effort;

  /// `null` = sin responder; `true`/`false` = respondió.
  bool? _updateRoutine;

  StrengthSessionRepository get _repo =>
      ref.read(strengthSessionRepositoryProvider);

  @override
  void initState() {
    super.initState();
    _repo.summary(widget.sessionId).then((s) {
      if (!mounted) return;
      setState(() {
        _summary = s;
        _effort = s?.session.perceivedEffort;
        _note.text = s?.session.note ?? '';
      });
    });
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final s = _summary;
    if (s == null) return const Scaffold(body: SizedBox.shrink());
    final unit = ref.watch(settingsControllerProvider).weightUnit;
    final completed = s.session.status == SessionStatus.completed;
    final date = DateFormat.MMMd(
      context.locale.toLanguageTag(),
    ).add_Hm().format(s.session.startedAt.toLocal());
    final volume = roundWeight(unit.fromGrams(s.data.volumeGrams));
    final minutes = (s.durationSeconds / 60).round();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _done();
      },
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              TlSpace.s4,
              TlSpace.s6,
              TlSpace.s4,
              TlSpace.s8,
            ),
            children: [
              Icon(Icons.emoji_events_outlined, size: 40, color: c.accent),
              const SizedBox(height: TlSpace.s2),
              Semantics(
                header: true,
                child: Text(
                  completed ? l10n.summaryDoneTitle : l10n.strengthSavedTitle,
                  key: const Key('summary-title'),
                  style: t.headline,
                ),
              ),
              const SizedBox(height: TlSpace.s1),
              Text(
                l10n.summarySubtitle(sessionTitle(l10n, s.data.title), date),
                style: t.bodySm.copyWith(color: c.inkMuted),
              ),
              const SizedBox(height: TlSpace.s4),
              Row(
                children: [
                  _Stat(
                    label: l10n.strengthSummaryDuration,
                    value: l10n.strengthMinutes(minutes),
                    valueKey: const Key('summary-duration'),
                  ),
                  _Stat(
                    label: l10n.strengthSummaryVolume,
                    value: l10n
                        .weightValue(
                          l10n.grouped(volume),
                          l10n.unitSymbol(unit),
                        )
                        .toUpperCase(),
                    valueKey: const Key('summary-volume'),
                  ),
                  _Stat(
                    label: l10n.strengthSummarySets,
                    value: l10n.numberValue(s.data.completedSets),
                    valueKey: const Key('summary-sets'),
                  ),
                ],
              ),
              for (final r in s.records) ...[
                const SizedBox(height: TlSpace.s3),
                _RecordCard(records: r, unit: unit),
              ],
              if (s.routineChanged && s.routineName != null) ...[
                const SizedBox(height: TlSpace.s3),
                _UpdateRoutineCard(
                  routine: s.routineName!,
                  answer: _updateRoutine,
                  onAnswer: _answerUpdate,
                ),
              ],
              SectionLabel(l10n.summaryRpeQuestion),
              Wrap(
                spacing: TlSpace.s1,
                runSpacing: TlSpace.s1,
                children: [
                  for (var n = 1; n <= 10; n++)
                    Semantics(
                      button: true,
                      selected: _effort == n,
                      label: l10n.summaryRpeValue(n),
                      excludeSemantics: true,
                      child: ChoiceChip(
                        key: Key('rpe-$n'),
                        label: Text(l10n.numberValue(n)),
                        selected: _effort == n,
                        showCheckmark: false,
                        onSelected: (on) =>
                            setState(() => _effort = on ? n : null),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: TlSpace.s1),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.summaryRpeEasy,
                      style: t.caption.copyWith(color: c.inkMuted),
                    ),
                  ),
                  Text(
                    l10n.summaryRpeMax,
                    style: t.caption.copyWith(color: c.inkMuted),
                  ),
                ],
              ),
              SectionLabel(l10n.summaryNote),
              TextField(
                key: const Key('summary-note'),
                controller: _note,
                minLines: 2,
                maxLines: 4,
                maxLength: 500,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: l10n.strengthNoteHint,
                  counterText: '',
                ),
              ),
              const SizedBox(height: TlSpace.s6),
              TlButton(
                key: const Key('summary-done'),
                label: l10n.summaryDone,
                onPressed: _done,
              ),
              const SizedBox(height: TlSpace.s2),
              TlButton(
                key: const Key('summary-discard'),
                label: l10n.summaryDiscard,
                variant: TlButtonVariant.text,
                onPressed: _discard,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _answerUpdate(bool yes) async {
    setState(() => _updateRoutine = yes);
    if (!yes) return;
    await _repo.updateRoutineFromSession(widget.sessionId);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.strengthRoutineUpdated(_summary!.routineName!),
          ),
        ),
      );
  }

  Future<void> _done() async {
    final note = _note.text.trim();
    await _repo.rate(
      widget.sessionId,
      perceivedEffort: _effort,
      note: note.isEmpty ? null : note,
    );
    if (mounted) context.go(Routes.home);
  }

  Future<void> _discard() async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        key: const Key('discard-dialog'),
        title: Text(l10n.summaryDiscardTitle),
        content: Text(l10n.summaryDiscardBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.dialogCancel),
          ),
          TextButton(
            key: const Key('discard-confirm'),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.summaryDiscardConfirm),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await _repo.discard(widget.sessionId);
    if (mounted) context.go(Routes.home);
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, this.valueKey});

  final String label;
  final String value;
  final Key? valueKey;

  @override
  Widget build(BuildContext context) {
    final t = context.text;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: t.overline),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              key: valueKey,
              style: t.displayXl.copyWith(fontSize: 34),
            ),
          ),
        ],
      ),
    );
  }
}

/// Récords nuevos de un ejercicio en la sesión (caché recalculada al
/// guardarla, R-P3): «RÉCORD NUEVO · Sentadilla» y una línea por récord.
class _RecordCard extends StatelessWidget {
  const _RecordCard({required this.records, required this.unit});

  final ExerciseRecords records;
  final WeightUnit unit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final exercise = records.exercise;
    return Container(
      key: Key('record-${exercise.catalogKey ?? exercise.id}'),
      padding: const EdgeInsets.all(TlSpace.s4),
      decoration: BoxDecoration(
        color: c.accentSoft,
        borderRadius: BorderRadius.circular(TlRadius.lg),
        border: Border.all(color: c.accent, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.strengthNewRecord,
            style: t.overline.copyWith(color: c.accent),
          ),
          const SizedBox(height: TlSpace.s1),
          Text(
            exerciseName(exercise, context.locale),
            style: t.title.copyWith(color: c.ink),
          ),
          for (final r in records.records)
            Text(
              recordLine(l10n, r, unit),
              key: Key('record-line-${r.type.name}-${r.weightGrams}'),
              style: t.body.copyWith(color: c.ink),
            ),
        ],
      ),
    );
  }
}

class _UpdateRoutineCard extends StatelessWidget {
  const _UpdateRoutineCard({
    required this.routine,
    required this.answer,
    required this.onAnswer,
  });

  final String routine;
  final bool? answer;
  final ValueChanged<bool> onAnswer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    return Container(
      key: const Key('update-routine'),
      padding: const EdgeInsets.all(TlSpace.s4),
      decoration: BoxDecoration(
        color: c.surface1,
        borderRadius: BorderRadius.circular(TlRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            answer == true
                ? l10n.strengthRoutineUpdated(routine)
                : l10n.strengthUpdateRoutineQuestion(routine),
            style: t.body,
          ),
          if (answer == null) ...[
            const SizedBox(height: TlSpace.s3),
            Row(
              children: [
                Expanded(
                  child: TlButton(
                    key: const Key('update-routine-yes'),
                    label: l10n.strengthUpdateRoutineYes,
                    variant: TlButtonVariant.secondary,
                    onPressed: () => onAnswer(true),
                  ),
                ),
                const SizedBox(width: TlSpace.s2),
                Expanded(
                  child: TlButton(
                    key: const Key('update-routine-no'),
                    label: l10n.strengthUpdateRoutineNo,
                    variant: TlButtonVariant.text,
                    onPressed: () => onAnswer(false),
                  ),
                ),
              ],
            ),
          ] else if (answer == false)
            Text(
              l10n.strengthRoutineKept,
              style: t.bodySm.copyWith(color: c.inkMuted),
            ),
        ],
      ),
    );
  }
}
