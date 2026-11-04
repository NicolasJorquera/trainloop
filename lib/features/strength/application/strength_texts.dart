import 'package:flutter/widgets.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/units/weight_unit.dart';
import '../../../data/db/enums.dart';
import '../../../platform/timer_engine_client.dart';
import '../../exercises/domain/exercise_names.dart';
import '../../settings/domain/app_settings.dart';
import '../domain/strength_rules.dart';
import '../domain/strength_session.dart';

// Textos de la sesión de fuerza que dependen del idioma y de la unidad de
// la persona: valores de una serie, serie siguiente, progreso y el programa
// que recibe el servicio nativo.

/// Lo que la sesión necesita del idioma, las preferencias y el tema para
/// hablar con el servicio (textos ya localizados y colores).
class StrengthEnv {
  const StrengthEnv({
    required this.l10n,
    required this.settings,
    required this.locale,
    required this.restColor,
    required this.accent,
  });

  factory StrengthEnv.of(BuildContext context, AppSettings settings) =>
      StrengthEnv(
        l10n: context.l10n,
        settings: settings,
        locale: context.locale,
        restColor: context.colors.phases.rest.background,
        accent: context.colors.accent,
      );

  final AppLocalizations l10n;
  final AppSettings settings;
  final Locale locale;
  final Color restColor;
  final Color accent;

  WeightUnit get unit => settings.weightUnit;
}

/// Peso en la unidad de la persona, con el separador del idioma («82,5»).
/// `null` si no hay peso.
String? weightNumber(AppLocalizations l10n, SetValues v, WeightUnit unit) {
  final w = v.weightIn(unit);
  return w == null ? null : l10n.decimalText(l10n.decimal(w));
}

/// Valores de una serie en una línea según lo que registra el ejercicio:
/// «80 kg × 8», «× 12» o «0:45». `null` si no hay nada que mostrar.
String? setValuesText(
  AppLocalizations l10n,
  ExerciseLogType type,
  SetValues v,
  WeightUnit unit,
) {
  if (type.tracksTime) {
    final d = v.durationSeconds;
    return d == null ? null : l10n.duration(d);
  }
  final reps = v.reps;
  final w = v.weightIn(unit);
  if (type.tracksWeight && w != null && reps != null) {
    return l10n.strengthWeightTimesReps(l10n.weight(w, unit), reps);
  }
  if (reps != null) return l10n.strengthTimesReps(reps);
  return null;
}

/// Valores de la "última marca" en la columna ANTERIOR (S10): «80 × 8».
String previousText(
  AppLocalizations l10n,
  ExerciseLogType type,
  SetValues v,
  WeightUnit unit,
) {
  if (type.tracksTime) {
    final d = v.durationSeconds;
    return d == null ? l10n.strengthNoValue : l10n.duration(d);
  }
  final reps = v.reps;
  final w = weightNumber(l10n, v, unit);
  if (type.tracksWeight && w != null && reps != null) {
    return l10n.strengthPrevious(w, reps);
  }
  if (reps != null) return l10n.strengthTimesReps(reps);
  return l10n.strengthNoValue;
}

/// Etiqueta de la serie en S10: «C» para el calentamiento, su número para
/// las demás y una letra para al fallo («3F») y drop set («3D»).
String setTag(AppLocalizations l10n, SessionSet s) => switch (s.type) {
  SetType.warmup => l10n.setTagWarmup,
  SetType.normal => l10n.numberValue(s.number ?? 0),
  SetType.failure => l10n.setTagWithType(s.number ?? 0, l10n.setTagFailure),
  SetType.drop => l10n.setTagWithType(s.number ?? 0, l10n.setTagDrop),
};

/// Nombre del tipo de serie (S11).
String setTypeName(AppLocalizations l10n, SetType t) => switch (t) {
  SetType.warmup => l10n.setTypeWarmup,
  SetType.normal => l10n.setTypeNormal,
  SetType.failure => l10n.setTypeFailure,
  SetType.drop => l10n.setTypeDrop,
};

/// Título de la sesión: la rutina o "Entrenamiento libre".
String sessionTitle(AppLocalizations l10n, String? title) =>
    title ?? l10n.strengthFreeTitle;

/// «Sentadilla · serie 3» (o «· calentamiento»).
String setHeading(AppLocalizations l10n, String exercise, SessionSet s) =>
    s.number == null
    ? l10n.strengthSetHeadingWarmup(exercise)
    : l10n.strengthSetHeading(exercise, s.number!);

/// «Siguiente: Sentadilla, serie 3 · 80 kg × 8» para el descanso y la
/// notificación. Vacío si no quedan series.
String nextSetText(
  AppLocalizations l10n,
  StrengthSessionData data,
  WeightUnit unit,
  Locale locale, {
  String? afterSetId,
}) {
  final next = data.nextPending(afterSetId: afterSetId);
  if (next == null || next.set.id == afterSetId) return '';
  final name = exerciseName(next.exercise.exercise, locale);
  final where = next.set.number == null
      ? l10n.strengthNextWarmup(name)
      : l10n.strengthNextSet(name, next.set.number!);
  final values = setValuesText(
    l10n,
    next.exercise.exercise.logType,
    next.set.proposed,
    unit,
  );
  return values == null ? where : l10n.summaryJoin(where, values);
}

/// «3/12 series» del encabezado de S10 y de la notificación.
String progressText(AppLocalizations l10n, StrengthSessionData data) =>
    l10n.strengthProgress(data.completedSets, data.totalSets);

/// Programa de la sesión para el servicio nativo.
StrengthProgram buildStrengthProgram({
  required String sessionId,
  required String title,
  required DateTime startedAt,
  required StrengthEnv env,
}) {
  final l10n = env.l10n;
  return StrengthProgram(
    sessionId: sessionId,
    title: title,
    locale: env.locale.toLanguageTag(),
    sounds: env.settings.sounds,
    voice: env.settings.voice,
    vibration: env.settings.vibration,
    strings: {
      'channel': l10n.timerChannel,
      'rest': l10n.strengthRestNotification,
      'restOver': l10n.strengthRestOver,
      'restOverSpeech': l10n.cueRestOver,
      'plus15': l10n.strengthPlus15Short,
      'skip': l10n.timerSkipShort,
      'inProgress': l10n.strengthInProgress,
    },
    restColor: env.restColor.toARGB32(),
    color: env.accent.toARGB32(),
    startedAt: startedAt,
  );
}
