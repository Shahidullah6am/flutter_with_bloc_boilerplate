# Project Documentation

This document provides an overview of the project structure, and explains how the different parts of the application work together.

## Project Structure

The project is organized into the following main directories:

- `lib`: Contains the core source code of the application.
  - `main.dart`: The entry point of the application.
  - `bootstrap.dart`: Initializes the application's services and runs the app.
  - `injection_container.dart`: Handles dependency injection.
  - `config`: Contains configuration files for routing, themes, etc.
  - `core`: Contains the core functionalities of the application.
  - `features`: Contains the different features of the application, organized by domain.
- `test`: Contains the tests for the application.
- `android`, `ios`, `web`: Platform-specific code.

## `lib` directory

### `main.dart`

The `main.dart` file is the entry point of the application. It calls the `bootstrap()` function to initialize and run the app.

```dart
import 'bootstrap.dart';

Future<void> main() async {
  await bootstrap();
}
```

### `bootstrap.dart`

The `bootstrap.dart` file is responsible for initializing the application's services and running the app. It performs the following steps:

1.  **Ensures Flutter binding is initialized:** `WidgetsFlutterBinding.ensureInitialized()`
2.  **Initializes dependency injection:** `await di.init()`
3.  **Runs the app:** `runApp(const MyApp())`

The `MyApp` widget is the root widget of the application. It sets up the `MaterialApp.router` with the application's title, themes, and router configuration.

```dart
import 'package:flutter/material.dart';
import 'injection_container.dart' as di;
import 'config/app_router.dart';
import 'config/app_theme.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize dependency injection
  await di.init();

  // 2. Initialize other services if needed
  // await Firebase.initializeApp();
  // await LocalDatabase.init();
  // await AnalyticsService.init();

  // 3. Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter BLoC Boilerplate',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
```

### `injection_container.dart`

The `injection_container.dart` file uses the `get_it` package for dependency injection. It has a single `init()` function that calls feature-specific injection initializers. This modular approach keeps the dependency setup clean and organized.

```dart
import 'package:flutter_bloc_boilerplate/features/auth/auth_injection.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Global/core injections (network, shared prefs, etc.)

  // Feature injections
  await initAuthInjection();
}
```

As an example, the `auth_injection.dart` file sets up all the dependencies for the authentication feature, including the BLoC, use cases, repository, and data sources.

```dart
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
```

### `config` directory

The `config` directory contains the application's configuration files.

#### `app_router.dart`

The `app_router.dart` file defines the application's routes using the `go_router` package. It specifies the initial location and the routes for each page in the application.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc_boilerplate/features/auth/presentation/pages/login_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      // Example future routes
      // GoRoute(
      //   path: '/home',
      //   name: 'home',
      //   builder: (context, state) => const HomePage(),
      // ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('404: ${state.error}'),
      ),
    ),
  );
}
```

#### `app_theme.dart`

The `app_theme.dart` file defines the application's light and dark themes. It includes styles for colors, text, app bars, and input fields.

```dart
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blueGrey,
    scaffoldBackgroundColor: Colors.black,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );
}
```

### `core` directory

The `core` directory contains the application's core functionality, which is shared across different features.

#### `error` directory

The `error` directory defines the application's exception and failure classes.

- `exceptions.dart`: Contains custom exception classes, such as `ServerException` and `CacheException`, which are thrown by the data layer.
- `failures.dart`: Contains custom failure classes, such as `ServerFailure`, `CacheFailure`, and `NetworkFailure`. These are domain-level errors that are passed to the presentation layer.

#### `network` directory

The `network` directory provides networking capabilities.

- `api_client.dart`: An `ApiClient` class that handles HTTP requests using the `http` package.
- `network_info.dart`: A `NetworkInfo` class that checks for network connectivity using the `connectivity_plus` package.

#### `usecases` directory

The `usecases` directory contains the base `UseCase` class.

- `usecase.dart`: Defines a generic `UseCase` class with a `call` method that returns an `Either` of `Failure` or a generic type `T`. This provides a consistent way to handle success and failure scenarios in the domain layer.

#### `utils` directory

The `utils` directory contains utility classes.

- `logger.dart`: A simple logging utility that uses `dart:developer` to log messages and errors.

### `features` directory

The `features` directory contains the different features of the application, organized by domain. The project follows a clean architecture, with each feature divided into three layers: `data`, `domain`, and `presentation`.

#### `auth` feature

The `auth` feature handles user authentication.

##### `data` layer

The `data` layer is responsible for data retrieval and storage.

- `datasources/auth_remote_data_source.dart`: Defines the `AuthRemoteDataSource` abstract class and its implementation, which communicates with the remote API.
- `models/user_model.dart`: The `UserModel` is a data transfer object that extends the `User` entity from the domain layer.
- `repositories/auth_repository_impl.dart`: The `AuthRepositoryImpl` class implements the `AuthRepository` from the domain layer and uses the `AuthRemoteDataSource` to fetch data.

##### `domain` layer

The `domain` layer contains the business logic of the application.

- `entities/user.dart`: The `User` entity represents a user in the application.
- `repositories/auth_repository.dart`: The `AuthRepository` abstract class defines the contract for the authentication repository.
- `usecases/login.dart`: The `Login` use case handles the user login logic.
- `usecases/logout.dart`: The `Logout` use case handles the user logout logic.

##### `presentation` layer

The `presentation` layer is responsible for the UI and state management.

- `bloc`: Contains the `AuthBloc`, `AuthEvent`, and `AuthState` classes, which manage the state of the authentication feature using the `flutter_bloc` package.
- `pages/login_page.dart`: The `LoginPage` is the UI for the login screen. It uses a `BlocConsumer` to interact with the `AuthBloc` and update the UI based on the state.
- `widgets`: Contains any widgets that are specific to the authentication feature.
