import 'package:flutter/foundation.dart';

/// Recordatorio local (F-13): días de la semana (ISO 1 = lunes … 7 =
/// domingo) y una hora local común. Máximo uno por día; nunca si ya se
/// entrenó ese día (lo decide el receptor nativo al sonar).
@immutable
class ReminderSchedule {
  const ReminderSchedule({
    this.enabled = false,
    this.weekdays = const {},
    this.minuteOfDay = defaultMinute,
  });

  /// 18:00.
  static const defaultMinute = 18 * 60;

  /// Días que se proponen al activarlo sin días elegidos: lunes, miércoles
  /// y viernes.
  static const suggestedDays = {1, 3, 5};

  final bool enabled;
  final Set<int> weekdays;
  final int minuteOfDay;

  /// Activo y con al menos un día.
  bool get active => enabled && weekdays.isNotEmpty;

  ReminderSchedule copyWith({
    bool? enabled,
    Set<int>? weekdays,
    int? minuteOfDay,
  }) => ReminderSchedule(
    enabled: enabled ?? this.enabled,
    weekdays: weekdays ?? this.weekdays,
    minuteOfDay: minuteOfDay ?? this.minuteOfDay,
  );

  /// Cambia un día; si no queda ninguno, se desactiva.
  ReminderSchedule toggleDay(int weekday) {
    final days = {...weekdays};
    if (!days.remove(weekday)) days.add(weekday);
    return copyWith(weekdays: days, enabled: enabled && days.isNotEmpty);
  }

  /// Activa (proponiendo días si no hay) o desactiva, sin olvidar los días.
  ReminderSchedule withEnabled(bool on) => copyWith(
    enabled: on,
    weekdays: on && weekdays.isEmpty ? suggestedDays : weekdays,
  );

  @override
  bool operator ==(Object other) =>
      other is ReminderSchedule &&
      other.enabled == enabled &&
      setEquals(other.weekdays, weekdays) &&
      other.minuteOfDay == minuteOfDay;

  @override
  int get hashCode =>
      Object.hash(enabled, Object.hashAllUnordered(weekdays), minuteOfDay);

  @override
  String toString() =>
      'ReminderSchedule(enabled: $enabled, days: $weekdays, $minuteOfDay)';
}

/// Próximo recordatorio estrictamente después de [now] (hora local), o
/// `null` si no está activo. Igual que `ReminderScheduler.nextTrigger` en
/// Kotlin, que es quien programa la alarma.
DateTime? nextReminder(ReminderSchedule s, DateTime now) {
  if (!s.active) return null;
  for (var offset = 0; offset <= 7; offset++) {
    // DateTime local: un salto de horario de verano corre la hora.
    final candidate = DateTime(
      now.year,
      now.month,
      now.day + offset,
      s.minuteOfDay ~/ 60,
      s.minuteOfDay % 60,
    );
    if (!s.weekdays.contains(candidate.weekday)) continue;
    if (candidate.isAfter(now)) return candidate;
  }
  return null;
}
