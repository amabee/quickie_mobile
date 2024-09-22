import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quickie_mobile/screens/Dashboard_Screen.dart';
import 'package:quickie_mobile/screens/login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  Future<bool> checkUserLoggedIn() async {
    await Hive.initFlutter();
    var box = await Hive.openBox('userBox');
    return box.get('isLoggedIn', defaultValue: false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.png', width: 100, height: 100), // Replace with your logo
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
        } else {
          if (snapshot.data == true) {
            return DashBoardScreen();
          } else {
            return LoginScreen();
          }
        }
      },
    );
  }
}