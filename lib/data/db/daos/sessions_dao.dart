import 'package:drift/drift.dart';

import '../app_database.dart';
import '../converters.dart';
import '../enums.dart';
import '../tables.dart';

part 'sessions_dao.g.dart';

/// Sesiones (historial inmutable) con sus ejercicios, series y fases.
/// Cada serie y cada fase se guarda en su propia transacción (NF-06).
@DriftAccessor(tables: [Sessions, SessionExercises, SetLogs, IntervalPhaseLogs])
class SessionsDao extends DatabaseAccessor<AppDatabase>
    with _$SessionsDaoMixin {
  SessionsDao(super.attachedDatabase);

  /// Estados que aparecen en el historial.
  static const historyStatuses = [
    SessionStatus.completed,
    SessionStatus.incomplete,
  ];

  /// Empieza una sesión en curso con la copia de su plantilla.
  Future<String> start({
    required SessionKind kind,
    String? templateId,
    Map<String, Object?>? templateSnapshot,
    String? timeZoneId,
    DateTime? startedAt,
  }) async {
    final start = startedAt ?? DateTime.now();
    final row = await into(sessions).insertReturning(
      SessionsCompanion.insert(
        kind: kind,
        templateId: Value(templateId),
        status: SessionStatus.inProgress,
        startedAt: start.toUtc(),
        timeZoneId: Value(timeZoneId),
        utcOffsetMinutes: start.toLocal().timeZoneOffset.inMinutes,
        templateSnapshot: Value(templateSnapshot),
      ),
    );
    return row.id;
  }

  Future<Session?> findById(String id) =>
      (select(sessions)..where((t) => t.id.equals(id))).getSingleOrNull();

  Stream<Session?> watchById(String id) =>
      (select(sessions)..where((t) => t.id.equals(id))).watchSingleOrNull();

  /// Sesiones sin terminar (recuperación al abrir la app), la más reciente
  /// primero.
  Future<List<Session>> findRecoverable() =>
      (select(sessions)
            ..where(
              (t) => t.status.isInValues([
                SessionStatus.inProgress,
                SessionStatus.recoveryPending,
              ]),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
          .get();

  /// Historial: completadas e incompletas no archivadas, la más reciente
  /// primero.
  Stream<List<Session>> watchHistory({int? limit}) {
    final query = select(sessions)
      ..where(
        (t) => t.status.isInValues(historyStatuses) & t.archivedAt.isNull(),
      )
      ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]);
    if (limit != null) query.limit(limit);
    return query.watch();
  }

  Future<void> saveCheckpoint(
    String id, {
    required int phaseIndex,
    required int elapsedMs,
    required int pausedSeconds,
  }) => _edit(
    id,
    SessionsCompanion(
      checkpointPhaseIndex: Value(phaseIndex),
      checkpointElapsedMs: Value(elapsedMs),
      checkpointAt: Value(nowUtc()),
      pausedSeconds: Value(pausedSeconds),
    ),
  );

  Future<void> setStatus(String id, SessionStatus status) =>
      _edit(id, SessionsCompanion(status: Value(status)));

  Future<void> finish(
    String id, {
    required SessionStatus status,
    DateTime? endedAt,
    int? perceivedEffort,
    String? note,
  }) => _edit(
    id,
    SessionsCompanion(
      status: Value(status),
      endedAt: Value((endedAt ?? DateTime.now()).toUtc()),
      perceivedEffort: Value(perceivedEffort),
      note: Value(note),
    ),
  );

  Future<void> archive(String id) =>
      _edit(id, SessionsCompanion(archivedAt: Value(nowUtc())));

  Future<String> addExercise({
    required String sessionId,
    required String exerciseId,
    required int sortOrder,
  }) async => (await into(sessionExercises).insertReturning(
    SessionExercisesCompanion.insert(
      sessionId: sessionId,
      exerciseId: exerciseId,
      sortOrder: sortOrder,
    ),
  )).id;

  Stream<List<SessionExercise>> watchExercises(String sessionId) =>
      (select(sessionExercises)
            ..where((t) => t.sessionId.equals(sessionId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  /// Guarda una serie completa en su propia transacción: la reescribe si
  /// [entry] trae el id de una existente, si no la inserta. Calcula los
  /// gramos a partir del valor y la unidad.
  Future<String> logSet(SetLogsCompanion entry) => transaction(() async {
    final value = entry.weightValue.present ? entry.weightValue.value : null;
    final unit = entry.weightUnit.present ? entry.weightUnit.value : null;
    final data = entry.copyWith(
      weightGrams: Value(
        value != null && unit != null ? unit.toGrams(value) : null,
      ),
    );
    var id = entry.id.present ? entry.id.value : null;
    final updated =
        id != null &&
        await (update(setLogs)..where((t) => t.id.equals(id!))).write(
              data.copyWith(updatedAt: Value(nowUtc())),
            ) >
            0;
    if (!updated) id = (await into(setLogs).insertReturning(data)).id;
    final row = await (select(
      setLogs,
    )..where((t) => t.id.equals(id!))).getSingle();
    await _touch(row.sessionId);
    return row.id;
  });

  /// Guarda una fase de intervalos en su propia transacción.
  Future<String> logPhase(IntervalPhaseLogsCompanion entry) =>
      transaction(() async {
        final row = await into(intervalPhaseLogs).insertReturning(entry);
        await _touch(row.sessionId);
        return row.id;
      });

  Stream<List<SetLog>> watchSets(String sessionId) =>
      (select(setLogs)
            ..where((t) => t.sessionId.equals(sessionId))
            ..orderBy([
              (t) => OrderingTerm.asc(t.sessionExerciseId),
              (t) => OrderingTerm.asc(t.sortOrder),
            ]))
          .watch();

  /// Series completadas de un ejercicio en sesiones del historial, de la más
  /// antigua a la más reciente (gráficos y "la vez anterior").
  Stream<List<SetLog>> watchSetsForExercise(String exerciseId) {
    final query =
        select(setLogs).join([
            innerJoin(sessions, sessions.id.equalsExp(setLogs.sessionId)),
          ])
          ..where(
            setLogs.exerciseId.equals(exerciseId) &
                setLogs.completed.equals(true) &
                sessions.archivedAt.isNull() &
                sessions.status.isInValues(historyStatuses),
          )
          ..orderBy([
            OrderingTerm.asc(sessions.startedAt),
            OrderingTerm.asc(setLogs.sortOrder),
          ]);
    return query.watch().map(
      (rows) => [for (final r in rows) r.readTable(setLogs)],
    );
  }

  Stream<List<IntervalPhaseLog>> watchPhases(String sessionId) =>
      (select(intervalPhaseLogs)
            ..where((t) => t.sessionId.equals(sessionId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  /// Volumen de la sesión en gramos: suma de peso × reps de las series
  /// completadas, calculado en la base.
  Stream<int> watchVolumeGrams(String sessionId) {
    final volume = (setLogs.weightGrams * setLogs.reps).sum();
    final query = selectOnly(setLogs)
      ..addColumns([volume])
      ..where(
        setLogs.sessionId.equals(sessionId) & setLogs.completed.equals(true),
      );
    return query.watchSingle().map((row) => row.read(volume) ?? 0);
  }

  Future<void> _edit(String id, SessionsCompanion changes) =>
      (update(sessions)..where((t) => t.id.equals(id))).write(
        changes.copyWith(updatedAt: Value(nowUtc())),
      );

  Future<void> _touch(String sessionId) =>
      _edit(sessionId, const SessionsCompanion());
}
