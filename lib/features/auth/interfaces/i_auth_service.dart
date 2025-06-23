import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:boilerplate_template/shared/exceptions/auth_exceptions.dart';

abstract class IAuthService {
  Stream<User?> get authStateChanges;

  Future<User> signInWithEmailAndPassword(String email, String password);

  Future<User> registerWithEmailAndPassword(String email, String password);

  Future<void> verifyPhoneNumber(
    String phoneNumber, {
    required Function(String) codeSent,
    required Function(AuthException) verificationFailed,
  });

  Future<User> signInWithSmsCode(String smsCode);

  Future<User?> signInWithGoogle();

  Future<void> signOut();
}
