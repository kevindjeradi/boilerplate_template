import 'package:firebase_auth/firebase_auth.dart';

import 'package:boilerplate_template/shared/exceptions/auth_exceptions.dart';
import 'package:boilerplate_template/shared/exceptions/permission_exceptions.dart';
import 'package:boilerplate_template/shared/exceptions/api_exceptions.dart';

class ErrorHandlingService {
  // Méthode pour mapper FirebaseAuthException vers AuthException
  AuthException mapFirebaseAuthException(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return AuthException.invalidEmail();
      case 'user-disabled':
        return AuthException.userDisabled();
      case 'user-not-found':
        return AuthException.userNotFound();
      case 'wrong-password':
        return AuthException.wrongPassword();
      case 'email-already-in-use':
        return AuthException.emailAlreadyInUse();
      case 'operation-not-allowed':
        return AuthException.operationNotAllowed();
      case 'weak-password':
        return AuthException.weakPassword();
      case 'invalid-verification-code':
        return AuthException.invalidVerificationCode();
      case 'invalid-verification-id':
        return AuthException.invalidVerificationId();
      case 'invalid-phone-number':
        return AuthException.invalidPhoneNumber();
      case 'too-many-requests':
        return AuthException.tooManyRequests();
      default:
        return AuthException(exception.code,
            exception.message ?? 'Unknown authentication error');
    }
  }

  // Méthode pour mapper Exception générale à AuthException
  AuthException mapException(Exception exception) {
    if (exception is FirebaseAuthException) {
      return mapFirebaseAuthException(exception);
    }
    return AuthException('unknown', exception.toString());
  }

  // Méthodes pour les autres types d'exceptions
  PermissionException mapPermissionResult(bool isGranted,
      {bool isPermanentlyDenied = false}) {
    if (isPermanentlyDenied) {
      return PermissionException.permanentlyDenied();
    } else if (!isGranted) {
      return PermissionException.denied();
    } else {
      return PermissionException.restricted();
    }
  }

  PermissionException mapExceptionToPermissionError(Exception exception) {
    return PermissionException(exception.toString());
  }

  ApiException mapHttpStatusCode(int statusCode, String message) {
    switch (statusCode) {
      case 400:
        return ApiException.badRequest();
      case 401:
        return ApiException.unauthorized();
      case 403:
        return ApiException.forbidden();
      case 404:
        return ApiException.notFound();
      case 500:
        return ApiException.internalServerError();
      default:
        return ApiException(message, statusCode);
    }
  }
}
