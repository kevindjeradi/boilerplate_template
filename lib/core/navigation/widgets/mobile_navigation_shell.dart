import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/router/app_router.dart';
import '../../../features/auth/controllers/auth_controller.dart';
import '../../../features/auth/states/auth_state.dart';
import '../config/navigation_config.dart';
import '../models/navigation_item.dart';

class MobileNavigationShell extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final List<Widget> pages;

  const MobileNavigationShell({
    required this.currentIndex,
    required this.onIndexChanged,
    required this.pages,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final currentUser = ref.watch(currentUserProvider);
    final authState = ref.watch(authControllerProvider);

    final isAuthenticated = authState is AuthAuthenticated;
    final isAdmin = currentUser?.role.isAdmin ?? false;

    final navigationTabs = NavigationConfig.getTabsForUser(
      localizations: localization,
      isAuthenticated: isAuthenticated,
      isAdmin: isAdmin,
    );

    // Titre dynamique selon la page active
    final allTabs = NavigationConfig.getAllTabs(localization);
    final currentTitle = currentIndex < allTabs.length
        ? allTabs[currentIndex].label
        : localization.home;

    return Scaffold(
      appBar: AppBar(
        title: Text(currentTitle),
        actions: [
          IconButton(
            icon: Icon(isAuthenticated ? Icons.settings : Icons.person),
            onPressed: () => AppNavigation.goToSettings(context),
          ),
        ],
      ),
      body: pages.first, // Le navigationShell est le premier (et seul) élément
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Needed for 4+ tabs
        currentIndex: _getDisplayIndex(currentIndex, navigationTabs),
        onTap: (displayIndex) {
          // Convertir l'index d'affichage vers l'index réel
          final realIndex = _getRealIndex(displayIndex, navigationTabs);
          onIndexChanged(realIndex);
        },
        items: navigationTabs.map((tab) {
          return BottomNavigationBarItem(
            icon: Icon(tab.icon),
            label: tab.label,
          );
        }).toList(),
      ),
    );
  }

  // Convertir l'index réel du shell vers l'index d'affichage
  int _getDisplayIndex(int realIndex, List<NavigationItem> visibleTabs) {
    final allTabs = [
      AppRoutes.home,
      AppRoutes.page1,
      AppRoutes.page2,
      AppRoutes.admin
    ];
    if (realIndex >= allTabs.length) return 0;

    final currentRoute = allTabs[realIndex];
    final displayIndex =
        visibleTabs.indexWhere((tab) => tab.route == currentRoute);
    return displayIndex >= 0 ? displayIndex : 0;
  }

  // Convertir l'index d'affichage vers l'index réel du shell
  int _getRealIndex(int displayIndex, List<NavigationItem> visibleTabs) {
    if (displayIndex < 0 || displayIndex >= visibleTabs.length) return 0;

    final selectedRoute = visibleTabs[displayIndex].route;
    return AppRoutes.getTabIndexFromPath(selectedRoute);
  }
}
