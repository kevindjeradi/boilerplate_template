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
import 'package:boilerplate_template/home_screen.dart';

part 'app_router.g.dart';

// Route names
class AppRoutes {
  static const String auth = '/auth';
  static const String home = '/';
  static const String settings = '/settings';
  static const String loading = '/loading';
  // Écrans publics (accessibles sans auth)
  static const Set<String> publicRoutes = {auth, loading};

  // Helper methods
  static bool isPublicRoute(String path) => publicRoutes.contains(path);
  static bool isPrivateRoute(String path) => !isPublicRoute(path);
}

// Router réactif aux changements d'auth - approche Riverpod 3.0
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  // Surveiller l'état d'auth pour invalidation automatique
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      final currentPath = state.uri.path;

      return switch (authState) {
        // État initial : laisser passer, Firebase répondra vite
        AuthInitial() => null,

        // Authentifié mais sur écran public → rediriger vers home
        AuthAuthenticated() when AppRoutes.isPublicRoute(currentPath) =>
          AppRoutes.home,

        // Non authentifié mais sur écran privé → rediriger vers auth
        AuthUnauthenticated() when AppRoutes.isPrivateRoute(currentPath) =>
          AppRoutes.auth,

        // En cours de chargement d'authentification :
        // - Si on est sur une route privée (comme /), rediriger vers auth
        // - Sinon laisser sur la page courante
        AuthLoading() when AppRoutes.isPrivateRoute(currentPath) =>
          AppRoutes.auth,
        AuthLoading() => null,

        // Code SMS envoyé : si sur route privée, aller vers auth
        AuthCodeSent() when AppRoutes.isPrivateRoute(currentPath) =>
          AppRoutes.auth,
        AuthCodeSent() => null,

        // Tous les autres cas : pas de redirection
        _ => null,
      };
    },
    routes: [
      GoRoute(
        path: AppRoutes.loading,
        name: 'loading',
        builder: (context, state) => const LoadingScreen(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        name: 'auth',
        builder: (context, state) => AuthScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
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
                '${state.error}',
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

// Navigation helpers simplifiés
class AppNavigation {
  static void goToAuth(BuildContext context) {
    context.go(AppRoutes.auth);
  }

  static void goToHome(BuildContext context) {
    context.go(AppRoutes.home);
  }

  static void goToSettings(BuildContext context) {
    context.push(AppRoutes.settings);
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
