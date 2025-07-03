import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/navigation_item.dart';
import '../../router/app_router.dart';

class NavigationConfig {
  // Get all navigation tabs (sans filtrage)
  static List<NavigationItem> getAllTabs(AppLocalizations localizations) {
    return [
      NavigationItem(
        route: AppRoutes.home,
        icon: Icons.home_rounded,
        label: localizations.home,
      ),
      NavigationItem(
        route: AppRoutes.page1,
        icon: Icons.article_rounded,
        label: localizations.page1,
      ),
      NavigationItem(
        route: AppRoutes.page2,
        icon: Icons.description_rounded,
        label: localizations.page2,
      ),
      NavigationItem(
        route: AppRoutes.admin,
        icon: Icons.admin_panel_settings,
        label: localizations.admin,
      ),
    ];
  }

  // Get navigation tabs based on user role and auth state
  static List<NavigationItem> getTabsForUser({
    required AppLocalizations localizations,
    bool isAuthenticated = false,
    bool isAdmin = false,
  }) {
    final allTabs = getAllTabs(localizations);

    return allTabs.where((tab) {
      // Si la route est publique, toujours visible
      if (AppRoutes.isPublicRoute(tab.route)) {
        // Pour admin, vérifier le rôle même si public
        if (tab.route == AppRoutes.admin) {
          return isAdmin;
        }
        return true;
      }

      // Si la route est privée, visible seulement si auth
      if (AppRoutes.isPrivateRoute(tab.route)) {
        if (tab.route == AppRoutes.admin) {
          return isAuthenticated && isAdmin;
        }
        return isAuthenticated;
      }

      return true;
    }).toList();
  }

  static int getIndexFromRoute(String route, {bool isAdmin = false}) {
    // Routes dans l'ordre du StatefulShellRoute
    const routes = [
      AppRoutes.home,
      AppRoutes.page1,
      AppRoutes.page2,
      AppRoutes.admin
    ];
    final index = routes.indexOf(route);
    return index >= 0 ? index : 0;
  }

  static String getRouteFromIndex(int index, {bool isAdmin = false}) {
    const routes = [
      AppRoutes.home,
      AppRoutes.page1,
      AppRoutes.page2,
      AppRoutes.admin
    ];
    if (index >= 0 && index < routes.length) {
      return routes[index];
    }
    return routes[0];
  }
}
