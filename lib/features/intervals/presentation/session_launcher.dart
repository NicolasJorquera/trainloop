import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme_context.dart';
import '../../analytics/application/analytics_service.dart';
import '../../monetization/application/ad_guard_provider.dart';
import '../../settings/application/settings_controller.dart';
import '../../strength/application/strength_session_controller.dart';
import '../application/interval_providers.dart';
import '../application/interval_session_controller.dart';
import '../domain/interval_templates.dart';
import '../domain/interval_workout_draft.dart';
import 'active_session.dart';
import 'session_dialogs.dart';

/// Empieza [workout] desde S03 o desde una tarjeta (botón ▶):
///
/// 1. Si ya hay una sesión activa, ofrece volver a ella (R-I13).
/// 2. La primera vez sin permiso de notificaciones, lo explica y lo pide;
///    si se niega, la sesión empieza igual (T-07).
/// 3. Si la app está "Restringida" en batería, guía para quitarlo (T-08).
/// 4. Si el volumen multimedia está en 0, avisa sin bloquear (R-I8).
///
/// Después abre S05. Nada de esto aparece durante la sesión. La sesión de
/// fuerza (D5) pasa por los mismos pasos ([checkBeforeSession]).
Future<void> startIntervalSession(
  BuildContext context,
  WidgetRef ref,
  IntervalWorkoutDraft workout, {
  String? sourceId,
}) async {
  final controller = ref.read(intervalSessionProvider.notifier);
  // R-A1: sin anuncios desde «Empezar» (también durante los avisos previos).
  final started = await ref.read(adHoldsProvider.notifier).during(
    AdHold.starting,
    () async {
      if (!await checkBeforeSession(context, ref)) return false;
      if (!context.mounted) return false;
      final settings = ref.read(settingsControllerProvider);
      final l10n = context.l10n;
      final palette = context.colors.phases;
      final localeTag = context.locale.toLanguageTag();
      await controller.start(
        workout,
        sourceId: sourceId,
        l10n: l10n,
        settings: settings,
        palette: palette,
        localeTag: localeTag,
      );
      return true;
    },
  );
  if (!started) return;
  final analytics = ref.read(analyticsServiceProvider)
    ..log(AnalyticsEvent.sessionStarted(SessionKindParam.intervals));
  if (IntervalTemplate.bySourceId(sourceId) case final template?) {
    analytics.log(AnalyticsEvent.templateUsed(template.key));
  }
  if (context.mounted) await context.push(Routes.timer);
}

/// Pasos 1 a 4 antes de empezar cualquier sesión (intervalos o fuerza).
/// `false` si no hay que empezar: ya había una sesión activa (se ofrece
/// volver a ella) o la persona fue a los ajustes de batería.
Future<bool> checkBeforeSession(BuildContext context, WidgetRef ref) async {
  final engine = ref.read(timerEngineClientProvider);
  final intervalActive = ref.read(intervalSessionProvider)?.active ?? false;
  final strengthActive = ref.read(strengthSessionProvider) != null;
  if (intervalActive || strengthActive) {
    final choice = await showActiveSessionDialog(context);
    if (choice == null || !context.mounted) return false;
    if (choice == ActiveSessionChoice.goBack) {
      await context.push(intervalActive ? Routes.timer : Routes.strength);
      return false;
    }
    // «Terminar y empezar nueva»: el diálogo ya confirmó.
    final ended = await endActiveSession(
      context,
      ref,
      confirmed: true,
      openSummary: false,
    );
    if (!ended || !context.mounted) return false;
  }

  if (!await engine.notificationsGranted() &&
      !await engine.notificationPromptShown()) {
    if (!context.mounted) return false;
    final ask = await showNotificationRationale(context);
    await engine.markNotificationPromptShown();
    if (ask) await engine.requestNotifications();
  }

  while (await engine.backgroundRestricted()) {
    final brand = await engine.manufacturer();
    if (!context.mounted) return false;
    final choice = await showBatteryDialog(context, brand: brand);
    if (choice == BatteryChoice.openSettings) {
      await engine.openAppSettings();
      return false;
    }
    if (choice == BatteryChoice.later) break;
  }

  final settings = ref.read(settingsControllerProvider);
  if ((settings.sounds || settings.voice) && await engine.mediaVolumeZero()) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(context.l10n.volumeZero)));
    }
  }
  return context.mounted;
}
