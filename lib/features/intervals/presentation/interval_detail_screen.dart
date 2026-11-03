import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/tl_button.dart';
import '../../settings/application/settings_controller.dart';
import '../application/interval_providers.dart';
import '../application/interval_texts.dart';
import '../domain/interval_templates.dart';
import '../domain/interval_workout_draft.dart';
import '../domain/phase_plan.dart';
import 'interval_widgets.dart';
import 'session_launcher.dart';

/// S03 Detalle antes de empezar: estructura, total (con la preparación) y
/// avisos activos. Empezar, editar o duplicar; una plantilla se
/// personaliza (copia editable). Precalienta la voz al entrar para que el
/// primer aviso ya hable.
class IntervalDetailScreen extends ConsumerStatefulWidget {
  const IntervalDetailScreen({this.workoutId, this.templateKey, super.key});

  final String? workoutId;
  final String? templateKey;

  @override
  ConsumerState<IntervalDetailScreen> createState() =>
      _IntervalDetailScreenState();
}

class _IntervalDetailScreenState extends ConsumerState<IntervalDetailScreen> {
  IntervalWorkoutDraft? _saved;
  var _voiceReady = true;
  var _starting = false;

  IntervalTemplate? get _template => widget.templateKey == null
      ? null
      : IntervalTemplate.byKey(widget.templateKey!);

  @override
  void initState() {
    super.initState();
    final id = widget.workoutId;
    if (id != null) {
      ref.read(intervalWorkoutRepositoryProvider).load(id).then((d) {
        if (mounted) setState(() => _saved = d);
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final ready = await ref
          .read(timerEngineClientProvider)
          .prewarmVoice(context.locale.toLanguageTag());
      if (mounted) setState(() => _voiceReady = ready);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final template = _template;
    final workout = template != null ? templateWorkout(l10n, template) : _saved;
    final settings = ref.watch(settingsControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: workout == null
            ? const SizedBox.shrink()
            : ListView(
                padding: const EdgeInsets.fromLTRB(
                  TlSpace.s4,
                  TlSpace.s2,
                  TlSpace.s4,
                  TlSpace.s8,
                ),
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: TlSpace.s3),
                          child: Semantics(
                            header: true,
                            child: Text(
                              workout.name.toUpperCase(),
                              style: t.headline,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        key: const Key('detail-close'),
                        tooltip: l10n.detailCloseTooltip,
                        icon: const Icon(Icons.close),
                        onPressed: () => context.pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: TlSpace.s1),
                  Text(
                    _meta(l10n, workout, template != null),
                    style: t.bodySm.copyWith(color: c.inkMuted),
                  ),
                  const SizedBox(height: TlSpace.s3),
                  PhaseStrip(expandPhases(workout)),
                  const SizedBox(height: TlSpace.s4),
                  WorkoutStructure(workout),
                  const SizedBox(height: TlSpace.s4),
                  Text(
                    _alerts(
                      l10n,
                      settings.voice,
                      settings.sounds,
                      settings.vibration,
                    ),
                    style: t.bodySm.copyWith(color: c.inkMuted),
                  ),
                  if (settings.voice && !_voiceReady) ...[
                    const SizedBox(height: TlSpace.s1),
                    Text(
                      l10n.detailNoVoice,
                      key: const Key('detail-no-voice'),
                      style: t.bodySm.copyWith(color: c.warning),
                    ),
                  ],
                  const SizedBox(height: TlSpace.s6),
                  TlButton(
                    key: const Key('detail-start'),
                    label: l10n.detailStart,
                    icon: Icons.play_arrow,
                    onPressed: _starting
                        ? null
                        : () => _start(workout, template),
                  ),
                  const SizedBox(height: TlSpace.s3),
                  if (template != null)
                    TlButton(
                      key: const Key('detail-customize'),
                      label: l10n.detailCustomize,
                      variant: TlButtonVariant.secondary,
                      onPressed: () => context.pushReplacement(
                        Routes.intervalNewFromTemplate(template.key),
                      ),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TlButton(
                            key: const Key('detail-edit'),
                            label: l10n.detailEdit,
                            variant: TlButtonVariant.secondary,
                            onPressed: () => _edit(workout.id!),
                          ),
                        ),
                        const SizedBox(width: TlSpace.s2),
                        Expanded(
                          child: TlButton(
                            key: const Key('detail-duplicate'),
                            label: l10n.detailDuplicate,
                            variant: TlButtonVariant.secondary,
                            onPressed: () => _duplicate(workout),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
      ),
    );
  }

  String _meta(
    AppLocalizations l10n,
    IntervalWorkoutDraft workout,
    bool isTemplate,
  ) {
    final totals = WorkoutTotals.of(expandPhases(workout));
    final meta = l10n.detailMeta(
      l10n.duration(totals.totalSeconds),
      totals.workPhases,
    );
    return isTemplate ? l10n.summaryJoin(meta, l10n.templateTag) : meta;
  }

  Future<void> _start(
    IntervalWorkoutDraft workout,
    IntervalTemplate? template,
  ) async {
    setState(() => _starting = true);
    await startIntervalSession(
      context,
      ref,
      workout,
      sourceId: template?.sourceId,
    );
    if (mounted) setState(() => _starting = false);
  }

  Future<void> _edit(String id) async {
    await context.push(Routes.intervalEdit(id));
    final d = await ref.read(intervalWorkoutRepositoryProvider).load(id);
    if (mounted) setState(() => _saved = d);
  }

  Future<void> _duplicate(IntervalWorkoutDraft workout) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final name = l10n.routineCopyName(workout.name);
    await ref
        .read(intervalWorkoutRepositoryProvider)
        .duplicate(workout.id!, name: name);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.routineDuplicated(name))));
  }
}

/// «Voz, pitidos, vibración: activados» según las preferencias.
String _alerts(AppLocalizations l10n, bool voice, bool beeps, bool vibration) {
  final items = [
    if (voice) l10n.alertVoice,
    if (beeps) l10n.alertBeeps,
    if (vibration) l10n.alertVibration,
  ];
  if (items.isEmpty) return l10n.alertsOff;
  final list = items.join(', ');
  return l10n.alertsOn(list[0].toUpperCase() + list.substring(1));
}
