import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../data/db/app_database.dart';
import '../../../data/db/enums.dart';
import '../../history/data/history_repository.dart';
import '../../history/domain/week.dart';

/// Exportación CSV (F-14): un archivo de sesiones y otro de series, para
/// hojas de cálculo. Idioma neutro: punto decimal, fechas ISO 8601 con el
/// desfase local de la sesión y encabezados en inglés (snake_case). Los
/// nombres (rutina, entrenamiento, ejercicio) van como se ven en la app.
/// UTF-8 con BOM y fin de línea CRLF (RFC 4180) para que Excel lo abra bien.
abstract final class CsvExport {
  static const mimeType = 'text/csv';

  static String sessionsFileName(DateTime now) =>
      'trainloop-sessions-${_date(now)}.csv';

  static String setsFileName(DateTime now) =>
      'trainloop-sets-${_date(now)}.csv';

  static const sessionHeader = [
    'session_id',
    'started_at',
    'ended_at',
    'type',
    'status',
    'name',
    'active_seconds',
    'paused_seconds',
    'completed_sets',
    'volume_kg',
    'rounds_done',
    'rounds_planned',
    'work_seconds',
    'perceived_effort',
    'note',
  ];

  static const setHeader = [
    'session_id',
    'session_started_at',
    'exercise',
    'exercise_key',
    'exercise_order',
    'set_order',
    'set_type',
    'weight',
    'unit',
    'weight_kg',
    'reps',
    'rpe',
    'duration_seconds',
    'distance_m',
    'logged_at',
  ];

  /// Sesiones del historial (completadas e incompletas, sin borradas), de la
  /// más antigua a la más reciente.
  static Future<String> sessions(
    AppDatabase db, {
    required String Function(HistoryEntry) titleOf,
  }) async {
    final entries = (await HistoryRepository(db).loadEntries()).reversed;
    final rows = [
      for (final e in entries)
        [
          e.id,
          isoWithOffset(e.session.startedAt, e.session.utcOffsetMinutes),
          e.session.endedAt == null
              ? null
              : isoWithOffset(e.session.endedAt!, e.session.utcOffsetMinutes),
          e.kind.name,
          e.session.status.name,
          titleOf(e),
          e.activeSeconds,
          e.session.pausedSeconds,
          if (e.isStrength) e.completedSets else null,
          if (e.isStrength) _kg(e.volumeGrams) else null,
          if (e.isStrength) null else e.roundsDone,
          if (e.isStrength) null else e.roundsPlanned,
          if (e.isStrength) null else e.workSeconds,
          e.session.perceivedEffort,
          e.session.note,
        ],
    ];
    return encode(sessionHeader, rows);
  }

  /// Series hechas de las sesiones del historial, en orden.
  static Future<String> sets(
    AppDatabase db, {
    required String Function(Exercise) exerciseName,
  }) async {
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
                db.sessions.status.isInValues([
                  SessionStatus.completed,
                  SessionStatus.incomplete,
                ]),
          )
          ..orderBy([
            OrderingTerm.asc(db.sessions.startedAt),
            OrderingTerm.asc(db.sessionExercises.sortOrder),
            OrderingTerm.asc(db.setLogs.sortOrder),
          ]);
    final rows = [
      for (final r in await query.get())
        _setRow(
          r.readTable(db.setLogs),
          r.readTable(db.sessions),
          r.readTable(db.exercises),
          r.readTable(db.sessionExercises),
          exerciseName,
        ),
    ];
    return encode(setHeader, rows);
  }

  static List<Object?> _setRow(
    SetLog s,
    Session session,
    Exercise exercise,
    SessionExercise entry,
    String Function(Exercise) exerciseName,
  ) => [
    s.sessionId,
    isoWithOffset(session.startedAt, session.utcOffsetMinutes),
    exerciseName(exercise),
    exercise.catalogKey,
    entry.sortOrder + 1,
    s.sortOrder + 1,
    s.setType.name,
    s.weightValue,
    s.weightUnit?.name,
    s.weightGrams == null ? null : _kg(s.weightGrams!),
    s.reps,
    s.rpe,
    s.durationSeconds,
    s.distanceMeters,
    s.loggedAt == null
        ? null
        : isoWithOffset(s.loggedAt!, session.utcOffsetMinutes),
  ];

  static double _kg(int grams) => grams / 1000;

  /// `2026-10-28T18:30:00-03:00`: la hora local de la sesión con su desfase.
  static String isoWithOffset(DateTime utc, int offsetMinutes) {
    final local = utc.toUtc().add(Duration(minutes: offsetMinutes));
    final sign = offsetMinutes < 0 ? '-' : '+';
    final abs = offsetMinutes.abs();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${local.year.toString().padLeft(4, '0')}-${two(local.month)}-'
        '${two(local.day)}T${two(local.hour)}:${two(local.minute)}:'
        '${two(local.second)}$sign${two(abs ~/ 60)}:${two(abs % 60)}';
  }

  /// Texto CSV con BOM, CRLF y comillas solo donde hacen falta.
  static String encode(List<String> header, List<List<Object?>> rows) {
    final b = StringBuffer('﻿')..write(_line(header));
    for (final r in rows) {
      b.write(_line(r));
    }
    return b.toString();
  }

  static String _line(List<Object?> cells) =>
      '${cells.map(_cell).join(',')}\r\n';

  static String _cell(Object? v) {
    if (v == null) return '';
    final s = switch (v) {
      final double d when d == d.roundToDouble() => d.toStringAsFixed(1),
      final double d => _trimDouble(d),
      _ => '$v',
    };
    final needsQuotes =
        s.contains(',') ||
        s.contains('"') ||
        s.contains('\n') ||
        s.contains('\r') ||
        s.startsWith(' ') ||
        s.endsWith(' ');
    return needsQuotes ? '"${s.replaceAll('"', '""')}"' : s;
  }

  /// 62.5 → «62.5», 0.30000000000000004 → «0.3».
  static String _trimDouble(double d) {
    var s = d.toStringAsFixed(3);
    s = s.replaceFirst(RegExp(r'0+$'), '');
    return s.endsWith('.') ? '${s}0' : s;
  }

  static List<int> bytes(String csv) => utf8.encode(csv);
}

String _date(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';
