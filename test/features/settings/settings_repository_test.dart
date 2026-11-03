import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainloop/core/theme/accent.dart';
import 'package:trainloop/core/units/weight_unit.dart';
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
      weightUnit: WeightUnit.lb,
      weekStart: WeekStart.sunday,
      sounds: false,
      voice: true,
      vibration: false,
      weeklyGoal: 5,
    );
    await SharedPreferencesSettingsRepository(prefs).save(value);
    expect(SharedPreferencesSettingsRepository(prefs).load(), value);
  });

  test('valores desconocidos vuelven al valor por defecto', () async {
    SharedPreferences.setMockInitialValues({
      SharedPreferencesSettingsRepository.keyTheme: 'sepia',
      SharedPreferencesSettingsRepository.keyAccent: 'magenta',
      SharedPreferencesSettingsRepository.keyLanguage: 'fr',
      SharedPreferencesSettingsRepository.keyWeightUnit: 'stone',
      SharedPreferencesSettingsRepository.keyWeekStart: 'friday',
    });
    final repo = SharedPreferencesSettingsRepository(
      await SharedPreferences.getInstance(),
    );
    expect(repo.load(), const AppSettings());
  });
  test(
    'preferencias nuevas: kg, lunes, voz, sonido y vibración (R-I7), 3 por semana',
    () {
      const s = AppSettings();
      expect(s.weightUnit, WeightUnit.kg);
      expect(s.weekStart, WeekStart.monday);
      expect([s.sounds, s.voice, s.vibration], [true, true, true]);
      expect(s.weeklyGoal, 3);
    },
  );

  test('el objetivo semanal fuera de rango se acota', () async {
    SharedPreferences.setMockInitialValues({
      SharedPreferencesSettingsRepository.keyWeeklyGoal: 99,
    });
    final repo = SharedPreferencesSettingsRepository(
      await SharedPreferences.getInstance(),
    );
    expect(repo.load().weeklyGoal, AppSettings.maxWeeklyGoal);
  });

  test('convierte kg y lb a gramos enteros', () {
    expect(WeightUnit.kg.toGrams(102.5), 102500);
    expect(WeightUnit.lb.toGrams(45), 20412);
    expect(WeightUnit.lb.fromGrams(20412), closeTo(45, 0.01));
  });
}
