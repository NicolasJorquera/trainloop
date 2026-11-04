import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/database_providers.dart';
import '../../../platform/reminder_client.dart';
import '../data/reminder_repository.dart';
import '../domain/reminder_schedule.dart';

final reminderRepositoryProvider = Provider<ReminderRepository>(
  (ref) => ReminderRepository(ref.watch(appDatabaseProvider)),
);

final reminderControllerProvider =
    AsyncNotifierProvider<ReminderController, ReminderSchedule>(
      ReminderController.new,
    );

/// Estado del recordatorio: lo guarda en la base y lo envía al lado
/// nativo con los textos del idioma activo (que llegan con [setTexts]).
class ReminderController extends AsyncNotifier<ReminderSchedule> {
  ReminderTexts? _texts;

  @override
  Future<ReminderSchedule> build() =>
      ref.watch(reminderRepositoryProvider).load();

  Future<void> change(ReminderSchedule next) async {
    state = AsyncData(next);
    await ref.read(reminderRepositoryProvider).save(next);
    await _push(next);
  }

  /// Textos traducidos de la notificación. Con un idioma nuevo, reprograma.
  Future<void> setTexts(ReminderTexts texts) async {
    if (texts == _texts) return;
    _texts = texts;
    await sync();
  }

  /// Vuelve a leer la base (p. ej. tras restaurar un respaldo) y
  /// reprograma.
  Future<void> sync() async {
    final s = await ref.read(reminderRepositoryProvider).load();
    state = AsyncData(s);
    await _push(s);
  }

  Future<void> _push(ReminderSchedule s) async {
    final texts = _texts;
    if (texts == null) return;
    try {
      await ref.read(reminderClientProvider).schedule(s, texts);
    } on Exception {
      // Sin canal (pruebas o plataforma sin soporte): nada que programar.
    }
  }
}
