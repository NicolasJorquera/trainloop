import 'package:flutter/material.dart';

import '../theme/theme_context.dart';
import '../theme/tokens.dart';

class TlSegment<T> {
  const TlSegment(this.value, this.label);

  final T value;
  final String label;
}

/// Alterna entre 2 y 4 opciones excluyentes.
class TlSegmentedControl<T> extends StatelessWidget {
  const TlSegmentedControl({
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.semanticLabel,
    super.key,
  });

  final List<TlSegment<T>> segments;
  final T selected;
  final ValueChanged<T> onChanged;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Semantics(
      container: true,
      label: semanticLabel,
      child: Container(
        padding: const EdgeInsets.all(TlSpace.s1),
        decoration: BoxDecoration(
          color: c.surface2,
          borderRadius: BorderRadius.circular(TlRadius.md),
        ),
        child: Row(
          children: [
            for (final s in segments)
              Expanded(
                child: _Segment(
                  label: s.label,
                  selected: s.value == selected,
                  onTap: () => onChanged(s.value),
                  selectedColor: c.surface1,
                  style: s.value == selected
                      ? t.bodySm.copyWith(fontWeight: FontWeight.w600)
                      : t.bodySm.copyWith(
                          color: c.inkMuted,
                          fontWeight: FontWeight.w500,
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.selectedColor,
    required this.style,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color selectedColor;
  final TextStyle style;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    child: Material(
      color: selected ? selectedColor : Colors.transparent,
      borderRadius: BorderRadius.circular(TlRadius.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(TlRadius.sm),
        onTap: onTap,
        child: ConstrainedBox(
          // NF-08: 48 dp de área táctil.
          constraints: const BoxConstraints(minHeight: TlSize.touchMin),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: TlSpace.s1),
              child: Text(label, style: style, textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    ),
  );
}
