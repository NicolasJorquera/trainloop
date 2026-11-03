import 'package:flutter/material.dart';

import '../theme/theme_context.dart';
import '../theme/tokens.dart';

enum TlButtonVariant { primary, secondary, text }

/// Botón de Pizarra de hierro: principal, secundario o de texto.
class TlButton extends StatelessWidget {
  const TlButton({
    required this.label,
    required this.onPressed,
    this.variant = TlButtonVariant.primary,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final TlButtonVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (bg, fg, border) = switch (variant) {
      TlButtonVariant.primary => (c.primaryBg, c.primaryInk, null),
      TlButtonVariant.secondary => (
        Colors.transparent,
        c.ink,
        BorderSide(color: c.ink, width: 2),
      ),
      TlButtonVariant.text => (Colors.transparent, c.accent, null),
    };
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(TlRadius.md),
      side: border ?? BorderSide.none,
    );
    // Nodo propio para TalkBack: no se mezcla con el texto vecino.
    return Semantics(
      container: true,
      button: true,
      enabled: onPressed != null,
      // Deshabilitado: mismo estilo atenuado.
      child: Opacity(
        opacity: onPressed == null ? 0.4 : 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: TlSize.buttonHeight),
          child: Material(
            color: bg,
            shape: shape,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: TlSpace.s4,
                  vertical: TlSpace.s3,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: fg, size: 22),
                      const SizedBox(width: TlSpace.s2),
                    ],
                    Flexible(
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        style: context.text.button.copyWith(color: fg),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
