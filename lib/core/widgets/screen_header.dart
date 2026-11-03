import 'package:flutter/material.dart';

import '../theme/theme_context.dart';
import '../theme/tokens.dart';

/// Título de pantalla en estilo `headline`, con acciones opcionales.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    required this.title,
    this.leading,
    this.trailing,
    super.key,
  });

  final String title;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: TlSpace.s4, bottom: TlSpace.s2),
    child: Row(
      children: [
        if (leading != null) ...[leading!, const SizedBox(width: TlSpace.s1)],
        Expanded(
          child: Semantics(
            header: true,
            child: Text(title, style: context.text.headline),
          ),
        ),
        ?trailing,
      ],
    ),
  );
}
