// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sessions_dao.dart';

// ignore_for_file: type=lint
mixin _$SessionsDaoMixin on DatabaseAccessor<AppDatabase> {
  $SessionsTable get sessions => attachedDatabase.sessions;
  $ExercisesTable get exercises => attachedDatabase.exercises;
  $SessionExercisesTable get sessionExercises =>
      attachedDatabase.sessionExercises;
  $SetLogsTable get setLogs => attachedDatabase.setLogs;
  $IntervalPhaseLogsTable get intervalPhaseLogs =>
      attachedDatabase.intervalPhaseLogs;
  SessionsDaoManager get managers => SessionsDaoManager(this);
}

class SessionsDaoManager {
  final _$SessionsDaoMixin _db;
  SessionsDaoManager(this._db);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db.attachedDatabase, _db.sessions);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db.attachedDatabase, _db.exercises);
  $$SessionExercisesTableTableManager get sessionExercises =>
      $$SessionExercisesTableTableManager(
        _db.attachedDatabase,
        _db.sessionExercises,
      );
  $$SetLogsTableTableManager get setLogs =>
      $$SetLogsTableTableManager(_db.attachedDatabase, _db.setLogs);
  $$IntervalPhaseLogsTableTableManager get intervalPhaseLogs =>
      $$IntervalPhaseLogsTableTableManager(
        _db.attachedDatabase,
        _db.intervalPhaseLogs,
      );
}
