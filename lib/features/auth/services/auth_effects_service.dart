import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boilerplate_template/features/auth/states/auth_state.dart';
import 'package:boilerplate_template/shared/user/controllers/user_controller.dart';
import 'package:boilerplate_template/features/auth/controllers/auth_controller.dart';

// Service pour gérer les effets de bord de l'authentification
class AuthEffectsService {
  static void initialize(Ref ref) {
    // Écouter les changements d'état d'authentification
    ref.listen(authControllerProvider, (previous, next) {
      _handleAuthStateChange(ref, previous, next);
    });
  }

  static void _handleAuthStateChange(
    Ref ref,
    AuthState? previous,
    AuthState next,
  ) {
    switch (next) {
      case AuthAuthenticated(:final userId):
        // Trigger user data fetch via UserController
        ref.read(userControllerProvider.notifier).fetchCurrentUser(userId);
        break;
      case AuthUnauthenticated():
        // Clear user data
        ref.read(userControllerProvider.notifier).clearUser();
        break;
      case AuthInitial():
      case AuthLoading():
      case AuthCodeSent():
        // Pas d'action nécessaire pour ces états
        break;
    }
  }
}

// Provider simple pour initialiser les effets
final authEffectsServiceProvider = Provider<void>((ref) {
  AuthEffectsService.initialize(ref);
});
