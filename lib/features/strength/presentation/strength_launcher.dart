import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/router/routes.dart';
import '../../intervals/presentation/session_launcher.dart';
import '../../settings/application/settings_controller.dart';
import '../application/strength_session_controller.dart';
import '../application/strength_texts.dart';

/// Empieza una sesión de fuerza (R-G1) desde una rutina, desde cero o
/// repitiendo la última, y abre S10. Pasa por los mismos pasos previos que
/// los intervalos: sesión activa (R-I13), permiso de notificaciones, batería
/// restringida y volumen en 0. Una rutina vacía no se puede empezar: invita
/// a agregar ejercicios.
Future<void> startStrengthSession(
  BuildContext context,
  WidgetRef ref,
  StrengthStart how,
) async {
  if (!await checkBeforeSession(context, ref)) return;
  if (!context.mounted) return;
  final env = StrengthEnv.of(context, ref.read(settingsControllerProvider));
  try {
    await ref.read(strengthSessionProvider.notifier).start(how, env);
  } on StateError {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(context.l10n.strengthEmptyRoutine)),
      );
    if (how case StartFromRoutine(:final routineId)) {
      await context.push(Routes.routineEdit(routineId));
    }
    return;
  }
  if (context.mounted) await context.push(Routes.strength);
}
