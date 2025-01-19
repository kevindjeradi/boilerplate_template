import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:boilerplate_template/common/user/interfaces/i_user_service.dart';
import 'package:boilerplate_template/common/user/models/user_model.dart';
import 'package:boilerplate_template/features/auth/interfaces/i_auth_service.dart';

class AuthService implements IAuthService {
  final FirebaseAuth _firebaseAuth;
  final IUserService _userService;
  final GoogleSignIn _googleSignIn;

  String? verificationId;

  AuthService(
    this._userService, {
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    String? clientId,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              clientId: clientId,
            );

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser != null) {
        return await _getUserModel(firebaseUser);
      }
      return null;
    });
  }

  Future<UserModel?> _getUserModel(User? firebaseUser) async {
    if (firebaseUser != null) {
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
    return null;
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return await _getUserModel(userCredential.user);
  }

  @override
  Future<UserModel?> registerWithEmailAndPassword(
      String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return await _getUserModel(userCredential.user);
  }

  @override
  Future<void> verifyPhoneNumber(
    String phoneNumber, {
    required Function(String) codeSent,
    required Function(FirebaseAuthException) verificationFailed,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        await _getUserModel(userCredential.user);
      },
      verificationFailed: (FirebaseAuthException e) {
        verificationFailed(e);
      },
      codeSent: (String verId, int? resendToken) {
        verificationId = verId;
        codeSent(verId);
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
  }

  @override
  Future<UserModel?> signInWithSmsCode(String smsCode) async {
    if (verificationId == null) {
      throw Exception('Verification ID is null');
    }
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: smsCode,
    );
    UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    return await _getUserModel(userCredential.user);
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return await _getUserModel(userCredential.user);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
}
