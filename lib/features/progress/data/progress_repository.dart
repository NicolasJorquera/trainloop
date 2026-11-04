import 'package:drift/drift.dart';

import '../../../data/db/app_database.dart';
import '../../../data/db/daos/sessions_dao.dart';
import '../../history/domain/personal_records.dart';
import '../../strength/domain/strength_rules.dart' as rules;

/// Un ejercicio en una sesión del historial: sus series hechas en orden.
class ExerciseSession {
  const ExerciseSession(this.session, this.sets);

  final Session session;

  /// Series hechas (incluido el calentamiento), en orden.
  final List<SetLog> sets;

  /// Series que cuentan (sin calentamiento).
  List<SetLog> get working => sets.where(countsForRecords).toList();

  /// Mejor serie (la "última marca"): la más pesada con al menos 1
  /// repetición y, a igual peso, la de más repeticiones; sin peso, la de más
  /// repeticiones o la más larga.
  SetLog? get bestSet {
    final w = working;
    if (w.isEmpty) return null;
    int score(SetLog s) => s.weightGrams ?? 0;
    return w.reduce((a, b) {
      if (score(a) != score(b)) return score(a) >= score(b) ? a : b;
      final ra = a.reps ?? 0, rb = b.reps ?? 0;
      if (ra != rb) return ra >= rb ? a : b;
      return (a.durationSeconds ?? 0) >= (b.durationSeconds ?? 0) ? a : b;
    });
  }

  /// Mejor 1RM estimado de la sesión (Epley, 1–12 reps), en gramos.
  double? get bestOneRmGrams {
    double? best;
    for (final s in working) {
      final rm = rules.estimatedOneRmGrams(s.weightGrams, s.reps);
      if (rm != null && (best == null || rm > best)) best = rm;
    }
    return best;
  }

  /// Volumen del ejercicio en la sesión, sin calentamiento.
  int get volumeGrams => rules.volumeGrams(sets);
}

/// Historial de un ejercicio, de la sesión más antigua a la más reciente.
class ExerciseProgress {
  const ExerciseProgress(this.exercise, this.sessions);

  final Exercise exercise;
  final List<ExerciseSession> sessions;

  ExerciseSession? get last => sessions.lastOrNull;

  ExerciseSession? get previous =>
      sessions.length < 2 ? null : sessions[sessions.length - 2];

  /// La mejor serie de la última sesión iguala la de la anterior.
  bool get sameAsPrevious {
    final a = last?.bestSet, b = previous?.bestSet;
    if (a == null || b == null) return false;
    return a.weightGrams == b.weightGrams &&
        a.reps == b.reps &&
        a.durationSeconds == b.durationSeconds;
  }
}

/// Lecturas de Progreso (S14) y del detalle de ejercicio (S15) sobre las
/// series del historial.
class ProgressRepository {
  ProgressRepository(this._db);

  final AppDatabase _db;

  /// Se actualiza con cada cambio de sesiones o series.
  Stream<List<ExerciseProgress>> watchAll() => _db
      .customSelect(
        'SELECT 1',
        readsFrom: {_db.sessions, _db.setLogs, _db.exercises},
      )
      .watch()
      .asyncMap((_) => loadAll());

  /// Ejercicios con series hechas en el historial, el más reciente primero.
  Future<List<ExerciseProgress>> loadAll({String? exerciseId}) async {
    final db = _db;
    final query =
        db.select(db.setLogs).join([
            innerJoin(
              db.sessions,
              db.sessions.id.equalsExp(db.setLogs.sessionId),
            ),
            innerJoin(
              db.exercises,
              db.exercises.id.equalsExp(db.setLogs.exerciseId),
            ),
            innerJoin(
              db.sessionExercises,
              db.sessionExercises.id.equalsExp(db.setLogs.sessionExerciseId),
            ),
          ])
          ..where(
            db.setLogs.completed.equals(true) &
                db.sessions.archivedAt.isNull() &
                db.sessions.status.isInValues(SessionsDao.historyStatuses) &
                (exerciseId == null
                    ? const Constant(true)
                    : db.setLogs.exerciseId.equals(exerciseId)),
          )
          ..orderBy([
            OrderingTerm.asc(db.sessions.startedAt),
            OrderingTerm.asc(db.sessionExercises.sortOrder),
            OrderingTerm.asc(db.setLogs.sortOrder),
          ]);
    final rows = await query.get();
    final exercises = <String, Exercise>{};
    final bySession = <String, Map<String, (Session, List<SetLog>)>>{};
    for (final r in rows) {
      final e = r.readTable(db.exercises);
      final s = r.readTable(db.sessions);
      exercises[e.id] = e;
      final perSession = bySession[e.id] ??= {};
      (perSession[s.id] ??= (s, [])).$2.add(r.readTable(db.setLogs));
    }
    final out = [
      for (final MapEntry(key: id, value: sessions) in bySession.entries)
        ExerciseProgress(exercises[id]!, [
          for (final (s, sets) in sessions.values) ExerciseSession(s, sets),
        ]),
    ];
    out.sort(
      (a, b) => b.last!.session.startedAt.compareTo(a.last!.session.startedAt),
    );
    return out;
  }

  Stream<ExerciseProgress?> watchExercise(String exerciseId) => _db
      .customSelect(
        'SELECT 1',
        readsFrom: {_db.sessions, _db.setLogs, _db.exercises},
      )
      .watch()
      .asyncMap((_) async {
        final list = await loadAll(exerciseId: exerciseId);
        if (list.isNotEmpty) return list.single;
        final e = await _db.exercisesDao.findById(exerciseId);
        return e == null ? null : ExerciseProgress(e, const []);
      });
}
