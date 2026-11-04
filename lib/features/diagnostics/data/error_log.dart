import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../domain/error_reporter.dart';

/// Registro local de errores (NF-04 sin proveedor): un anillo acotado de las
/// últimas [maxEntries] entradas en `files/diagnostics/errors.jsonl`, con
/// escritura atómica. No sale del teléfono (NF-07): solo se comparte si la
/// persona lo exporta desde Configuración.
///
/// Los errores del motor nativo (Kotlin) los guarda `CrashLog.kt` en
/// `native_crashes.log` en la misma carpeta; [exportText] los incluye.
class ErrorLog implements ErrorReporter {
  /// Registro en archivo, dentro de la carpeta que devuelve [directory]
  /// (se resuelve en la primera lectura o escritura: no demora el
  /// arranque).
  ErrorLog({
    required Future<Directory> Function() directory,
    required this.appVersion,
    DateTime Function()? clock,
  }) : _directory = directory,
       _clock = clock ?? DateTime.now;

  /// Solo en memoria (pruebas y la app sin `main`).
  ErrorLog.memory({this.appVersion = '', DateTime Function()? clock})
    : _directory = null,
      _clock = clock ?? DateTime.now;

  static const fileName = 'errors.jsonl';
  static const nativeFileName = 'native_crashes.log';
  static const maxEntries = 50;
  static const maxMessageChars = 2000;
  static const maxStackLines = 30;

  final Future<Directory> Function()? _directory;
  final DateTime Function() _clock;
  final String appVersion;

  List<ErrorEntry>? _entries;
  Future<void> _queue = Future.value();

  /// Avisa cuando cambia el registro (para el contador de Configuración).
  final changes = ValueNotifier<int>(0);

  @override
  void record(
    Object error,
    StackTrace? stack, {
    required ErrorSource source,
    bool fatal = false,
    String? context,
  }) {
    try {
      final message = _clip(
        '${error.runtimeType}: $error${context == null ? '' : ' ($context)'}',
      );
      final entry = ErrorEntry(
        at: _clock().toUtc(),
        source: source,
        fatal: fatal,
        message: message,
        stack: _trimStack(stack),
        appVersion: appVersion,
      );
      unawaited(
        _enqueue(() async {
          final entries = await _load();
          if (entries.isNotEmpty && entries.last.sameAs(entry)) {
            entries[entries.length - 1] = entries.last.repeated(entry.at);
          } else {
            entries.add(entry);
            if (entries.length > maxEntries) {
              entries.removeRange(0, entries.length - maxEntries);
            }
          }
          await _save(entries);
          changes.value++;
        }),
      );
    } catch (_) {
      // El registro nunca puede romper la app.
    }
  }

  /// Entradas de la más vieja a la más nueva.
  Future<List<ErrorEntry>> entries() async {
    await _queue;
    return List.unmodifiable(await _load());
  }

  /// Errores de Dart más los del motor nativo.
  Future<int> count() async =>
      (await entries()).length + (await _nativeEntries()).length;

  /// Texto para compartir: encabezado y los errores, del más nuevo al más
  /// viejo.
  Future<String> exportText() async {
    final dart = await entries();
    final native = await _nativeEntries();
    final b = StringBuffer()
      ..writeln('Trainloop $appVersion · registro de errores / error log')
      ..writeln('Exportado / exported: ${_clock().toUtc().toIso8601String()}')
      ..writeln();
    for (final e in dart.reversed) {
      b.writeln(e.toText());
    }
    if (native.isNotEmpty) {
      b.writeln('--- nativo / native ---');
      for (final e in native.reversed) {
        b
          ..writeln(e)
          ..writeln();
      }
    }
    return b.toString();
  }

  /// Vacía el registro (también el nativo).
  Future<void> clear() => _enqueue(() async {
    _entries = [];
    await _save(const []);
    final dir = await _dir();
    final native = dir == null ? null : File('${dir.path}/$nativeFileName');
    if (native != null && native.existsSync()) await native.delete();
    changes.value++;
  });

  /// Las escrituras van de a una. Un fallo no corta la cola.
  Future<void> _enqueue(Future<void> Function() task) {
    final run = _queue.then((_) => task());
    _queue = run.catchError((Object _) {});
    return run;
  }

  Future<Directory?> _dir() async {
    final f = _directory;
    if (f == null) return null;
    final dir = await f();
    await dir.create(recursive: true);
    return dir;
  }

  Future<List<ErrorEntry>> _load() async {
    final cached = _entries;
    if (cached != null) return cached;
    final loaded = <ErrorEntry>[];
    try {
      final dir = await _dir();
      final file = dir == null ? null : File('${dir.path}/$fileName');
      if (file != null && file.existsSync()) {
        for (final line in await file.readAsLines()) {
          if (line.trim().isEmpty) continue;
          try {
            final e = ErrorEntry.tryFromJson(jsonDecode(line));
            if (e != null) loaded.add(e);
          } catch (_) {
            // Línea dañada (p. ej. corte a mitad de escritura): se salta.
          }
        }
      }
    } catch (_) {
      // Sin archivo legible: se empieza de cero.
    }
    if (loaded.length > maxEntries) {
      loaded.removeRange(0, loaded.length - maxEntries);
    }
    return _entries = loaded;
  }

  Future<void> _save(List<ErrorEntry> entries) async {
    final dir = await _dir();
    if (dir == null) return;
    final file = File('${dir.path}/$fileName');
    final tmp = File('${file.path}.tmp');
    await tmp.writeAsString(
      entries.map((e) => jsonEncode(e.toJson())).join('\n'),
      flush: true,
    );
    await tmp.rename(file.path);
  }

  /// Entradas de `CrashLog.kt`, separadas por una línea `---`.
  Future<List<String>> _nativeEntries() async {
    try {
      final dir = await _dir();
      final file = dir == null ? null : File('${dir.path}/$nativeFileName');
      if (file == null || !file.existsSync()) return const [];
      return (await file.readAsString())
          .split('\n---\n')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  static String _clip(String s) =>
      s.length <= maxMessageChars ? s : '${s.substring(0, maxMessageChars)}…';

  static String _trimStack(StackTrace? stack) {
    if (stack == null) return '';
    final lines = stack
        .toString()
        .split('\n')
        .where((l) => l.trim().isNotEmpty)
        .toList();
    if (lines.length <= maxStackLines) return lines.join('\n');
    return [
      ...lines.take(maxStackLines),
      '… (${lines.length - maxStackLines})',
    ].join('\n');
  }
}
