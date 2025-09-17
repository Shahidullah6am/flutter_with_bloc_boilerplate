import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final Logout logout;

  AuthBloc({required this.login, required this.logout}) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await login(LoginParams(event.email, event.password));
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) => emit(Authenticated(user)),
      );
    });

    on<LogoutRequested>((event, emit) async {
      await logout(NoParams());
      emit(AuthInitial());
    });
  }
}
