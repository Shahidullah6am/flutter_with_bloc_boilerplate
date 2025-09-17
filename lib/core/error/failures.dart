/// Base class for all failures
abstract class Failure {
  final String message;
  Failure({required this.message});
}

/// Represents server failure
class ServerFailure extends Failure {
  ServerFailure({required super.message});
}

/// Represents cache failure
class CacheFailure extends Failure {
  CacheFailure({required super.message});
}

/// Represents network failure
class NetworkFailure extends Failure {
  NetworkFailure({required super.message});
}
