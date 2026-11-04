import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/tl_button.dart';
import '../../intervals/presentation/session_dialogs.dart';
import '../application/strength_session_controller.dart';
import '../application/strength_texts.dart';
import '../data/strength_session_repository.dart';

// Diálogos de la sesión de fuerza, con el estilo de S18.

/// Qué hacer al terminar con series sin marcar (R-G10). `null` = volver a
/// la sesión.
Future<PendingSets?> showPendingSetsDialog(BuildContext context, int count) {
  final l10n = context.l10n;
  return showTlDialog<PendingSets>(
    context,
    key: const Key('pending-sets-dialog'),
    icon: Icons.playlist_add_check,
    title: l10n.strengthPendingTitle(count),
    body: [Text(l10n.strengthPendingBody)],
    actions: (pop) => [
      TlButton(
        key: const Key('pending-discard'),
        label: l10n.strengthPendingDiscard,
        onPressed: () => pop(PendingSets.discard),
      ),
      TlButton(
        key: const Key('pending-complete'),
        label: l10n.strengthPendingComplete,
        variant: TlButtonVariant.secondary,
        onPressed: () => pop(PendingSets.complete),
      ),
      TlButton(
        key: const Key('pending-back'),
        label: l10n.strengthBackToSession,
        variant: TlButtonVariant.text,
        onPressed: () => pop(null),
      ),
    ],
  );
}

/// Ninguna serie hecha (R-G11): `true` = descartar la sesión.
Future<bool> showNoSetsDialog(BuildContext context) async {
  final l10n = context.l10n;
  final result = await showTlDialog<bool>(
    context,
    key: const Key('no-sets-dialog'),
    icon: Icons.delete_outline,
    title: l10n.strengthNoSetsTitle,
    body: [Text(l10n.strengthNoSetsBody)],
    actions: (pop) => [
      TlButton(
        key: const Key('no-sets-discard'),
        label: l10n.summaryDiscardConfirm,
        onPressed: () => pop(true),
      ),
      TlButton(
        key: const Key('no-sets-back'),
        label: l10n.strengthBackToSession,
        variant: TlButtonVariant.text,
        onPressed: () => pop(false),
      ),
    ],
  );
  return result ?? false;
}

/// Quitar un ejercicio con series hechas: `true` = quitarlo.
Future<bool> showRemoveExerciseDialog(BuildContext context, String name) async {
  final l10n = context.l10n;
  final result = await showTlDialog<bool>(
    context,
    key: const Key('remove-exercise-dialog'),
    icon: Icons.delete_outline,
    title: l10n.strengthRemoveExerciseTitle(name),
    body: [Text(l10n.strengthRemoveExerciseBody)],
    actions: (pop) => [
      TlButton(
        key: const Key('remove-exercise-confirm'),
        label: l10n.strengthRemoveExercise,
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

/// Notas del ejercicio en la sesión. `null` = cancelar.
Future<String?> showNotesDialog(BuildContext context, String? initial) {
  final l10n = context.l10n;
  final controller = TextEditingController(text: initial);
  return showTlDialog<String>(
    context,
    key: const Key('notes-dialog'),
    icon: Icons.edit_note,
    title: l10n.strengthNotesTitle,
    body: [
      TextField(
        key: const Key('notes-field'),
        controller: controller,
        autofocus: true,
        minLines: 2,
        maxLines: 4,
        maxLength: 300,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: l10n.strengthNotesHint,
          counterText: '',
        ),
      ),
    ],
    actions: (pop) => [
      TlButton(
        key: const Key('notes-save'),
        label: l10n.strengthNotesSave,
        onPressed: () => pop(controller.text),
      ),
      TlButton(
        label: l10n.dialogCancel,
        variant: TlButtonVariant.text,
        onPressed: () => pop(null),
      ),
    ],
  );
}

/// S18-b para la sesión de fuerza: sus series ya están guardadas. No se
/// descarta tocando fuera.
Future<RecoveryChoice?> showStrengthRecoveryDialog(
  BuildContext context,
  StrengthRecoveryOffer offer,
) {
  final l10n = context.l10n;
  final c = context.colors;
  final minutes = DateTime.now()
      .difference(offer.savedAt.toLocal())
      .inMinutes
      .clamp(0, 999999);
  return showTlDialog<RecoveryChoice>(
    context,
    key: const Key('strength-recovery-dialog'),
    icon: Icons.history,
    title: l10n.recoveryTitle,
    dismissible: false,
    body: [
      Text(
        l10n.summaryJoin(
          sessionTitle(l10n, offer.title),
          l10n.strengthSetsDone(offer.completedSets),
        ),
        style: context.text.title,
      ),
      const SizedBox(height: TlSpace.s1),
      Text(
        l10n.recoveryAgo(minutes),
        style: context.text.bodySm.copyWith(color: c.inkMuted),
      ),
      const SizedBox(height: TlSpace.s3),
      Text(l10n.strengthRecoveryBody),
    ],
    actions: (pop) => [
      TlButton(
        key: const Key('recovery-resume'),
        label: l10n.strengthRecoveryResume,
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
