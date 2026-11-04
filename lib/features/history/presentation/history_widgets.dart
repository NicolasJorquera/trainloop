import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/theme/tokens.dart';
import '../../../data/db/enums.dart';
import '../../settings/application/settings_controller.dart';
import '../application/history_texts.dart';
import '../domain/week.dart';

/// Cómo se dibuja la marca de un día o una sesión.
enum BadgeStyle {
  /// Relleno: hecho.
  filled,

  /// Contorno: planificado.
  outline,

  /// Punteado: descanso o libre.
  dotted,
}

/// Color de un tipo de sesión: fuerza = acento, intervalos = verde azulado.
Color kindColor(BuildContext context, SessionKind? kind) => switch (kind) {
  SessionKind.strength => context.colors.typeStrength,
  SessionKind.intervals => context.colors.typeIntervals,
  null => context.colors.line,
};

/// Círculo con la letra del tipo (F / I). Decorativo: el texto de la fila
/// dice lo mismo.
class KindBadge extends StatelessWidget {
  const KindBadge({
    required this.kind,
    this.style = BadgeStyle.filled,
    this.size = 32,
    super.key,
  });

  final SessionKind? kind;
  final BadgeStyle style;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = kindColor(context, kind);
    final filled = style == BadgeStyle.filled && kind != null;
    return ExcludeSemantics(
      child: CustomPaint(
        painter: _BadgePainter(
          color: color,
          filled: filled,
          dotted: style == BadgeStyle.dotted || kind == null,
        ),
        child: SizedBox.square(
          dimension: size,
          child: Center(
            child: filled
                ? Text(
                    kindLetter(context.l10n, kind!),
                    style: context.text.button.copyWith(
                      color: context.colors.bg,
                      fontSize: size * 0.5,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

class _BadgePainter extends CustomPainter {
  _BadgePainter({
    required this.color,
    required this.filled,
    required this.dotted,
  });

  final Color color;
  final bool filled;
  final bool dotted;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final r = size.shortestSide / 2 - 1.5;
    if (filled) {
      canvas.drawCircle(center, r + 1.5, Paint()..color = color);
      return;
    }
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    if (!dotted) {
      canvas.drawCircle(center, r, stroke);
      return;
    }
    const dots = 12;
    final dot = Paint()..color = color;
    for (var i = 0; i < dots; i++) {
      final a = i * 2 * math.pi / dots;
      canvas.drawCircle(
        center + Offset(r * math.cos(a), r * math.sin(a)),
        1.4,
        dot,
      );
    }
  }

  @override
  bool shouldRepaint(_BadgePainter old) =>
      old.color != color || old.filled != filled || old.dotted != dotted;
}

/// Fila de una sesión del historial: marca, nombre y meta. Abre S13.
class EntryTile extends ConsumerWidget {
  const EntryTile(this.entry, {this.showDate = true, super.key});

  final HistoryEntry entry;
  final bool showDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.text;
    final unit = ref.watch(settingsControllerProvider).weightUnit;
    return Material(
      color: c.surface1,
      borderRadius: BorderRadius.circular(TlRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: Key('entry-${entry.id}'),
        onTap: () => context.push(Routes.sessionDetail(entry.id)),
        child: Padding(
          padding: const EdgeInsets.all(TlSpace.s3),
          child: Row(
            children: [
              KindBadge(kind: entry.kind),
              const SizedBox(width: TlSpace.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entryTitle(l10n, entry), style: t.title),
                    Text(
                      showDate
                          ? entryMeta(l10n, context.locale, entry, unit)
                          : entryFacts(l10n, entry, unit),
                      style: t.bodySm.copyWith(color: c.inkMuted),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: c.inkMuted),
            ],
          ),
        ),
      ),
    );
  }
}

/// Cifra grande con su etiqueta (S13, S14).
class StatBox extends StatelessWidget {
  const StatBox({
    required this.label,
    required this.value,
    this.suffix,
    this.valueKey,
    super.key,
  });

  final String label;
  final String value;
  final String? suffix;
  final Key? valueKey;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(TlSpace.s3),
        decoration: BoxDecoration(
          color: c.surface1,
          borderRadius: BorderRadius.circular(TlRadius.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text.rich(
                TextSpan(
                  text: value,
                  children: [
                    if (suffix != null)
                      TextSpan(
                        text: suffix,
                        style: t.title.copyWith(color: c.inkMuted),
                      ),
                  ],
                ),
                key: valueKey,
                style: t.displayXl.copyWith(fontSize: 34, height: 1.1),
              ),
            ),
            Text(label, style: t.bodySm.copyWith(color: c.inkMuted)),
          ],
        ),
      ),
    );
  }
}

/// «2/4» del objetivo, con el separador del idioma.
String goalText(AppLocalizations l10n, int done, int goal) =>
    l10n.summaryRoundsValue(done, goal);

/// Etiqueta de una semana en la lista: esta, la anterior o «del 12 oct».
String weekLabel(
  AppLocalizations l10n,
  Locale locale,
  DateTime weekStart,
  DateTime currentWeek,
) {
  if (weekStart == currentWeek) return l10n.historyThisWeek;
  if (weekStart == currentWeek.subtract(const Duration(days: 7))) {
    return l10n.historyLastWeek;
  }
  return l10n.historyWeekOf(dayMonth(locale, weekStart).toUpperCase());
}

/// Minutos de una semana: «71 MIN».
String weekMinutes(AppLocalizations l10n, WeekStats w) =>
    l10n.historyMinutes(w.activeMinutes);

/// Peso en número, para cuando la unidad ya está en la columna.
String plainWeight(AppLocalizations l10n, double value) =>
    l10n.decimalText(l10n.decimal(value));
