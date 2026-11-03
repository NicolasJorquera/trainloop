import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'features/settings/application/settings_controller.dart';
import 'features/settings/data/settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _registerFontLicenses();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(
          SharedPreferencesSettingsRepository(prefs),
        ),
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
