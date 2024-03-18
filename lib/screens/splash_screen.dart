import 'package:auth_app/constants/keys.dart';
import 'package:auth_app/constants/routes.dart';
import 'package:auth_app/main.dart';
import 'package:auth_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// create a state class that shows a splash screen for 3 seconds
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      DateTime? exp = hiveBox.get(Keys.exp);

      if (exp == null) {
        hiveBox.delete(Keys.authToken);
        hiveBox.delete(Keys.refreshToken);
        hiveBox.delete(Keys.exp);
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.login, (route) => false);
      } else if (exp.isBefore(DateTime.now())) {
        AuthService.refreshToken().then((value) {
          Navigator.pushNamedAndRemoveUntil(
              context, value ? Routes.home : Routes.login, (route) => false);
        }).catchError((error) {
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.login, (route) => false);
        });
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.home, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 100),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
