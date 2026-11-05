import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/tab_page.dart';
import '../../../core/widgets/tl_segmented_control.dart';
import '../../intervals/presentation/interval_list.dart';
import '../../routines/presentation/routine_list.dart';

enum _TrainKind { intervals, routines }

/// S02 Entrenar: entrenamientos de intervalos y plantillas (D4) y rutinas
/// de fuerza (D3) con EMPEZAR y entrenamiento libre (D5).
class TrainScreen extends StatelessWidget {
  const TrainScreen({this.showRoutines = false, super.key});

  /// Vista de fuerza (rutinas) en vez de intervalos. Sale de la URL
  /// (`?kind=`): así cada botón de Inicio abre siempre su vista, aunque la
  /// pestaña conserve su estado.
  final bool showRoutines;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final kind = showRoutines ? _TrainKind.routines : _TrainKind.intervals;
    final intervals = kind == _TrainKind.intervals;
    return TabPage(
      children: [
        TabHeader(
          title: l10n.trainTitle,
          trailing: intervals
              ? _HeaderButton(
                  key: const Key('new-interval'),
                  label: l10n.trainNewInterval,
                  tooltip: l10n.intervalNewTooltip,
                  onPressed: () => context.push(Routes.intervalNew),
                )
              : _HeaderButton(
                  key: const Key('new-routine'),
                  label: l10n.trainNewRoutine,
                  tooltip: l10n.routineNewTitle,
                  onPressed: () => context.push(Routes.routineNew),
                ),
        ),
        const SizedBox(height: TlSpace.s2),
        TlSegmentedControl<_TrainKind>(
          semanticLabel: l10n.trainKindLabel,
          selected: kind,
          onChanged: (k) => context.go(
            k == _TrainKind.routines ? Routes.trainRoutines : Routes.train,
          ),
          segments: [
            TlSegment(_TrainKind.intervals, l10n.trainIntervals),
            TlSegment(_TrainKind.routines, l10n.trainRoutines),
          ],
        ),
        const SizedBox(height: TlSpace.s4),
        if (intervals) const IntervalList() else const RoutineList(),
      ],
    );
  }
}

/// Botón principal compacto del encabezado ("NUEVA").
class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.label,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final String label;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      container: true,
      button: true,
      label: tooltip,
      excludeSemantics: true,
      child: Material(
        color: c.primaryBg,
        borderRadius: BorderRadius.circular(TlRadius.md),
        child: InkWell(
          borderRadius: BorderRadius.circular(TlRadius.md),
          onTap: onPressed,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: TlSize.touchMin),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: TlSpace.s4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 20, color: c.primaryInk),
                  const SizedBox(width: TlSpace.s1),
                  Text(
                    label,
                    style: context.text.button.copyWith(color: c.primaryInk),
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
