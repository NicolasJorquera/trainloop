import 'package:flutter/widgets.dart';

/// Valores de un acento elegible (ver docs/design/system/tokens.json).
@immutable
class AccentSwatch {
  const AccentSwatch({
    required this.dark,
    required this.light,
    required this.softDark,
    required this.softLight,
  });

  /// Relleno en tema oscuro y muestra del selector.
  final Color dark;

  /// Texto y barras en tema claro (contraste 4.5:1 sobre `bg`).
  final Color light;

  /// `accent-<nombre>-soft` en oscuro.
  final Color softDark;

  /// `accent-<nombre>-soft` en claro.
  final Color softLight;
}

/// Los 8 acentos predefinidos. No hay selector libre.
enum AccentPreset {
  orquidea(
    AccentSwatch(
      dark: Color(0xFFD45CFF),
      light: Color(0xFF8A2BBF),
      softDark: Color(0xFF2E1B37),
      softLight: Color(0xFFF9E8FF),
    ),
  ),
  rosa(
    AccentSwatch(
      dark: Color(0xFFFF5CA8),
      light: Color(0xFFB8216A),
      softDark: Color(0xFF351B29),
      softLight: Color(0xFFFFE8F3),
    ),
  ),
  rojo(
    AccentSwatch(
      dark: Color(0xFFFF5A5F),
      light: Color(0xFFC2262E),
      softDark: Color(0xFF351B1E),
      softLight: Color(0xFFFFE8E9),
    ),
  ),
  naranja(
    AccentSwatch(
      dark: Color(0xFFFF8A3D),
      light: Color(0xFFB4500F),
      softDark: Color(0xFF352318),
      softLight: Color(0xFFFFEFE4),
    ),
  ),
  amarillo(
    AccentSwatch(
      dark: Color(0xFFFFD23F),
      light: Color(0xFF8A6A00),
      softDark: Color(0xFF352E18),
      softLight: Color(0xFFFFF9E4),
    ),
  ),
  lima(
    AccentSwatch(
      dark: Color(0xFFA3E635),
      light: Color(0xFF4D7C0F),
      softDark: Color(0xFF263117),
      softLight: Color(0xFFF2FCE3),
    ),
  ),
  azul(
    AccentSwatch(
      dark: Color(0xFF4D9FFF),
      light: Color(0xFF1F5FC9),
      softDark: Color(0xFF182637),
      softLight: Color(0xFFE6F2FF),
    ),
  ),
  violeta(
    AccentSwatch(
      dark: Color(0xFF9B7BFF),
      light: Color(0xFF5B3FD1),
      softDark: Color(0xFF252037),
      softLight: Color(0xFFF1ECFF),
    ),
  );

  const AccentPreset(this.swatch);

  final AccentSwatch swatch;

  /// Acento por defecto de la marca.
  static const fallback = AccentPreset.orquidea;

  /// Busca por nombre persistido; si no existe devuelve [fallback].
  static AccentPreset fromName(String? name) => AccentPreset.values.firstWhere(
    (a) => a.name == name,
    orElse: () => fallback,
  );
}
