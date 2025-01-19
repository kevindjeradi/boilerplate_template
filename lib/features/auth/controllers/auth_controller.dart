import 'package:boilerplate_template/common/error_handling/services/error_handling_service.dart';
import 'package:boilerplate_template/common/user/controllers/user_controller.dart';
import 'package:boilerplate_template/features/auth/interfaces/i_auth_service.dart';
import 'package:boilerplate_template/common/user/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthController extends GetxController {
  final IAuthService _authService;
  final ErrorHandlingService _errorHandlingService;
  final UserController _userController;

  Rxn<UserModel> user = Rxn<UserModel>();
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxBool isLoginMode = true.obs;
  RxBool isCodeSent = false.obs;
  RxInt selectedAuthMethod = 0.obs;

  AuthController(
      this._authService, this._errorHandlingService, this._userController);

  @override
  void onInit() {
    super.onInit();
    _authService.authStateChanges.listen((userModel) {
      user.value = userModel;
      if (userModel != null) {
        _userController.fetchCurrentUser(userModel.id);
      } else {
        _userController.currentUser.value = null;
      }
    });
  }

  void resetState() {
    isLoading.value = false;
    errorMessage.value = '';
    isLoginMode.value = true;
    isCodeSent.value = false;
  }

  void toggleLoginMode() {
    isLoginMode.value = !isLoginMode.value;
  }

  void setSelectedAuthMethod(int index) {
    selectedAuthMethod.value = index;
    resetState();
  }

  Future<void> authenticateWithEmail(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      UserModel? userModel;
      if (isLoginMode.value) {
        userModel =
            await _authService.signInWithEmailAndPassword(email, password);
      } else {
        userModel =
            await _authService.registerWithEmailAndPassword(email, password);
      }
      if (userModel != null) {
        user.value = userModel;
        Get.offAllNamed('/home');
      }
    } catch (e) {
      errorMessage.value =
          _errorHandlingService.getErrorMessage(e as Exception);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      UserModel? userModel = await _authService.signInWithGoogle();
      if (userModel != null) {
        user.value = userModel;
        Get.offAllNamed('/home');
      }
    } catch (e) {
      errorMessage.value =
          _errorHandlingService.getErrorMessage(e as Exception);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _authService.verifyPhoneNumber(
        phoneNumber,
        codeSent: (String verificationId) {
          isCodeSent.value = true;
          isLoading.value = false;
        },
        verificationFailed: (FirebaseAuthException e) {
          errorMessage.value = _errorHandlingService.getErrorMessage(e);
          isLoading.value = false;
        },
      );
    } catch (e) {
      errorMessage.value =
          _errorHandlingService.getErrorMessage(e as Exception);
      isLoading.value = false;
    }
  }

  Future<void> verifySmsCode(String smsCode) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      UserModel? userModel = await _authService.signInWithSmsCode(smsCode);
      if (userModel != null) {
        user.value = userModel;
        isCodeSent.value = false;
        Get.offAllNamed('/home');
      }
    } catch (e) {
      errorMessage.value =
          _errorHandlingService.getErrorMessage(e as Exception);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    user.value = null;
    Get.offAllNamed('/auth');
  }

  String? validateEmail(String? value) {
    final localization = AppLocalizations.of(Get.context!)!;
    if (value == null || value.isEmpty) {
      return localization.pleaseEnterYourEmail;
    } else if (!GetUtils.isEmail(value)) {
      return localization.pleaseEnterValidEmail;
    }
    return null;
  }

  String? validatePassword(String? value) {
    final localization = AppLocalizations.of(Get.context!)!;
    if (value == null || value.isEmpty) {
      return localization.pleaseEnterYourPassword;
    } else if (!isLoginMode.value && value.length < 6) {
      return localization.passwordMustBeAtLeast6Characters;
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    final localization = AppLocalizations.of(Get.context!)!;
    if (value == null || value.isEmpty) {
      return localization.pleaseEnterYourPhoneNumber;
    } else if (!GetUtils.isPhoneNumber(value)) {
      return localization.pleaseEnterValidPhoneNumber;
    }
    return null;
  }

  String? validateSmsCode(String? value) {
    final localization = AppLocalizations.of(Get.context!)!;
    if (value == null || value.isEmpty) {
      return localization.pleaseEnterSmsCode;
    }
    return null;
  }
}
