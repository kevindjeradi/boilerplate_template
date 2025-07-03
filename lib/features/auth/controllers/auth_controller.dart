import 'dart:async';

import 'package:boilerplate_template/shared/exceptions/auth_exceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:boilerplate_template/features/auth/interfaces/i_auth_service.dart';
import 'package:boilerplate_template/shared/user/models/user_model.dart';
import 'package:boilerplate_template/shared/user/interfaces/i_user_service.dart';
import 'package:boilerplate_template/features/auth/states/auth_state.dart';
import 'package:boilerplate_template/features/auth/providers/auth_providers.dart';
import 'package:boilerplate_template/shared/providers/shared_providers.dart';
import 'package:boilerplate_template/shared/services/app_logger.dart';

part 'auth_controller.g.dart';
part 'auth_controller.freezed.dart';

// Auth form state avec Freezed
@freezed
class AuthFormState with _$AuthFormState {
  const factory AuthFormState({
    @Default(true) bool isLoginMode,
    @Default(false) bool isCodeSent,
    @Default(0) int selectedAuthMethod,
    String? verificationId,
  }) = _AuthFormState;
}

// Controller d'authentification unifié - SEULE SOURCE DE VÉRITÉ
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  late final IAuthService _authService;
  late final IUserService _userService;
  StreamSubscription<User?>? _authStateSubscription;
  bool _isAuthenticating = false;

  @override
  AuthState build() {
    AppLogger.info('Initializing AuthController');

    // Initialisation des services
    _authService = ref.read(authServiceProvider);
    _userService = ref.read(userServiceProvider);

    // Setup du listener Firebase immédiatement
    _setupFirebaseAuthListener();

    // Cleanup automatique
    ref.onDispose(() {
      AppLogger.info('Disposing AuthController');
      _authStateSubscription?.cancel();
    });

    // Démarrer non authentifié
    return const AuthState.unauthenticated();
  }

  // Setup du listener Firebase auth
  void _setupFirebaseAuthListener() {
    _authStateSubscription = _authService.authStateChanges.listen(
      (firebaseUser) async {
        if (!_canPerformOperation()) return;

        // Si on est en cours d'authentification, ne pas traiter les changements d'état
        if (_isAuthenticating) {
          AppLogger.info('Ignoring auth state change while authenticating');
          return;
        }

        AppLogger.info('Firebase auth state changed: ${firebaseUser?.uid}');

        try {
          if (firebaseUser != null) {
            // Utilisateur connecté : récupérer/créer le UserModel
            final userModel = await _getOrCreateUserModel(firebaseUser);
            if (_canPerformOperation()) {
              AppLogger.info(
                  'User authenticated successfully: ${userModel.email}');
              state = AuthState.authenticated(userModel);
            }
          } else {
            // Utilisateur déconnecté
            if (_canPerformOperation()) {
              AppLogger.info('User unauthenticated');
              state = const AuthState.unauthenticated();
            }
          }
        } catch (e) {
          AppLogger.error('Error handling auth state change', e);
          if (_canPerformOperation()) {
            state = const AuthState.unauthenticated();
          }
        }
      },
      onError: (error) {
        AppLogger.error('Firebase auth stream error', error);
        if (_canPerformOperation()) {
          state = const AuthState.unauthenticated();
        }
      },
    );
  }

  // Orchestration business : récupérer ou créer UserModel
  Future<UserModel> _getOrCreateUserModel(User firebaseUser) async {
    UserModel? userModel = await _userService.getUser(firebaseUser.uid);

    if (userModel == null) {
      // Créer un nouveau utilisateur
      userModel = UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email,
        phoneNumber: firebaseUser.phoneNumber,
        createdAt: DateTime.now(),
      );

      await _userService.createUser(userModel);
      AppLogger.info('Created new user: ${userModel.email}');
    }

    return userModel;
  }

  // MÉTHODES D'AUTHENTIFICATION SIMPLIFIÉES

  Future<AuthException?> authenticateWithEmail(
      String email, String password, bool isLoginMode) async {
    if (!_canPerformOperation()) return null;

    AppLogger.info('Authenticating with email: $email (login: $isLoginMode)');
    _isAuthenticating = true;

    try {
      if (isLoginMode) {
        await _authService.signInWithEmailAndPassword(email, password);
      } else {
        await _authService.registerWithEmailAndPassword(email, password);
      }

      // Le listener Firebase se chargera de mettre à jour l'état
      AppLogger.info('Email authentication initiated successfully');
      return null;
    } on AuthException catch (e) {
      AppLogger.error('Email authentication failed', e);
      return e;
    } catch (e) {
      AppLogger.error('Unexpected authentication error', e);
      return AuthException('unknown', e.toString());
    } finally {
      _isAuthenticating = false;
    }
  }

  Future<AuthException?> signInWithGoogle() async {
    if (!_canPerformOperation()) return null;

    AppLogger.info('Starting Google Sign-In');
    _isAuthenticating = true;

    try {
      final firebaseUser = await _authService.signInWithGoogle();

      if (firebaseUser == null) {
        // Utilisateur a annulé
        AppLogger.info('Google Sign-In cancelled by user');
        return const AuthException('cancelled', 'Sign in cancelled by user');
      }

      // Attendre que le UserModel soit créé/récupéré
      final userModel = await _getOrCreateUserModel(firebaseUser);
      if (_canPerformOperation()) {
        AppLogger.info('Google Sign-In successful: ${userModel.email}');
        state = AuthState.authenticated(userModel);
      }
      return null;
    } on AuthException catch (e) {
      AppLogger.error('Google Sign-In failed', e);
      return e;
    } catch (e) {
      AppLogger.error('Unexpected Google Sign-In error', e);
      return AuthException('unknown', e.toString());
    } finally {
      _isAuthenticating = false;
    }
  }

  Future<AuthException?> verifyPhoneNumber(String phoneNumber) async {
    if (!_canPerformOperation()) return null;

    AppLogger.info('Verifying phone number: $phoneNumber');
    _isAuthenticating = true;

    try {
      await _authService.verifyPhoneNumber(
        phoneNumber,
        codeSent: (String verificationId) {
          if (_canPerformOperation()) {
            AppLogger.info('SMS code sent successfully');
            state = AuthState.codeSent(verificationId);
          }
        },
        verificationFailed: (AuthException error) {
          AppLogger.error('Phone verification failed', error);
          return error;
        },
      );
      return null;
    } catch (e) {
      AppLogger.error('Unexpected phone verification error', e);
      return AuthException('unknown', e.toString());
    } finally {
      _isAuthenticating = false;
    }
  }

  Future<AuthException?> verifySmsCode(String smsCode) async {
    if (!_canPerformOperation()) return null;

    AppLogger.info('Verifying SMS code');
    _isAuthenticating = true;

    try {
      await _authService.signInWithSmsCode(smsCode);
      // Le listener Firebase se chargera de mettre à jour l'état
      AppLogger.info('SMS verification initiated successfully');
      return null;
    } on AuthException catch (e) {
      AppLogger.error('SMS verification failed', e);
      return e;
    } catch (e) {
      AppLogger.error('Unexpected SMS verification error', e);
      return AuthException('unknown', e.toString());
    } finally {
      _isAuthenticating = false;
    }
  }

  Future<void> signOut() async {
    if (!_canPerformOperation()) return;

    AppLogger.info('Signing out user');

    try {
      await _authService.signOut();
      // Le listener Firebase se chargera de mettre à jour l'état
      AppLogger.info('Sign out initiated successfully');
    } on AuthException catch (e) {
      AppLogger.error('Sign out failed', e);
      // En cas d'erreur de déconnexion, on force l'état unauthenticated
      if (_canPerformOperation()) {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      AppLogger.error('Unexpected sign out error', e);
      if (_canPerformOperation()) {
        state = const AuthState.unauthenticated();
      }
    }
  }

  // Reset complet (pour tests ou cas exceptionnels)
  void resetState() {
    if (_canPerformOperation()) {
      AppLogger.info('Resetting auth state');
      state = const AuthState.initial();
    }
  }

  // Guard pour vérifier si on peut encore effectuer des opérations
  bool _canPerformOperation() {
    return ref.exists(authControllerProvider);
  }

  // Méthodes utilitaires
  bool isAuthenticated(Ref ref) {
    final authState = ref.read(authControllerProvider);
    return authState is AuthAuthenticated;
  }

  UserModel? currentUser(Ref ref) {
    final authState = ref.read(authControllerProvider);
    return authState is AuthAuthenticated ? authState.user : null;
  }
}

// Controller séparé pour l'état du formulaire - RESPONSABILITÉ UNIQUE: UI FORM
@riverpod
class AuthFormController extends _$AuthFormController {
  @override
  AuthFormState build() {
    return const AuthFormState();
  }

  void toggleLoginMode() {
    state = state.copyWith(isLoginMode: !state.isLoginMode);
  }

  void setSelectedAuthMethod(int index) {
    state = state.copyWith(
      selectedAuthMethod: index,
      isCodeSent: false,
    );
  }

  void setCodeSent(bool isCodeSent, {String? verificationId}) {
    state = state.copyWith(
      isCodeSent: isCodeSent,
      verificationId: verificationId,
    );
  }

  void resetState() {
    state = const AuthFormState();
  }
}

// Helper providers
@riverpod
String? currentUserId(Ref ref) {
  return ref.watch(authControllerProvider.select((state) {
    if (state is AuthAuthenticated) {
      return state.user.id;
    }
    return null;
  }));
}

@riverpod
bool isAuthLoading(Ref ref) {
  return false;
}

@riverpod
UserModel? currentUser(Ref ref) {
  return ref.watch(authControllerProvider.select((state) {
    if (state is AuthAuthenticated) {
      return state.user;
    }
    return null;
  }));
}
