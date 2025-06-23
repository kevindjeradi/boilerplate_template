import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../exceptions/auth_exceptions.dart';
import '../exceptions/api_exceptions.dart';
import '../exceptions/permission_exceptions.dart';
import '../exceptions/user_exceptions.dart';

// Extensions pour la localisation des exceptions (COUCHE UI UNIQUEMENT)
extension AuthExceptionLocalizedMessage on AuthException {
  String toLocalizedMessage(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    switch (code) {
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
        return message;
    }
  }
}

extension ApiExceptionLocalizedMessage on ApiException {
  String toLocalizedMessage(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

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
        return message;
    }
  }
}

extension PermissionExceptionLocalizedMessage on PermissionException {
  String toLocalizedMessage(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    if (message.contains('permanently denied')) {
      return localization.permissionPermanentlyDenied;
    } else if (message.contains('restricted')) {
      return localization.permissionRestricted;
    } else {
      return localization.permissionDenied;
    }
  }
}

extension UserExceptionLocalizedMessage on UserException {
  String toLocalizedMessage(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    if (message.contains('not found')) {
      return localization.userNotFound;
    } else if (message.contains('fetch')) {
      return localization.userFetchFailed;
    } else if (message.contains('update')) {
      return localization.userUpdateFailed;
    } else if (message.contains('delete')) {
      return localization.userDeleteFailed;
    } else {
      return message;
    }
  }
}
