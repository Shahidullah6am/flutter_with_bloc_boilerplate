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

/// Exception thrown for 400 status code
class BadRequestException implements Exception {
  final String message;
  BadRequestException(this.message);

  @override
  String toString() => "BadRequestException: $message";
}

/// Exception thrown for 401 status code
class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);

  @override
  String toString() => "UnauthorizedException: $message";
}

/// Exception thrown for 403 status code
class ForbiddenException implements Exception {
  final String message;
  ForbiddenException(this.message);

  @override
  String toString() => "ForbiddenException: $message";
}

/// Exception thrown for 404 status code
class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);

  @override
  String toString() => "NotFoundException: $message";
}
