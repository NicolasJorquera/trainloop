import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trainloop/core/theme/accent.dart';
import 'package:trainloop/core/theme/phase_colors.dart';
import 'package:trainloop/core/theme/tokens.dart';

/// Luminancia relativa (WCAG 2.x).
double luminance(Color c) {
  double ch(double v) =>
      v <= 0.04045 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * ch(c.r) + 0.7152 * ch(c.g) + 0.0722 * ch(c.b);
}

/// Contraste WCAG entre dos colores opacos (1–21).
double contrast(Color a, Color b) {
  final la = luminance(a);
  final lb = luminance(b);
  final hi = math.max(la, lb);
  final lo = math.min(la, lb);
  return (hi + 0.05) / (lo + 0.05);
}

/// Texto normal: 4,5:1 (AA). Componentes y gráficos: 3:1 (AA, 1.4.11).
const text = 4.5;
const graphic = 3.0;

/// Pares de los tokens que la app usa como texto/fondo o como gráfico.
List<(String, Color, Color, double)> pairs(TlColors c) => [
  for (final (name, bg) in [
    ('bg', c.bg),
    ('surface1', c.surface1),
    ('surface2', c.surface2),
  ]) ...[
    ('ink/$name', c.ink, bg, text),
    ('inkMuted/$name', c.inkMuted, bg, text),
    ('accent/$name', c.accent, bg, text),
    ('danger/$name', c.danger, bg, text),
    ('success/$name', c.success, bg, text),
    ('warning/$name', c.warning, bg, text),
    ('typeIntervals/$name', c.typeIntervals, bg, text),
  ],
  ('accent/accentSoft', c.accent, c.accentSoft, text),
  ('ink/accentSoft', c.ink, c.accentSoft, text),
  ('success/successSoft', c.success, c.successSoft, text),
  ('primaryInk/primaryBg', c.primaryInk, c.primaryBg, text),
  ('onAccent/accent', c.onAccent, c.accent, text),
  // Barras y gráficos: el acento frente al fondo y a la barra apagada.
  ('accent/barOff (gráfico)', c.accent, c.barOff, graphic),
  ('primaryBg/bg (botón)', c.primaryBg, c.bg, graphic),
  for (final p in Phase.values)
    ('fase ${p.name}', c.phases.of(p).ink, c.phases.of(p).background, text),
];

void main() {
  for (final brightness in Brightness.values) {
    group('tema ${brightness.name}', () {
      for (final accent in AccentPreset.values) {
        test('${accent.name}: todos los pares cumplen WCAG AA', () {
          final c = TlColors.resolve(brightness, accent);
          final failures = [
            for (final (name, fg, bg, min) in pairs(c))
              if (contrast(fg, bg) < min)
                '$name ${contrast(fg, bg).toStringAsFixed(2)} < $min',
          ];
          expect(failures, isEmpty);
        });
      }
    });
  }

  test('la fórmula coincide con valores conocidos', () {
    expect(contrast(Colors.black, Colors.white), closeTo(21, 0.01));
    expect(
      contrast(const Color(0xFF777777), Colors.white),
      closeTo(4.48, 0.01),
    );
  });
}
