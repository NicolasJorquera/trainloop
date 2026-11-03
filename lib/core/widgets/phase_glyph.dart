import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/phase_colors.dart';

/// Forma geométrica de cada fase (■ ◆ ▲ ● ▼): funciona sin color y no es
/// texto, así que no necesita traducción.
class PhaseGlyph extends StatelessWidget {
  const PhaseGlyph(
    this.phase, {
    required this.color,
    this.size = 14,
    super.key,
  });

  final Phase phase;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size.square(size),
    painter: _GlyphPainter(phase, color),
  );
}

class _GlyphPainter extends CustomPainter {
  _GlyphPainter(this.phase, this.color);

  final Phase phase;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final w = size.width;
    final h = size.height;
    switch (phase) {
      case Phase.prep:
        canvas.drawRect(Rect.fromLTWH(w * .1, h * .1, w * .8, h * .8), paint);
      case Phase.warm:
        canvas
          ..save()
          ..translate(w / 2, h / 2)
          ..rotate(math.pi / 4)
          ..drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: w * .62,
              height: h * .62,
            ),
            paint,
          )
          ..restore();
      case Phase.work:
        canvas.drawPath(
          Path()
            ..moveTo(w / 2, h * .08)
            ..lineTo(w, h * .92)
            ..lineTo(0, h * .92)
            ..close(),
          paint,
        );
      case Phase.rest:
        canvas.drawCircle(Offset(w / 2, h / 2), w * .42, paint);
      case Phase.cool:
        canvas.drawPath(
          Path()
            ..moveTo(0, h * .08)
            ..lineTo(w, h * .08)
            ..lineTo(w / 2, h * .92)
            ..close(),
          paint,
        );
    }
  }

  @override
  bool shouldRepaint(_GlyphPainter old) =>
      old.phase != phase || old.color != color;
}
