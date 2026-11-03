import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/phase_colors.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/phase_glyph.dart';
import '../../../platform/timer_engine_client.dart';
import '../application/interval_providers.dart';
import '../application/interval_session_controller.dart';
import '../application/interval_texts.dart';

/// S05 Temporizador en ejecución (F-04). Solo muestra el estado que publica
/// el motor nativo: fondo del color de la fase (phasePaletteFor), fase con
/// forma y palabra, tiempo restante grande, fase siguiente y progreso.
/// Tocar el centro pausa o reanuda; volver, saltar, mantener 1 s para
/// detener y bloqueo de controles (R-I10). Áreas táctiles ≥ 64 dp.
class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({super.key});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  var _locked = false;
  var _left = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(intervalSessionProvider, (_, next) {
      if (next != null && next.saved) _toSummary(next.sessionId);
    });
    final session = ref.watch(intervalSessionProvider);
    if (session == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_left) context.go(Routes.home);
      });
      return const Scaffold(body: SizedBox.shrink());
    }
    final l10n = context.l10n;
    final controller = ref.read(intervalSessionProvider.notifier);
    final engine = session.engine;
    final phase = session.phase;
    final colors = context.colors.phases.of(phaseOf(phase.type));
    final fg = colors.ink;
    final paused = engine.state == EngineRunState.paused;
    final t = context.text;
    final next = session.next;

    final roundText = [
      if (phase.sets > 0) l10n.timerSet(phase.set, phase.sets),
      if (phase.rounds > 0) l10n.timerRound(phase.round, phase.rounds),
    ];

    return PopScope(
      canPop: false,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: colors.background.computeLuminance() > 0.4
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: colors.background,
          body: SafeArea(
            child: DefaultTextStyle.merge(
              style: TextStyle(color: fg),
              child: IconTheme.merge(
                data: IconThemeData(color: fg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        TlSpace.s4,
                        TlSpace.s4,
                        TlSpace.s4,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _Progress(session: session, color: fg),
                          const SizedBox(height: TlSpace.s3),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  session.snapshot.workout.name.toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  style: t.overline.copyWith(color: fg),
                                ),
                              ),
                              if (roundText.isNotEmpty)
                                Text(
                                  roundText.reduce(l10n.summaryJoin),
                                  key: const Key('timer-round'),
                                  style: t.overline.copyWith(color: fg),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Semantics(
                        button: true,
                        label: paused ? l10n.timerResume : l10n.timerPause,
                        child: InkWell(
                          key: const Key('timer-center'),
                          onTap: _locked
                              ? null
                              : (paused ? controller.resume : controller.pause),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TlSpace.s4,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (!paused) ...[
                                      PhaseGlyph(
                                        phaseOf(phase.type),
                                        color: fg,
                                        size: 36,
                                      ),
                                      const SizedBox(width: TlSpace.s3),
                                    ],
                                    Flexible(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          paused
                                              ? l10n.timerPaused
                                              : phaseBigLabel(l10n, phase),
                                          key: const Key('timer-phase'),
                                          style: t.phase.copyWith(color: fg),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Opacity(
                                  opacity: paused ? 0.55 : 1,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: _Countdown(
                                      engine: engine,
                                      clock: ref
                                          .read(timerEngineClientProvider)
                                          .clock,
                                      style: t.timer.copyWith(color: fg),
                                    ),
                                  ),
                                ),
                                Text(
                                  next == null
                                      ? l10n.timerLast
                                      : l10n.timerNext(
                                          phaseName(l10n, next),
                                          l10n.duration(next.seconds),
                                        ),
                                  key: const Key('timer-next'),
                                  style: t.body.copyWith(
                                    color: fg,
                                    fontSize: 17,
                                  ),
                                ),
                                const SizedBox(height: TlSpace.s3),
                                if (paused)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: TlSpace.s3,
                                      vertical: TlSpace.s1,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: fg, width: 2),
                                      borderRadius: BorderRadius.circular(
                                        TlRadius.sm,
                                      ),
                                    ),
                                    child: Text(
                                      l10n.timerTapToResume,
                                      style: t.button.copyWith(color: fg),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (_locked)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          TlSpace.s4,
                          0,
                          TlSpace.s4,
                          TlSpace.s2,
                        ),
                        child: Text(
                          l10n.timerLocked,
                          key: const Key('timer-locked'),
                          style: t.bodySm.copyWith(
                            color: fg,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        TlSpace.s4,
                        0,
                        TlSpace.s4,
                        TlSpace.s3,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _ControlButton(
                            key: const Key('timer-previous'),
                            icon: Icons.skip_previous,
                            tooltip: l10n.timerPrevious,
                            color: fg,
                            onPressed: _locked ? null : controller.previous,
                          ),
                          _ControlButton(
                            key: const Key('timer-toggle'),
                            icon: paused ? Icons.play_arrow : Icons.pause,
                            tooltip: paused
                                ? l10n.timerResume
                                : l10n.timerPause,
                            color: fg,
                            filled: colors,
                            width: 152,
                            height: TlSize.touchPrimary,
                            onPressed: _locked
                                ? null
                                : (paused
                                      ? controller.resume
                                      : controller.pause),
                          ),
                          _ControlButton(
                            key: const Key('timer-skip'),
                            icon: Icons.skip_next,
                            tooltip: l10n.timerSkip,
                            color: fg,
                            onPressed: _locked ? null : controller.skip,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        TlSpace.s4,
                        0,
                        TlSpace.s4,
                        TlSpace.s6,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: HoldToStopButton(
                              label: l10n.timerHoldToStop,
                              semanticLabel: l10n.timerHoldHint,
                              color: fg,
                              enabled: !_locked,
                              onStop: controller.stop,
                            ),
                          ),
                          const SizedBox(width: TlSpace.s2),
                          _ControlButton(
                            key: const Key('timer-lock'),
                            icon: _locked ? Icons.lock : Icons.lock_open,
                            tooltip: l10n.timerLock,
                            color: fg,
                            filled: _locked ? colors : null,
                            width: TlSize.buttonHeight,
                            height: TlSize.buttonHeight,
                            selected: _locked,
                            onPressed: () => setState(() => _locked = !_locked),
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
    );
  }

  void _toSummary(String sessionId) {
    if (_left) return;
    _left = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.pushReplacement(Routes.sessionSummary(sessionId));
      ref.read(intervalSessionProvider.notifier).dismiss();
    });
  }
}

/// Tiempo restante calculado localmente desde el último estado del motor;
/// solo se repinta mientras corre (no hay tráfico por fotograma).
class _Countdown extends StatefulWidget {
  const _Countdown({
    required this.engine,
    required this.clock,
    required this.style,
  });

  final EngineState engine;
  final Duration Function() clock;
  final TextStyle style;

  @override
  State<_Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<_Countdown> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(_Countdown old) {
    super.didUpdateWidget(old);
    _sync();
  }

  void _sync() {
    final running = widget.engine.state == EngineRunState.running;
    if (running && _timer == null) {
      _timer = Timer.periodic(
        const Duration(milliseconds: 200),
        (_) => setState(() {}),
      );
    } else if (!running) {
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
  Widget build(BuildContext context) {
    final ms = widget.engine.remainingAt(widget.clock());
    final seconds = (ms / 1000).ceil();
    return Text(
      context.l10n.duration(seconds),
      key: const Key('timer-remaining'),
      style: widget.style.copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}

/// Barra segmentada: una franja por fase, en proporción a su duración.
class _Progress extends StatelessWidget {
  const _Progress({required this.session, required this.color});

  final ActiveSession session;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final i = session.engine.index;
    final phases = session.phases;
    return Semantics(
      label: context.l10n.timerProgress(
        (i + 1).clamp(1, phases.length),
        phases.length,
      ),
      child: SizedBox(
        height: 6,
        child: Row(
          children: [
            for (final (k, p) in phases.indexed) ...[
              if (k > 0 && phases.length <= 60) const SizedBox(width: 3),
              Expanded(
                flex: p.seconds,
                child: ColoredBox(
                  color: color.withValues(
                    alpha: k < i
                        ? 1
                        : k == i
                        ? 0.7
                        : 0.25,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onPressed,
    this.filled,
    this.width = TlSize.touchSession,
    this.height = TlSize.touchSession,
    this.selected,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final Color color;

  /// Botón relleno con el color de texto y el ícono del color de la fase.
  final PhaseColor? filled;
  final double width;
  final double height;
  final bool? selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final fill = filled;
    return Semantics(
      button: true,
      selected: selected,
      enabled: onPressed != null,
      label: tooltip,
      excludeSemantics: true,
      child: Tooltip(
        message: tooltip,
        child: Opacity(
          opacity: onPressed == null ? 0.35 : 1,
          child: Material(
            color: fill != null ? color : Colors.transparent,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: color, width: 2),
              borderRadius: BorderRadius.circular(TlRadius.md),
            ),
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(TlRadius.md),
              child: SizedBox(
                width: width,
                height: height,
                child: Icon(
                  icon,
                  size: height > TlSize.touchSession ? 40 : 26,
                  color: fill?.background ?? color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Detener exige mantener presionado 1 s (R-I10); la franja muestra el
/// avance. Con TalkBack, la acción de mantener presionado también detiene.
class HoldToStopButton extends StatefulWidget {
  const HoldToStopButton({
    required this.label,
    required this.semanticLabel,
    required this.color,
    required this.onStop,
    this.enabled = true,
    super.key,
  });

  static const holdDuration = Duration(seconds: 1);

  final String label;
  final String semanticLabel;
  final Color color;
  final VoidCallback onStop;
  final bool enabled;

  @override
  State<HoldToStopButton> createState() => _HoldToStopButtonState();
}

class _HoldToStopButtonState extends State<HoldToStopButton>
    with SingleTickerProviderStateMixin {
  late final _hold = AnimationController(
    vsync: this,
    duration: HoldToStopButton.holdDuration,
  )..addStatusListener(_onStatus);

  void _onStatus(AnimationStatus s) {
    if (s == AnimationStatus.completed) {
      HapticFeedback.heavyImpact();
      widget.onStop();
      _hold.value = 0;
    }
  }

  @override
  void dispose() {
    _hold.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color;
    return Semantics(
      button: true,
      enabled: widget.enabled,
      label: widget.semanticLabel,
      onLongPress: widget.enabled ? widget.onStop : null,
      excludeSemantics: true,
      child: Opacity(
        opacity: widget.enabled ? 1 : 0.35,
        child: Listener(
          key: const Key('timer-hold-stop'),
          onPointerDown: widget.enabled ? (_) => _hold.forward(from: 0) : null,
          onPointerUp: (_) => _cancel(),
          onPointerCancel: (_) => _cancel(),
          child: Container(
            height: TlSize.buttonHeight,
            decoration: BoxDecoration(
              border: Border.all(color: color, width: 2),
              borderRadius: BorderRadius.circular(TlRadius.md),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedBuilder(
                  animation: _hold,
                  builder: (context, _) => FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _hold.value,
                    child: ColoredBox(
                      color: color.withValues(alpha: 0.3),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    widget.label,
                    style: context.text.button.copyWith(color: color),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _cancel() {
    if (_hold.status != AnimationStatus.completed) _hold.value = 0;
  }
}
