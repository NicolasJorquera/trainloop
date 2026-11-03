// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interval_workouts_dao.dart';

// ignore_for_file: type=lint
mixin _$IntervalWorkoutsDaoMixin on DatabaseAccessor<AppDatabase> {
  $IntervalWorkoutsTable get intervalWorkouts =>
      attachedDatabase.intervalWorkouts;
  $IntervalBlocksTable get intervalBlocks => attachedDatabase.intervalBlocks;
  IntervalWorkoutsDaoManager get managers => IntervalWorkoutsDaoManager(this);
}

class IntervalWorkoutsDaoManager {
  final _$IntervalWorkoutsDaoMixin _db;
  IntervalWorkoutsDaoManager(this._db);
  $$IntervalWorkoutsTableTableManager get intervalWorkouts =>
      $$IntervalWorkoutsTableTableManager(
        _db.attachedDatabase,
        _db.intervalWorkouts,
      );
  $$IntervalBlocksTableTableManager get intervalBlocks =>
      $$IntervalBlocksTableTableManager(
        _db.attachedDatabase,
        _db.intervalBlocks,
      );
}
