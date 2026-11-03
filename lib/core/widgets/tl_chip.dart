import 'package:flutter/material.dart';

import '../theme/theme_context.dart';
import '../theme/tokens.dart';

/// Chip de filtro u opción: relleno principal si está activo, contorno si no.
class TlChip extends StatelessWidget {
  const TlChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.trailingIcon,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = selected ? c.primaryInk : c.ink;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? c.primaryBg : Colors.transparent,
        shape: StadiumBorder(
          side: BorderSide(color: selected ? c.primaryBg : c.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 40),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: TlSpace.s4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: context.text.bodySm.copyWith(
                      color: fg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (trailingIcon != null) ...[
                    const SizedBox(width: TlSpace.s1),
                    Icon(trailingIcon, size: 18, color: fg),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
