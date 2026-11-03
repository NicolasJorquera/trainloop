import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/core/theme/accent.dart';
import 'package:trainloop/core/theme/app_theme.dart';
import 'package:trainloop/core/theme/phase_colors.dart';
import 'package:trainloop/core/theme/tokens.dart';
import 'package:trainloop/core/theme/typography.dart';

const _nearBlack = Color(0xFF0E0F11);

void main() {
  group('TlColors.resolve', () {
    for (final accent in AccentPreset.values) {
      test('oscuro + ${accent.name}: acento relleno con tinta negra', () {
        final c = TlColors.resolve(Brightness.dark, accent);
        expect(c.bg, _nearBlack);
        expect(c.accent, accent.swatch.dark);
        expect(c.accentSoft, accent.swatch.softDark);
        expect(c.primaryBg, accent.swatch.dark);
        expect(c.primaryInk, _nearBlack);
        expect(c.typeStrength, c.accent);
        expect(c.phases, phasePaletteFor(accent));
      });

      test('claro + ${accent.name}: botón negro con texto en el acento', () {
        final c = TlColors.resolve(Brightness.light, accent);
        expect(c.bg, const Color(0xFFF2F2EE));
        expect(c.accent, accent.swatch.light);
        expect(c.accentSoft, accent.swatch.softLight);
        expect(c.primaryBg, _nearBlack);
        expect(c.primaryInk, accent.swatch.dark);
        expect(c.phases, phasePaletteFor(accent));
      });
    }

    test('el acento nunca cambia danger, success ni warning', () {
      for (final b in Brightness.values) {
        final base = TlColors.resolve(b, AccentPreset.orquidea);
        for (final accent in AccentPreset.values) {
          final c = TlColors.resolve(b, accent);
          expect(
            [c.danger, c.success, c.warning],
            [base.danger, base.success, base.warning],
          );
        }
      }
    });

    test('lerp interpola y respeta los extremos', () {
      final a = TlColors.resolve(Brightness.dark, AccentPreset.orquidea);
      final b = TlColors.resolve(Brightness.light, AccentPreset.lima);
      expect(a.lerp(b, 0).accent, a.accent);
      expect(a.lerp(b, 1).accent, b.accent);
      expect(a.lerp(b, 1).phases, b.phases);
      expect(a.lerp(null, .5), same(a));
    });
  });

  test('buildTrainloopTheme expone tokens, tipografía y ColorScheme', () {
    final theme = buildTrainloopTheme(Brightness.dark, AccentPreset.azul);
    final c = theme.extension<TlColors>()!;
    final t = theme.extension<TlText>()!;
    expect(theme.brightness, Brightness.dark);
    expect(theme.colorScheme.primary, AccentPreset.azul.swatch.dark);
    expect(theme.scaffoldBackgroundColor, c.bg);
    expect(t.headline.fontFamily, TlFonts.display);
    expect(t.body.fontFamily, TlFonts.body);
    expect(t.overline.color, c.inkMuted);
  });
}
