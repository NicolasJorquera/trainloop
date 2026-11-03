import 'package:flutter/material.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/units/weight_unit.dart';
import '../../../core/widgets/tl_button.dart';
import '../../../core/widgets/tl_stepper.dart';
import '../../exercises/domain/exercise_names.dart';
import '../domain/routine_draft.dart';

/// Hoja del editor de rutina con el objetivo de un ejercicio. Cada cambio se
/// aplica al momento con [onChanged]; el peso se escribe en [unit].
Future<void> showRoutineEntrySheet(
  BuildContext context, {
  required RoutineEntryDraft entry,
  required WeightUnit unit,
  required ValueChanged<RoutineEntryDraft> onChanged,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (context) =>
      _EntrySheet(entry: entry, unit: unit, onChanged: onChanged),
);

class _EntrySheet extends StatefulWidget {
  const _EntrySheet({
    required this.entry,
    required this.unit,
    required this.onChanged,
  });

  final RoutineEntryDraft entry;
  final WeightUnit unit;
  final ValueChanged<RoutineEntryDraft> onChanged;

  @override
  State<_EntrySheet> createState() => _EntrySheetState();
}

class _EntrySheetState extends State<_EntrySheet> {
  late RoutineEntryDraft _e = widget.entry;
  final _weight = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final w = _e.weight;
    if (_weight.text.isEmpty && w != null) {
      _weight.text = context.l10n.decimal(
        widget.unit.convertFrom(w, _e.weightUnit ?? widget.unit),
      );
    }
  }

  @override
  void dispose() {
    _weight.dispose();
    super.dispose();
  }

  void _set(RoutineEntryDraft e) {
    setState(() => _e = e);
    widget.onChanged(e);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final e = _e;
    TlStepper stepper({
      required String key,
      required String label,
      required String value,
      required VoidCallback? down,
      required VoidCallback? up,
    }) => TlStepper(
      key: Key('sheet-$key'),
      label: label,
      value: value,
      decreaseTooltip: l10n.stepperDecrease(label),
      increaseTooltip: l10n.stepperIncrease(label),
      onDecrease: down,
      onIncrease: up,
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(
        TlSpace.s4,
        0,
        TlSpace.s4,
        TlSpace.s4 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              exerciseName(e.exercise, context.locale),
              style: context.text.title,
            ),
            const SizedBox(height: TlSpace.s2),
            stepper(
              key: 'sets',
              label: l10n.sheetSets,
              value: l10n.numberValue(e.sets),
              down: e.sets > 1
                  ? () => _set(e.copyWith(sets: e.sets - 1))
                  : null,
              up: e.sets < RoutineEntryDraft.maxSets
                  ? () => _set(e.copyWith(sets: e.sets + 1))
                  : null,
            ),
            if (e.countsReps && e.reps != null)
              stepper(
                key: 'reps',
                label: l10n.sheetReps,
                value: l10n.numberValue(e.reps!),
                down: e.reps! > 1
                    ? () => _set(e.copyWith(reps: e.reps! - 1))
                    : null,
                up: e.reps! < RoutineEntryDraft.maxReps
                    ? () => _set(e.copyWith(reps: e.reps! + 1))
                    : null,
              ),
            if (e.countsTime && e.durationSeconds != null)
              stepper(
                key: 'duration',
                label: l10n.sheetDuration,
                value: l10n.duration(e.durationSeconds!),
                down: e.durationSeconds! > RoutineEntryDraft.durationStep
                    ? () => _set(
                        e.copyWith(
                          durationSeconds:
                              e.durationSeconds! -
                              RoutineEntryDraft.durationStep,
                        ),
                      )
                    : null,
                up: () => _set(
                  e.copyWith(
                    durationSeconds:
                        e.durationSeconds! + RoutineEntryDraft.durationStep,
                  ),
                ),
              ),
            if (e.tracksWeight)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: TlSpace.s2),
                child: TextField(
                  key: const Key('sheet-weight'),
                  controller: _weight,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.sheetWeight,
                    suffixText: l10n.unitSymbol(widget.unit),
                  ),
                  onChanged: (v) => _set(
                    e.copyWith(
                      weight: () => parseDecimal(v),
                      weightUnit: widget.unit,
                    ),
                  ),
                ),
              ),
            stepper(
              key: 'rest',
              label: l10n.sheetRest,
              value: l10n.duration(e.restSeconds),
              down: e.restSeconds > 0
                  ? () => _set(
                      e.copyWith(
                        restSeconds: e.restSeconds - RoutineEntryDraft.restStep,
                      ),
                    )
                  : null,
              up: e.restSeconds < RoutineEntryDraft.maxRestSeconds
                  ? () => _set(
                      e.copyWith(
                        restSeconds: e.restSeconds + RoutineEntryDraft.restStep,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: TlSpace.s4),
            TlButton(
              key: const Key('sheet-done'),
              label: l10n.sheetDone,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
