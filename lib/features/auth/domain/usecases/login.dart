import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';
import '../entities/user.dart';
import '../../../../core/error/failures.dart';

class Login {
  final AuthRepository repository;
  Login(this.repository);

  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;
  LoginParams(this.email, this.password);
}
