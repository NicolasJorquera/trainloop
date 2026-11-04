import 'package:drift/drift.dart';
import 'package:trainloop/core/units/weight_unit.dart';
import 'package:trainloop/data/catalog/exercise_catalog_seeder.dart';
import 'package:trainloop/data/db/app_database.dart';
import 'package:trainloop/data/db/enums.dart';
import 'package:trainloop/features/history/data/history_repository.dart';
import 'package:trainloop/features/history/data/records_repository.dart';
import 'package:trainloop/features/intervals/domain/interval_templates.dart';
import 'package:trainloop/features/intervals/domain/interval_workout_draft.dart';
import 'package:trainloop/features/intervals/domain/workout_snapshot.dart';
import 'package:trainloop/features/strength/domain/strength_rules.dart';

/// Conjunto de datos mínimo de docs/pruebas-historial.md: una semana
/// (lunes 26 oct 2026), "hoy" = miércoles 28, zona UTC−3 (las sesiones
/// guardan utc_offset_minutes = −180), semana desde el lunes y objetivo de
/// 3 sesiones. Fuerza con calentamiento (A, editada con
/// `HistoryRepository`), Tabata completo (B) e incompleto (C) y fuerza con
/// récord de peso (D). Los récords se calculan al guardar cada sesión.
abstract final class HistoryFixture {
  /// Hoy (fecha civil) y la hora local para el reloj de las pruebas.
  static final today = DateTime.utc(2026, 10, 28);
  static final now = DateTime(2026, 10, 28, 12);
  static const offsetMinutes = -180;
  static const goal = 3;
}

/// Ids de las sesiones y ejercicios del conjunto.
class FixtureIds {
  final sessions = <String, String>{};
  late String squat;
  late String bench;

  /// Serie de sentadilla de A que se editó.
  late String editedSet;

  String operator [](String name) => sessions[name]!;
}

typedef FixtureSet = ({double? kg, int reps, SetType type});

FixtureSet w(double kg, int reps) => (kg: kg, reps: reps, type: SetType.warmup);
FixtureSet n(double kg, int reps) => (kg: kg, reps: reps, type: SetType.normal);

/// Hora local (UTC−3) → instante UTC.
DateTime _local(int month, int day, int hour, [int minute = 0]) => DateTime.utc(
  2026,
  month,
  day,
  hour,
  minute,
).subtract(const Duration(minutes: HistoryFixture.offsetMinutes));

Future<FixtureIds> buildHistoryFixture(AppDatabase db) async {
  await seedExerciseCatalog(db.exercisesDao);
  final ids = FixtureIds()
    ..squat = (await db.exercisesDao.findByCatalogKey('back_squat_barbell'))!.id
    ..bench = (await db.exercisesDao.findByCatalogKey(
      'bench_press_barbell',
    ))!.id;
  final records = RecordsRepository(db);
  final history = HistoryRepository(db);

  Future<String> session(
    String name,
    SessionKind kind,
    DateTime start, {
    Map<String, Object?>? snapshot,
  }) async {
    final row = await db
        .into(db.sessions)
        .insertReturning(
          SessionsCompanion.insert(
            kind: kind,
            status: SessionStatus.inProgress,
            startedAt: start,
            utcOffsetMinutes: HistoryFixture.offsetMinutes,
            timeZoneId: const Value('America/Santiago'),
            templateSnapshot: Value(snapshot),
          ),
        );
    ids.sessions[name] = row.id;
    return row.id;
  }

  Future<String> strength(
    String name,
    DateTime start,
    int minutes,
    Map<String, List<FixtureSet>> exercises, {
    SessionStatus status = SessionStatus.completed,
  }) async {
    final id = await session(
      name,
      SessionKind.strength,
      start,
      snapshot: {
        'routine': {'name': name},
        'exercises': const [],
      },
    );
    var order = 0;
    for (final MapEntry(key: exerciseId, value: sets) in exercises.entries) {
      final entry = await db.sessionsDao.addExercise(
        sessionId: id,
        exerciseId: exerciseId,
        sortOrder: order++,
      );
      for (final (i, s) in sets.indexed) {
        await db.sessionsDao.logSet(
          SetLogsCompanion.insert(
            sessionExerciseId: entry,
            sessionId: id,
            exerciseId: exerciseId,
            sortOrder: i,
            setType: Value(s.type),
            weightValue: Value(s.kg),
            weightUnit: Value(s.kg == null ? null : WeightUnit.kg),
            reps: Value(s.reps),
            completed: const Value(true),
            loggedAt: Value(start.add(Duration(minutes: 2 + i))),
          ),
        );
      }
    }
    await db.sessionsDao.finish(
      id,
      status: status,
      endedAt: start.add(Duration(minutes: minutes)),
    );
    // Récords al guardar la sesión (R-P3).
    await records.recomputeSession(id);
    return id;
  }

  /// Sesión de intervalos que registra las primeras [phases] fases (todas
  /// si es `null`); la última puede quedar corta ([lastActual]).
  Future<String> intervals(
    String name,
    DateTime start,
    IntervalWorkoutDraft workout, {
    int? phases,
    int? lastActual,
    int pausedSeconds = 0,
  }) async {
    final snap = WorkoutSnapshot.of(workout);
    final id = await session(
      name,
      SessionKind.intervals,
      start,
      snapshot: snap.toJson(),
    );
    final count = phases ?? snap.phases.length;
    var elapsed = 0;
    for (var i = 0; i < count; i++) {
      final p = snap.phases[i];
      final actual = i == count - 1 && lastActual != null
          ? lastActual
          : p.seconds;
      elapsed += actual;
      await db.sessionsDao.logPhase(
        IntervalPhaseLogsCompanion.insert(
          sessionId: id,
          sortOrder: i,
          phaseType: p.type,
          round: Value(p.round == 0 ? 1 : p.round),
          plannedSeconds: p.seconds,
          actualSeconds: actual,
        ),
      );
    }
    await db.sessionsDao.finish(
      id,
      status: phases == null
          ? SessionStatus.completed
          : SessionStatus.incomplete,
      endedAt: start.add(Duration(seconds: elapsed + pausedSeconds)),
      pausedSeconds: pausedSeconds,
    );
    return id;
  }

  final tabata = IntervalTemplate.tabata.build(
    name: 'Tabata 20/10',
    run: 'Correr',
    walk: 'Caminar',
  );

  // Semana del lunes 26 de octubre de 2026 (hoy = miércoles 28).
  // A: fuerza con calentamiento; la 2.ª serie de sentadilla se registró
  // 80 × 6 y luego se corrige a 85 × 8 (sesión editada).
  final a = await strength('A', _local(10, 26, 18), 50, {
    ids.squat: [w(40, 10), n(80, 8), n(80, 6)],
    ids.bench: [n(60, 8)],
  });
  // B: Tabata completo. C: Tabata detenido en el 3.er trabajo (15 de 20 s).
  await intervals('B', _local(10, 27, 7), tabata);
  await intervals(
    'C',
    _local(10, 27, 19),
    tabata,
    phases: 6,
    lastActual: 15,
    pausedSeconds: 30,
  );
  // D: fuerza, récord de peso.
  await strength('D', _local(10, 28, 7), 20, {
    ids.squat: [n(90, 3)],
  });

  final setsA = await db.sessionsDao.setsOf(a);
  ids.editedSet = setsA
      .where((s) => s.exerciseId == ids.squat && s.sortOrder == 2)
      .single
      .id;
  await history.updateSet(
    ids.editedSet,
    const SetValues(weight: 85, unit: WeightUnit.kg, reps: 8),
  );
  return ids;
}
