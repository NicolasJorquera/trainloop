import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Página desplazable con el margen lateral estándar (`space-4`).
class TabPage extends StatelessWidget {
  const TabPage({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: ListView(
      padding: const EdgeInsets.fromLTRB(TlSpace.s4, 0, TlSpace.s4, TlSpace.s8),
      children: children,
    ),
  );
}
