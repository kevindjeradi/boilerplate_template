import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:boilerplate_template/shared/services/app_logger.dart';
import 'package:boilerplate_template/features/auth/interfaces/i_auth_service.dart';
import 'package:boilerplate_template/features/auth/services/auth_service.dart';
import 'package:boilerplate_template/features/auth/services/auth_validation_service.dart';
import 'package:boilerplate_template/shared/error_handling/providers/error_providers.dart';

part 'auth_providers.g.dart';

// ==================== AUTH PROVIDERS ====================

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) {
  return FirebaseAuth.instance;
}

@Riverpod(keepAlive: true)
GoogleSignIn googleSignIn(Ref ref) {
  final googleClientId = dotenv.env['GOOGLE_CLIENT_ID'];

  if (googleClientId == null || googleClientId.isEmpty) {
    AppLogger.warning(
        'Google Client ID is null or empty. Using default configuration.');
    return GoogleSignIn(
      // Forcer l'interaction utilisateur pour éviter les connexions automatiques
      forceCodeForRefreshToken: true,
    );
  }

  // Configurer selon la plateforme
  if (kIsWeb) {
    return GoogleSignIn(
      clientId: googleClientId, // Required for web only
      // Forcer l'interaction utilisateur pour éviter les connexions automatiques
      forceCodeForRefreshToken: true,
    );
  } else {
    return GoogleSignIn(
      serverClientId: googleClientId, // Required for Android/iOS
      // Forcer l'interaction utilisateur pour éviter les connexions automatiques
      forceCodeForRefreshToken: true,
    );
  }
}

@Riverpod(keepAlive: true)
IAuthService authService(Ref ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final googleSignIn = ref.watch(googleSignInProvider);
  final errorHandlingService = ref.watch(errorHandlingServiceProvider);

  return AuthService(
    firebaseAuth: firebaseAuth,
    googleSignIn: googleSignIn,
    errorHandlingService: errorHandlingService,
  );
}

@Riverpod(keepAlive: true)
AuthValidationService authValidationService(Ref ref) {
  return AuthValidationService();
}
