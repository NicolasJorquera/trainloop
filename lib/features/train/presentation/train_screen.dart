import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/tab_page.dart';
import '../../../core/widgets/tl_segmented_control.dart';
import '../../routines/presentation/routine_list.dart';

enum _TrainKind { intervals, routines }

/// S02 Entrenar: rutinas de fuerza (D3). Los intervalos llegan en D4; por
/// ahora muestran su estado vacío.
class TrainScreen extends StatefulWidget {
  const TrainScreen({super.key});

  @override
  State<TrainScreen> createState() => _TrainScreenState();
}

class _TrainScreenState extends State<TrainScreen> {
  _TrainKind _kind = _TrainKind.intervals;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final intervals = _kind == _TrainKind.intervals;
    return TabPage(
      children: [
        ScreenHeader(
          title: l10n.trainTitle,
          trailing: intervals
              ? null
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
          selected: _kind,
          onChanged: (k) => setState(() => _kind = k),
          segments: [
            TlSegment(_TrainKind.intervals, l10n.trainIntervals),
            TlSegment(_TrainKind.routines, l10n.trainRoutines),
          ],
        ),
        const SizedBox(height: TlSpace.s4),
        if (intervals)
          EmptyState(
            icon: Icons.timer_outlined,
            title: l10n.trainIntervalsEmptyTitle,
            body: l10n.trainIntervalsEmptyBody,
          )
        else
          const RoutineList(),
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
