import 'package:drift/drift.dart';

import '../app_database.dart';
import '../converters.dart';
import '../tables.dart';

part 'plan_dao.g.dart';

/// Plan semanal (día → entrenamiento) y recordatorios.
@DriftAccessor(tables: [PlanDays, Reminders])
class PlanDao extends DatabaseAccessor<AppDatabase> with _$PlanDaoMixin {
  PlanDao(super.attachedDatabase);

  Stream<List<PlanDay>> watchPlan() =>
      (select(planDays)..orderBy([
            (t) => OrderingTerm.asc(t.weekday),
            (t) => OrderingTerm.asc(t.sortOrder),
          ]))
          .watch();

  /// Reemplaza los entrenamientos de un día (ISO 1–7) en una transacción.
  Future<void> setDay(int weekday, List<PlanDaysCompanion> entries) =>
      transaction(() async {
        await (delete(planDays)..where((t) => t.weekday.equals(weekday))).go();
        for (final (i, e) in entries.indexed) {
          await into(
            planDays,
          ).insert(e.copyWith(weekday: Value(weekday), sortOrder: Value(i)));
        }
      });

  Stream<List<Reminder>> watchReminders() =>
      (select(reminders)..orderBy([
            (t) => OrderingTerm.asc(t.weekday),
            (t) => OrderingTerm.asc(t.minuteOfDay),
          ]))
          .watch();

  Future<String> addReminder(RemindersCompanion entry) async =>
      (await into(reminders).insertReturning(entry)).id;

  Future<void> editReminder(String id, RemindersCompanion changes) =>
      (update(reminders)..where((t) => t.id.equals(id))).write(
        changes.copyWith(updatedAt: Value(nowUtc())),
      );

  /// Los recordatorios no los referencia el historial: se borran de verdad.
  Future<int> deleteReminder(String id) =>
      (delete(reminders)..where((t) => t.id.equals(id))).go();
}
