import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/units/weight_unit.dart';
import 'converters.dart';
import 'daos/ad_state_dao.dart';
import 'daos/exercises_dao.dart';
import 'daos/interval_workouts_dao.dart';
import 'daos/plan_dao.dart';
import 'daos/records_dao.dart';
import 'daos/routines_dao.dart';
import 'daos/sessions_dao.dart';
import 'enums.dart';
import 'tables.dart';

part 'app_database.g.dart';

/// Nombre del archivo: `trainloop.sqlite` en el directorio de soporte de la
/// app (en Android, `files/`). Las reglas de respaldo de Android lo incluyen.
const databaseName = 'trainloop';

/// Base local (SQLite vía Drift) con las 14 tablas de docs/modelo-datos.md.
@DriftDatabase(
  tables: [
    Exercises,
    StrengthRoutines,
    RoutineExercises,
    RoutineSetTargets,
    IntervalWorkouts,
    IntervalBlocks,
    Sessions,
    SessionExercises,
    SetLogs,
    IntervalPhaseLogs,
    PersonalRecords,
    PlanDays,
    Reminders,
    AdStates,
  ],
  daos: [
    ExercisesDao,
    RoutinesDao,
    IntervalWorkoutsDao,
    SessionsDao,
    RecordsDao,
    PlanDao,
    AdStateDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Sin [executor] abre el archivo de la app; las pruebas pasan uno en
  /// memoria o un archivo temporal.
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? openAppDatabaseConnection());

  /// Cada cambio de esquema sube este número, guarda el esquema con
  /// `dart run drift_dev make-migrations` y agrega su paso y su prueba.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // v2 en adelante: `m.runMigrationSteps` con los pasos generados en
      // app_database.steps.dart (make-migrations).
      throw UnsupportedError('Sin migración de v$from a v$to');
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Filas por tabla (sección de depuración en Configuración).
  Future<Map<String, int>> rowCounts() async => {
    for (final table in allTables)
      table.actualTableName: await customSelect(
        'SELECT COUNT(*) AS c FROM "${table.actualTableName}"',
        readsFrom: {table},
      ).map((row) => row.read<int>('c')).getSingle(),
  };
}

QueryExecutor openAppDatabaseConnection() => driftDatabase(
  name: databaseName,
  native: const DriftNativeOptions(
    databaseDirectory: getApplicationSupportDirectory,
  ),
);
