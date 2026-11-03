import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/tab_page.dart';
import '../../../core/widgets/tl_segmented_control.dart';

enum _TrainKind { intervals, routines }

/// S02 Entrenar. Las listas reales llegan en D3 (rutinas) y D4 (intervalos).
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
        ScreenHeader(title: l10n.trainTitle),
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
        EmptyState(
          icon: intervals ? Icons.timer_outlined : Icons.fitness_center,
          title: intervals
              ? l10n.trainIntervalsEmptyTitle
              : l10n.trainRoutinesEmptyTitle,
          body: intervals
              ? l10n.trainIntervalsEmptyBody
              : l10n.trainRoutinesEmptyBody,
        ),
      ],
    );
  }
}
