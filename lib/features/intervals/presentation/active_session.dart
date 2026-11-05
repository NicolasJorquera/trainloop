import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/router/visible_path.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../data/db/enums.dart';
import '../../../platform/timer_engine_client.dart';
import '../../strength/application/strength_session_controller.dart';
import '../../strength/application/strength_texts.dart';
import '../../strength/data/strength_session_repository.dart';
import '../../strength/presentation/strength_dialogs.dart';
import '../application/interval_session_controller.dart';
import '../application/interval_texts.dart';
import 'session_dialogs.dart';

/// Termina la sesión en curso (intervalos o fuerza) desde fuera de ella.
///
/// Sin [confirmed] pide confirmación; la fuerza además pregunta qué hacer
/// con las series sin marcar (R-G10) o propone descartarla si no hay
/// ninguna hecha (R-G11). Con [openSummary] abre el resumen al terminar.
/// `true` si ya no queda ninguna sesión en curso.
Future<bool> endActiveSession(
  BuildContext context,
  WidgetRef ref, {
  bool confirmed = false,
  bool openSummary = true,
}) async {
  final router = ref.read(routerProvider);
  if (ref.read(intervalSessionProvider)?.active ?? false) {
    if (!confirmed && !await showEndSessionDialog(context)) return false;
    final controller = ref.read(intervalSessionProvider.notifier);
    await controller.stopAndWait();
    final s = ref.read(intervalSessionProvider);
    if (s == null) return true;
    if (!s.saved) return !s.active;
    if (openSummary) {
      unawaited(router.push(Routes.sessionSummary(s.sessionId)));
    }
    controller.dismiss();
    return true;
  }

  final active = ref.read(strengthSessionProvider);
  if (active == null) return true;
  final data = await ref
      .read(strengthSessionRepositoryProvider)
      .load(active.sessionId);
  if (!context.mounted) return false;
  final controller = ref.read(strengthSessionProvider.notifier);
  if (data == null || data.completedSets == 0) {
    if (!await showNoSetsDialog(context)) return false;
    await controller.discard();
    return true;
  }
  var pending = PendingSets.discard;
  if (data.pendingSets > 0) {
    final choice = await showPendingSetsDialog(context, data.pendingSets);
    if (choice == null) return false;
    pending = choice;
  } else if (!confirmed && !await showEndSessionDialog(context)) {
    return false;
  }
  final status = await controller.finish(pending: pending);
  if (openSummary && status != SessionStatus.discarded) {
    unawaited(router.push(Routes.strengthSummary(data.id)));
  }
  return true;
}

/// Marco de toda la app: arriba, bajo la barra de estado, muestra la barra
/// «sesión en curso» en cualquier pantalla que no sea la sesión.
class ActiveSessionFrame extends ConsumerStatefulWidget {
  const ActiveSessionFrame({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<ActiveSessionFrame> createState() => _ActiveSessionFrameState();
}

class _ActiveSessionFrameState extends ConsumerState<ActiveSessionFrame> {
  late final GoRouter _router = ref.read(routerProvider);
  var _path = '';

  @override
  void initState() {
    super.initState();
    _router.routerDelegate.addListener(_onRoute);
  }

  @override
  void dispose() {
    _router.routerDelegate.removeListener(_onRoute);
    super.dispose();
  }

  /// El router avisa en medio de un build: se repinta al terminar el frame.
  void _onRoute() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final path = visiblePathOf(_router);
      if (path != _path) setState(() => _path = path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final interval = ref.watch(intervalSessionProvider);
    final strength = ref.watch(strengthSessionProvider);
    final intervalActive = interval?.active ?? false;
    final path = _path = visiblePathOf(_router);
    final show =
        (intervalActive || strength != null) &&
        path != Routes.timer &&
        path != Routes.strength &&
        !path.startsWith('/sessions/') &&
        !path.startsWith('${Routes.strength}/') &&
        // Eligiendo ejercicios para la sesión (S10 está debajo).
        !(!intervalActive && path.startsWith(Routes.exercises));
    // El árbol no cambia de forma al aparecer la barra: el Navigator de
    // [child] no debe reubicarse.
    return Column(
      children: [
        if (show) const _ActiveSessionBar() else const SizedBox.shrink(),
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: show,
            child: widget.child,
          ),
        ),
      ],
    );
  }
}

class _ActiveSessionBar extends ConsumerStatefulWidget {
  const _ActiveSessionBar();

  @override
  ConsumerState<_ActiveSessionBar> createState() => _ActiveSessionBarState();
}

class _ActiveSessionBarState extends ConsumerState<_ActiveSessionBar> {
  Timer? _tick;
  var _busy = false;

  @override
  void initState() {
    super.initState();
    // El tiempo de la sesión de fuerza se repinta cada segundo.
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && ref.read(strengthSessionProvider) != null) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  BuildContext? get _navContext =>
      ref.read(routerProvider).routerDelegate.navigatorKey.currentContext;

  void _open(bool interval) {
    ref
        .read(routerProvider)
        .push(interval ? Routes.timer : Routes.strength)
        .ignore();
  }

  Future<void> _end() async {
    final context = _navContext;
    if (context == null || _busy) return;
    setState(() => _busy = true);
    try {
      await endActiveSession(context, ref);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final interval = ref.watch(intervalSessionProvider);
    final intervalActive = interval?.active ?? false;
    final String title;
    final String subtitle;
    if (intervalActive) {
      title = l10n.sessionBarIntervals(interval!.snapshot.workout.name);
      final phase = phaseTypeName(l10n, interval.phase.type);
      subtitle = interval.engine.state == EngineRunState.paused
          ? l10n.summaryJoin(phase, l10n.sessionBarPaused)
          : phase;
    } else {
      final id = ref.watch(strengthSessionProvider)!.sessionId;
      final data = ref.watch(strengthSessionDataProvider(id)).value;
      title = l10n.sessionBarStrength(sessionTitle(l10n, data?.title));
      final elapsed = data == null
          ? 0
          : DateTime.now()
                .toUtc()
                .difference(data.session.startedAt)
                .inSeconds
                .clamp(0, 359999);
      subtitle = data == null
          ? ''
          : l10n.summaryJoin(l10n.duration(elapsed), progressText(l10n, data));
    }

    return Material(
      key: const Key('active-session-bar'),
      color: c.accent,
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Expanded(
              child: Semantics(
                button: true,
                label: '$title. $subtitle',
                hint: l10n.sessionBarHint,
                excludeSemantics: true,
                child: InkWell(
                  key: const Key('active-session-open'),
                  onTap: () => _open(intervalActive),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: TlSize.touchMin + TlSpace.s2,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TlSpace.s4,
                        vertical: TlSpace.s1,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            intervalActive
                                ? Icons.timer_outlined
                                : Icons.fitness_center,
                            color: c.onAccent,
                          ),
                          const SizedBox(width: TlSpace.s3),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title.toUpperCase(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: t.overline.copyWith(color: c.onAccent),
                                ),
                                if (subtitle.isNotEmpty)
                                  Text(
                                    subtitle,
                                    key: const Key('active-session-status'),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: t.bodySm.copyWith(
                                      color: c.onAccent,
                                      fontFeatures: const [
                                        FontFeature.tabularFigures(),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Sin tooltip: la barra está fuera del Navigator (sin Overlay).
            IconButton(
              key: const Key('active-session-bar-end'),
              constraints: const BoxConstraints.tightFor(
                width: TlSize.touchMin + TlSpace.s2,
                height: TlSize.touchMin + TlSpace.s2,
              ),
              color: c.onAccent,
              icon: Icon(
                Icons.stop_circle_outlined,
                semanticLabel: l10n.sessionBarEnd,
              ),
              onPressed: _busy ? null : _end,
            ),
          ],
        ),
      ),
    );
  }
}
