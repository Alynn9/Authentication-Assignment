import 'package:auth_app/constants/routes.dart';
import 'package:auth_app/screens/home_screen.dart';
import 'package:auth_app/screens/login_screen.dart';
import 'package:auth_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

late Box hiveBox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  hiveBox = await Hive.openBox('auth_app');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: Routes.splash,
      routes: {
        Routes.splash: (context) => const SplashScreen(),
        Routes.home: (context) => const HomeScreen(),
        Routes.login: (context) => const LoginScreen(),
      },
    );
  }
}
