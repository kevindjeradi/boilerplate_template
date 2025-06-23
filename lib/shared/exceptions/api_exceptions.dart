// Exceptions API et réseau
class ApiException implements Exception {
  final int? statusCode;
  final String message;

  const ApiException(this.message, [this.statusCode]);

  factory ApiException.badRequest() => const ApiException('Bad request', 400);
  factory ApiException.unauthorized() =>
      const ApiException('Unauthorized', 401);
  factory ApiException.forbidden() => const ApiException('Forbidden', 403);
  factory ApiException.notFound() => const ApiException('Not found', 404);
  factory ApiException.internalServerError() =>
      const ApiException('Internal server error', 500);
  factory ApiException.networkError() => const ApiException('Network error');
  factory ApiException.timeout() => const ApiException('Request timeout');

  @override
  String toString() => 'ApiException: $message';
}
