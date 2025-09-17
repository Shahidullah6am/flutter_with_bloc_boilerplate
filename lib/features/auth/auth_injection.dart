import 'package:flutter_bloc_boilerplate/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_bloc_boilerplate/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_bloc_boilerplate/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_bloc_boilerplate/features/auth/domain/usecases/login.dart';
import 'package:flutter_bloc_boilerplate/features/auth/domain/usecases/logout.dart';
import 'package:flutter_bloc_boilerplate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initAuthInjection() async {
  // Bloc
  sl.registerFactory(() => AuthBloc(login: sl(), logout: sl()));

  // Use cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Logout(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl()));

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl());
}
