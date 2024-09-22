import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quickie_mobile/screens/Dashboard_Screen.dart';
import 'package:quickie_mobile/screens/login.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  Future<bool> checkUserLoggedIn() async {
    await Hive.initFlutter();
    var box = await Hive.openBox('userBox');
    return box.get('isLoggedIn', defaultValue: false);
  }

  Future<void> delay() async {
    await Future.delayed(Duration(seconds: 3));
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
                  Image.asset('assets/logo.png', width: 150, height: 150),
                  const SizedBox(height: 20),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Colors.blueAccent, Colors.purpleAccent],
                      tileMode: TileMode.repeated,
                    ).createShader(bounds),
                    child: const SpinKitWaveSpinner(
                      color:
                          Colors.white, // Use a neutral color for the spinner
                      trackColor: Colors.transparent, // No track color
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          // Add a delay before navigating
          Future.delayed(Duration(seconds: 3), () {
            if (snapshot.data == true) {
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
          });

          // Show a placeholder until the delay is over
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.png', width: 150, height: 150),
                  const SizedBox(height: 20),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.blueAccent, Colors.purpleAccent],
                      tileMode: TileMode.repeated,
                    ).createShader(bounds),
                    child: const SpinKitWaveSpinner(
                      color:
                          Colors.white, // Use a neutral color for the spinner
                      trackColor: Colors.transparent,
                      waveColor: Color.fromARGB(255, 170, 241, 234),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
