import 'package:drift/drift.dart';

import '../../../data/db/app_database.dart';
import '../../../data/db/enums.dart';
import '../domain/interstitial_policy.dart';

/// Lo que el intersticial necesita de la base: la sesión que terminó y el
/// historial de R-A3 (`ad_state` + sesiones completadas).
class AdHistoryRepository {
  AdHistoryRepository(this._db);

  final AppDatabase _db;

  Future<Session?> session(String id) => _db.sessionsDao.findById(id);

  /// Duración sin pausas de una sesión terminada.
  static int activeSeconds(Session s) {
    final end = s.endedAt;
    if (end == null) return 0;
    final total = end.difference(s.startedAt).inSeconds - s.pausedSeconds;
    return total < 0 ? 0 : total;
  }

  Future<InterstitialHistory> history() async {
    final count = _db.sessions.id.count();
    final first = _db.sessions.startedAt.min();
    final row =
        await (_db.selectOnly(_db.sessions)
              ..addColumns([count, first])
              ..where(
                _db.sessions.status.equalsValue(SessionStatus.completed) &
                    _db.sessions.archivedAt.isNull(),
              ))
            .getSingle();
    final firstMillis = row.read(first);
    final state = await _db.adStateDao.read();
    return InterstitialHistory(
      completedSessions: row.read(count) ?? 0,
      firstSessionAt: firstMillis == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(firstMillis, isUtc: true),
      sessionsSinceInterstitial: state.sessionsSinceInterstitial,
      lastInterstitialAt: state.lastInterstitialAt,
    );
  }

  /// Suma una sesión completada para el tope «1 cada 3 sesiones».
  Future<void> countSession() => _db.adStateDao.countSession();

  Future<void> markShown() => _db.adStateDao.markInterstitialShown();
}
