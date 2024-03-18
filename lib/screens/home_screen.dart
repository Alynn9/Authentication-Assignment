import 'package:auth_app/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:auth_app/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final reportCount = await AuthService.getGeneralReport();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Report count: $reportCount'),
                  ),
                );
              },
              child: const Text('Get Report'),
            ),
            ElevatedButton(
              onPressed: () {
                AuthService.logout();
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.login, (route) => false);
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
