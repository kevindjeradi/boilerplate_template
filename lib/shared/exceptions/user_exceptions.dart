// Exceptions utilisateur
class UserException implements Exception {
  final String message;

  const UserException(this.message);

  factory UserException.notFound() => const UserException('User not found');
  factory UserException.fetchFailed() =>
      const UserException('Failed to fetch user');
  factory UserException.updateFailed() =>
      const UserException('Failed to update user');
  factory UserException.deleteFailed() =>
      const UserException('Failed to delete user');

  @override
  String toString() => 'UserException: $message';
}
