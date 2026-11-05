import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/app_info.dart';
import 'features/diagnostics/application/error_handling.dart';
import 'features/settings/application/settings_controller.dart';
import 'features/settings/data/settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Registro local de errores (NF-04), antes que nada. La carpeta se
  // resuelve recién al primer error: no suma al arranque (NF-02).
  final errorLog = ErrorLog(
    directory: () async => Directory(
      '${(await getApplicationSupportDirectory()).path}/diagnostics',
    ),
    appVersion: appVersion,
  );
  // Aquí se suma un proveedor (p. ej. Crashlytics) cuando Gestión lo
  // decida: `MultiErrorReporter([errorLog, proveedor])`.
  installErrorHandlers(errorLog);
  _registerFontLicenses();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(
          SharedPreferencesSettingsRepository(prefs),
        ),
        errorLogProvider.overrideWithValue(errorLog),
      ],
      child: const TrainloopApp(),
    ),
  );
}

/// Las fuentes van empaquetadas (OFL); su licencia aparece en "Licencias".
void _registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    for (final (package, file) in [
      ('Barlow Condensed', 'OFL-BarlowCondensed.txt'),
      ('Inter', 'OFL-Inter.txt'),
    ]) {
      yield LicenseEntryWithLineBreaks([
        package,
      ], await rootBundle.loadString('assets/fonts/$file'));
    }
  });
}
