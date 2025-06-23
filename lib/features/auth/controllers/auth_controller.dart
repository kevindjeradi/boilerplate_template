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

// Controller moderne avec Riverpod 3.0 - État simple AuthState (pas AsyncValue)
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  late final IAuthService _authService;
  late final IUserService _userService;
  StreamSubscription<User?>? _authStateSubscription;

  // Flag pour éviter les conflits lors de l'auth manuelle Google
  bool _isManualGoogleSignInInProgress = false;

  @override
  AuthState build() {
    // Initialisation des services via providers modernes
    _authService = ref.read(authServiceProvider);
    _userService = ref.read(userServiceProvider);

    // Setup du listener auth state
    _setupAuthStateListener();

    // Cleanup automatique quand le provider est disposé
    ref.onDispose(() {
      _authStateSubscription?.cancel();
    });

    return const AuthState.initial();
  }

  void _setupAuthStateListener() {
    _authStateSubscription =
        _authService.authStateChanges.listen((firebaseUser) async {
      if (!ref.exists(authControllerProvider)) return; // Guard contre dispose

      // Ignorer les changements d'état pendant l'authentification Google manuelle
      if (_isManualGoogleSignInInProgress) {
        return;
      }

      if (firebaseUser != null) {
        // Orchestration business : récupérer/créer UserModel
        try {
          final userModel = await _getOrCreateUserModel(firebaseUser);
          if (ref.exists(authControllerProvider)) {
            state = AuthState.authenticated(userModel.id);
          }
        } catch (e) {
          AppLogger.error('Failed to get/create user model', e);
          if (ref.exists(authControllerProvider)) {
            state = const AuthState.unauthenticated();
          }
        }
      } else {
        if (ref.exists(authControllerProvider)) {
          state = const AuthState.unauthenticated();
        }
      }
    });
  }

  // Orchestration business centralisée
  Future<UserModel> _getOrCreateUserModel(User firebaseUser) async {
    UserModel? userModel = await _userService.getUser(firebaseUser.uid);

    if (userModel == null) {
      userModel = UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email,
        phoneNumber: firebaseUser.phoneNumber,
        createdAt: DateTime.now(),
      );
      await _userService.createUser(userModel);
    }

    return userModel;
  }

  // MÉTHODES SIMPLIFIÉES AVEC ORCHESTRATION

  Future<void> authenticateWithEmail(
      String email, String password, bool isLoginMode) async {
    if (!_canPerformOperation()) return;

    state = const AuthState.loading();

    try {
      final firebaseUser = isLoginMode
          ? await _authService.signInWithEmailAndPassword(email, password)
          : await _authService.registerWithEmailAndPassword(email, password);

      if (_canPerformOperation()) {
        // Orchestration business
        final userModel = await _getOrCreateUserModel(firebaseUser);
        state = AuthState.authenticated(userModel.id);
      }
    } on AuthException catch (e) {
      if (_canPerformOperation()) {
        AppLogger.error('Email authentication failed', e);
        state = const AuthState.unauthenticated();
        rethrow;
      }
    }
  }

  Future<void> signInWithGoogle() async {
    if (!_canPerformOperation()) return;

    state = const AuthState.loading();

    // Activer le flag pour éviter les conflits avec le listener
    _isManualGoogleSignInInProgress = true;

    try {
      final firebaseUser = await _authService.signInWithGoogle();

      if (_canPerformOperation()) {
        if (firebaseUser != null) {
          // Orchestration business
          final userModel = await _getOrCreateUserModel(firebaseUser);
          state = AuthState.authenticated(userModel.id);
        } else {
          state = const AuthState.unauthenticated();
        }
      }
    } on AuthException catch (e) {
      if (_canPerformOperation()) {
        AppLogger.error('Google Sign-In error', e);
        state = const AuthState.unauthenticated();
        rethrow;
      }
    } finally {
      // Désactiver le flag une fois l'opération terminée
      _isManualGoogleSignInInProgress = false;
    }
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    if (!_canPerformOperation()) return;

    state = const AuthState.loading();

    try {
      await _authService.verifyPhoneNumber(
        phoneNumber,
        codeSent: (String verificationId) {
          if (_canPerformOperation()) {
            state = AuthState.codeSent(verificationId);
          }
        },
        verificationFailed: (AuthException error) {
          if (_canPerformOperation()) {
            AppLogger.error('Phone verification failed', error);
            state = const AuthState.unauthenticated();
          }
        },
      );
    } on AuthException catch (e) {
      if (_canPerformOperation()) {
        AppLogger.error('Phone verification failed', e);
        state = const AuthState.unauthenticated();
        rethrow;
      }
    }
  }

  Future<void> verifySmsCode(String smsCode) async {
    if (!_canPerformOperation()) return;

    state = const AuthState.loading();

    try {
      final firebaseUser = await _authService.signInWithSmsCode(smsCode);
      if (_canPerformOperation()) {
        // Orchestration business
        final userModel = await _getOrCreateUserModel(firebaseUser);
        state = AuthState.authenticated(userModel.id);
      }
    } on AuthException catch (e) {
      if (_canPerformOperation()) {
        AppLogger.error('SMS verification failed', e);
        state = const AuthState.unauthenticated();
        rethrow;
      }
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      // L'état sera mis à jour via le listener authStateChanges
    } on AuthException catch (e) {
      AppLogger.error('Sign out failed', e);
      rethrow;
    }
  }

  void resetState() {
    state = const AuthState.initial();
  }

  // Guard pour vérifier si on peut encore effectuer des opérations
  bool _canPerformOperation() {
    return ref.exists(authControllerProvider);
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

// Helper providers simplifiés
@riverpod
bool isAuthenticated(Ref ref) {
  final authState = ref.watch(authControllerProvider);
  return authState is AuthAuthenticated;
}

@riverpod
String? currentAuthUserId(Ref ref) {
  final authState = ref.watch(authControllerProvider);
  return authState is AuthAuthenticated ? authState.userId : null;
}

@riverpod
bool isAuthLoading(Ref ref) {
  final authState = ref.watch(authControllerProvider);
  return authState is AuthLoading;
}
