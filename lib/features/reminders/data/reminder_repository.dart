import 'package:drift/drift.dart';

import '../../../data/db/app_database.dart';
import '../domain/reminder_schedule.dart';

/// Guarda el recordatorio en la tabla `reminder` (una fila por día, con la
/// misma hora y el mismo estado), así viaja en el respaldo.
class ReminderRepository {
  ReminderRepository(this._db);

  final AppDatabase _db;

  Future<ReminderSchedule> load() async {
    final rows = await _db.select(_db.reminders).get();
    if (rows.isEmpty) return const ReminderSchedule();
    return ReminderSchedule(
      enabled: rows.any((r) => r.enabled),
      weekdays: {for (final r in rows) r.weekday},
      minuteOfDay: rows.first.minuteOfDay,
    );
  }

  Future<void> save(ReminderSchedule s) => _db.transaction(() async {
    await _db.delete(_db.reminders).go();
    for (final day in s.weekdays.toList()..sort()) {
      await _db.planDao.addReminder(
        RemindersCompanion.insert(
          weekday: day,
          minuteOfDay: s.minuteOfDay,
          enabled: Value(s.enabled),
        ),
      );
    }
  });
}
