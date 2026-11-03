import 'package:flutter/material.dart';

import '../../../core/theme/accent.dart';
import '../../../core/units/weight_unit.dart';

/// Tema elegido en Configuración.
enum ThemePreference {
  system(ThemeMode.system),
  light(ThemeMode.light),
  dark(ThemeMode.dark);

  const ThemePreference(this.mode);

  final ThemeMode mode;

  static ThemePreference fromName(String? name) => ThemePreference.values
      .firstWhere((v) => v.name == name, orElse: () => ThemePreference.system);
}

/// Idioma elegido en Configuración. `system` sigue al teléfono (o al idioma
/// por app de Android 13+); `pseudo` solo existe en builds de depuración.
enum AppLanguage {
  system(null),
  es(Locale('es', '419')),
  en(Locale('en')),
  ptBR(Locale('pt', 'BR')),
  pseudo(Locale('en', 'XA'));

  const AppLanguage(this.locale);

  /// Locale forzado, o `null` para seguir al sistema.
  final Locale? locale;

  static AppLanguage fromName(String? name) => AppLanguage.values.firstWhere(
    (v) => v.name == name,
    orElse: () => AppLanguage.system,
  );
}

/// Primer día de la semana (resúmenes semanales y objetivo).
enum WeekStart {
  monday(DateTime.monday),
  sunday(DateTime.sunday);

  const WeekStart(this.weekday);

  /// Día ISO de `DateTime.weekday`.
  final int weekday;

  static WeekStart fromName(String? name) => WeekStart.values.firstWhere(
    (v) => v.name == name,
    orElse: () => WeekStart.monday,
  );
}

/// Preferencias del usuario (almacén clave-valor, no la base).
@immutable
class AppSettings {
  const AppSettings({
    this.theme = ThemePreference.system,
    this.accent = AccentPreset.fallback,
    this.language = AppLanguage.system,
    this.weightUnit = WeightUnit.kg,
    this.weekStart = WeekStart.monday,
    this.sounds = true,
    this.voice = true,
    this.vibration = true,
    this.weeklyGoal = defaultWeeklyGoal,
  });

  /// Sesiones por semana.
  static const defaultWeeklyGoal = 3;
  static const minWeeklyGoal = 1;
  static const maxWeeklyGoal = 14;

  final ThemePreference theme;
  final AccentPreset accent;
  final AppLanguage language;
  final WeightUnit weightUnit;
  final WeekStart weekStart;

  /// Señales del temporizador: sonidos, voz y vibración.
  final bool sounds;
  final bool voice;
  final bool vibration;
  final int weeklyGoal;

  AppSettings copyWith({
    ThemePreference? theme,
    AccentPreset? accent,
    AppLanguage? language,
    WeightUnit? weightUnit,
    WeekStart? weekStart,
    bool? sounds,
    bool? voice,
    bool? vibration,
    int? weeklyGoal,
  }) => AppSettings(
    theme: theme ?? this.theme,
    accent: accent ?? this.accent,
    language: language ?? this.language,
    weightUnit: weightUnit ?? this.weightUnit,
    weekStart: weekStart ?? this.weekStart,
    sounds: sounds ?? this.sounds,
    voice: voice ?? this.voice,
    vibration: vibration ?? this.vibration,
    weeklyGoal: weeklyGoal ?? this.weeklyGoal,
  );

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.theme == theme &&
      other.accent == accent &&
      other.language == language &&
      other.weightUnit == weightUnit &&
      other.weekStart == weekStart &&
      other.sounds == sounds &&
      other.voice == voice &&
      other.vibration == vibration &&
      other.weeklyGoal == weeklyGoal;

  @override
  int get hashCode => Object.hash(
    theme,
    accent,
    language,
    weightUnit,
    weekStart,
    sounds,
    voice,
    vibration,
    weeklyGoal,
  );

  @override
  String toString() =>
      'AppSettings($theme, $accent, $language, $weightUnit, $weekStart, '
      'sounds: $sounds, voice: $voice, vibration: $vibration, '
      'weeklyGoal: $weeklyGoal)';
}
