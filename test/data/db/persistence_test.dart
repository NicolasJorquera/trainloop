import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/data/db/app_database.dart';
import 'package:trainloop/data/db/enums.dart';

void main() {
  test('los datos sobreviven a cerrar y reabrir el archivo', () async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final dir = await Directory.systemTemp.createTemp('trainloop_db');
    addTearDown(() => dir.delete(recursive: true));
    final file = File('${dir.path}/$databaseName.sqlite');

    final first = AppDatabase(NativeDatabase(file));
    final exerciseId = await first.exercisesDao.create(
      name: 'Remo',
      logType: ExerciseLogType.weightReps,
      primaryMuscle: Muscle.back,
    );
    final sessionId = await first.sessionsDao.start(
      kind: SessionKind.strength,
      templateSnapshot: {'name': 'Tirón'},
    );
    await first.close();

    final second = AppDatabase(NativeDatabase(file));
    addTearDown(second.close);
    expect((await second.exercisesDao.findById(exerciseId))!.name, 'Remo');
    final session = (await second.sessionsDao.findById(sessionId))!;
    expect(session.templateSnapshot, {'name': 'Tirón'});
    expect((await second.rowCounts())['session'], 1);
  });
}
