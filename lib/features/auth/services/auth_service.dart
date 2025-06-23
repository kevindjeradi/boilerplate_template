import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:boilerplate_template/shared/services/app_logger.dart';
import 'package:boilerplate_template/features/auth/interfaces/i_auth_service.dart';
import 'package:boilerplate_template/shared/exceptions/auth_exceptions.dart';
import 'package:boilerplate_template/shared/error_handling/services/error_handling_service.dart';

class AuthService implements IAuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final ErrorHandlingService _errorHandlingService;

  String? verificationId;

  AuthService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    String? clientId,
    ErrorHandlingService? errorHandlingService,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              clientId: clientId,
            ),
        _errorHandlingService = errorHandlingService ?? ErrorHandlingService();

  @override
  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges();
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        return userCredential.user!;
      } else {
        throw const AuthException('sign-in-failed', 'Failed to sign in user');
      }
    } on FirebaseAuthException catch (e) {
      throw _errorHandlingService.mapFirebaseAuthException(e);
    } catch (e) {
      throw AuthException('unknown', e.toString());
    }
  }

  @override
  Future<User> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        return userCredential.user!;
      } else {
        throw const AuthException(
            'registration-failed', 'Failed to register user');
      }
    } on FirebaseAuthException catch (e) {
      throw _errorHandlingService.mapFirebaseAuthException(e);
    } catch (e) {
      throw AuthException('unknown', e.toString());
    }
  }

  @override
  Future<void> verifyPhoneNumber(
    String phoneNumber, {
    required Function(String) codeSent,
    required Function(AuthException) verificationFailed,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _firebaseAuth.signInWithCredential(credential);
          } catch (e) {
            AppLogger.error('Auto verification failed', e);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          final authException =
              _errorHandlingService.mapFirebaseAuthException(e);
          verificationFailed(authException);
        },
        codeSent: (String verId, int? resendToken) {
          verificationId = verId;
          codeSent(verId);
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId = verId;
        },
      );
    } on FirebaseAuthException catch (e) {
      throw _errorHandlingService.mapFirebaseAuthException(e);
    } catch (e) {
      throw AuthException('unknown', e.toString());
    }
  }

  @override
  Future<User> signInWithSmsCode(String smsCode) async {
    if (verificationId == null) {
      throw AuthException.invalidVerificationId();
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: smsCode,
      );
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        return userCredential.user!;
      } else {
        throw const AuthException(
            'sms-sign-in-failed', 'Failed to sign in with SMS');
      }
    } on FirebaseAuthException catch (e) {
      throw _errorHandlingService.mapFirebaseAuthException(e);
    } catch (e) {
      throw AuthException('unknown', e.toString());
    }
  }

  @override
  Future<User?> signInWithGoogle() async {
    try {
      // Essayer d'abord une connexion silencieuse (sans popup)
      GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();

      if (googleUser == null) {
        // Si la connexion silencieuse échoue, forcer la sélection de compte
        await _googleSignIn.signOut(); // S'assurer qu'on part de zéro
        googleUser = await _googleSignIn.signIn();
      }

      if (googleUser == null) {
        return null; // User cancelled
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase error during Google Sign-In', e);
      throw _errorHandlingService.mapFirebaseAuthException(e);
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      AppLogger.error('Unexpected error during Google Sign-In', e);
      throw AuthException('unknown', e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      AppLogger.error('Error during sign out', e);
      throw AuthException('signout-failed', e.toString());
    }
  }
}
