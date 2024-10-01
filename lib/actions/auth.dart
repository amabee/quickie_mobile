import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickie_mobile/actions/session_checker.dart';
import 'package:quickie_mobile/screens/home_screen.dart';
import 'package:quickie_mobile/screens/login.dart';
import 'package:quickie_mobile/utils/url.dart';

SessionChecker sc = SessionChecker();
URL url = URL();

void login(String username, String password, BuildContext context) async {
  final Map<String, dynamic> jsonData = {
    "username": username,
    "password": password
  };

  final Map<String, dynamic> queryParams = {
    "operation": "login",
    "json": jsonEncode(jsonData),
  };

  try {
    http.Response res = await http
        .get(Uri.parse(url.authApiURL).replace(queryParameters: queryParams));

    if (res.statusCode != 200) {
      print("Status Error: ${res.statusCode}");
      return;
    }

    var user = jsonDecode(res.body);

    if (user.containsKey('error')) {
      print("Error: ${user['error']}");
      return;
    } else {
      var userData = user['success'];
      print("OK?");
      await sc.setSession(
          userData['user_id'],
          username,
          true,
          userData['email'],
          userData['first_name'],
          userData['last_name'],
          userData['first_name']);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  } catch (e) {
    print("Exception occurred: $e");
  }
}

void signup(String firstname, String lastname, String username, String email,
    String password, BuildContext context) async {
  URL url = URL();

  final Map<String, dynamic> jsonData = {
    "username": username,
    "password": password,
    "firstname": firstname,
    "lastname": lastname,
    "email": email,
  };

  final Map<String, dynamic> queryParams = {
    "operation": "signup",
    "json": jsonEncode(jsonData)
  };

  try {
    http.Response res = await http.post(
      Uri.parse(url.authApiURL),
      body: queryParams,
    );

    if (res.statusCode != 200) {
      print("Status Error: ${res.statusCode}");
      return;
    }

    var user = jsonDecode(res.body);

    if (user.containsKey('error')) {
      print("Error: ${user['error']}");
      return;
    } else {
      print("OK?");
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  } catch (e) {
    print(e);
  }
}
