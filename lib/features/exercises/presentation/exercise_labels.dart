import '../../../core/l10n/l10n.dart';
import '../../../data/db/enums.dart';
import '../domain/exercise_filter.dart';

/// Nombres localizados de los enums de ejercicios.
extension ExerciseLabels on AppLocalizations {
  String muscle(Muscle m) => switch (m) {
    Muscle.chest => muscleChest,
    Muscle.back => muscleBack,
    Muscle.shoulders => muscleShoulders,
    Muscle.biceps => muscleBiceps,
    Muscle.triceps => muscleTriceps,
    Muscle.forearms => muscleForearms,
    Muscle.core => muscleCore,
    Muscle.quads => muscleQuads,
    Muscle.hamstrings => muscleHamstrings,
    Muscle.glutes => muscleGlutes,
    Muscle.calves => muscleCalves,
    Muscle.fullBody => muscleFullBody,
    Muscle.cardio => muscleCardio,
    Muscle.other => muscleOther,
  };

  String muscleGroup(MuscleGroup g) => switch (g) {
    MuscleGroup.legs => muscleGroupLegs,
    MuscleGroup.chest => muscleGroupChest,
    MuscleGroup.back => muscleGroupBack,
    MuscleGroup.shoulders => muscleGroupShoulders,
    MuscleGroup.arms => muscleGroupArms,
    MuscleGroup.core => muscleGroupCore,
    MuscleGroup.other => muscleGroupOther,
  };

  String equipment(Equipment e) => switch (e) {
    Equipment.barbell => equipmentBarbell,
    Equipment.dumbbell => equipmentDumbbell,
    Equipment.machine => equipmentMachine,
    Equipment.cable => equipmentCable,
    Equipment.kettlebell => equipmentKettlebell,
    Equipment.band => equipmentBand,
    Equipment.bodyweight => equipmentBodyweight,
    Equipment.other => equipmentOther,
  };

  String logType(ExerciseLogType t) => switch (t) {
    ExerciseLogType.weightReps => logTypeWeightReps,
    ExerciseLogType.reps => logTypeReps,
    ExerciseLogType.time => logTypeTime,
    ExerciseLogType.distance => logTypeDistance,
    ExerciseLogType.timeDistance => logTypeTimeDistance,
  };
}
