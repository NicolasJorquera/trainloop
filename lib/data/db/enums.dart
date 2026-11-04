// Enums persistidos. Drift los guarda como texto con su `name` (textEnum):
// renombrar un valor exige una migración que actualice las filas.

/// Cómo se registra un ejercicio.
enum ExerciseLogType { weightReps, reps, time, distance, timeDistance }

/// Músculo principal de un ejercicio.
enum Muscle {
  chest,
  back,
  shoulders,
  biceps,
  triceps,
  forearms,
  core,
  quads,
  hamstrings,
  glutes,
  calves,
  fullBody,
  cardio,
  other,
}

/// Equipo que usa un ejercicio.
enum Equipment {
  barbell,
  dumbbell,
  machine,
  cable,
  kettlebell,
  band,
  bodyweight,
  other,
}

/// Tipo de serie (objetivo en la rutina o registrada en la sesión).
enum SetType { warmup, normal, drop, failure }

/// Nodo de un entrenamiento de intervalos: un intervalo con duración o un
/// grupo que repite a sus hijos `rounds` veces.
enum IntervalBlockKind { interval, group }

/// Tipo de fase de un intervalo.
enum PhaseType { prepare, warmup, work, rest, cooldown }

/// Tipo de sesión y de plantilla de origen.
enum SessionKind { intervals, strength }

/// Estado de una sesión. La sesión en curso se identifica por su estado.
enum SessionStatus {
  inProgress,
  completed,
  incomplete,
  discarded,
  recoveryPending,
}

/// Tipo de récord personal (PRD, flujo 3): peso máximo, 1RM estimado,
/// más repeticiones con un peso dado (uno por peso), mayor volumen del
/// ejercicio en una sesión, y en ejercicios de tiempo o distancia la mayor
/// duración o distancia de una serie. v5 renombró `maxSetVolume` a
/// [maxSessionVolume] (la caché se vació y se recalculó).
enum RecordType {
  maxWeight,
  estimatedOneRm,
  maxReps,
  maxSessionVolume,
  maxDuration,
  maxDistance,
}

/// Estado del consentimiento UMP (anuncios, D8).
enum ConsentStatus { unknown, required, notRequired, obtained }
