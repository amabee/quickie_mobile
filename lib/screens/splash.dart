import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quickie_mobile/actions/session_checker.dart';
import 'package:quickie_mobile/screens/Dashboard_Screen.dart';
import 'package:quickie_mobile/screens/login.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  Future<void> _navigateBasedOnSession(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    SessionChecker sc = SessionChecker();

    bool isLoggedIn = await sc.checkSession();
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashBoardScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _navigateBasedOnSession(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.png', width: 150, height: 150),
                  const SizedBox(height: 20),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Colors.blueAccent, Colors.purpleAccent],
                      tileMode: TileMode.repeated,
                    ).createShader(bounds),
                    child: const SpinKitWaveSpinner(
                      color: Colors.white, // Neutral spinner color
                      trackColor: Colors.transparent, // No track color
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container(); // Placeholder until the Future completes.
        }
      },
    );
  }
}
