import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthValidationService {
  // Validation methods sans dépendance au controller
  String? validateEmail(String? value, BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return localization.pleaseEnterYourEmail;
    } else if (!_isEmail(value)) {
      return localization.pleaseEnterValidEmail;
    }
    return null;
  }

  String? validatePassword(
      String? value, BuildContext context, bool isLoginMode) {
    final localization = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return localization.pleaseEnterYourPassword;
    } else if (!isLoginMode && value.length < 6) {
      return localization.passwordMustBeAtLeast6Characters;
    }
    return null;
  }

  String? validatePhoneNumber(String? value, BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return localization.pleaseEnterYourPhoneNumber;
    } else if (!_isPhoneNumber(value)) {
      return localization.pleaseEnterValidPhoneNumber;
    }
    return null;
  }

  String? validateSmsCode(String? value, BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return localization.pleaseEnterSmsCode;
    } else if (value.length != 6) {
      return localization.invalidVerificationCode;
    }
    return null;
  }

  // Helper methods
  bool _isEmail(String value) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value);
  }

  bool _isPhoneNumber(String value) {
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(value);
  }
}
