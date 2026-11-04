import 'package:flutter/foundation.dart';

/// De dónde vino un error no capturado.
enum ErrorSource {
  /// `FlutterError.onError`: construcción, dibujo, gestos, canales.
  flutter,

  /// `PlatformDispatcher.instance.onError`: errores asíncronos sin capturar.
  platform,

  /// Un error que el código capturó y quiso dejar registrado.
  caught,
}

/// Un error del registro local. Solo lo técnico: tipo, mensaje y pila,
/// recortados. Nunca se agregan datos del entrenamiento a propósito.
@immutable
class ErrorEntry {
  const ErrorEntry({
    required this.at,
    required this.source,
    required this.fatal,
    required this.message,
    required this.stack,
    required this.appVersion,
    this.count = 1,
  });

  /// Última vez que ocurrió (UTC).
  final DateTime at;
  final ErrorSource source;

  /// `true` si nadie lo capturó (pudo cortar el flujo de la persona).
  final bool fatal;
  final String message;
  final String stack;
  final String appVersion;

  /// Veces seguidas que se repitió (se agrupan para no llenar el registro).
  final int count;

  /// Mismo error que [other] (para agrupar repeticiones seguidas).
  bool sameAs(ErrorEntry other) =>
      other.source == source &&
      other.message == message &&
      other.stack == stack &&
      other.fatal == fatal;

  ErrorEntry repeated(DateTime at) => ErrorEntry(
    at: at,
    source: source,
    fatal: fatal,
    message: message,
    stack: stack,
    appVersion: appVersion,
    count: count + 1,
  );

  Map<String, Object?> toJson() => {
    'at': at.toUtc().toIso8601String(),
    'source': source.name,
    'fatal': fatal,
    'message': message,
    'stack': stack,
    'appVersion': appVersion,
    'count': count,
  };

  /// `null` si la línea está dañada (se ignora).
  static ErrorEntry? tryFromJson(Object? json) {
    if (json is! Map) return null;
    try {
      return ErrorEntry(
        at: DateTime.parse(json['at']! as String),
        source: ErrorSource.values.byName(json['source']! as String),
        fatal: json['fatal']! as bool,
        message: json['message']! as String,
        stack: json['stack']! as String,
        appVersion: json['appVersion']! as String,
        count: json['count']! as int,
      );
    } catch (_) {
      return null;
    }
  }

  /// Texto legible para el archivo exportado.
  String toText() {
    final b = StringBuffer()
      ..writeln(
        '[${at.toUtc().toIso8601String()}] ${source.name}'
        '${fatal ? ' fatal' : ''}${count > 1 ? ' ×$count' : ''}'
        ' · $appVersion',
      )
      ..writeln(message);
    if (stack.isNotEmpty) b.writeln(stack);
    return b.toString();
  }
}

/// Destino de los errores no capturados (NF-04). Por defecto, solo el
/// registro local (`ErrorLog`), que nunca sale del teléfono salvo que la
/// persona lo exporte (NF-07). Para sumar un proveedor (p. ej. Firebase
/// Crashlytics) cuando Gestión lo decida: otra implementación y
/// `MultiErrorReporter([log, proveedor])` en `main`, igual que
/// `AnalyticsSink` para la analítica.
abstract interface class ErrorReporter {
  /// Nunca lanza: un error al registrar no puede tapar el original.
  void record(
    Object error,
    StackTrace? stack, {
    required ErrorSource source,
    bool fatal = false,
    String? context,
  });
}

/// Reparte cada error entre varios destinos.
class MultiErrorReporter implements ErrorReporter {
  const MultiErrorReporter(this.reporters);

  final List<ErrorReporter> reporters;

  @override
  void record(
    Object error,
    StackTrace? stack, {
    required ErrorSource source,
    bool fatal = false,
    String? context,
  }) {
    for (final r in reporters) {
      try {
        r.record(error, stack, source: source, fatal: fatal, context: context);
      } catch (_) {
        // Un destino caído no afecta a los demás.
      }
    }
  }
}
