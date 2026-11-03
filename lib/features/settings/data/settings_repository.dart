import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/accent.dart';
import '../domain/app_settings.dart';

/// Persistencia de [AppSettings]. La lectura es síncrona: el almacenamiento
/// se abre antes de `runApp` para pintar el primer frame con el tema correcto.
///
/// Implementación actual: shared_preferences. En el entregable 2 (Drift)
/// basta con otra implementación de esta interfaz.
abstract interface class SettingsRepository {
  AppSettings load();

  Future<void> save(AppSettings settings);
}

/// [SettingsRepository] sobre shared_preferences.
class SharedPreferencesSettingsRepository implements SettingsRepository {
  SharedPreferencesSettingsRepository(this._prefs);

  static const keyTheme = 'settings.theme';
  static const keyAccent = 'settings.accent';
  static const keyLanguage = 'settings.language';

  final SharedPreferences _prefs;

  @override
  AppSettings load() => AppSettings(
    theme: ThemePreference.fromName(_prefs.getString(keyTheme)),
    accent: AccentPreset.fromName(_prefs.getString(keyAccent)),
    language: AppLanguage.fromName(_prefs.getString(keyLanguage)),
  );

  @override
  Future<void> save(AppSettings settings) async {
    await Future.wait([
      _prefs.setString(keyTheme, settings.theme.name),
      _prefs.setString(keyAccent, settings.accent.name),
      _prefs.setString(keyLanguage, settings.language.name),
    ]);
  }
}

/// [SettingsRepository] en memoria, para pruebas.
class InMemorySettingsRepository implements SettingsRepository {
  InMemorySettingsRepository([this.value = const AppSettings()]);

  AppSettings value;

  @override
  AppSettings load() => value;

  @override
  Future<void> save(AppSettings settings) async => value = settings;
}
