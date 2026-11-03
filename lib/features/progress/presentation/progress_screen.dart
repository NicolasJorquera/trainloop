import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/tab_page.dart';

/// Pestaña Progress: estado vacío hasta el entregable 6 (historial y estadísticas).
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TabPage(
      children: [
        ScreenHeader(title: l10n.progressTitle),
        const SizedBox(height: TlSpace.s4),
        EmptyState(
          icon: Icons.show_chart,
          title: l10n.progressEmptyTitle,
          body: l10n.progressEmptyBody,
        ),
      ],
    );
  }
}
