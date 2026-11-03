import 'package:flutter/material.dart';

import '../theme/theme_context.dart';
import '../theme/tokens.dart';

/// Fila con etiqueta y un valor que se ajusta con − y +.
class TlStepper extends StatelessWidget {
  const TlStepper({
    required this.label,
    required this.value,
    required this.decreaseTooltip,
    required this.increaseTooltip,
    this.onDecrease,
    this.onIncrease,
    super.key,
  });

  final String label;
  final String value;
  final String decreaseTooltip;
  final String increaseTooltip;

  /// `null` deshabilita el botón (límite alcanzado).
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TlSpace.s2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: t.body)),
          _StepButton(Icons.remove, decreaseTooltip, onDecrease),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 72),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: t.title.copyWith(color: c.ink),
            ),
          ),
          _StepButton(Icons.add, increaseTooltip, onIncrease),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton(this.icon, this.tooltip, this.onPressed);

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => IconButton.filledTonal(
    tooltip: tooltip,
    onPressed: onPressed,
    constraints: const BoxConstraints.tightFor(
      width: TlSize.touchMin,
      height: TlSize.touchMin,
    ),
    style: IconButton.styleFrom(
      backgroundColor: context.colors.surface2,
      foregroundColor: context.colors.ink,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TlRadius.md),
      ),
    ),
    icon: Icon(icon),
  );
}
