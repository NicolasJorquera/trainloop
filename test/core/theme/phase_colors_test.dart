import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/core/theme/accent.dart';
import 'package:trainloop/core/theme/phase_colors.dart';

const _ink = Color(0xFF0E0F11);
const _warm = Color(0xFFFFB020);
const _rest = Color(0xFF2BD9C5);
const _cool = Color(0xFF4D9FFF);
const _pink = Color(0xFFFF5CA8);
const _violet = Color(0xFF9B7BFF);

void main() {
  group('phasePaletteFor', () {
    // acento → (warm, rest, cool) esperados según la regla de distinción.
    final expected = <AccentPreset, (Color, Color, Color)>{
      AccentPreset.orquidea: (_warm, _rest, _cool),
      AccentPreset.rosa: (_warm, _rest, _cool),
      AccentPreset.rojo: (_warm, _rest, _cool),
      AccentPreset.naranja: (_pink, _rest, _cool),
      AccentPreset.amarillo: (_pink, _rest, _cool),
      AccentPreset.lima: (_warm, _cool, _violet),
      AccentPreset.azul: (_warm, _rest, _violet),
      AccentPreset.violeta: (_warm, _rest, _cool),
    };

    for (final MapEntry(key: accent, value: (warm, rest, cool))
        in expected.entries) {
      test('${accent.name}: trabajo = acento y alternativos correctos', () {
        final p = phasePaletteFor(accent);
        expect(p.work.background, accent.swatch.dark);
        expect(p.warm.background, warm);
        expect(p.rest.background, rest);
        expect(p.cool.background, cool);
        expect(p.prep, const PhaseColor(Color(0xFF0E0F11), Color(0xFFF2F3EF)));
      });
    }

    test('todas las fases vivas llevan texto casi negro', () {
      for (final accent in AccentPreset.values) {
        final p = phasePaletteFor(accent);
        for (final phase in [Phase.warm, Phase.work, Phase.rest, Phase.cool]) {
          expect(p.of(phase).ink, _ink, reason: '$accent/$phase');
        }
      }
    });

    test('ninguna fase repite el color de Trabajo', () {
      for (final accent in AccentPreset.values) {
        final p = phasePaletteFor(accent);
        final others = [
          p.prep,
          p.warm,
          p.rest,
          p.cool,
        ].map((c) => c.background);
        expect(others, isNot(contains(p.work.background)), reason: '$accent');
        expect(others.toSet().length, 4, reason: '$accent');
      }
    });
  });

  test('AccentPreset.fromName usa Orquídea si el valor no existe', () {
    expect(AccentPreset.fromName('lima'), AccentPreset.lima);
    expect(AccentPreset.fromName('magenta'), AccentPreset.orquidea);
    expect(AccentPreset.fromName(null), AccentPreset.orquidea);
  });
}
