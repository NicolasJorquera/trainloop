import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/data/db/app_database.dart';
import 'package:trainloop/data/db/database_providers.dart';
import 'package:trainloop/features/reminders/application/reminder_controller.dart';
import 'package:trainloop/features/reminders/data/reminder_repository.dart';
import 'package:trainloop/features/reminders/domain/reminder_schedule.dart';
import 'package:trainloop/features/reminders/presentation/reminder_section.dart';
import 'package:trainloop/features/settings/domain/app_settings.dart';
import 'package:trainloop/platform/reminder_client.dart';

import '../../helpers/fake_platform.dart';
import '../../helpers/fake_timer_engine.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/test_database.dart';

const _texts = ReminderTexts(title: 't', body: 'b', channelName: 'c');

void main() {
  group('nextReminder', () {
    // Martes 3 de noviembre de 2026, 10:00.
    final now = DateTime(2026, 11, 3, 10);

    test('apagado o sin días: ninguno', () {
      expect(nextReminder(const ReminderSchedule(), now), isNull);
      expect(nextReminder(const ReminderSchedule(enabled: true), now), isNull);
    });

    test('hoy si la hora no pasó; si no, el próximo día elegido', () {
      const s = ReminderSchedule(
        enabled: true,
        weekdays: {2, 4},
        minuteOfDay: 18 * 60,
      );
      expect(nextReminder(s, now), DateTime(2026, 11, 3, 18));
      expect(
        nextReminder(s, DateTime(2026, 11, 3, 18)),
        DateTime(2026, 11, 5, 18),
      );
      // Solo martes y ya pasó: el martes siguiente.
      expect(
        nextReminder(s.copyWith(weekdays: {2}), DateTime(2026, 11, 3, 19)),
        DateTime(2026, 11, 10, 18),
      );
    });

    test('máximo uno por día: una sola hora para todos los días', () {
      const s = ReminderSchedule(
        enabled: true,
        weekdays: {1, 2, 3, 4, 5, 6, 7},
        minuteOfDay: 7 * 60 + 30,
      );
      final first = nextReminder(s, now)!;
      final second = nextReminder(s, first)!;
      expect(second.difference(first).inHours, inInclusiveRange(23, 25));
    });
  });

  group('ReminderSchedule', () {
    test('activar sin días propone lunes, miércoles y viernes', () {
      final s = const ReminderSchedule().withEnabled(true);
      expect(s.active, isTrue);
      expect(s.weekdays, {1, 3, 5});
    });

    test('quitar el último día lo apaga; apagar no olvida los días', () {
      var s = const ReminderSchedule(enabled: true, weekdays: {3});
      s = s.toggleDay(3);
      expect(s.active, isFalse);
      s = const ReminderSchedule(enabled: true, weekdays: {1, 2});
      expect(s.withEnabled(false).weekdays, {1, 2});
    });

    test('orden de los días según el inicio de semana', () {
      expect(orderedWeekdays(WeekStart.monday), [1, 2, 3, 4, 5, 6, 7]);
      expect(orderedWeekdays(WeekStart.sunday), [7, 1, 2, 3, 4, 5, 6]);
    });
  });

  group('repositorio y programación', () {
    late AppDatabase db;
    setUp(() => db = openTestDatabase());
    tearDown(() => db.close());

    test('guarda una fila por día y la vuelve a leer', () async {
      final repo = ReminderRepository(db);
      expect(await repo.load(), const ReminderSchedule());
      const s = ReminderSchedule(
        enabled: true,
        weekdays: {1, 5},
        minuteOfDay: 6 * 60 + 45,
      );
      await repo.save(s);
      expect(await db.select(db.reminders).get(), hasLength(2));
      expect(await repo.load(), s);
      await repo.save(s.withEnabled(false));
      expect((await repo.load()).enabled, isFalse);
      expect((await repo.load()).weekdays, {1, 5});
    });

    test('el controlador guarda y envía al lado nativo', () async {
      final client = FakeReminderClient();
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          reminderClientProvider.overrideWithValue(client),
        ],
      );
      addTearDown(container.dispose);
      final controller = container.read(reminderControllerProvider.notifier);
      await container.read(reminderControllerProvider.future);

      // Sin textos todavía no se programa nada.
      await controller.change(
        const ReminderSchedule(enabled: true, weekdays: {2}),
      );
      expect(client.scheduled, isEmpty);

      await controller.setTexts(_texts);
      expect(client.last, {
        'enabled': true,
        'weekdays': [2],
        'minuteOfDay': 18 * 60,
        'title': 't',
        'body': 'b',
        'channelName': 'c',
      });
      // Los mismos textos no reprograman.
      await controller.setTexts(_texts);
      expect(client.scheduled, hasLength(1));

      await controller.change(
        const ReminderSchedule(enabled: true, weekdays: {2}).toggleDay(2),
      );
      expect(client.last!['enabled'], isFalse);

      // Tras restaurar un respaldo, sync relee la base.
      await ReminderRepository(db).save(
        const ReminderSchedule(enabled: true, weekdays: {6}, minuteOfDay: 600),
      );
      await controller.sync();
      expect(client.last!['weekdays'], [6]);
      expect(client.last!['minuteOfDay'], 600);
    });
  });

  group('S16 recordatorios', () {
    Future<void> openReminders(WidgetTester tester) async {
      await tester.tap(find.byKey(const Key('open-settings')));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.byKey(const Key('reminders-switch')),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
    }

    testWidgets('activar pide permiso, programa y muestra el próximo', (
      tester,
    ) async {
      useTallViewport(tester);
      final client = FakeReminderClient();
      final engine = FakeTimerEngine()..granted = false;
      await pumpTrainloop(tester, engine: engine, reminders: client);
      // Al abrir, la app envía los textos (apagado).
      expect(client.last!['enabled'], isFalse);
      await openReminders(tester);

      await tester.tap(find.byKey(const Key('reminders-switch')));
      await settleDb(tester);
      expect(engine.calls, contains('requestNotifications'));
      expect(client.last!['enabled'], isTrue);
      expect(client.last!['weekdays'], [1, 3, 5]);
      expect(find.byKey(const Key('reminders-next')), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('reminder-day-7')));
      await settleDb(tester);
      expect(client.last!['weekdays'], [1, 3, 5, 7]);
    });

    testWidgets('sin permiso queda apagado y explica por qué', (tester) async {
      useTallViewport(tester);
      final client = FakeReminderClient();
      final engine = FakeTimerEngine()
        ..granted = false
        ..grantOnRequest = false;
      await pumpTrainloop(tester, engine: engine, reminders: client);
      await openReminders(tester);
      await tester.tap(find.byKey(const Key('reminders-switch')));
      await settleDb(tester);
      expect(client.last!['enabled'], isFalse);
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
