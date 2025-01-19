import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class ErrorHandlingService {
  String getErrorMessage(Exception exception) {
    final localization = AppLocalizations.of(Get.context!)!;

    if (exception is FirebaseAuthException) {
      return _handleFirebaseAuthException(exception);
    }

    return localization.unexpectedError;
  }

  String getErrorMessageFromStatusCode(int statusCode) {
    final localization = AppLocalizations.of(Get.context!)!;

    switch (statusCode) {
      case 400:
        return localization.badRequest;
      case 401:
        return localization.unauthorized;
      case 403:
        return localization.forbidden;
      case 404:
        return localization.notFound;
      case 500:
        return localization.internalServerError;
      default:
        return localization.unexpectedError;
    }
  }

  String _handleFirebaseAuthException(FirebaseAuthException exception) {
    final localization = AppLocalizations.of(Get.context!)!;

    switch (exception.code) {
      case 'invalid-email':
        return localization.invalidEmail;
      case 'user-disabled':
        return localization.userDisabled;
      case 'user-not-found':
        return localization.noUserFoundForThatEmail;
      case 'wrong-password':
        return localization.wrongPasswordProvided;
      case 'email-already-in-use':
        return localization.accountAlreadyExistsForThatEmail;
      case 'operation-not-allowed':
        return localization.operationNotAllowed;
      case 'weak-password':
        return localization.weakPassword;
      case 'invalid-verification-code':
        return localization.invalidVerificationCode;
      case 'invalid-verification-id':
        return localization.invalidVerificationId;
      case 'invalid-phone-number':
        return localization.invalidPhoneNumber;
      case 'too-many-requests':
        return localization.tooManyRequests;
      default:
        return localization.authenticationError;
    }
  }
}
