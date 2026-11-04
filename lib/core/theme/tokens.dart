import 'package:flutter/material.dart';

import 'accent.dart';
import 'phase_colors.dart';

/// Espaciado en rejilla de 4 px (`space-*`).
abstract final class TlSpace {
  static const s1 = 4.0;
  static const s2 = 8.0;
  static const s3 = 12.0;
  static const s4 = 16.0;
  static const s6 = 24.0;
  static const s8 = 32.0;
}

/// Radios (`radius-*`): esquinas casi rectas.
abstract final class TlRadius {
  static const sm = 4.0;
  static const md = 6.0;
  static const lg = 8.0;
  static const sheet = 12.0;
  static const full = 9999.0;
}

/// Tamaños mínimos (`size-*`).
abstract final class TlSize {
  static const touchMin = 48.0;
  static const touchSession = 64.0;
  static const touchPrimary = 88.0;
  static const bannerHeight = 50.0;
  static const bottomNavHeight = 68.0;
  static const buttonHeight = 56.0;
}

/// Tokens de color de Pizarra de hierro resueltos para un tema y un acento.
@immutable
class TlColors extends ThemeExtension<TlColors> {
  const TlColors({
    required this.bg,
    required this.surface1,
    required this.surface2,
    required this.ink,
    required this.inkMuted,
    required this.line,
    required this.accent,
    required this.accentSoft,
    required this.onAccent,
    required this.primaryBg,
    required this.primaryInk,
    required this.barOff,
    required this.success,
    required this.successSoft,
    required this.danger,
    required this.warning,
    required this.typeIntervals,
    required this.phases,
  });

  /// Resuelve los tokens de tokens.json para [brightness] y [accent].
  factory TlColors.resolve(Brightness brightness, AccentPreset accent) {
    final a = accent.swatch;
    final phases = phasePaletteFor(accent);
    return switch (brightness) {
      Brightness.dark => TlColors(
        bg: const Color(0xFF0E0F11),
        surface1: const Color(0xFF191B1E),
        surface2: const Color(0xFF22252A),
        ink: const Color(0xFFF2F3EF),
        inkMuted: const Color(0xFFA2A7AD),
        line: const Color(0xFF34383E),
        accent: a.dark,
        accentSoft: a.softDark,
        onAccent: const Color(0xFF0E0F11),
        primaryBg: a.dark,
        primaryInk: const Color(0xFF0E0F11),
        barOff: const Color(0xFF33373C),
        success: const Color(0xFF5CD38A),
        successSoft: const Color(0xFF15301F),
        danger: const Color(0xFFFF6B6B),
        warning: const Color(0xFFFFB547),
        typeIntervals: const Color(0xFF2BD9C5),
        phases: phases,
      ),
      Brightness.light => TlColors(
        bg: const Color(0xFFF2F2EE),
        surface1: const Color(0xFFFFFFFF),
        surface2: const Color(0xFFE8E8E3),
        ink: const Color(0xFF0E0F11),
        inkMuted: const Color(0xFF555A60),
        line: const Color(0xFFC9CBC4),
        accent: a.light,
        accentSoft: a.softLight,
        onAccent: const Color(0xFFFFFFFF),
        primaryBg: const Color(0xFF0E0F11),
        primaryInk: a.dark,
        barOff: const Color(0xFFD6D7D1),
        success: const Color(0xFF247534),
        successSoft: const Color(0xFFE6F4EA),
        danger: const Color(0xFFC52929),
        warning: const Color(0xFFA15300),
        typeIntervals: const Color(0xFF0A7368),
        phases: phases,
      ),
    };
  }

  final Color bg;
  final Color surface1;
  final Color surface2;
  final Color ink;
  final Color inkMuted;
  final Color line;
  final Color accent;
  final Color accentSoft;
  final Color onAccent;
  final Color primaryBg;
  final Color primaryInk;
  final Color barOff;
  final Color success;
  final Color successSoft;
  final Color danger;
  final Color warning;
  final Color typeIntervals;
  final PhasePalette phases;

  /// `type-strength` siempre es el acento.
  Color get typeStrength => accent;

  @override
  TlColors copyWith({Color? accent, PhasePalette? phases}) => TlColors(
    bg: bg,
    surface1: surface1,
    surface2: surface2,
    ink: ink,
    inkMuted: inkMuted,
    line: line,
    accent: accent ?? this.accent,
    accentSoft: accentSoft,
    onAccent: onAccent,
    primaryBg: primaryBg,
    primaryInk: primaryInk,
    barOff: barOff,
    success: success,
    successSoft: successSoft,
    danger: danger,
    warning: warning,
    typeIntervals: typeIntervals,
    phases: phases ?? this.phases,
  );

  @override
  TlColors lerp(TlColors? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return TlColors(
      bg: l(bg, other.bg),
      surface1: l(surface1, other.surface1),
      surface2: l(surface2, other.surface2),
      ink: l(ink, other.ink),
      inkMuted: l(inkMuted, other.inkMuted),
      line: l(line, other.line),
      accent: l(accent, other.accent),
      accentSoft: l(accentSoft, other.accentSoft),
      onAccent: l(onAccent, other.onAccent),
      primaryBg: l(primaryBg, other.primaryBg),
      primaryInk: l(primaryInk, other.primaryInk),
      barOff: l(barOff, other.barOff),
      success: l(success, other.success),
      successSoft: l(successSoft, other.successSoft),
      danger: l(danger, other.danger),
      warning: l(warning, other.warning),
      typeIntervals: l(typeIntervals, other.typeIntervals),
      phases: PhasePalette.lerp(phases, other.phases, t),
    );
  }
}
