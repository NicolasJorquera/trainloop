import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/section_label.dart';
import '../../../core/widgets/tab_page.dart';
import '../../../core/widgets/tl_button.dart';
import '../../../core/widgets/tl_chip.dart';
import '../../../core/widgets/tl_stepper.dart';
import '../../../data/db/app_database.dart';
import '../../../data/db/enums.dart';
import '../../settings/application/settings_controller.dart';
import '../application/exercise_providers.dart';
import '../domain/exercise_draft.dart';
import '../domain/exercise_names.dart';
import 'exercise_labels.dart';

/// S09 Crear o editar un ejercicio propio. Si el nombre ya existe (también
/// el de un ejercicio incluido en cualquier idioma) avisa, no deja guardar
/// y ofrece usar el existente. Al cerrar devuelve el ejercicio elegido.
class ExerciseFormScreen extends ConsumerStatefulWidget {
  const ExerciseFormScreen({this.exerciseId, this.initialName = '', super.key});

  /// `null` para crear uno nuevo.
  final String? exerciseId;
  final String initialName;

  @override
  ConsumerState<ExerciseFormScreen> createState() => _ExerciseFormScreenState();
}

class _ExerciseFormScreenState extends ConsumerState<ExerciseFormScreen> {
  late final TextEditingController _name;
  final _increment = TextEditingController();
  ExerciseDraft? _draft;
  var _saving = false;
  var _incrementFilled = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initialName);
    final unit = ref.read(settingsControllerProvider).weightUnit;
    final id = widget.exerciseId;
    if (id == null) {
      _draft = ExerciseDraft.initial(widget.initialName, unit);
    } else {
      ref.read(exerciseRepositoryProvider).findById(id).then((e) {
        if (e == null || !mounted) return;
        _name.text = e.name;
        _setDraft(ExerciseDraft.from(e, unit));
      });
    }
  }

  void _setDraft(ExerciseDraft d) {
    setState(() => _draft = d);
    _fillIncrement();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fillIncrement();
  }

  /// Escribe el incremento con el separador decimal del idioma (una vez).
  void _fillIncrement() {
    final draft = _draft;
    if (_incrementFilled || draft == null) return;
    _incrementFilled = true;
    final inc = draft.increment;
    if (inc != null) _increment.text = context.l10n.decimal(inc);
  }

  @override
  void dispose() {
    _name.dispose();
    _increment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final draft = _draft;
    final library = ref.watch(exerciseLibraryProvider).value ?? const [];
    final duplicate = draft == null
        ? null
        : findDuplicateExercise(
            draft.name,
            library,
            ignoreId: widget.exerciseId,
          );
    final canSave =
        draft != null && draft.hasValidName && duplicate == null && !_saving;

    return Scaffold(
      body: draft == null
          ? const SizedBox.shrink()
          : TabPage(
              children: [
                ScreenHeader(
                  title: widget.exerciseId == null
                      ? l10n.exerciseCreateTitle
                      : l10n.exerciseEditTitle,
                  leading: IconButton(
                    tooltip: l10n.backTooltip,
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                  trailing: widget.exerciseId == null
                      ? null
                      : IconButton(
                          key: const Key('exercise-archive'),
                          tooltip: l10n.exerciseArchive,
                          icon: const Icon(Icons.archive_outlined),
                          onPressed: _archive,
                        ),
                ),
                SectionLabel(l10n.fieldName),
                TextField(
                  key: const Key('exercise-name'),
                  controller: _name,
                  autofocus: widget.exerciseId == null,
                  maxLength: ExerciseDraft.maxNameLength,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: l10n.exerciseNameHint,
                    counterText: '',
                  ),
                  onChanged: (v) =>
                      setState(() => _draft = draft.copyWith(name: v)),
                ),
                if (duplicate != null) _DuplicateWarning(duplicate),
                SectionLabel(l10n.exerciseTrackLabel),
                Wrap(
                  spacing: TlSpace.s2,
                  runSpacing: TlSpace.s2,
                  children: [
                    for (final type in ExerciseLogType.values)
                      TlChip(
                        key: Key('logtype-${type.name}'),
                        label: l10n.logType(type),
                        selected: draft.logType == type,
                        onTap: () => setState(
                          () => _draft = draft.copyWith(logType: type),
                        ),
                      ),
                  ],
                ),
                SectionLabel(l10n.exerciseMuscleLabel),
                _EnumDropdown<Muscle>(
                  key: const Key('exercise-muscle'),
                  label: l10n.exerciseMuscleLabel,
                  values: Muscle.values,
                  value: draft.muscle,
                  labelOf: l10n.muscle,
                  onChanged: (m) =>
                      setState(() => _draft = draft.copyWith(muscle: m)),
                ),
                SectionLabel(l10n.exerciseEquipmentLabel),
                _EnumDropdown<Equipment>(
                  key: const Key('exercise-equipment'),
                  label: l10n.exerciseEquipmentLabel,
                  values: Equipment.values,
                  value: draft.equipment,
                  labelOf: l10n.equipment,
                  onChanged: (e) =>
                      setState(() => _draft = draft.copyWith(equipment: e)),
                ),
                if (draft.tracksWeight) ...[
                  SectionLabel(l10n.exerciseIncrementLabel),
                  TextField(
                    key: const Key('exercise-increment'),
                    controller: _increment,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      suffixText: l10n.unitSymbol(draft.unit),
                    ),
                    onChanged: (v) => setState(
                      () => _draft = draft.copyWith(
                        increment: () => parseDecimal(v),
                      ),
                    ),
                  ),
                ],
                SectionLabel(l10n.exerciseRestLabel),
                TlStepper(
                  label: l10n.sheetRest,
                  value: l10n.duration(draft.restSeconds),
                  decreaseTooltip: l10n.stepperDecrease(l10n.sheetRest),
                  increaseTooltip: l10n.stepperIncrease(l10n.sheetRest),
                  onDecrease: draft.restSeconds > 0
                      ? () => setState(
                          () => _draft = draft.copyWith(
                            restSeconds: draft.restSeconds - 15,
                          ),
                        )
                      : null,
                  onIncrease: draft.restSeconds < ExerciseDraft.maxRestSeconds
                      ? () => setState(
                          () => _draft = draft.copyWith(
                            restSeconds: draft.restSeconds + 15,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: TlSpace.s6),
                TlButton(
                  key: const Key('exercise-save'),
                  label: l10n.exerciseSave,
                  onPressed: canSave ? () => _save(draft) : null,
                ),
              ],
            ),
    );
  }

  Future<void> _save(ExerciseDraft draft) async {
    setState(() => _saving = true);
    final saved = await ref
        .read(exerciseRepositoryProvider)
        .saveCustom(draft, id: widget.exerciseId);
    if (mounted) context.pop(saved);
  }

  Future<void> _archive() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    await ref.read(exerciseRepositoryProvider).archive(widget.exerciseId!);
    messenger.showSnackBar(SnackBar(content: Text(l10n.exerciseArchived)));
    if (mounted) context.pop();
  }
}

/// Aviso de duplicado con el atajo para usar el ejercicio existente.
class _DuplicateWarning extends StatelessWidget {
  const _DuplicateWarning(this.existing);

  final Exercise existing;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final name = exerciseName(existing, context.locale);
    return Padding(
      padding: const EdgeInsets.only(top: TlSpace.s2),
      child: Semantics(
        liveRegion: true,
        child: Container(
          key: const Key('exercise-duplicate'),
          padding: const EdgeInsets.all(TlSpace.s3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TlRadius.md),
            border: Border.all(color: c.warning),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.exerciseDuplicate(name),
                style: context.text.bodySm.copyWith(color: c.warning),
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  key: const Key('exercise-use-existing'),
                  onPressed: () => context.pop(existing),
                  child: Text(l10n.exerciseUseExisting(name)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EnumDropdown<T extends Enum> extends StatelessWidget {
  const _EnumDropdown({
    required this.label,
    required this.values,
    required this.value,
    required this.labelOf,
    required this.onChanged,
    super.key,
  });

  final String label;
  final List<T> values;
  final T value;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    child: DropdownButtonFormField<T>(
      initialValue: value,
      dropdownColor: context.colors.surface2,
      items: [
        for (final v in values)
          DropdownMenuItem(value: v, child: Text(labelOf(v))),
      ],
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    ),
  );
}
