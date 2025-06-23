// Exceptions d'authentification
class AuthException implements Exception {
  final String code;
  final String message;

  const AuthException(this.code, this.message);

  factory AuthException.invalidEmail() =>
      const AuthException('invalid-email', 'Invalid email address');
  factory AuthException.userDisabled() =>
      const AuthException('user-disabled', 'User account has been disabled');
  factory AuthException.userNotFound() =>
      const AuthException('user-not-found', 'No user found for that email');
  factory AuthException.wrongPassword() =>
      const AuthException('wrong-password', 'Wrong password provided');
  factory AuthException.emailAlreadyInUse() => const AuthException(
      'email-already-in-use', 'Account already exists for that email');
  factory AuthException.operationNotAllowed() =>
      const AuthException('operation-not-allowed', 'Operation not allowed');
  factory AuthException.weakPassword() =>
      const AuthException('weak-password', 'The password provided is too weak');
  factory AuthException.invalidVerificationCode() => const AuthException(
      'invalid-verification-code', 'Invalid verification code');
  factory AuthException.invalidVerificationId() =>
      const AuthException('invalid-verification-id', 'Invalid verification ID');
  factory AuthException.invalidPhoneNumber() =>
      const AuthException('invalid-phone-number', 'Invalid phone number');
  factory AuthException.tooManyRequests() => const AuthException(
      'too-many-requests', 'Too many requests. Try again later');
  factory AuthException.userCancelled() =>
      const AuthException('user-cancelled', 'User cancelled the operation');
  factory AuthException.networkError() =>
      const AuthException('network-error', 'Network error occurred');

  @override
  String toString() => 'AuthException: $message';
}
