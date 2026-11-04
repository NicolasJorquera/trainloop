import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/units/weight_unit.dart';
import '../../../core/widgets/tl_button.dart';
import '../../../core/widgets/tl_chip.dart';
import '../../../data/db/enums.dart';
import '../application/strength_texts.dart';
import '../domain/strength_rules.dart';

/// Lo que devuelve S11: los valores a guardar o quitar la serie.
sealed class SetEditResult {
  const SetEditResult();
}

class SetEditSave extends SetEditResult {
  const SetEditSave(this.values);

  final SetValues values;
}

class SetEditDelete extends SetEditResult {
  const SetEditDelete();
}

/// S11 Registro de serie: peso con ± del incremento del ejercicio (o
/// teclado), repeticiones con ±, RPE opcional (6–10 en pasos de 0,5) y tipo
/// de serie. El peso se escribe y se muestra en la unidad de la persona.
/// `null` = cerrar sin guardar.
Future<SetEditResult?> showSetEditor(
  BuildContext context, {
  required String heading,
  required String? previous,
  required ExerciseLogType logType,
  required SetValues initial,
  required WeightUnit unit,
  required double increment,
  required bool canDelete,
}) => showModalBottomSheet<SetEditResult>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  backgroundColor: context.colors.surface1,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(TlRadius.sheet)),
  ),
  builder: (context) => _SetEditor(
    heading: heading,
    previous: previous,
    logType: logType,
    initial: initial,
    unit: unit,
    increment: increment,
    canDelete: canDelete,
  ),
);

class _SetEditor extends StatefulWidget {
  const _SetEditor({
    required this.heading,
    required this.previous,
    required this.logType,
    required this.initial,
    required this.unit,
    required this.increment,
    required this.canDelete,
  });

  final String heading;
  final String? previous;
  final ExerciseLogType logType;
  final SetValues initial;
  final WeightUnit unit;
  final double increment;
  final bool canDelete;

  @override
  State<_SetEditor> createState() => _SetEditorState();
}

class _SetEditorState extends State<_SetEditor> {
  static const _durationStep = 5;

  final _weight = TextEditingController();
  final _reps = TextEditingController();
  late SetValues _v;

  @override
  void initState() {
    super.initState();
    // Todo se edita en la unidad de la persona.
    _v = widget.initial.copyWith(
      weight: () => widget.initial.weightIn(widget.unit),
      unit: widget.unit,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_weight.text.isEmpty && _v.weight != null) {
      _weight.text = context.l10n.decimal(_v.weight!);
    }
    if (_reps.text.isEmpty && _v.reps != null) _reps.text = '${_v.reps}';
  }

  @override
  void dispose() {
    _weight.dispose();
    _reps.dispose();
    super.dispose();
  }

  void _stepWeight(double delta) {
    final next = roundWeight(((_v.weight ?? 0) + delta).clamp(0, 1e6));
    setState(() => _v = _v.copyWith(weight: () => next));
    _weight.text = context.l10n.decimal(next);
  }

  void _stepReps(int delta) {
    final next = ((_v.reps ?? 0) + delta).clamp(0, SetLimits.maxReps);
    setState(() => _v = _v.copyWith(reps: () => next));
    _reps.text = '$next';
  }

  void _stepDuration(int delta) {
    final next = ((_v.durationSeconds ?? 0) + delta).clamp(
      0,
      SetLimits.maxDurationSeconds,
    );
    setState(() => _v = _v.copyWith(durationSeconds: () => next));
  }

  String? _error(AppLocalizations l10n, List<SetError> errors) {
    if (errors.isEmpty) return null;
    return switch (errors.first) {
      SetError.weightRange => l10n.setErrorWeightRange(
        l10n.weight(
          roundWeight(
            widget.unit.convertFrom(SetLimits.maxWeightKg, WeightUnit.kg),
          ),
          widget.unit,
        ),
      ),
      SetError.weightStep => l10n.setErrorWeightStep(
        l10n.decimal(SetLimits.weightStep),
      ),
      SetError.repsRange => l10n.setErrorReps(SetLimits.maxReps),
      SetError.rpeRange => l10n.setErrorRpe,
      SetError.durationRange => l10n.setErrorDuration,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final type = widget.logType;
    final errors = validateSet(type, _v);
    final error = _error(l10n, errors);
    final complete = canLogDirectly(type, _v);
    final inc = l10n.decimal(widget.increment);
    final unitLabel = l10n.unitSymbol(widget.unit);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          TlSpace.s4,
          TlSpace.s2,
          TlSpace.s4,
          TlSpace.s6,
        ),
        child: Column(
          key: const Key('set-editor'),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(widget.heading, style: t.headline),
                  ),
                ),
                if (widget.canDelete)
                  IconButton(
                    key: const Key('set-delete'),
                    tooltip: l10n.strengthRemoveSet,
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () =>
                        Navigator.of(context).pop(const SetEditDelete()),
                  ),
                IconButton(
                  key: const Key('set-close'),
                  tooltip: l10n.strengthCloseNoSave,
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            if (widget.previous != null)
              Text(
                l10n.strengthLastTime(widget.previous!),
                key: const Key('set-previous'),
                style: t.body.copyWith(color: c.inkMuted),
              ),
            if (type.tracksWeight) ...[
              _Label(l10n.strengthWeightLabel(unitLabel.toUpperCase())),
              _ValueRow(
                minusKey: const Key('weight-minus'),
                plusKey: const Key('weight-plus'),
                minusLabel: l10n.setStepMinus(inc),
                plusLabel: l10n.setStepPlus(inc),
                minusTooltip: l10n.strengthWeightMinus(
                  l10n.weight(widget.increment, widget.unit),
                ),
                plusTooltip: l10n.strengthWeightPlus(
                  l10n.weight(widget.increment, widget.unit),
                ),
                onMinus: () => _stepWeight(-widget.increment),
                onPlus: () => _stepWeight(widget.increment),
                error:
                    errors.contains(SetError.weightRange) ||
                    errors.contains(SetError.weightStep),
                child: TextField(
                  key: const Key('weight-field'),
                  controller: _weight,
                  textAlign: TextAlign.center,
                  style: t.displayXl.copyWith(fontSize: 40),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: l10n.strengthNoValue,
                    semanticCounterText: unitLabel,
                  ),
                  onChanged: (text) => setState(
                    () => _v = _v.copyWith(weight: () => parseDecimal(text)),
                  ),
                ),
              ),
            ],
            if (type.tracksReps) ...[
              _Label(l10n.strengthRepsLabel),
              _ValueRow(
                minusKey: const Key('reps-minus'),
                plusKey: const Key('reps-plus'),
                minusLabel: l10n.setStepMinusOne,
                plusLabel: l10n.setStepPlusOne,
                minusTooltip: l10n.strengthRepsMinus,
                plusTooltip: l10n.strengthRepsPlus,
                onMinus: () => _stepReps(-1),
                onPlus: () => _stepReps(1),
                error: errors.contains(SetError.repsRange),
                child: TextField(
                  key: const Key('reps-field'),
                  controller: _reps,
                  textAlign: TextAlign.center,
                  style: t.displayXl.copyWith(fontSize: 40),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: l10n.strengthNoValue,
                  ),
                  onChanged: (text) => setState(
                    () => _v = _v.copyWith(reps: () => int.tryParse(text)),
                  ),
                ),
              ),
            ],
            if (type.tracksTime) ...[
              _Label(l10n.strengthTimeLabel),
              _ValueRow(
                minusKey: const Key('time-minus'),
                plusKey: const Key('time-plus'),
                minusLabel: l10n.setStepMinusSeconds(_durationStep),
                plusLabel: l10n.setStepPlusSeconds(_durationStep),
                minusTooltip: l10n.strengthTimeMinus(_durationStep),
                plusTooltip: l10n.strengthTimePlus(_durationStep),
                onMinus: () => _stepDuration(-_durationStep),
                onPlus: () => _stepDuration(_durationStep),
                error: errors.contains(SetError.durationRange),
                child: Center(
                  child: Text(
                    _v.durationSeconds == null
                        ? l10n.strengthNoValue
                        : l10n.duration(_v.durationSeconds!),
                    key: const Key('time-value'),
                    style: t.displayXl.copyWith(fontSize: 40),
                  ),
                ),
              ),
            ],
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: TlSpace.s2),
                child: Text(
                  error,
                  key: const Key('set-error'),
                  style: t.bodySm.copyWith(color: c.danger),
                ),
              ),
            _Label(l10n.strengthRpeLabel),
            Wrap(
              spacing: TlSpace.s1,
              runSpacing: TlSpace.s1,
              children: [
                for (final r in SetLimits.rpeValues)
                  TlChip(
                    key: Key('rpe-${r.toString()}'),
                    label: l10n.decimalText(l10n.decimal(r)),
                    selected: _v.rpe == r,
                    onTap: () => setState(
                      () => _v = _v.copyWith(rpe: () => _v.rpe == r ? null : r),
                    ),
                  ),
              ],
            ),
            _Label(l10n.strengthSetTypeLabel),
            Wrap(
              spacing: TlSpace.s1,
              runSpacing: TlSpace.s1,
              children: [
                for (final st in [
                  SetType.warmup,
                  SetType.normal,
                  SetType.failure,
                  SetType.drop,
                ])
                  TlChip(
                    key: Key('set-type-${st.name}'),
                    label: setTypeName(l10n, st),
                    selected: _v.type == st,
                    onTap: () => setState(() => _v = _v.copyWith(type: st)),
                  ),
              ],
            ),
            const SizedBox(height: TlSpace.s6),
            TlButton(
              key: const Key('set-save'),
              label: l10n.strengthSaveSet,
              onPressed: errors.isEmpty && complete
                  ? () => Navigator.of(context).pop(SetEditSave(_v))
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: TlSpace.s4, bottom: TlSpace.s2),
    child: Text(
      text,
      style: context.text.overline.copyWith(color: context.colors.inkMuted),
    ),
  );
}

/// Fila de valor con − y + grandes (≥ 64 dp durante la sesión, NF-08).
class _ValueRow extends StatelessWidget {
  const _ValueRow({
    required this.minusKey,
    required this.plusKey,
    required this.minusLabel,
    required this.plusLabel,
    required this.minusTooltip,
    required this.plusTooltip,
    required this.onMinus,
    required this.onPlus,
    required this.child,
    this.error = false,
  });

  final Key minusKey;
  final Key plusKey;
  final String minusLabel;
  final String plusLabel;
  final String minusTooltip;
  final String plusTooltip;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final Widget child;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        _StepButton(
          key: minusKey,
          label: minusLabel,
          tooltip: minusTooltip,
          onTap: onMinus,
        ),
        const SizedBox(width: TlSpace.s2),
        Expanded(
          child: Container(
            height: TlSize.touchSession,
            decoration: BoxDecoration(
              color: error ? c.danger.withValues(alpha: 0.15) : c.surface2,
              borderRadius: BorderRadius.circular(TlRadius.md),
              border: error ? Border.all(color: c.danger, width: 2) : null,
            ),
            alignment: Alignment.center,
            child: child,
          ),
        ),
        const SizedBox(width: TlSpace.s2),
        _StepButton(
          key: plusKey,
          label: plusLabel,
          tooltip: plusTooltip,
          onTap: onPlus,
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.label,
    required this.tooltip,
    required this.onTap,
    super.key,
  });

  final String label;
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
        color: c.surface2,
        borderRadius: BorderRadius.circular(TlRadius.md),
        child: InkWell(
          borderRadius: BorderRadius.circular(TlRadius.md),
          onTap: onTap,
          child: SizedBox(
            width: 72,
            height: TlSize.touchSession,
            child: Center(
              child: Text(
                label,
                style: context.text.title.copyWith(color: c.ink),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
