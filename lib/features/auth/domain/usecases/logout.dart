import '../repositories/auth_repository.dart';

class Logout {
  final AuthRepository repository;
  Logout(this.repository);

  Future<void> call(NoParams params) async {
    return await repository.logout();
  }
}

class NoParams {}
