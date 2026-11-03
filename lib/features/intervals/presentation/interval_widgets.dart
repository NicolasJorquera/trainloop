import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/phase_glyph.dart';
import '../../../data/db/enums.dart';
import '../application/interval_texts.dart';
import '../domain/interval_templates.dart';
import '../domain/interval_workout_draft.dart';
import '../domain/phase_plan.dart';

/// Franja con las fases en proporción a su duración y en su color
/// (decorativa: el texto de la tarjeta ya dice lo mismo).
class PhaseStrip extends StatelessWidget {
  const PhaseStrip(this.phases, {this.height = 6, super.key});

  final List<PlannedPhase> phases;
  final double height;

  @override
  Widget build(BuildContext context) {
    final palette = context.colors.phases;
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(TlRadius.sm),
        child: SizedBox(
          height: height,
          child: Row(
            children: [
              for (final p in phases)
                Expanded(
                  flex: p.seconds,
                  child: ColoredBox(
                    color: p.type == PhaseType.prepare
                        ? context.colors.barOff
                        : palette.of(phaseOf(p.type)).background,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Plantilla en Inicio y en Entrenar: nombre, rondas y total. Abre S03.
class TemplateTile extends StatelessWidget {
  const TemplateTile(this.template, {super.key});

  final IntervalTemplate template;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final workout = templateWorkout(l10n, template);
    final phases = expandPhases(workout);
    return Material(
      color: c.surface1,
      borderRadius: BorderRadius.circular(TlRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: Key('template-${template.key}'),
        onTap: () => context.push(Routes.templateDetail(template.key)),
        child: Padding(
          padding: const EdgeInsets.all(TlSpace.s3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(workout.name, style: t.title),
              const SizedBox(height: TlSpace.s1),
              Text(
                workoutMeta(l10n, WorkoutTotals.of(phases)),
                style: t.caption.copyWith(color: c.inkMuted),
              ),
              const SizedBox(height: TlSpace.s2),
              PhaseStrip(phases, height: 4),
            ],
          ),
        ),
      ),
    );
  }
}

/// Cuadrícula de 2 columnas de plantillas.
class TemplateGrid extends StatelessWidget {
  const TemplateGrid(this.templates, {super.key});

  final List<IntervalTemplate> templates;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (var i = 0; i < templates.length; i += 2)
        Padding(
          padding: const EdgeInsets.only(bottom: TlSpace.s2),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: TemplateTile(templates[i])),
                const SizedBox(width: TlSpace.s2),
                Expanded(
                  child: i + 1 < templates.length
                      ? TemplateTile(templates[i + 1])
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
    ],
  );
}

/// Fila de un intervalo: forma de la fase, nombre (o etiqueta) y duración.
class PhaseRow extends StatelessWidget {
  const PhaseRow({
    required this.type,
    required this.seconds,
    this.label,
    super.key,
  });

  final PhaseType type;
  final int seconds;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final glyphColor = type == PhaseType.prepare
        ? c.ink
        : c.phases.of(phaseOf(type)).background;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TlSpace.s2),
      child: Row(
        children: [
          PhaseGlyph(phaseOf(type), color: glyphColor),
          const SizedBox(width: TlSpace.s3),
          Expanded(
            child: Text(label ?? phaseTypeName(l10n, type), style: t.body),
          ),
          Text(l10n.duration(seconds), style: t.title),
        ],
      ),
    );
  }
}

/// Estructura de solo lectura (S03): preparación, intervalos y repeticiones.
class WorkoutStructure extends StatelessWidget {
  const WorkoutStructure(this.workout, {super.key});

  final IntervalWorkoutDraft workout;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (workout.prepareSeconds > 0)
        PhaseRow(type: PhaseType.prepare, seconds: workout.prepareSeconds),
      for (final n in workout.blocks) _node(context, n),
    ],
  );

  Widget _node(BuildContext context, IntervalNode n) => switch (n) {
    IntervalStep() => PhaseRow(
      type: n.type,
      seconds: n.seconds,
      label: n.label,
    ),
    IntervalRepeat() => _RepeatBox(
      repeat: n,
      children: [for (final c in n.children) _node(context, c)],
    ),
  };
}

class _RepeatBox extends StatelessWidget {
  const _RepeatBox({required this.repeat, required this.children});

  final IntervalRepeat repeat;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final hasRest = repeat.children.any(
      (n) => n is IntervalStep && n.type == PhaseType.rest,
    );
    return Container(
      margin: const EdgeInsets.symmetric(vertical: TlSpace.s1),
      padding: const EdgeInsets.fromLTRB(
        TlSpace.s3,
        TlSpace.s2,
        TlSpace.s3,
        TlSpace.s2,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: c.line, width: 2),
        borderRadius: BorderRadius.circular(TlRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${l10n.repeatCaps} ${l10n.repeatRounds(repeat.rounds)}',
            style: t.overline.copyWith(color: c.ink),
          ),
          ...children,
          if (repeat.skipLastRest && hasRest && repeat.rounds > 0)
            Text(
              l10n.detailSkipLast,
              style: t.caption.copyWith(color: c.inkMuted),
            ),
        ],
      ),
    );
  }
}
