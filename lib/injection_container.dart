import 'package:flutter_bloc_boilerplate/features/auth/auth_injection.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Global/core injections (network, shared prefs, etc.)

  // Feature injections
  await initAuthInjection();
}
