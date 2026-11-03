import 'package:flutter/material.dart';

import '../theme/theme_context.dart';
import '../theme/tokens.dart';

/// Estado vacío: ícono de trazo, título condensado y texto de apoyo.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    required this.body,
    super.key,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TlSpace.s6),
      decoration: BoxDecoration(
        color: c.surface1,
        borderRadius: BorderRadius.circular(TlRadius.lg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: c.accent),
          const SizedBox(height: TlSpace.s4),
          Text(title, style: t.title),
          const SizedBox(height: TlSpace.s2),
          Text(body, style: t.bodySm.copyWith(color: c.inkMuted)),
        ],
      ),
    );
  }
}
