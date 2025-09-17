import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Base class for use cases
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Empty params for cases where no parameters are needed
class NoParams {}