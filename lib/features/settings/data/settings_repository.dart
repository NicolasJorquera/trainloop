import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/accent.dart';
import '../../../core/units/weight_unit.dart';
import '../domain/app_settings.dart';

/// Persistencia de [AppSettings]. La lectura es síncrona: el almacenamiento
/// se abre antes de `runApp` para pintar el primer frame con el tema correcto.
///
/// Las preferencias quedan en shared_preferences (clave-valor, como define la
/// arquitectura); la base Drift guarda solo datos de entrenamiento.
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
  static const keyWeightUnit = 'settings.weightUnit';
  static const keyWeekStart = 'settings.weekStart';
  static const keySounds = 'settings.sounds';
  static const keyVoice = 'settings.voice';
  static const keyVibration = 'settings.vibration';
  static const keyWeeklyGoal = 'settings.weeklyGoal';

  static const _defaults = AppSettings();

  final SharedPreferences _prefs;

  @override
  AppSettings load() => AppSettings(
    theme: ThemePreference.fromName(_prefs.getString(keyTheme)),
    accent: AccentPreset.fromName(_prefs.getString(keyAccent)),
    language: AppLanguage.fromName(_prefs.getString(keyLanguage)),
    weightUnit: WeightUnit.fromName(_prefs.getString(keyWeightUnit)),
    weekStart: WeekStart.fromName(_prefs.getString(keyWeekStart)),
    sounds: _prefs.getBool(keySounds) ?? _defaults.sounds,
    voice: _prefs.getBool(keyVoice) ?? _defaults.voice,
    vibration: _prefs.getBool(keyVibration) ?? _defaults.vibration,
    weeklyGoal: (_prefs.getInt(keyWeeklyGoal) ?? _defaults.weeklyGoal).clamp(
      AppSettings.minWeeklyGoal,
      AppSettings.maxWeeklyGoal,
    ),
  );

  @override
  Future<void> save(AppSettings settings) async {
    await Future.wait([
      _prefs.setString(keyTheme, settings.theme.name),
      _prefs.setString(keyAccent, settings.accent.name),
      _prefs.setString(keyLanguage, settings.language.name),
      _prefs.setString(keyWeightUnit, settings.weightUnit.name),
      _prefs.setString(keyWeekStart, settings.weekStart.name),
      _prefs.setBool(keySounds, settings.sounds),
      _prefs.setBool(keyVoice, settings.voice),
      _prefs.setBool(keyVibration, settings.vibration),
      _prefs.setInt(keyWeeklyGoal, settings.weeklyGoal),
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
