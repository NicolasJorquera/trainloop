import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// UUID v4 generado en el teléfono.
String newId() => _uuid.v4();

/// Instante actual en UTC.
DateTime nowUtc() => DateTime.now().toUtc();

/// Fechas como milisegundos UTC (entero). En Dart siempre llegan en UTC.
class UtcMillisConverter extends TypeConverter<DateTime, int> {
  const UtcMillisConverter();

  @override
  DateTime fromSql(int fromDb) =>
      DateTime.fromMillisecondsSinceEpoch(fromDb, isUtc: true);

  @override
  int toSql(DateTime value) => value.millisecondsSinceEpoch;
}

/// Objeto JSON guardado como texto (copia de la plantilla en la sesión).
class JsonMapConverter extends TypeConverter<Map<String, Object?>, String> {
  const JsonMapConverter();

  @override
  Map<String, Object?> fromSql(String fromDb) =>
      (jsonDecode(fromDb) as Map).cast<String, Object?>();

  @override
  String toSql(Map<String, Object?> value) => jsonEncode(value);
}
