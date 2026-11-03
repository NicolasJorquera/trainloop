// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_state_dao.dart';

// ignore_for_file: type=lint
mixin _$AdStateDaoMixin on DatabaseAccessor<AppDatabase> {
  $AdStatesTable get adStates => attachedDatabase.adStates;
  AdStateDaoManager get managers => AdStateDaoManager(this);
}

class AdStateDaoManager {
  final _$AdStateDaoMixin _db;
  AdStateDaoManager(this._db);
  $$AdStatesTableTableManager get adStates =>
      $$AdStatesTableTableManager(_db.attachedDatabase, _db.adStates);
}
