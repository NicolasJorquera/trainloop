import 'package:flutter/material.dart';

import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';

/// Barras de sesiones por semana con la línea del objetivo (S14). Cada
/// barra es un botón (R-P7: abre las sesiones que la componen).
class WeeklyBars extends StatelessWidget {
  const WeeklyBars({
    required this.values,
    required this.labels,
    required this.goal,
    required this.goalLabel,
    required this.semanticsOf,
    required this.valueText,
    required this.onTap,
    this.height = 120,
    super.key,
  });

  final List<int> values;
  final List<String> labels;
  final int goal;
  final String goalLabel;
  final String Function(int index) semanticsOf;

  /// Cifra sobre la barra (pasa por l10n).
  final String Function(int value) valueText;
  final ValueChanged<int> onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final top = [goal, ...values].reduce((a, b) => a > b ? a : b).clamp(1, 99);
    final goalY = 1 - goal / top;
    return Column(
      children: [
        SizedBox(
          height: height,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _GoalLinePainter(
                    y: goalY,
                    color: c.inkMuted,
                    base: c.line,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: (goalY * height - 16).clamp(0, height - 16),
                child: Text(
                  goalLabel,
                  style: t.caption.copyWith(color: c.inkMuted),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final (i, v) in values.indexed)
                    Expanded(
                      child: Semantics(
                        button: true,
                        label: semanticsOf(i),
                        excludeSemantics: true,
                        child: InkWell(
                          key: Key('week-bar-$i'),
                          onTap: () => onTap(i),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TlSpace.s1,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  valueText(v),
                                  style: t.caption.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Container(
                                  height: (height - 20) * v / top,
                                  decoration: BoxDecoration(
                                    color: c.accent.withValues(
                                      alpha: i == values.length - 1 ? 1 : 0.5,
                                    ),
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(TlRadius.sm),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: TlSpace.s1),
        ExcludeSemantics(
          child: Row(
            children: [
              for (final l in labels)
                Expanded(
                  child: Text(
                    l,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: t.caption.copyWith(color: c.inkMuted, fontSize: 11),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GoalLinePainter extends CustomPainter {
  _GoalLinePainter({required this.y, required this.color, required this.base});

  final double y;
  final Color color;
  final Color base;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(0, size.height - 0.5),
      Offset(size.width, size.height - 0.5),
      Paint()..color = base,
    );
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    final yy = y * (size.height - 20) + 20;
    for (var x = 0.0; x < size.width; x += 8) {
      canvas.drawLine(Offset(x, yy), Offset(x + 4, yy), paint);
    }
  }

  @override
  bool shouldRepaint(_GoalLinePainter old) =>
      old.y != y || old.color != color || old.base != base;
}

/// Línea simple de una serie en el tiempo (1RM estimado, S15), dibujada con
/// CustomPaint; el último punto se resalta. Decorativa: [semanticLabel]
/// resume la tendencia en texto.
class TrendLine extends StatelessWidget {
  const TrendLine({
    required this.points,
    required this.semanticLabel,
    this.height = 96,
    super.key,
  });

  /// (x en milisegundos, y) en orden.
  final List<(double, double)> points;
  final String semanticLabel;
  final double height;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      label: semanticLabel,
      image: true,
      excludeSemantics: true,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(
          painter: _TrendPainter(
            points: points,
            line: c.accent,
            base: c.line,
            guide: c.inkMuted,
          ),
        ),
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  _TrendPainter({
    required this.points,
    required this.line,
    required this.base,
    required this.guide,
  });

  final List<(double, double)> points;
  final Color line;
  final Color base;
  final Color guide;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(0, size.height - 1),
      Offset(size.width, size.height - 1),
      Paint()..color = base,
    );
    if (points.length < 2) return;
    final xs = points.map((p) => p.$1);
    final ys = points.map((p) => p.$2);
    final minX = xs.reduce((a, b) => a < b ? a : b);
    final maxX = xs.reduce((a, b) => a > b ? a : b);
    var minY = ys.reduce((a, b) => a < b ? a : b);
    var maxY = ys.reduce((a, b) => a > b ? a : b);
    if (maxY - minY < 1e-6) {
      minY -= 1;
      maxY += 1;
    }
    const pad = 8.0;
    Offset at((double, double) p) => Offset(
      pad +
          (maxX == minX ? 0.5 : (p.$1 - minX) / (maxX - minX)) *
              (size.width - 2 * pad),
      pad + (1 - (p.$2 - minY) / (maxY - minY)) * (size.height - 2 * pad),
    );
    final top = at((minX, maxY)).dy;
    final dash = Paint()
      ..color = guide
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 8) {
      canvas.drawLine(Offset(x, top), Offset(x + 4, top), dash);
    }
    final path = Path()..moveTo(at(points.first).dx, at(points.first).dy);
    for (final p in points.skip(1)) {
      path.lineTo(at(p).dx, at(p).dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = line
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(at(points.last), 6, Paint()..color = line);
  }

  @override
  bool shouldRepaint(_TrendPainter old) =>
      old.points != points || old.line != line;
}
