import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/l10n/l10n.dart';
import '../core/widgets/tl_bottom_nav.dart';
import '../features/monetization/application/ad_guard_provider.dart';
import '../features/monetization/presentation/ad_banner.dart';

/// Contenedor de las 4 pestañas con la barra inferior y, sobre ella, el
/// banner (diseño de Main; solo si el guard lo permite).
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: navigationShell),
          const AdBanner(placement: BannerPlacement.tabs),
        ],
      ),
      bottomNavigationBar: TlBottomNav(
        semanticLabel: l10n.navMainLabel,
        currentIndex: navigationShell.currentIndex,
        onTap: (i) => navigationShell.goBranch(
          i,
          initialLocation: i == navigationShell.currentIndex,
        ),
        items: [
          TlNavItem(
            key: const Key('nav-home'),
            icon: Icons.home_outlined,
            label: l10n.navHome,
          ),
          TlNavItem(
            key: const Key('nav-train'),
            icon: Icons.fitness_center,
            label: l10n.navTrain,
          ),
          TlNavItem(
            key: const Key('nav-history'),
            icon: Icons.history,
            label: l10n.navHistory,
          ),
          TlNavItem(
            key: const Key('nav-progress'),
            icon: Icons.show_chart,
            label: l10n.navProgress,
          ),
        ],
      ),
    );
  }
}
