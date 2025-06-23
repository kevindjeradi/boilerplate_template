// Exceptions de permissions
class PermissionException implements Exception {
  final String message;

  const PermissionException(this.message);

  factory PermissionException.denied() =>
      const PermissionException('Permission denied');
  factory PermissionException.permanentlyDenied() =>
      const PermissionException('Permission permanently denied');
  factory PermissionException.restricted() =>
      const PermissionException('Permission restricted');

  @override
  String toString() => 'PermissionException: $message';
}
