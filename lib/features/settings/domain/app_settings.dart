import 'package:flutter/material.dart';

import '../../../core/theme/accent.dart';

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

/// Preferencias de apariencia e idioma.
@immutable
class AppSettings {
  const AppSettings({
    this.theme = ThemePreference.system,
    this.accent = AccentPreset.fallback,
    this.language = AppLanguage.system,
  });

  final ThemePreference theme;
  final AccentPreset accent;
  final AppLanguage language;

  AppSettings copyWith({
    ThemePreference? theme,
    AccentPreset? accent,
    AppLanguage? language,
  }) => AppSettings(
    theme: theme ?? this.theme,
    accent: accent ?? this.accent,
    language: language ?? this.language,
  );

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.theme == theme &&
      other.accent == accent &&
      other.language == language;

  @override
  int get hashCode => Object.hash(theme, accent, language);

  @override
  String toString() => 'AppSettings($theme, $accent, $language)';
}
