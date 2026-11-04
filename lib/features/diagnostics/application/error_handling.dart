import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/error_log.dart';
import '../domain/error_reporter.dart';

export '../data/error_log.dart';
export '../domain/error_reporter.dart';

/// Registro local de errores. `main` lo sobrescribe con el de archivo; por
/// defecto (pruebas) vive en memoria.
final errorLogProvider = Provider<ErrorLog>((ref) => ErrorLog.memory());

/// Cantidad de errores del registro (Configuración). Se recalcula cuando
/// el registro cambia.
final errorCountProvider = FutureProvider.autoDispose<int>((ref) {
  final log = ref.watch(errorLogProvider);
  void listener() => ref.invalidateSelf();
  log.changes.addListener(listener);
  ref.onDispose(() => log.changes.removeListener(listener));
  return log.count();
});

/// Engancha [reporter] a los errores no capturados (NF-04):
///
/// * `FlutterError.onError`: errores del framework (construcción, dibujo,
///   gestos y canales de plataforma). Se siguen mostrando en la consola.
/// * `PlatformDispatcher.instance.onError`: errores asíncronos que nadie
///   capturó. Reemplaza a `runZonedGuarded`, que Flutter ya no recomienda
///   para esto y que obliga a crear el binding dentro de la zona.
///
/// En depuración devuelve `false` para que el error siga apareciendo como
/// siempre; en release, `true` (la app sigue).
void installErrorHandlers(ErrorReporter reporter) {
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    reporter.record(
      details.exception,
      details.stack,
      source: ErrorSource.flutter,
      fatal: !details.silent,
      context: details.context?.toDescription(),
    );
    previous?.call(details);
  };
  final dispatcher = PlatformDispatcher.instance;
  final previousDispatcher = dispatcher.onError;
  dispatcher.onError = (error, stack) {
    reporter.record(error, stack, source: ErrorSource.platform, fatal: true);
    final handled = previousDispatcher?.call(error, stack) ?? false;
    return handled || !kDebugMode;
  };
}
