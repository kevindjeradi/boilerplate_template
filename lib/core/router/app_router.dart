import 'package:boilerplate_template/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:boilerplate_template/shared/services/app_logger.dart';
import 'package:boilerplate_template/features/auth/states/auth_state.dart';
import 'package:boilerplate_template/features/auth/controllers/auth_controller.dart';
import 'package:boilerplate_template/features/auth/screens/auth_screen.dart';
import 'package:boilerplate_template/features/settings/screens/settings_screen.dart';
import 'package:boilerplate_template/features/admin/screens/admin_screen.dart';
import 'package:boilerplate_template/home_screen.dart';
import 'package:boilerplate_template/features/page1/screens/page1_screen.dart';
import 'package:boilerplate_template/features/page2/screens/page2_screen.dart';
import 'package:boilerplate_template/core/navigation/widgets/app_navigation_shell.dart';

part 'app_router.g.dart';

// Route names
class AppRoutes {
  static const String auth = '/auth';
  static const String home = '/home';
  static const String page1 = '/page1';
  static const String page2 = '/page2';
  static const String admin = '/admin';
  static const String settings = '/settings';
  static const String loading = '/loading';

  // TODO: Pour ton projet, configure les routes privées ici
  // Par défaut: admin seulement
  // Exemples: billing, profile, settings, dashboard...
  static const Set<String> privateRoutes = {
    admin, // Toujours privé (admin required)
    // settings,  // Décommenter si settings doit être privé
    // profile,   // Ajouter selon le projet
  };

  // Routes de navigation principale (dans le shell)
  static const Set<String> mainNavigationRoutes = {home, page1, page2, admin};

  // Helper methods
  static bool isPrivateRoute(String path) => privateRoutes.contains(path);
  static bool isPublicRoute(String path) => !isPrivateRoute(path);
  static bool isMainNavigationRoute(String path) =>
      mainNavigationRoutes.contains(path);

  // Obtenir l'index de l'onglet depuis l'URL
  static int getTabIndexFromPath(String path) {
    const navigationOrder = [home, page1, page2, admin];
    final index = navigationOrder.indexOf(path);
    return index >= 0 ? index : 0;
  }

  // Obtenir le path depuis l'index de l'onglet
  static String getPathFromTabIndex(int index) {
    const navigationOrder = [home, page1, page2, admin];
    if (index >= 0 && index < navigationOrder.length) {
      return navigationOrder[index];
    }
    return home;
  }
}

// Router réactif aux changements d'auth - unifié et simplifié
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  // Surveiller l'état d'auth pour invalidation automatique
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      final currentPath = state.uri.path;

      // Rediriger / vers /home
      if (currentPath == '/') {
        return AppRoutes.home;
      }

      // Pendant le loading ou l'envoi de code, on ne redirige pas
      if (authState is AuthCodeSent) {
        return null;
      }

      // Rediriger vers auth si on essaie d'accéder à une route privée sans être authentifié
      if (AppRoutes.isPrivateRoute(currentPath) &&
          authState is! AuthAuthenticated) {
        return AppRoutes.auth;
      }

      // Rediriger vers home si on est sur auth et qu'on est authentifié
      if (currentPath == AppRoutes.auth && authState is AuthAuthenticated) {
        return AppRoutes.home;
      }

      // Dans tous les autres cas, ne pas rediriger
      return null;
    },
    routes: [
      // Auth route séparée (sans navigation)
      GoRoute(
        path: AppRoutes.auth,
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),

      // Loading route (hors navigation)
      GoRoute(
        path: AppRoutes.loading,
        name: 'loading',
        builder: (context, state) => const LoadingScreen(),
      ),

      // Navigation principale avec StatefulShellRoute
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppNavigationShell(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // Branch 1: Page1
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.page1,
                name: 'page1',
                builder: (context, state) => const Page1Screen(),
              ),
            ],
          ),
          // Branch 2: Page2
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.page2,
                name: 'page2',
                builder: (context, state) => const Page2Screen(),
              ),
            ],
          ),
          // Branch 3: Admin
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.admin,
                name: 'admin',
                builder: (context, state) => const AdminScreen(),
              ),
            ],
          ),
        ],
      ),

      // Routes secondaires (hors navigation)
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) {
      AppLogger.error('Router error: ${state.error}');
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Page not found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Error: ${state.error}',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Navigation helpers
class AppNavigation {
  static void goToAuth(BuildContext context) {
    context.go(AppRoutes.auth);
  }

  static void goToHome(BuildContext context) {
    context.go(AppRoutes.home);
  }

  static void goToPage1(BuildContext context) {
    context.go(AppRoutes.page1);
  }

  static void goToPage2(BuildContext context) {
    context.go(AppRoutes.page2);
  }

  static void goToSettings(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SettingsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        },
      ),
    );
  }

  static void goToAdmin(BuildContext context) {
    context.push(AppRoutes.admin);
  }

  static void pop(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      // Fallback to home if can't pop
      context.go(AppRoutes.home);
    }
  }
}
