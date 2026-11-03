import 'package:flutter/material.dart';

import '../theme/theme_context.dart';
import '../theme/tokens.dart';

/// Etiqueta de sección en estilo `overline` (ink-muted, mayúsculas).
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: TlSpace.s6, bottom: TlSpace.s2),
    child: Semantics(
      header: true,
      child: Text(label, style: context.text.overline),
    ),
  );
}
