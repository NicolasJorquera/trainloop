import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/section_label.dart';
import '../../../core/widgets/tl_button.dart';
import '../../../data/db/enums.dart';
import '../../monetization/application/interstitial_controller.dart';
import '../application/interval_providers.dart';
import '../data/interval_session_repository.dart';

/// S06 Resumen de una sesión de intervalos: total activo, rondas hechas,
/// tiempo de trabajo, fases omitidas y pausas; esfuerzo percibido 1–10 y
/// nota opcionales. Con menos de 30 s de actividad propone descartarla
/// (R-I12).
class SessionSummaryScreen extends ConsumerStatefulWidget {
  const SessionSummaryScreen({required this.sessionId, super.key});

  final String sessionId;

  @override
  ConsumerState<SessionSummaryScreen> createState() =>
      _SessionSummaryScreenState();
}

class _SessionSummaryScreenState extends ConsumerState<SessionSummaryScreen> {
  static const _shortSeconds = 30;

  final _note = TextEditingController();
  IntervalSessionRecord? _record;
  int? _effort;

  @override
  void initState() {
    super.initState();
    ref.read(intervalSessionRepositoryProvider).load(widget.sessionId).then((
      r,
    ) {
      if (mounted) setState(() => _record = r);
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
    final r = _record;
    if (r == null) return const Scaffold(body: SizedBox.shrink());
    final completed = r.session.status == SessionStatus.completed;
    final short = r.activeSeconds < _shortSeconds;
    final started = r.session.startedAt.toLocal();
    final date = DateFormat.MMMd(
      context.locale.toLanguageTag(),
    ).add_Hm().format(started);
    final paused = r.session.pausedSeconds;

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
              Icon(
                completed
                    ? Icons.emoji_events_outlined
                    : Icons.stop_circle_outlined,
                size: 40,
                color: c.accent,
              ),
              const SizedBox(height: TlSpace.s2),
              Semantics(
                header: true,
                child: Text(
                  completed ? l10n.summaryDoneTitle : l10n.summaryStoppedTitle,
                  key: const Key('summary-title'),
                  style: t.headline,
                ),
              ),
              const SizedBox(height: TlSpace.s1),
              Text(
                l10n.summarySubtitle(r.snapshot.workout.name, date),
                style: t.bodySm.copyWith(color: c.inkMuted),
              ),
              const SizedBox(height: TlSpace.s4),
              Row(
                children: [
                  _Stat(
                    label: l10n.summaryTotal,
                    value: l10n.duration(r.activeSeconds),
                    valueKey: const Key('summary-total'),
                  ),
                  _Stat(
                    label: l10n.summaryRounds,
                    value: l10n.summaryRoundsValue(
                      r.roundsDone,
                      r.roundsPlanned,
                    ),
                    valueKey: const Key('summary-rounds'),
                  ),
                  _Stat(
                    label: l10n.summaryWork,
                    value: l10n.duration(r.workSeconds),
                  ),
                ],
              ),
              const SizedBox(height: TlSpace.s3),
              Text(
                l10n.summaryJoin(
                  l10n.summarySkipped(r.skippedCount),
                  paused > 0
                      ? l10n.summaryPaused(l10n.duration(paused))
                      : l10n.summaryNoPauses,
                ),
                style: t.bodySm.copyWith(color: c.inkMuted),
              ),
              if (short) ...[
                const SizedBox(height: TlSpace.s3),
                Text(
                  l10n.summaryShort,
                  key: const Key('summary-short'),
                  style: t.body.copyWith(color: c.warning),
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
                  hintText: l10n.summaryNoteHint,
                  counterText: '',
                ),
              ),
              const SizedBox(height: TlSpace.s6),
              if (short) ...[
                TlButton(
                  key: const Key('summary-discard'),
                  label: l10n.summaryDiscard,
                  onPressed: _discard,
                ),
                const SizedBox(height: TlSpace.s2),
                TlButton(
                  key: const Key('summary-done'),
                  label: l10n.summaryDone,
                  variant: TlButtonVariant.secondary,
                  onPressed: _done,
                ),
              ] else ...[
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _done() async {
    final note = _note.text.trim();
    await ref
        .read(intervalSessionRepositoryProvider)
        .rate(
          widget.sessionId,
          perceivedEffort: _effort,
          note: note.isEmpty ? null : note,
        );
    if (!mounted) return;
    // «Listo» (R-A2): primero se sale del resumen; el intersticial (si el
    // experimento está activo y todo lo permite) aparece ya en Inicio.
    final ads = ref.read(interstitialControllerProvider.notifier);
    context.go(Routes.home);
    unawaited(ads.afterSummaryDone(widget.sessionId));
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
    await ref.read(intervalSessionRepositoryProvider).discard(widget.sessionId);
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
              style: t.displayXl.copyWith(fontSize: 40),
            ),
          ),
        ],
      ),
    );
  }
}
