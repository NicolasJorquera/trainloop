import 'dart:typed_data';

import 'package:trainloop/features/reminders/domain/reminder_schedule.dart';
import 'package:trainloop/platform/documents_client.dart';
import 'package:trainloop/platform/reminder_client.dart';

/// Recordatorios sin canal nativo: guarda lo que se programó.
class FakeReminderClient implements ReminderClient {
  final scheduled = <Map<String, Object?>>[];

  Map<String, Object?>? get last => scheduled.isEmpty ? null : scheduled.last;

  @override
  Future<void> schedule(ReminderSchedule s, ReminderTexts texts) async =>
      scheduled.add(reminderPayload(s, texts));
}

/// Selector de documentos de prueba: «guarda» en memoria y «abre» lo que se
/// le indique en [toOpen].
class FakeDocumentsClient implements DocumentsClient {
  final saved = <String, List<int>>{};
  List<int>? toOpen;
  bool cancel = false;

  @override
  Future<String?> save({
    required String name,
    required String mimeType,
    required List<int> bytes,
  }) async {
    if (cancel) return null;
    saved[name] = bytes;
    return name;
  }

  @override
  Future<PickedDocument?> open() async {
    final bytes = toOpen;
    if (cancel || bytes == null) return null;
    return PickedDocument(bytes: Uint8List.fromList(bytes), name: 'backup');
  }
}
