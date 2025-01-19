import 'package:boilerplate_template/common/user/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthService {
  Future<UserModel?> signInWithEmailAndPassword(String email, String password);
  Future<UserModel?> registerWithEmailAndPassword(
      String email, String password);

  Future<void> verifyPhoneNumber(
    String phoneNumber, {
    required Function(String) codeSent,
    required Function(FirebaseAuthException) verificationFailed,
  });

  Future<UserModel?> signInWithSmsCode(String smsCode);

  Future<UserModel?> signInWithGoogle();

  Stream<UserModel?> get authStateChanges;
  Future<void> signOut();
}
