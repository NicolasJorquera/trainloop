import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/reminders/domain/reminder_schedule.dart';

/// Textos ya traducidos de la notificación del recordatorio: el receptor
/// nativo no tiene acceso a l10n.
class ReminderTexts {
  const ReminderTexts({
    required this.title,
    required this.body,
    required this.channelName,
  });

  final String title;
  final String body;
  final String channelName;

  @override
  bool operator ==(Object other) =>
      other is ReminderTexts &&
      other.title == title &&
      other.body == body &&
      other.channelName == channelName;

  @override
  int get hashCode => Object.hash(title, body, channelName);
}

/// Programa la alarma nativa (`android/.../reminders/`).
abstract interface class ReminderClient {
  Future<void> schedule(ReminderSchedule schedule, ReminderTexts texts);
}

class MethodChannelReminderClient implements ReminderClient {
  static const _channel = MethodChannel('trainloop/reminders');

  @override
  Future<void> schedule(ReminderSchedule s, ReminderTexts texts) =>
      _channel.invokeMethod<void>('schedule', reminderPayload(s, texts));
}

/// Lo que recibe el lado nativo.
Map<String, Object?> reminderPayload(ReminderSchedule s, ReminderTexts t) => {
  'enabled': s.active,
  'weekdays': s.weekdays.toList()..sort(),
  'minuteOfDay': s.minuteOfDay,
  'title': t.title,
  'body': t.body,
  'channelName': t.channelName,
};

final reminderClientProvider = Provider<ReminderClient>(
  (ref) => MethodChannelReminderClient(),
);
