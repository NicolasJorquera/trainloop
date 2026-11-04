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

  /// Marca para recuperación una sesión que quedó en curso al cerrarse la
  /// app, con el punto guardado por el motor.
  Future<void> markRecoveryPending(
    String id, {
    required int phaseIndex,
    required int elapsedMs,
    required int pausedSeconds,
    DateTime? checkpointAt,
  }) => _edit(
    id,
    SessionsCompanion(
      status: const Value(SessionStatus.recoveryPending),
      checkpointPhaseIndex: Value(phaseIndex),
      checkpointElapsedMs: Value(elapsedMs),
      checkpointAt: Value((checkpointAt ?? DateTime.now()).toUtc()),
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
    int? pausedSeconds,
  }) => _edit(
    id,
    SessionsCompanion(
      status: Value(status),
      endedAt: Value((endedAt ?? DateTime.now()).toUtc()),
      perceivedEffort: Value(perceivedEffort),
      note: Value(note),
      pausedSeconds: pausedSeconds == null
          ? const Value.absent()
          : Value(pausedSeconds),
    ),
  );

  /// Esfuerzo percibido y nota del resumen (S06).
  Future<void> rate(String id, {int? perceivedEffort, String? note}) => _edit(
    id,
    SessionsCompanion(
      perceivedEffort: Value(perceivedEffort),
      note: Value(note),
    ),
  );

  Future<void> archive(String id) =>
      _edit(id, SessionsCompanion(archivedAt: Value(nowUtc())));

  /// Deshace [archive] (borrar del historial con deshacer, S13).
  Future<void> unarchive(String id) =>
      _edit(id, const SessionsCompanion(archivedAt: Value(null)));

  Future<String> addExercise({
    required String sessionId,
    required String exerciseId,
    required int sortOrder,
    int? restSeconds,
  }) async => (await into(sessionExercises).insertReturning(
    SessionExercisesCompanion.insert(
      sessionId: sessionId,
      exerciseId: exerciseId,
      sortOrder: sortOrder,
      restSeconds: Value(restSeconds),
    ),
  )).id;

  /// Ejercicios de la sesión en su orden, con el ejercicio de la biblioteca.
  Future<List<(SessionExercise, Exercise)>> exercisesOf(
    String sessionId,
  ) async {
    final rows =
        await (select(sessionExercises).join([
                innerJoin(
                  exercises,
                  exercises.id.equalsExp(sessionExercises.exerciseId),
                ),
              ])
              ..where(sessionExercises.sessionId.equals(sessionId))
              ..orderBy([OrderingTerm.asc(sessionExercises.sortOrder)]))
            .get();
    return [
      for (final r in rows)
        (r.readTable(sessionExercises), r.readTable(exercises)),
    ];
  }

  /// Series de la sesión (completadas o no) por ejercicio y orden.
  Future<List<SetLog>> setsOf(String sessionId) =>
      (select(setLogs)
            ..where((t) => t.sessionId.equals(sessionId))
            ..orderBy([
              (t) => OrderingTerm.asc(t.sessionExerciseId),
              (t) => OrderingTerm.asc(t.sortOrder),
            ]))
          .get();

  Future<SetLog?> findSet(String id) =>
      (select(setLogs)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Agrega una serie sin completar (objetivo o valores propuestos).
  Future<String> addPlannedSet(SetLogsCompanion entry) =>
      logSet(entry.copyWith(completed: const Value(false)));

  /// Quita una serie en su propia transacción.
  Future<void> deleteSet(String id) => transaction(() async {
    final row = await findSet(id);
    if (row == null) return;
    await (delete(setLogs)..where((t) => t.id.equals(id))).go();
    await _touch(row.sessionId);
  });

  /// Quita un ejercicio de la sesión con sus series.
  Future<void> deleteExercise(String id) => transaction(() async {
    final row = await (select(
      sessionExercises,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return;
    await (delete(setLogs)..where((t) => t.sessionExerciseId.equals(id))).go();
    await (delete(sessionExercises)..where((t) => t.id.equals(id))).go();
    await _touch(row.sessionId);
  });

  /// Guarda el orden de los ejercicios de una sesión.
  Future<void> reorderExercises(String sessionId, List<String> orderedIds) =>
      transaction(() async {
        for (final (i, id) in orderedIds.indexed) {
          await (update(sessionExercises)
                ..where((t) => t.id.equals(id) & t.sessionId.equals(sessionId)))
              .write(
                SessionExercisesCompanion(
                  sortOrder: Value(i),
                  updatedAt: Value(nowUtc()),
                ),
              );
        }
        await _touch(sessionId);
      });

  Future<void> setExerciseNotes(String id, String? notes) =>
      (update(sessionExercises)..where((t) => t.id.equals(id))).write(
        SessionExercisesCompanion(
          notes: Value(notes),
          updatedAt: Value(nowUtc()),
        ),
      );

  /// Sesiones de fuerza sin terminar (en curso o pendientes de
  /// recuperación), la más reciente primero.
  Future<List<Session>> findActiveStrength() =>
      (select(sessions)
            ..where(
              (t) =>
                  t.kind.equalsValue(SessionKind.strength) &
                  t.status.isInValues([
                    SessionStatus.inProgress,
                    SessionStatus.recoveryPending,
                  ]),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
          .get();

  /// Última sesión de fuerza del historial ("repetir la última").
  Stream<Session?> watchLastStrength() =>
      (select(sessions)
            ..where(
              (t) =>
                  t.kind.equalsValue(SessionKind.strength) &
                  t.status.isInValues(historyStatuses) &
                  t.archivedAt.isNull(),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
            ..limit(1))
          .watchSingleOrNull();

  /// Series completadas de [exerciseId] en la última sesión del historial
  /// que lo tiene (sin contar [excludeSessionId]), en su orden: la "última
  /// marca" de cada serie (R-G2).
  Future<List<SetLog>> lastSetsForExercise(
    String exerciseId, {
    String? excludeSessionId,
  }) async {
    final last =
        await (select(setLogs).join([
                innerJoin(sessions, sessions.id.equalsExp(setLogs.sessionId)),
              ])
              ..where(
                setLogs.exerciseId.equals(exerciseId) &
                    setLogs.completed.equals(true) &
                    sessions.archivedAt.isNull() &
                    sessions.status.isInValues(historyStatuses) &
                    (excludeSessionId == null
                        ? const Constant(true)
                        : sessions.id.equals(excludeSessionId).not()),
              )
              ..orderBy([OrderingTerm.desc(sessions.startedAt)])
              ..limit(1))
            .getSingleOrNull();
    if (last == null) return const [];
    final sessionId = last.readTable(sessions).id;
    final rows =
        await (select(setLogs).join([
                innerJoin(
                  sessionExercises,
                  sessionExercises.id.equalsExp(setLogs.sessionExerciseId),
                ),
              ])
              ..where(
                setLogs.sessionId.equals(sessionId) &
                    setLogs.exerciseId.equals(exerciseId) &
                    setLogs.completed.equals(true),
              )
              ..orderBy([
                OrderingTerm.asc(sessionExercises.sortOrder),
                OrderingTerm.asc(setLogs.sortOrder),
              ]))
            .get();
    return [for (final r in rows) r.readTable(setLogs)];
  }

  /// Series completadas de [exerciseId] en el historial, sin contar
  /// [excludeSessionId] (récords del resumen).
  Future<List<SetLog>> historySetsForExercise(
    String exerciseId, {
    required String excludeSessionId,
  }) async {
    final rows =
        await (select(setLogs).join([
              innerJoin(sessions, sessions.id.equalsExp(setLogs.sessionId)),
            ])..where(
              setLogs.exerciseId.equals(exerciseId) &
                  setLogs.completed.equals(true) &
                  sessions.archivedAt.isNull() &
                  sessions.status.isInValues(historyStatuses) &
                  sessions.id.equals(excludeSessionId).not(),
            ))
            .get();
    return [for (final r in rows) r.readTable(setLogs)];
  }

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

  /// Guarda la fase [IntervalPhaseLogsCompanion.sortOrder] en su propia
  /// transacción, reemplazando la que ya tuviera ese orden (volver a una fase
  /// la registra de nuevo). Idempotente: el motor puede reenviarla.
  Future<String> replacePhase(IntervalPhaseLogsCompanion entry) =>
      transaction(() async {
        await (delete(intervalPhaseLogs)..where(
              (t) =>
                  t.sessionId.equals(entry.sessionId.value) &
                  t.sortOrder.equals(entry.sortOrder.value),
            ))
            .go();
        return logPhase(entry);
      });

  /// Borra las fases de la sesión cuyo orden no está en [keep] (fases a las
  /// que se volvió y que no se terminaron de nuevo).
  Future<int> deletePhasesExcept(String sessionId, Set<int> keep) =>
      (delete(intervalPhaseLogs)..where(
            (t) => t.sessionId.equals(sessionId) & t.sortOrder.isNotIn(keep),
          ))
          .go();

  Future<List<IntervalPhaseLog>> phasesOf(String sessionId) =>
      (select(intervalPhaseLogs)
            ..where((t) => t.sessionId.equals(sessionId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

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
  /// completadas sin contar el calentamiento (R-G6), calculado en la base.
  Stream<int> watchVolumeGrams(String sessionId) {
    final volume = (setLogs.weightGrams * setLogs.reps).sum();
    final query = selectOnly(setLogs)
      ..addColumns([volume])
      ..where(
        setLogs.sessionId.equals(sessionId) &
            setLogs.completed.equals(true) &
            setLogs.setType.equalsValue(SetType.warmup).not(),
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
