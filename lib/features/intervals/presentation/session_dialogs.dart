import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/tl_button.dart';
import '../application/interval_session_controller.dart';
import '../application/interval_texts.dart';

// Diálogos de S18: permiso de notificaciones (a), recuperación (b),
// batería restringida (c) y "ya hay una sesión en curso" (R-I13).

enum RecoveryChoice { resume, saveIncomplete, discard }

enum BatteryChoice { openSettings, done, later }

/// S18-a: explica el permiso antes del diálogo del sistema. `true` =
/// continuar (pedir el permiso), `false` = empezar sin él.
Future<bool> showNotificationRationale(BuildContext context) async {
  final l10n = context.l10n;
  final result = await showTlDialog<bool>(
    context,
    key: const Key('notify-dialog'),
    icon: Icons.notifications_active_outlined,
    title: l10n.notifyTitle,
    body: [Text(l10n.notifyBody)],
    actions: (pop) => [
      TlButton(
        key: const Key('notify-continue'),
        label: l10n.notifyContinue,
        onPressed: () => pop(true),
      ),
      TlButton(
        key: const Key('notify-not-now'),
        label: l10n.notifyNotNow,
        variant: TlButtonVariant.text,
        onPressed: () => pop(false),
      ),
    ],
  );
  return result ?? false;
}

/// S18-b: sesión que quedó sin terminar. No se descarta tocando fuera;
/// `null` solo si otra navegación lo cierra.
Future<RecoveryChoice?> showRecoveryDialog(
  BuildContext context,
  RecoveryOffer offer,
) async {
  final l10n = context.l10n;
  final c = context.colors;
  final phases = offer.snapshot.phases;
  final phase = phases[offer.engine.index.clamp(0, phases.length - 1).toInt()];
  final where = phase.rounds > 0
      ? l10n.recoveryRound(phase.round, phase.rounds)
      : phaseName(l10n, phase);
  final saved = offer.engine.savedAt;
  final minutes = saved == null
      ? 0
      : DateTime.now().difference(saved).inMinutes.clamp(0, 999999);
  return showTlDialog<RecoveryChoice>(
    context,
    key: const Key('recovery-dialog'),
    icon: Icons.history,
    title: l10n.recoveryTitle,
    dismissible: false,
    body: [
      Text(
        '${offer.snapshot.workout.name} · $where',
        style: context.text.title,
      ),
      const SizedBox(height: TlSpace.s1),
      Text(
        l10n.recoveryAgo(minutes),
        style: context.text.bodySm.copyWith(color: c.inkMuted),
      ),
      const SizedBox(height: TlSpace.s3),
      Text(l10n.recoveryBody),
    ],
    actions: (pop) => [
      TlButton(
        key: const Key('recovery-resume'),
        label: l10n.recoveryResume,
        onPressed: () => pop(RecoveryChoice.resume),
      ),
      TlButton(
        key: const Key('recovery-save'),
        label: l10n.recoverySaveIncomplete,
        variant: TlButtonVariant.secondary,
        onPressed: () => pop(RecoveryChoice.saveIncomplete),
      ),
      TlButton(
        key: const Key('recovery-discard'),
        label: l10n.recoveryDiscard,
        variant: TlButtonVariant.text,
        onPressed: () => pop(RecoveryChoice.discard),
      ),
    ],
  );
}

/// S18-c: la app está "Restringida" en batería y el servicio no duraría
/// con la pantalla apagada (T-08, spike T4).
Future<BatteryChoice> showBatteryDialog(
  BuildContext context, {
  required String brand,
}) async {
  final l10n = context.l10n;
  final t = context.text;
  final steps = [l10n.batteryStep1, l10n.batteryStep2, l10n.batteryStep3];
  final result = await showTlDialog<BatteryChoice>(
    context,
    key: const Key('battery-dialog'),
    icon: Icons.battery_alert_outlined,
    title: l10n.batteryTitle(brand.toUpperCase()),
    body: [
      Text(l10n.batteryBody),
      const SizedBox(height: TlSpace.s3),
      for (final (i, s) in steps.indexed)
        Padding(
          padding: const EdgeInsets.only(bottom: TlSpace.s2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 28,
                child: Text(l10n.numberValue(i + 1), style: t.title),
              ),
              Expanded(child: Text(s, style: t.body)),
            ],
          ),
        ),
    ],
    actions: (pop) => [
      TlButton(
        key: const Key('battery-open'),
        label: l10n.batteryOpenSettings,
        onPressed: () => pop(BatteryChoice.openSettings),
      ),
      TlButton(
        key: const Key('battery-done'),
        label: l10n.batteryDone,
        variant: TlButtonVariant.secondary,
        onPressed: () => pop(BatteryChoice.done),
      ),
      TlButton(
        key: const Key('battery-later'),
        label: l10n.batteryLater,
        variant: TlButtonVariant.text,
        onPressed: () => pop(BatteryChoice.later),
      ),
    ],
  );
  return result ?? BatteryChoice.later;
}

/// R-I13: ya hay una sesión activa. `true` = volver a ella.
Future<bool> showActiveSessionDialog(BuildContext context) async {
  final l10n = context.l10n;
  final result = await showTlDialog<bool>(
    context,
    key: const Key('active-session-dialog'),
    icon: Icons.timer_outlined,
    title: l10n.activeSessionTitle,
    body: [Text(l10n.activeSessionBody)],
    actions: (pop) => [
      TlButton(
        key: const Key('active-session-go'),
        label: l10n.activeSessionGo,
        onPressed: () => pop(true),
      ),
      TlButton(
        label: l10n.dialogCancel,
        variant: TlButtonVariant.text,
        onPressed: () => pop(false),
      ),
    ],
  );
  return result ?? false;
}

/// Diálogo con el estilo de S18: ícono, título en mayúsculas, cuerpo y
/// botones a lo ancho, apilados.
Future<T?> showTlDialog<T>(
  BuildContext context, {
  required Key key,
  required IconData icon,
  required String title,
  required List<Widget> body,
  required List<Widget> Function(void Function(T? value) pop) actions,
  bool dismissible = true,
}) => showDialog<T>(
  context: context,
  barrierDismissible: dismissible,
  builder: (context) {
    final c = context.colors;
    final t = context.text;
    return PopScope(
      canPop: dismissible,
      child: Dialog(
        key: key,
        backgroundColor: c.surface1,
        insetPadding: const EdgeInsets.all(TlSpace.s4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TlRadius.sheet),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(TlSpace.s6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32, color: c.accent),
              const SizedBox(height: TlSpace.s3),
              Semantics(header: true, child: Text(title, style: t.headline)),
              const SizedBox(height: TlSpace.s3),
              DefaultTextStyle.merge(
                style: t.body.copyWith(color: c.ink),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: body,
                ),
              ),
              const SizedBox(height: TlSpace.s6),
              for (final a in actions((v) => Navigator.of(context).pop(v)))
                Padding(
                  padding: const EdgeInsets.only(bottom: TlSpace.s2),
                  child: a,
                ),
            ],
          ),
        ),
      ),
    );
  },
);
