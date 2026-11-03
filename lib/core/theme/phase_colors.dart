import 'package:flutter/widgets.dart';

import 'accent.dart';

/// Fases del temporizador. Se reconocen por color, forma y palabra a la vez.
enum Phase { prep, warm, work, rest, cool }

/// Fondo y texto de una fase. Iguales en ambos temas.
@immutable
class PhaseColor {
  const PhaseColor(this.background, this.ink);

  final Color background;
  final Color ink;

  static PhaseColor lerp(PhaseColor a, PhaseColor b, double t) => PhaseColor(
    Color.lerp(a.background, b.background, t)!,
    Color.lerp(a.ink, b.ink, t)!,
  );

  @override
  bool operator ==(Object other) =>
      other is PhaseColor && other.background == background && other.ink == ink;

  @override
  int get hashCode => Object.hash(background, ink);

  @override
  String toString() => 'PhaseColor($background, $ink)';
}

/// Colores de las 5 fases para un acento dado.
@immutable
class PhasePalette {
  const PhasePalette({
    required this.prep,
    required this.warm,
    required this.work,
    required this.rest,
    required this.cool,
  });

  final PhaseColor prep;
  final PhaseColor warm;
  final PhaseColor work;
  final PhaseColor rest;
  final PhaseColor cool;

  PhaseColor of(Phase phase) => switch (phase) {
    Phase.prep => prep,
    Phase.warm => warm,
    Phase.work => work,
    Phase.rest => rest,
    Phase.cool => cool,
  };

  static PhasePalette lerp(PhasePalette a, PhasePalette b, double t) =>
      PhasePalette(
        prep: PhaseColor.lerp(a.prep, b.prep, t),
        warm: PhaseColor.lerp(a.warm, b.warm, t),
        work: PhaseColor.lerp(a.work, b.work, t),
        rest: PhaseColor.lerp(a.rest, b.rest, t),
        cool: PhaseColor.lerp(a.cool, b.cool, t),
      );

  @override
  bool operator ==(Object other) =>
      other is PhasePalette &&
      other.prep == prep &&
      other.warm == warm &&
      other.work == work &&
      other.rest == rest &&
      other.cool == cool;

  @override
  int get hashCode => Object.hash(prep, warm, work, rest, cool);
}

/// Tokens `phase-*` de tokens.json.
abstract final class PhaseTokens {
  static const prep = Color(0xFF0E0F11);
  static const prepInk = Color(0xFFF2F3EF);
  static const warm = Color(0xFFFFB020);
  static const rest = Color(0xFF2BD9C5);
  static const cool = Color(0xFF4D9FFF);
  static const altPink = Color(0xFFFF5CA8);
  static const altViolet = Color(0xFF9B7BFF);

  /// Texto sobre cualquier fase viva (≥ 5:1 con los 8 acentos).
  static const ink = Color(0xFF0E0F11);
}

/// Regla de distinción entre fases: Trabajo siempre es el acento; si el
/// acento se parece a otra fase, esa fase pasa a su alternativo.
///
/// - Amarillo o Naranja → Calentamiento usa `phase-alt-pink`.
/// - Azul → Vuelta a la calma usa `phase-alt-violet`.
/// - Lima → Descanso usa `phase-cool` y Vuelta a la calma `phase-alt-violet`.
PhasePalette phasePaletteFor(AccentPreset accent) {
  final warm = switch (accent) {
    AccentPreset.amarillo || AccentPreset.naranja => PhaseTokens.altPink,
    _ => PhaseTokens.warm,
  };
  final rest = accent == AccentPreset.lima
      ? PhaseTokens.cool
      : PhaseTokens.rest;
  final cool = switch (accent) {
    AccentPreset.azul || AccentPreset.lima => PhaseTokens.altViolet,
    _ => PhaseTokens.cool,
  };
  return PhasePalette(
    prep: const PhaseColor(PhaseTokens.prep, PhaseTokens.prepInk),
    warm: PhaseColor(warm, PhaseTokens.ink),
    work: PhaseColor(accent.swatch.dark, PhaseTokens.ink),
    rest: PhaseColor(rest, PhaseTokens.ink),
    cool: PhaseColor(cool, PhaseTokens.ink),
  );
}
