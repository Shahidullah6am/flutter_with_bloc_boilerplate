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
