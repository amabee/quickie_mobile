import 'package:flutter/material.dart';
import 'package:quickie_mobile/providers/bottom_navbar_provider.dart';
import 'package:quickie_mobile/providers/post_provider.dart';
import 'package:quickie_mobile/providers/activity_filter_provider.dart';
import 'package:provider/provider.dart';
import 'package:quickie_mobile/screens/splash.dart';
import 'package:quickie_mobile/screens/splash.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavbarProvider()),
        ChangeNotifierProvider(create: (_) => ActivityFilterProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.black,
          primaryColorLight: Colors.grey.shade200,
        ),
        darkTheme: ThemeData(
          scaffoldBackgroundColor: const Color(0xff101010),
          primaryColor: Colors.white,
          primaryColorLight: Colors.grey.shade800,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
