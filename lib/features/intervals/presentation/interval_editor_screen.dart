import 'package:flutter/cupertino.dart' show CupertinoPicker;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/phase_glyph.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/section_label.dart';
import '../../../core/widgets/tl_button.dart';
import '../../../data/db/enums.dart';
import '../application/interval_providers.dart';
import '../application/interval_texts.dart';
import '../domain/interval_templates.dart';
import '../domain/interval_workout_draft.dart';
import '../domain/phase_plan.dart';

/// S04 Editor de intervalos (F-02): nombre, preparación y bloques. Un bloque
/// es un intervalo (calentamiento, trabajo, descanso o vuelta a la calma,
/// con etiqueta opcional) o una repetición de 1 a 99 rondas que puede
/// contener otra (2 niveles). La duración total se recalcula al instante.
/// Sin [workoutId] crea uno nuevo, vacío o a partir de [templateKey].
class IntervalEditorScreen extends ConsumerStatefulWidget {
  const IntervalEditorScreen({this.workoutId, this.templateKey, super.key});

  final String? workoutId;
  final String? templateKey;

  @override
  ConsumerState<IntervalEditorScreen> createState() =>
      _IntervalEditorScreenState();
}

class _IntervalEditorScreenState extends ConsumerState<IntervalEditorScreen> {
  static const _step = 5;

  final _name = TextEditingController();
  IntervalWorkoutDraft? _draft;
  var _saving = false;

  @override
  void initState() {
    super.initState();
    final id = widget.workoutId;
    if (id != null) {
      ref.read(intervalWorkoutRepositoryProvider).load(id).then((d) {
        if (!mounted) return;
        _name.text = d?.name ?? '';
        setState(() => _draft = d ?? IntervalWorkoutDraft.starter());
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_draft != null || widget.workoutId != null) return;
    final template = widget.templateKey == null
        ? null
        : IntervalTemplate.byKey(widget.templateKey!);
    if (template != null) {
      _draft = templateWorkout(context.l10n, template);
      _name.text = _draft!.name;
    } else {
      _draft = IntervalWorkoutDraft.starter();
    }
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _set(IntervalWorkoutDraft d) => setState(() => _draft = d);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final draft = _draft;
    if (draft == null) return const Scaffold(body: SizedBox.shrink());
    final errors = draft.errors;
    final total = WorkoutTotals.of(expandPhases(draft)).totalSeconds;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            TlSpace.s4,
            0,
            TlSpace.s4,
            TlSpace.s8,
          ),
          children: [
            ScreenHeader(
              title: widget.workoutId == null
                  ? l10n.editorNewTitle
                  : l10n.editorEditTitle,
              leading: IconButton(
                tooltip: l10n.backTooltip,
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            SectionLabel(l10n.fieldName),
            TextField(
              key: const Key('interval-name'),
              controller: _name,
              maxLength: IntervalWorkoutDraft.maxNameLength,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: _defaultName(context),
                counterText: '',
              ),
              onChanged: (v) => _set(draft.rename(v)),
            ),
            const SizedBox(height: TlSpace.s4),
            _Tile(
              child: _DurationRow(
                keyId: 'prep',
                type: PhaseType.prepare,
                seconds: draft.prepareSeconds,
                onMinus: draft.prepareSeconds > 0
                    ? () =>
                          _set(draft.withPrepare(draft.prepareSeconds - _step))
                    : null,
                onPlus:
                    draft.prepareSeconds <
                        IntervalWorkoutDraft.maxPrepareSeconds
                    ? () =>
                          _set(draft.withPrepare(draft.prepareSeconds + _step))
                    : null,
              ),
            ),
            for (final (i, n) in draft.blocks.indexed)
              _block(context, draft, [i], n, draft.blocks.length),
            const SizedBox(height: TlSpace.s2),
            TlButton(
              key: const Key('add-block'),
              label: l10n.editorAddBlock,
              icon: Icons.add,
              variant: TlButtonVariant.secondary,
              onPressed: () => _add(null),
            ),
            if (errors.isNotEmpty) ...[
              const SizedBox(height: TlSpace.s3),
              Semantics(
                liveRegion: true,
                child: Text(
                  _errorText(l10n, errors.first),
                  key: const Key('editor-error'),
                  style: t.bodySm.copyWith(color: c.danger),
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            TlSpace.s4,
            TlSpace.s2,
            TlSpace.s4,
            TlSpace.s4,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.editorTotal, style: t.overline),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        l10n.duration(total),
                        key: const Key('editor-total'),
                        style: t.headline,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TlButton(
                  key: const Key('interval-save'),
                  label: l10n.editorSave,
                  onPressed: errors.isEmpty && !_saving
                      ? () => _save(draft)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _block(
    BuildContext context,
    IntervalWorkoutDraft draft,
    List<int> path,
    IntervalNode node,
    int siblings,
  ) {
    final l10n = context.l10n;
    final id = path.join('-');
    final menu = _BlockMenu(
      keyId: id,
      canMoveUp: path.last > 0,
      canMoveDown: path.last < siblings - 1,
      canRename: node is IntervalStep,
      onSelected: (a) => _act(a, path),
    );
    switch (node) {
      case IntervalStep():
        return _Tile(
          child: _DurationRow(
            keyId: id,
            type: node.type,
            label: node.label,
            seconds: node.seconds,
            onMinus: node.seconds > IntervalStep.minSeconds
                ? () => _set(
                    draft.replaceAt(
                      path,
                      node.copyWith(seconds: node.seconds - _step),
                    ),
                  )
                : null,
            onPlus: node.seconds < IntervalStep.maxSeconds
                ? () => _set(
                    draft.replaceAt(
                      path,
                      node.copyWith(seconds: node.seconds + _step),
                    ),
                  )
                : null,
            onPickDuration: () => _pickDuration(path, node),
            trailing: menu,
          ),
        );
      case IntervalRepeat():
        final c = context.colors;
        final t = context.text;
        return Container(
          margin: const EdgeInsets.only(top: TlSpace.s2),
          padding: const EdgeInsets.fromLTRB(
            TlSpace.s3,
            TlSpace.s1,
            0,
            TlSpace.s2,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: c.accent, width: 2),
            borderRadius: BorderRadius.circular(TlRadius.lg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.repeatCaps,
                      style: t.overline.copyWith(color: c.ink),
                    ),
                  ),
                  menu,
                ],
              ),
              Row(
                children: [
                  _RoundButton(
                    key: Key('rounds-minus-$id'),
                    icon: Icons.remove,
                    tooltip: l10n.editorLessRounds,
                    onPressed: node.rounds > IntervalRepeat.minRounds
                        ? () => _set(
                            draft.replaceAt(
                              path,
                              node.copyWith(rounds: node.rounds - 1),
                            ),
                          )
                        : null,
                  ),
                  Expanded(
                    child: Text(
                      l10n.repeatRounds(node.rounds),
                      key: Key('rounds-$id'),
                      textAlign: TextAlign.center,
                      style: t.title,
                    ),
                  ),
                  _RoundButton(
                    key: Key('rounds-plus-$id'),
                    icon: Icons.add,
                    tooltip: l10n.editorMoreRounds,
                    onPressed: node.rounds < IntervalRepeat.maxRounds
                        ? () => _set(
                            draft.replaceAt(
                              path,
                              node.copyWith(rounds: node.rounds + 1),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: TlSpace.s3),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: TlSpace.s3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final (j, child) in node.children.indexed)
                      _block(
                        context,
                        draft,
                        [...path, j],
                        child,
                        node.children.length,
                      ),
                    const SizedBox(height: TlSpace.s1),
                    TlButton(
                      key: Key('add-to-$id'),
                      label: l10n.editorAddToRepeat,
                      icon: Icons.add,
                      variant: TlButtonVariant.text,
                      onPressed: () => _add(path),
                    ),
                    SwitchListTile(
                      key: Key('skip-last-$id'),
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.editorSkipLast, style: t.bodySm),
                      value: node.skipLastRest,
                      onChanged: (v) => _set(
                        draft.replaceAt(path, node.copyWith(skipLastRest: v)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
    }
  }

  Future<void> _add(List<int>? parent) async {
    final draft = _draft!;
    final depth = draft.depthOf(parent);
    final node = await showModalBottomSheet<IntervalNode>(
      context: context,
      showDragHandle: true,
      builder: (context) =>
          _AddSheet(allowRepeat: depth < IntervalWorkoutDraft.maxDepth),
    );
    if (node != null && mounted) _set(_draft!.append(parent, node));
  }

  void _act(_BlockAction action, List<int> path) {
    final draft = _draft!;
    switch (action) {
      case _BlockAction.rename:
        _rename(path, draft.nodeAt(path) as IntervalStep);
      case _BlockAction.up:
        _set(draft.move(path, -1));
      case _BlockAction.down:
        _set(draft.move(path, 1));
      case _BlockAction.remove:
        _set(draft.removeAt(path));
    }
  }

  Future<void> _rename(List<int> path, IntervalStep step) async {
    final l10n = context.l10n;
    final controller = TextEditingController(text: step.label ?? '');
    final label = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editorRename),
        content: TextField(
          key: const Key('label-field'),
          controller: controller,
          autofocus: true,
          maxLength: 30,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(hintText: l10n.editorLabelHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.dialogCancel),
          ),
          TextButton(
            key: const Key('label-ok'),
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text(l10n.dialogOk),
          ),
        ],
      ),
    );
    controller.dispose();
    if (label == null || !mounted) return;
    final clean = label.trim();
    _set(
      _draft!.replaceAt(
        path,
        step.copyWith(label: () => clean.isEmpty ? null : clean),
      ),
    );
  }

  Future<void> _pickDuration(List<int> path, IntervalStep step) async {
    final l10n = context.l10n;
    var minutes = step.seconds ~/ 60;
    var seconds = step.seconds % 60;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          l10n.editorDurationTitle(
            step.label ?? phaseTypeName(l10n, step.type),
          ),
        ),
        content: SizedBox(
          height: 180,
          child: Row(
            children: [
              _Wheel(
                label: l10n.editorMinutes,
                count: 100,
                initial: minutes,
                onChanged: (v) => minutes = v,
              ),
              _Wheel(
                label: l10n.editorSeconds,
                count: 60,
                initial: seconds,
                onChanged: (v) => seconds = v,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.dialogCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.dialogOk),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    _set(
      _draft!.replaceAt(path, step.copyWith(seconds: minutes * 60 + seconds)),
    );
  }

  String _defaultName(BuildContext context) => context.l10n.editorDefaultName(
    DateFormat.MMMd(context.locale.toLanguageTag()).format(DateTime.now()),
  );

  Future<void> _save(IntervalWorkoutDraft draft) async {
    setState(() => _saving = true);
    await ref
        .read(intervalWorkoutRepositoryProvider)
        .save(draft.rename(_name.text), fallbackName: _defaultName(context));
    if (mounted) context.pop();
  }
}

String _errorText(AppLocalizations l10n, IntervalDraftError e) => switch (e) {
  IntervalDraftError.noWork => l10n.editorErrorNoWork,
  IntervalDraftError.emptyRepeat ||
  IntervalDraftError.tooDeep => l10n.editorErrorEmptyRepeat,
  IntervalDraftError.tooLong => l10n.editorErrorTooLong,
};

class _Tile extends StatelessWidget {
  const _Tile({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: TlSpace.s2),
    child: Material(
      color: context.colors.surface1,
      borderRadius: BorderRadius.circular(TlRadius.lg),
      child: Padding(
        padding: const EdgeInsets.only(left: TlSpace.s3),
        child: child,
      ),
    ),
  );
}

/// Forma, nombre y − duración + de un intervalo (o de la preparación).
class _DurationRow extends StatelessWidget {
  const _DurationRow({
    required this.keyId,
    required this.type,
    required this.seconds,
    this.label,
    this.onMinus,
    this.onPlus,
    this.onPickDuration,
    this.trailing,
  });

  final String keyId;
  final PhaseType type;
  final int seconds;
  final String? label;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;
  final VoidCallback? onPickDuration;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final name = label ?? phaseTypeName(l10n, type);
    final glyph = type == PhaseType.prepare
        ? c.ink
        : c.phases.of(phaseOf(type)).background;
    return Row(
      children: [
        PhaseGlyph(phaseOf(type), color: glyph),
        const SizedBox(width: TlSpace.s2),
        Expanded(
          child: Text(name, style: t.body, overflow: TextOverflow.ellipsis),
        ),
        _RoundButton(
          key: Key('minus-$keyId'),
          icon: Icons.remove,
          tooltip: l10n.editorLess(name),
          onPressed: onMinus,
        ),
        InkWell(
          key: Key('duration-$keyId'),
          onTap: onPickDuration,
          borderRadius: BorderRadius.circular(TlRadius.md),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 64,
              minHeight: TlSize.touchMin,
            ),
            child: Center(child: Text(l10n.duration(seconds), style: t.title)),
          ),
        ),
        _RoundButton(
          key: Key('plus-$keyId'),
          icon: Icons.add,
          tooltip: l10n.editorMore(name),
          onPressed: onPlus,
        ),
        trailing ?? const SizedBox(width: TlSpace.s2),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    icon: Icon(icon),
    onPressed: onPressed,
    constraints: const BoxConstraints.tightFor(
      width: TlSize.touchMin,
      height: TlSize.touchMin,
    ),
  );
}

enum _BlockAction { rename, up, down, remove }

class _BlockMenu extends StatelessWidget {
  const _BlockMenu({
    required this.keyId,
    required this.canMoveUp,
    required this.canMoveDown,
    required this.canRename,
    required this.onSelected,
  });

  final String keyId;
  final bool canMoveUp;
  final bool canMoveDown;
  final bool canRename;
  final ValueChanged<_BlockAction> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopupMenuButton<_BlockAction>(
      key: Key('menu-$keyId'),
      tooltip: l10n.editorBlockActions,
      icon: const Icon(Icons.more_vert),
      onSelected: onSelected,
      itemBuilder: (context) => [
        if (canRename)
          PopupMenuItem(
            value: _BlockAction.rename,
            child: Text(l10n.editorRename),
          ),
        if (canMoveUp)
          PopupMenuItem(value: _BlockAction.up, child: Text(l10n.editorMoveUp)),
        if (canMoveDown)
          PopupMenuItem(
            value: _BlockAction.down,
            child: Text(l10n.editorMoveDown),
          ),
        PopupMenuItem(
          value: _BlockAction.remove,
          child: Text(l10n.editorRemove),
        ),
      ],
    );
  }
}

/// Hoja para agregar un bloque, con valores por defecto razonables.
class _AddSheet extends StatelessWidget {
  const _AddSheet({required this.allowRepeat});

  final bool allowRepeat;

  static const _defaults = {
    PhaseType.warmup: 300,
    PhaseType.work: 30,
    PhaseType.rest: 15,
    PhaseType.cooldown: 180,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TlSpace.s4),
            child: Text(l10n.editorAddTitle, style: context.text.title),
          ),
          for (final MapEntry(key: type, value: seconds) in _defaults.entries)
            ListTile(
              key: Key('add-${type.name}'),
              leading: PhaseGlyph(
                phaseOf(type),
                color: c.phases.of(phaseOf(type)).background,
                size: 18,
              ),
              title: Text(phaseTypeName(l10n, type)),
              trailing: Text(l10n.duration(seconds)),
              onTap: () =>
                  Navigator.of(context).pop(IntervalStep(type, seconds)),
            ),
          if (allowRepeat)
            ListTile(
              key: const Key('add-repeat'),
              leading: const Icon(Icons.repeat),
              title: Text(l10n.editorRepeat),
              trailing: Text(l10n.repeatRounds(4)),
              onTap: () => Navigator.of(context).pop(
                const IntervalRepeat(4, [
                  IntervalStep(PhaseType.work, 30),
                  IntervalStep(PhaseType.rest, 15),
                ]),
              ),
            ),
          const SizedBox(height: TlSpace.s2),
        ],
      ),
    );
  }
}

class _Wheel extends StatelessWidget {
  const _Wheel({
    required this.label,
    required this.count,
    required this.initial,
    required this.onChanged,
  });

  final String label;
  final int count;
  final int initial;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Expanded(
      child: Column(
        children: [
          Text(label, style: context.text.caption),
          Expanded(
            child: Semantics(
              label: label,
              child: CupertinoPicker(
                itemExtent: 40,
                scrollController: FixedExtentScrollController(
                  initialItem: initial,
                ),
                onSelectedItemChanged: onChanged,
                children: [
                  for (var i = 0; i < count; i++)
                    Center(
                      child: Text(
                        l10n.numberValue(i),
                        style: context.text.title,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
