/// Exception thrown when there is a server error
class ServerException implements Exception {
  final String message;
  ServerException(this.message);

  @override
  String toString() => "ServerException: $message";
}

/// Exception thrown when cache fails
class CacheException implements Exception {
  final String message;
  CacheException(this.message);

  @override
  String toString() => "CacheException: $message";
}
