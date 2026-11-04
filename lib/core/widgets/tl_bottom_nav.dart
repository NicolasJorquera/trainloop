import 'package:flutter/material.dart';

import '../theme/theme_context.dart';
import '../theme/tokens.dart';

class TlNavItem {
  const TlNavItem({required this.icon, required this.label, required this.key});

  final IconData icon;
  final String label;
  final Key key;
}

/// Barra inferior de 4 pestañas: indicador superior de 3 px en `accent`,
/// activa en `ink`, inactivas en `ink-muted`.
class TlBottomNav extends StatelessWidget {
  const TlBottomNav({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.semanticLabel,
    super.key,
  });

  final List<TlNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final label = context.text.overline.copyWith(fontSize: 11);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    // Con letra grande la barra crece para que la etiqueta quepa (NF-08).
    final scaled = MediaQuery.textScalerOf(context).scale(label.fontSize!);
    final extra = (scaled - label.fontSize!) * (label.height ?? 1.4);
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: ColoredBox(
        color: c.surface1,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: SizedBox(
            height: TlSize.bottomNavHeight + (extra > 0 ? extra : 0),
            child: Row(
              children: [
                for (var i = 0; i < items.length; i++)
                  Expanded(
                    child: _NavButton(
                      key: items[i].key,
                      item: items[i],
                      selected: i == currentIndex,
                      onTap: () => onTap(i),
                      indicator: c.accent,
                      color: i == currentIndex ? c.ink : c.inkMuted,
                      labelStyle: label,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
    required this.indicator,
    required this.color,
    required this.labelStyle,
    super.key,
  });

  final TlNavItem item;
  final bool selected;
  final VoidCallback onTap;
  final Color indicator;
  final Color color;
  final TextStyle labelStyle;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    child: InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: TlSpace.s3,
            right: TlSpace.s3,
            height: 3,
            child: ColoredBox(color: selected ? indicator : Colors.transparent),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item.icon, size: 22, color: color),
                const SizedBox(height: TlSpace.s1),
                // Nunca se corta: si no cabe a lo ancho, se achica (NF-08).
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: TlSpace.s1),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      item.label,
                      style: labelStyle.copyWith(color: color),
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
