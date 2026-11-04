import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/section_label.dart';
import '../../../platform/reminder_client.dart';
import '../../intervals/application/interval_providers.dart';
import '../../settings/application/settings_controller.dart';
import '../../settings/domain/app_settings.dart';
import '../application/reminder_controller.dart';
import '../domain/reminder_schedule.dart';

/// Hora local «18:00» (o «6:00 PM» en inglés) de un minuto del día.
String reminderTime(BuildContext context, int minuteOfDay) =>
    MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay(hour: minuteOfDay ~/ 60, minute: minuteOfDay % 60),
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );

/// Días ISO en el orden de la semana elegida en Configuración.
List<int> orderedWeekdays(WeekStart start) => [
  for (var i = 0; i < 7; i++) (start.weekday - 1 + i) % 7 + 1,
];

/// S16 · RECORDATORIOS (F-13): activar, días y hora. Pide el permiso de
/// notificaciones al activarlo; si se niega, queda apagado.
class ReminderSection extends ConsumerWidget {
  const ReminderSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final schedule =
        ref.watch(reminderControllerProvider).value ?? const ReminderSchedule();
    final weekStart = ref.watch(settingsControllerProvider).weekStart;
    final controller = ref.read(reminderControllerProvider.notifier);
    final locale = context.locale.toLanguageTag();
    // 2026-11-02 es lunes: base para los nombres de los días.
    DateTime dayOf(int weekday) => DateTime(2026, 11, 1 + weekday);
    final next = nextReminder(schedule, DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionLabel(l10n.remindersTitle),
        SwitchListTile(
          key: const Key('reminders-switch'),
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.remindersEnable, style: t.body),
          subtitle: Text(
            l10n.remindersHelp,
            style: t.bodySm.copyWith(color: c.inkMuted),
          ),
          value: schedule.active,
          onChanged: (on) => _setEnabled(context, ref, schedule, on),
        ),
        const SizedBox(height: TlSpace.s2),
        Wrap(
          spacing: TlSpace.s2,
          runSpacing: TlSpace.s2,
          children: [
            for (final day in orderedWeekdays(weekStart))
              _DayChip(
                key: ValueKey('reminder-day-$day'),
                label: l10n.formattedValue(
                  DateFormat.E(locale).format(dayOf(day)),
                ),
                semanticLabel: DateFormat.EEEE(locale).format(dayOf(day)),
                selected: schedule.weekdays.contains(day),
                onTap: () => controller.change(schedule.toggleDay(day)),
              ),
          ],
        ),
        const SizedBox(height: TlSpace.s2),
        ListTile(
          key: const Key('reminders-time'),
          contentPadding: EdgeInsets.zero,
          minTileHeight: TlSize.touchMin,
          title: Text(l10n.remindersTime, style: t.body),
          trailing: Text(
            l10n.formattedValue(reminderTime(context, schedule.minuteOfDay)),
            style: t.title,
          ),
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(
                hour: schedule.minuteOfDay ~/ 60,
                minute: schedule.minuteOfDay % 60,
              ),
            );
            if (picked == null) return;
            await controller.change(
              schedule.copyWith(minuteOfDay: picked.hour * 60 + picked.minute),
            );
          },
        ),
        if (next != null)
          Text(
            l10n.remindersNext(
              DateFormat.EEEE(locale).format(next),
              reminderTime(context, next.hour * 60 + next.minute),
            ),
            key: const Key('reminders-next'),
            style: t.bodySm.copyWith(color: c.inkMuted),
          ),
      ],
    );
  }

  Future<void> _setEnabled(
    BuildContext context,
    WidgetRef ref,
    ReminderSchedule schedule,
    bool on,
  ) async {
    final controller = ref.read(reminderControllerProvider.notifier);
    if (!on) return controller.change(schedule.withEnabled(false));
    final engine = ref.read(timerEngineClientProvider);
    final granted = await engine.requestNotifications();
    if (!granted) {
      if (!context.mounted) return;
      final l10n = context.l10n;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.remindersDenied),
            action: SnackBarAction(
              label: l10n.remindersOpenSettings,
              onPressed: engine.openAppSettings,
            ),
          ),
        );
      return;
    }
    await controller.change(schedule.withEnabled(true));
  }
}

/// Día del recordatorio: 48 dp, con el nombre completo para TalkBack.
class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.label,
    required this.semanticLabel,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final String semanticLabel;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      toggled: selected,
      label: semanticLabel,
      excludeSemantics: true,
      child: Material(
        color: selected ? c.primaryBg : Colors.transparent,
        shape: CircleBorder(
          side: BorderSide(color: selected ? c.primaryBg : c.inkMuted),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: TlSize.touchMin,
              minHeight: TlSize.touchMin,
            ),
            child: Center(
              widthFactor: 1,
              heightFactor: 1,
              child: Padding(
                padding: const EdgeInsets.all(TlSpace.s1),
                child: Text(
                  label,
                  style: context.text.bodySm.copyWith(
                    color: selected ? c.primaryInk : c.ink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Mantiene la alarma nativa al día: envía los textos del idioma activo
/// al abrir la app y al cambiar de idioma (y con ellos, reprograma).
class ReminderSync extends ConsumerStatefulWidget {
  const ReminderSync({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<ReminderSync> createState() => _ReminderSyncState();
}

class _ReminderSyncState extends ConsumerState<ReminderSync> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context);
    final texts = ReminderTexts(
      title: l10n.reminderNotificationTitle,
      body: l10n.reminderNotificationBody,
      channelName: l10n.reminderChannelName,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(reminderControllerProvider.notifier).setTexts(texts);
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
