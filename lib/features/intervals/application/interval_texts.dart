import 'dart:ui';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/phase_colors.dart';
import '../../../data/db/enums.dart';
import '../../../platform/timer_engine_client.dart';
import '../../settings/domain/app_settings.dart';
import '../domain/interval_templates.dart';
import '../domain/interval_workout_draft.dart';
import '../domain/phase_plan.dart';
import '../domain/workout_snapshot.dart';

// Textos del temporizador que dependen del idioma: nombres de fase, voz de
// los avisos y textos de la notificación que se envían al motor nativo.

/// Fase de color y forma del sistema de diseño para cada tipo.
Phase phaseOf(PhaseType type) => switch (type) {
  PhaseType.prepare => Phase.prep,
  PhaseType.warmup => Phase.warm,
  PhaseType.work => Phase.work,
  PhaseType.rest => Phase.rest,
  PhaseType.cooldown => Phase.cool,
};

/// Nombre del tipo en minúsculas iniciales (listas, notificación, voz).
String phaseTypeName(AppLocalizations l10n, PhaseType type) => switch (type) {
  PhaseType.prepare => l10n.phaseNamePrepare,
  PhaseType.warmup => l10n.phaseNameWarmup,
  PhaseType.work => l10n.phaseNameWork,
  PhaseType.rest => l10n.phaseNameRest,
  PhaseType.cooldown => l10n.phaseNameCooldown,
};

/// Etiqueta grande de S05 (en mayúsculas).
String phaseBigLabel(AppLocalizations l10n, PlannedPhase p) =>
    p.label?.toUpperCase() ??
    switch (p.type) {
      PhaseType.prepare => l10n.timerPhasePrepare,
      PhaseType.warmup => l10n.timerPhaseWarmup,
      PhaseType.work => l10n.phaseWork,
      PhaseType.rest => l10n.phaseRest,
      PhaseType.cooldown => l10n.timerPhaseCooldown,
    };

/// Etiqueta propia o, si no tiene, el nombre del tipo.
String phaseName(AppLocalizations l10n, PlannedPhase p) =>
    p.label ?? phaseTypeName(l10n, p.type);

/// Lo que dice la voz al empezar la fase [i] (R-I7): su nombre, la ronda en
/// el trabajo y, en preparación y descanso, la fase que sigue.
String cueSpeech(AppLocalizations l10n, List<PlannedPhase> phases, int i) {
  final p = phases[i];
  final name = phaseName(l10n, p);
  final base = p.type == PhaseType.work && p.rounds > 1
      ? l10n.cueRound(name, p.round, p.rounds)
      : name;
  final next = i + 1 < phases.length ? phases[i + 1] : null;
  if (next != null &&
      (p.type == PhaseType.prepare || p.type == PhaseType.rest)) {
    return l10n.cueThenNext(base, phaseName(l10n, next));
  }
  return base;
}

/// Título de la notificación: fase y ronda.
String notificationTitle(AppLocalizations l10n, PlannedPhase p) => p.rounds > 0
    ? l10n.timerNotificationRound(phaseName(l10n, p), p.round, p.rounds)
    : phaseName(l10n, p);

/// Nombre visible de una plantilla.
String templateName(AppLocalizations l10n, IntervalTemplate t) => switch (t) {
  IntervalTemplate.tabata => l10n.templateTabata,
  IntervalTemplate.hiit4020 => l10n.templateHiit4020,
  IntervalTemplate.hiit3030 => l10n.templateHiit3030,
  IntervalTemplate.emom10 => l10n.templateEmom10,
  IntervalTemplate.amrap12 => l10n.templateAmrap12,
  IntervalTemplate.walkRun => l10n.templateWalkRun,
};

/// Plantilla con el nombre y las etiquetas del idioma activo.
IntervalWorkoutDraft templateWorkout(
  AppLocalizations l10n,
  IntervalTemplate t,
) => t.build(
  name: templateName(l10n, t),
  run: l10n.templateRun,
  walk: l10n.templateWalk,
);

/// «8 rondas · 4:00» (el total incluye la preparación).
String workoutMeta(AppLocalizations l10n, WorkoutTotals totals) =>
    l10n.intervalMeta(totals.workPhases, l10n.duration(totals.totalSeconds));

/// Programa para el motor nativo.
TimerProgram buildTimerProgram({
  required String sessionId,
  required WorkoutSnapshot snapshot,
  required AppLocalizations l10n,
  required AppSettings settings,
  required PhasePalette palette,
  required String localeTag,
}) {
  final phases = snapshot.phases;
  return TimerProgram(
    sessionId: sessionId,
    title: snapshot.workout.name,
    locale: localeTag,
    sounds: settings.sounds,
    voice: settings.voice,
    vibration: settings.vibration,
    strings: {
      'pause': l10n.timerPause,
      'resume': l10n.timerResume,
      'skip': l10n.timerSkipShort,
      'paused': l10n.timerPaused,
      'channel': l10n.timerChannel,
      'finishSpeech': l10n.cueFinish,
    },
    phases: [
      for (final (i, p) in phases.indexed)
        TimerPhaseSpec(
          type: p.type.name,
          title: notificationTitle(l10n, p),
          speech: cueSpeech(l10n, phases, i),
          durationMs: p.seconds * 1000,
          color: _argb(palette.of(phaseOf(p.type)).background),
        ),
    ],
  );
}

int _argb(Color c) => c.toARGB32();
