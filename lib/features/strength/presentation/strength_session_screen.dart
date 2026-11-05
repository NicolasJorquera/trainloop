import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/units/weight_unit.dart';
import '../../../data/db/app_database.dart';
import '../../../data/db/enums.dart';
import '../../../platform/timer_engine_client.dart';
import '../../exercises/domain/exercise_names.dart';
import '../../intervals/application/interval_providers.dart';
import '../../settings/application/settings_controller.dart';
import '../application/strength_session_controller.dart';
import '../application/strength_texts.dart';
import '../data/strength_session_repository.dart';
import '../domain/strength_rules.dart';
import '../domain/strength_session.dart';
import 'set_editor_sheet.dart';
import 'strength_dialogs.dart';

/// S10 Sesión de fuerza (F-08): rutina, tiempo y series hechas arriba con
/// TERMINAR; el descanso automático (F-09) en una franja del color del
/// descanso con −15, +15 y SALTAR; y cada ejercicio con sus series: la
/// última marca (ANTERIOR), los valores propuestos en gris y ✓ para
/// guardarlos con 1 toque. Tocar peso o reps abre S11. Volver deja la
/// sesión en curso (Inicio la muestra).
class StrengthSessionScreen extends ConsumerStatefulWidget {
  const StrengthSessionScreen({super.key});

  @override
  ConsumerState<StrengthSessionScreen> createState() =>
      _StrengthSessionScreenState();
}

class _StrengthSessionScreenState extends ConsumerState<StrengthSessionScreen> {
  var _left = false;
  var _busy = false;

  StrengthEnv get _env =>
      StrengthEnv.of(context, ref.read(settingsControllerProvider));

  @override
  Widget build(BuildContext context) {
    final active = ref.watch(strengthSessionProvider);
    if (active == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_left) context.go(Routes.home);
      });
      return const Scaffold(body: SizedBox.shrink());
    }
    final id = active.sessionId;
    ref.listen(strengthSessionDataProvider(id), (_, next) {
      final data = next.value;
      if (data != null) {
        ref.read(strengthSessionProvider.notifier).syncNotification(data, _env);
      }
    });
    final data = ref.watch(strengthSessionDataProvider(id)).value;
    final l10n = context.l10n;
    final c = context.colors;
    if (data == null) {
      return Scaffold(backgroundColor: c.bg, body: const SizedBox.shrink());
    }
    final unit = ref.watch(settingsControllerProvider).weightUnit;

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(data: data, onFinish: _busy ? null : () => _finish(data)),
            _RestBanner(active: active),
            Expanded(
              child: ListView(
                key: const Key('strength-list'),
                padding: const EdgeInsets.fromLTRB(
                  TlSpace.s3,
                  TlSpace.s3,
                  TlSpace.s3,
                  TlSpace.s8,
                ),
                children: [
                  for (final (i, e) in data.exercises.indexed)
                    Padding(
                      padding: const EdgeInsets.only(bottom: TlSpace.s3),
                      child: _ExerciseCard(
                        key: ValueKey(e.id),
                        item: e,
                        unit: unit,
                        isFirst: i == 0,
                        isLast: i == data.exercises.length - 1,
                        onSet: (s) => _editSet(data, e, s),
                        onCheck: (s) => _check(data, e, s),
                        onAddSet: () => ref
                            .read(strengthSessionRepositoryProvider)
                            .addSet(e.id),
                        onRepeat: () => ref
                            .read(strengthSessionProvider.notifier)
                            .repeatLastSet(data, e, _env),
                        onAction: (a) => _exerciseAction(data, i, e, a),
                      ),
                    ),
                  _AddExerciseButton(onTap: () => _addExercises(data)),
                  if (data.exercises.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: TlSpace.s4),
                      child: Text(
                        l10n.strengthEmptyHint,
                        textAlign: TextAlign.center,
                        style: context.text.bodySm.copyWith(color: c.inkMuted),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ✓: guarda la serie con sus valores propuestos (1 toque, R-G3) o la
  /// desmarca si ya estaba hecha. Sin valores, abre S11.
  Future<void> _check(
    StrengthSessionData data,
    SessionExerciseItem e,
    SessionSet s,
  ) async {
    final controller = ref.read(strengthSessionProvider.notifier);
    if (s.completed) {
      await controller.uncompleteSet(s);
      return;
    }
    final v = s.proposed;
    if (!canLogDirectly(e.exercise.logType, v) ||
        validateSet(e.exercise.logType, v).isNotEmpty) {
      await _editSet(data, e, s);
      return;
    }
    await controller.completeSet(data, e, s, v, _env);
  }

  /// S11: editar y guardar (marca la serie como hecha) o quitarla.
  Future<void> _editSet(
    StrengthSessionData data,
    SessionExerciseItem e,
    SessionSet s,
  ) async {
    final l10n = context.l10n;
    final unit = ref.read(settingsControllerProvider).weightUnit;
    final name = exerciseName(e.exercise, context.locale);
    final prev = s.previous;
    final result = await showSetEditor(
      context,
      heading: setHeading(l10n, name, s),
      previous: prev == null
          ? null
          : setValuesText(
              l10n,
              e.exercise.logType,
              SetValues.ofLog(prev),
              unit,
            ),
      logType: e.exercise.logType,
      initial: s.proposed.copyWith(rpe: () => s.log.rpe),
      unit: unit,
      increment: incrementFor(e.exercise, unit),
      canDelete: e.sets.length > 1,
    );
    if (!mounted || result == null) return;
    final controller = ref.read(strengthSessionProvider.notifier);
    switch (result) {
      case SetEditDelete():
        await ref.read(strengthSessionRepositoryProvider).removeSet(s.id);
      case SetEditSave(:final values):
        await controller.completeSet(data, e, s, values, _env);
    }
  }

  Future<void> _addExercises(StrengthSessionData data) async {
    final picked = await context.push<List<Exercise>>(Routes.exercisesPick);
    if (picked == null || picked.isEmpty) return;
    await ref
        .read(strengthSessionRepositoryProvider)
        .addExercises(data.id, picked);
  }

  Future<void> _exerciseAction(
    StrengthSessionData data,
    int index,
    SessionExerciseItem e,
    _ExerciseAction action,
  ) async {
    final repo = ref.read(strengthSessionRepositoryProvider);
    switch (action) {
      case _ExerciseAction.notes:
        final notes = await showNotesDialog(context, e.entry.notes);
        if (notes != null) await repo.setNotes(e.id, notes);
      case _ExerciseAction.up:
        await repo.moveExercise(data.id, index, index - 1);
      case _ExerciseAction.down:
        await repo.moveExercise(data.id, index, index + 1);
      case _ExerciseAction.remove:
        if (e.completedCount > 0 &&
            !await showRemoveExerciseDialog(
              context,
              exerciseName(e.exercise, context.locale),
            )) {
          return;
        }
        await repo.removeExercise(e.id);
    }
  }

  /// TERMINAR: sin series hechas propone descartar (R-G11); con series sin
  /// marcar pregunta qué hacer (R-G10); después abre el resumen.
  Future<void> _finish(StrengthSessionData data) async {
    final controller = ref.read(strengthSessionProvider.notifier);
    if (data.completedSets == 0) {
      if (!await showNoSetsDialog(context)) return;
      _left = true;
      await controller.discard();
      if (mounted) context.go(Routes.home);
      return;
    }
    var pending = PendingSets.discard;
    if (data.pendingSets > 0) {
      final choice = await showPendingSetsDialog(context, data.pendingSets);
      if (choice == null) return;
      pending = choice;
    }
    setState(() => _busy = true);
    _left = true;
    final status = await controller.finish(pending: pending);
    if (!mounted) return;
    if (status == SessionStatus.discarded) {
      context.go(Routes.home);
    } else {
      context.go(Routes.strengthSummary(data.id));
    }
  }
}

/// Repinta [builder] cada [period] mientras [active] (tiempo de la sesión y
/// cuenta regresiva del descanso).
class _Ticking extends StatefulWidget {
  const _Ticking({
    required this.builder,
    this.period = const Duration(seconds: 1),
    this.active = true,
  });

  final WidgetBuilder builder;
  final Duration period;
  final bool active;

  @override
  State<_Ticking> createState() => _TickingState();
}

class _TickingState extends State<_Ticking> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(_Ticking old) {
    super.didUpdateWidget(old);
    _sync();
  }

  void _sync() {
    if (widget.active && _timer == null) {
      _timer = Timer.periodic(widget.period, (_) => setState(() {}));
    } else if (!widget.active) {
      _timer?.cancel();
      _timer = null;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context);
}

class _Header extends StatelessWidget {
  const _Header({required this.data, required this.onFinish});

  final StrengthSessionData data;
  final VoidCallback? onFinish;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    return Container(
      color: c.surface1,
      padding: const EdgeInsets.fromLTRB(
        TlSpace.s1,
        TlSpace.s2,
        TlSpace.s3,
        TlSpace.s2,
      ),
      child: Row(
        children: [
          IconButton(
            key: const Key('strength-back'),
            // NF-08: 64 dp durante la sesión.
            constraints: const BoxConstraints.tightFor(
              width: TlSize.touchSession,
              height: TlSize.touchSession,
            ),
            tooltip: l10n.backTooltip,
            icon: const Icon(Icons.arrow_back),
            onPressed: () =>
                context.canPop() ? context.pop() : context.go(Routes.home),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    sessionTitle(l10n, data.title).toUpperCase(),
                    key: const Key('strength-title'),
                    style: t.headline.copyWith(fontSize: 24),
                  ),
                ),
                _Ticking(
                  builder: (context) {
                    final elapsed = DateTime.now()
                        .toUtc()
                        .difference(data.session.startedAt)
                        .inSeconds
                        .clamp(0, 359999);
                    return Text(
                      l10n.summaryJoin(
                        l10n.duration(elapsed),
                        progressText(l10n, data),
                      ),
                      key: const Key('strength-progress'),
                      style: t.bodySm.copyWith(
                        color: c.inkMuted,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: TlSpace.s2),
          Semantics(
            button: true,
            child: Material(
              color: c.primaryBg,
              borderRadius: BorderRadius.circular(TlRadius.md),
              child: InkWell(
                key: const Key('strength-finish'),
                borderRadius: BorderRadius.circular(TlRadius.md),
                onTap: onFinish,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: TlSize.touchSession,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: TlSpace.s4),
                    child: Center(
                      widthFactor: 1,
                      child: Text(
                        l10n.strengthFinish,
                        style: t.button.copyWith(color: c.primaryInk),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Franja del descanso (color de la fase de descanso) o, al terminar, "¡A
/// la siguiente serie!" durante 3 s.
class _RestBanner extends ConsumerWidget {
  const _RestBanner({required this.active});

  final ActiveStrength active;

  static const _doneVisible = Duration(seconds: 3);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engine = active.engine;
    final ended = active.restEndedAt;
    final clock = ref.read(timerEngineClientProvider).clock;
    bool showDone() => ended != null && clock() - ended < _doneVisible;
    return _Ticking(
      period: const Duration(milliseconds: 250),
      active: active.resting || showDone(),
      builder: (context) {
        if (engine != null && engine.resting) {
          return _RestBar(engine: engine, clock: clock);
        }
        if (showDone()) {
          final c = context.colors;
          return Semantics(
            liveRegion: true,
            child: Container(
              key: const Key('rest-done'),
              constraints: const BoxConstraints(minHeight: 56),
              color: c.successSoft,
              padding: const EdgeInsets.symmetric(horizontal: TlSpace.s4),
              alignment: Alignment.centerLeft,
              child: Text(
                context.l10n.strengthRestOver.toUpperCase(),
                style: context.text.title.copyWith(color: c.success),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _RestBar extends ConsumerWidget {
  const _RestBar({required this.engine, required this.clock});

  final StrengthEngineState engine;
  final Duration Function() clock;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final t = context.text;
    final phase = context.colors.phases.rest;
    final ink = phase.ink;
    final controller = ref.read(strengthSessionProvider.notifier);
    final seconds = (engine.restRemainingAt(clock()) / 1000).ceil();
    return Semantics(
      container: true,
      label: l10n.strengthRestRemaining(l10n.duration(seconds)),
      child: Container(
        key: const Key('rest-bar'),
        color: phase.background,
        padding: const EdgeInsets.symmetric(
          horizontal: TlSpace.s4,
          vertical: TlSpace.s2,
        ),
        child: Row(
          children: [
            Expanded(
              child: ExcludeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.strengthRestLabel,
                      style: t.overline.copyWith(color: ink),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.duration(seconds),
                        key: const Key('rest-remaining'),
                        style: t.displayXl.copyWith(
                          fontSize: 52,
                          height: 0.95,
                          color: ink,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Con textos largos (pseudo-locale, letra grande) los botones
            // pasan a una segunda fila en vez de achicarse.
            Flexible(
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: TlSpace.s2,
                runSpacing: TlSpace.s2,
                children: [
                  _RestButton(
                    key: const Key('rest-minus'),
                    label: l10n.strengthMinus15,
                    tooltip: l10n.strengthMinus15Tooltip,
                    ink: ink,
                    onTap: () => controller.adjustRest(-restStepSeconds),
                  ),
                  _RestButton(
                    key: const Key('rest-plus'),
                    label: l10n.strengthPlus15,
                    tooltip: l10n.strengthPlus15Tooltip,
                    ink: ink,
                    onTap: () => controller.adjustRest(restStepSeconds),
                  ),
                  _RestButton(
                    key: const Key('rest-skip'),
                    label: l10n.strengthSkipRest,
                    tooltip: l10n.strengthSkipRestTooltip,
                    ink: phase.background,
                    background: ink,
                    onTap: controller.skipRest,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RestButton extends StatelessWidget {
  const _RestButton({
    required this.label,
    required this.tooltip,
    required this.ink,
    required this.onTap,
    this.background,
    super.key,
  });

  final String label;
  final String tooltip;
  final Color ink;
  final Color? background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: tooltip,
    excludeSemantics: true,
    child: Material(
      color: background ?? ink.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TlRadius.md),
        side: background == null
            ? BorderSide(color: ink, width: 2)
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 56,
            minHeight: TlSize.touchSession,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: TlSpace.s2),
            child: Center(
              widthFactor: 1,
              child: Text(
                label,
                style: context.text.title.copyWith(color: ink),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

enum _ExerciseAction { notes, up, down, remove }

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({
    required this.item,
    required this.unit,
    required this.isFirst,
    required this.isLast,
    required this.onSet,
    required this.onCheck,
    required this.onAddSet,
    required this.onRepeat,
    required this.onAction,
    super.key,
  });

  final SessionExerciseItem item;
  final WeightUnit unit;
  final bool isFirst;
  final bool isLast;
  final ValueChanged<SessionSet> onSet;
  final ValueChanged<SessionSet> onCheck;
  final VoidCallback onAddSet;
  final VoidCallback onRepeat;
  final ValueChanged<_ExerciseAction> onAction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final name = exerciseName(item.exercise, context.locale);
    final type = item.exercise.logType;
    final notes = item.entry.notes;
    final labelStyle = t.overline.copyWith(color: c.inkMuted);
    return Container(
      key: Key('exercise-card-${item.exercise.catalogKey ?? item.exercise.id}'),
      decoration: BoxDecoration(
        color: c.surface1,
        borderRadius: BorderRadius.circular(TlRadius.lg),
      ),
      padding: const EdgeInsets.fromLTRB(
        TlSpace.s2,
        TlSpace.s2,
        TlSpace.s2,
        TlSpace.s2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const SizedBox(width: TlSpace.s2),
              Expanded(
                child: Text(
                  name.toUpperCase(),
                  style: t.title.copyWith(color: c.accent),
                ),
              ),
              const SizedBox(width: TlSpace.s2),
              Flexible(
                flex: 0,
                child: Text(
                  l10n.strengthRestFor(l10n.duration(item.restSeconds)),
                  textAlign: TextAlign.end,
                  style: t.bodySm.copyWith(color: c.inkMuted),
                ),
              ),
              PopupMenuButton<_ExerciseAction>(
                key: Key('exercise-menu-${item.id}'),
                tooltip: l10n.strengthExerciseActions(name),
                icon: const Icon(Icons.more_vert),
                // NF-08: 64 dp durante la sesión.
                style: IconButton.styleFrom(
                  minimumSize: const Size.square(TlSize.touchSession),
                ),
                iconSize: 28,
                onSelected: onAction,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: _ExerciseAction.notes,
                    child: Text(l10n.strengthNotesTitle),
                  ),
                  if (!isFirst)
                    PopupMenuItem(
                      value: _ExerciseAction.up,
                      child: Text(l10n.strengthMoveUp),
                    ),
                  if (!isLast)
                    PopupMenuItem(
                      value: _ExerciseAction.down,
                      child: Text(l10n.strengthMoveDown),
                    ),
                  PopupMenuItem(
                    value: _ExerciseAction.remove,
                    child: Text(l10n.strengthRemoveExercise),
                  ),
                ],
              ),
            ],
          ),
          if (notes != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                TlSpace.s2,
                0,
                TlSpace.s2,
                TlSpace.s2,
              ),
              child: Text(
                notes,
                style: t.bodySm.copyWith(
                  color: c.inkMuted,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ExcludeSemantics(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: TlSpace.s2),
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    child: Text(l10n.strengthColSet, style: labelStyle),
                  ),
                  Expanded(
                    child: Text(l10n.strengthColPrevious, style: labelStyle),
                  ),
                  if (type.tracksWeight)
                    SizedBox(
                      width: 72,
                      child: Text(
                        l10n.unitSymbol(unit).toUpperCase(),
                        textAlign: TextAlign.center,
                        style: labelStyle,
                      ),
                    ),
                  SizedBox(
                    width: 64,
                    child: Text(
                      type.tracksTime
                          ? l10n.strengthColTime
                          : l10n.strengthColReps,
                      textAlign: TextAlign.center,
                      style: labelStyle,
                    ),
                  ),
                  const SizedBox(width: TlSize.touchSession + TlSpace.s1),
                ],
              ),
            ),
          ),
          for (final s in item.sets)
            _SetRow(
              key: ValueKey(s.id),
              set: s,
              type: type,
              unit: unit,
              exercise: name,
              onEdit: () => onSet(s),
              onCheck: () => onCheck(s),
            ),
          const SizedBox(height: TlSpace.s1),
          if (item.repeatSource case final source?)
            if (setValuesText(l10n, type, source.stored, unit)
                case final values?) ...[
              _RepeatSetButton(
                key: Key('repeat-set-${item.id}'),
                values: values,
                onTap: onRepeat,
              ),
              const SizedBox(height: TlSpace.s1),
            ],
          Material(
            color: c.surface2,
            borderRadius: BorderRadius.circular(TlRadius.md),
            child: InkWell(
              key: Key('add-set-${item.id}'),
              borderRadius: BorderRadius.circular(TlRadius.md),
              onTap: onAddSet,
              child: SizedBox(
                height: TlSize.touchSession,
                child: Center(
                  child: Text(
                    l10n.strengthAddSet,
                    style: t.button.copyWith(color: c.accent, fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// «Igual que antes: 10 kg × 8»: otra serie como la última efectiva, en un
/// toque (R-G3).
class _RepeatSetButton extends StatelessWidget {
  const _RepeatSetButton({
    required this.values,
    required this.onTap,
    super.key,
  });

  final String values;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return Semantics(
      button: true,
      label: l10n.strengthSameAsBeforeHint(values),
      excludeSemantics: true,
      child: Material(
        color: c.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(TlRadius.md),
        child: InkWell(
          borderRadius: BorderRadius.circular(TlRadius.md),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: TlSize.touchSession),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: TlSpace.s3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.replay, color: c.accent),
                  const SizedBox(width: TlSpace.s2),
                  Flexible(
                    child: Text(
                      l10n.strengthSameAsBefore(values),
                      textAlign: TextAlign.center,
                      style: context.text.button.copyWith(
                        color: c.accent,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SetRow extends StatelessWidget {
  const _SetRow({
    required this.set,
    required this.type,
    required this.unit,
    required this.exercise,
    required this.onEdit,
    required this.onCheck,
    super.key,
  });

  final SessionSet set;
  final ExerciseLogType type;
  final WeightUnit unit;
  final String exercise;
  final VoidCallback onEdit;
  final VoidCallback onCheck;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final done = set.completed;
    final v = set.proposed;
    final tag = setTag(l10n, set);
    final prev = set.previous;
    final heading = setHeading(l10n, exercise, set);
    final valueColor = done ? c.ink : c.inkMuted;
    final valueStyle = t.title.copyWith(color: valueColor, fontSize: 22);
    final key = set.id;
    final second = type.tracksTime
        ? (v.durationSeconds == null
              ? l10n.strengthNoValue
              : l10n.duration(v.durationSeconds!))
        : (v.reps == null ? l10n.strengthNoValue : l10n.numberValue(v.reps!));
    return Container(
      constraints: const BoxConstraints(minHeight: TlSize.touchSession),
      margin: const EdgeInsets.only(top: TlSpace.s1),
      padding: const EdgeInsets.symmetric(horizontal: TlSpace.s2),
      decoration: BoxDecoration(
        color: done ? c.successSoft : Colors.transparent,
        borderRadius: BorderRadius.circular(TlRadius.md),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Text(
              tag,
              style: t.title.copyWith(
                color: set.type == SetType.warmup ? c.warning : c.ink,
              ),
            ),
          ),
          Expanded(
            child: Text(
              prev == null
                  ? l10n.strengthNoValue
                  : previousText(l10n, type, SetValues.ofLog(prev), unit),
              key: Key('set-prev-$key'),
              style: t.bodySm.copyWith(color: c.inkMuted),
            ),
          ),
          if (type.tracksWeight)
            _Cell(
              key: Key('set-weight-$key'),
              width: 72,
              label: weightNumber(l10n, v, unit) ?? l10n.strengthNoValue,
              style: valueStyle,
              semantics: l10n.strengthEditWeight(heading),
              onTap: onEdit,
            ),
          _Cell(
            key: Key('set-reps-$key'),
            width: 64,
            label: second,
            style: valueStyle,
            semantics: l10n.strengthEditReps(heading),
            onTap: onEdit,
          ),
          const SizedBox(width: TlSpace.s1),
          Semantics(
            button: true,
            checked: done,
            label: done
                ? l10n.strengthUncompleteSet(heading)
                : l10n.strengthCompleteSet(heading),
            excludeSemantics: true,
            child: Material(
              color: done ? c.success : Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TlRadius.md),
                side: BorderSide(color: done ? c.success : c.line, width: 2),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                key: Key('set-check-$key'),
                onTap: onCheck,
                child: SizedBox(
                  width: TlSize.touchSession,
                  height: TlSize.touchSession,
                  child: Icon(
                    Icons.check,
                    size: 28,
                    color: done ? c.bg : c.inkMuted,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.width,
    required this.label,
    required this.style,
    required this.semantics,
    required this.onTap,
    super.key,
  });

  final double width;
  final String label;
  final TextStyle style;
  final String semantics;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: semantics,
    value: label,
    excludeSemantics: true,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: context.colors.surface2,
        borderRadius: BorderRadius.circular(TlRadius.sm),
        child: InkWell(
          borderRadius: BorderRadius.circular(TlRadius.sm),
          onTap: onTap,
          child: SizedBox(
            width: width - 4,
            height: TlSize.touchSession,
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(label, style: style),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _AddExerciseButton extends StatelessWidget {
  const _AddExerciseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      child: InkWell(
        key: const Key('strength-add-exercise'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(TlRadius.lg),
        child: Container(
          constraints: const BoxConstraints(minHeight: TlSize.touchSession),
          padding: const EdgeInsets.all(TlSpace.s2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TlRadius.lg),
            border: Border.all(color: c.line, width: 2),
          ),
          alignment: Alignment.center,
          child: Text(
            context.l10n.strengthAddExercise,
            style: context.text.button.copyWith(color: c.accent),
          ),
        ),
      ),
    );
  }
}
