import 'package:flutter/material.dart';

import '../theme/accent.dart';
import '../theme/phase_colors.dart';
import '../theme/theme_context.dart';
import '../theme/tokens.dart';
import 'phase_glyph.dart';

/// Rejilla 4 × 2 de los acentos predefinidos.
class AccentPicker extends StatelessWidget {
  const AccentPicker({
    required this.selected,
    required this.onChanged,
    required this.labelOf,
    required this.selectedHint,
    super.key,
  });

  final AccentPreset selected;
  final ValueChanged<AccentPreset> onChanged;
  final String Function(AccentPreset) labelOf;
  final String selectedHint;

  @override
  Widget build(BuildContext context) {
    // Con letra grande, 2 columnas: el nombre se lee entero (NF-08).
    final columns = MediaQuery.textScalerOf(context).scale(1) > 1.3 ? 2 : 4;
    final rows = AccentPreset.values.length ~/ columns;
    return Column(
      children: [
        for (var r = 0; r < rows; r++)
          Padding(
            padding: EdgeInsets.only(top: r == 0 ? 0 : TlSpace.s3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var col = 0; col < columns; col++) ...[
                  if (col > 0) const SizedBox(width: TlSpace.s2),
                  Expanded(
                    child: _Swatch(
                      accent: AccentPreset.values[r * columns + col],
                      selected:
                          AccentPreset.values[r * columns + col] == selected,
                      label: labelOf(AccentPreset.values[r * columns + col]),
                      selectedHint: selectedHint,
                      onTap: () =>
                          onChanged(AccentPreset.values[r * columns + col]),
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.accent,
    required this.selected,
    required this.label,
    required this.selectedHint,
    required this.onTap,
  });

  final AccentPreset accent;
  final bool selected;
  final String label;
  final String selectedHint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      key: ValueKey('accent-${accent.name}'),
      button: true,
      selected: selected,
      label: label,
      hint: selected ? selectedHint : null,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TlRadius.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: accent.swatch.dark,
                borderRadius: BorderRadius.circular(TlRadius.md),
                border: selected ? Border.all(color: c.ink, width: 3) : null,
              ),
              child: selected
                  ? const Icon(Icons.check, color: PhaseTokens.ink, size: 24)
                  : null,
            ),
            const SizedBox(height: TlSpace.s1),
            Text(
              label,
              textAlign: TextAlign.center,
              style: context.text.caption.copyWith(
                color: selected ? c.ink : c.inkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Vista previa de Trabajo (acento) y Descanso para ver el contraste.
class PhasePreview extends StatelessWidget {
  const PhasePreview({
    required this.workLabel,
    required this.restLabel,
    super.key,
  });

  final String workLabel;
  final String restLabel;

  @override
  Widget build(BuildContext context) {
    final p = context.colors.phases;
    final work = _Chip(Phase.work, p.work, workLabel);
    final rest = _Chip(Phase.rest, p.rest, restLabel);
    // Con letra grande, una debajo de la otra (NF-08).
    if (MediaQuery.textScalerOf(context).scale(1) > 1.3) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          work,
          const SizedBox(height: TlSpace.s2),
          rest,
        ],
      );
    }
    return Row(
      children: [
        Expanded(child: work),
        const SizedBox(width: TlSpace.s2),
        Expanded(child: rest),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.phase, this.color, this.label);

  final Phase phase;
  final PhaseColor color;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: TlSize.touchMin),
    padding: const EdgeInsets.symmetric(
      horizontal: TlSpace.s3,
      vertical: TlSpace.s1,
    ),
    decoration: BoxDecoration(
      color: color.background,
      borderRadius: BorderRadius.circular(TlRadius.md),
    ),
    child: Row(
      children: [
        PhaseGlyph(phase, color: color.ink),
        const SizedBox(width: TlSpace.s2),
        Flexible(
          child: Text(
            label,
            style: context.text.button.copyWith(
              color: color.ink,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    ),
  );
}
