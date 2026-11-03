import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainloop/core/theme/accent.dart';
import 'package:trainloop/features/settings/data/settings_repository.dart';
import 'package:trainloop/features/settings/domain/app_settings.dart';

void main() {
  test(
    'sin datos guardados usa Sistema, Orquídea e idioma del teléfono',
    () async {
      SharedPreferences.setMockInitialValues({});
      final repo = SharedPreferencesSettingsRepository(
        await SharedPreferences.getInstance(),
      );
      expect(repo.load(), const AppSettings());
    },
  );

  test('guarda y vuelve a leer las preferencias', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    const value = AppSettings(
      theme: ThemePreference.light,
      accent: AccentPreset.lima,
      language: AppLanguage.ptBR,
    );
    await SharedPreferencesSettingsRepository(prefs).save(value);
    expect(SharedPreferencesSettingsRepository(prefs).load(), value);
  });

  test('valores desconocidos vuelven al valor por defecto', () async {
    SharedPreferences.setMockInitialValues({
      SharedPreferencesSettingsRepository.keyTheme: 'sepia',
      SharedPreferencesSettingsRepository.keyAccent: 'magenta',
      SharedPreferencesSettingsRepository.keyLanguage: 'fr',
    });
    final repo = SharedPreferencesSettingsRepository(
      await SharedPreferences.getInstance(),
    );
    expect(repo.load(), const AppSettings());
  });
}
