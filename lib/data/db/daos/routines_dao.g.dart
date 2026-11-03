// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routines_dao.dart';

// ignore_for_file: type=lint
mixin _$RoutinesDaoMixin on DatabaseAccessor<AppDatabase> {
  $StrengthRoutinesTable get strengthRoutines =>
      attachedDatabase.strengthRoutines;
  $ExercisesTable get exercises => attachedDatabase.exercises;
  $RoutineExercisesTable get routineExercises =>
      attachedDatabase.routineExercises;
  $RoutineSetTargetsTable get routineSetTargets =>
      attachedDatabase.routineSetTargets;
  RoutinesDaoManager get managers => RoutinesDaoManager(this);
}

class RoutinesDaoManager {
  final _$RoutinesDaoMixin _db;
  RoutinesDaoManager(this._db);
  $$StrengthRoutinesTableTableManager get strengthRoutines =>
      $$StrengthRoutinesTableTableManager(
        _db.attachedDatabase,
        _db.strengthRoutines,
      );
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db.attachedDatabase, _db.exercises);
  $$RoutineExercisesTableTableManager get routineExercises =>
      $$RoutineExercisesTableTableManager(
        _db.attachedDatabase,
        _db.routineExercises,
      );
  $$RoutineSetTargetsTableTableManager get routineSetTargets =>
      $$RoutineSetTargetsTableTableManager(
        _db.attachedDatabase,
        _db.routineSetTargets,
      );
}
