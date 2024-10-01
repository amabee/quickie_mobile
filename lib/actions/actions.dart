import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:quickie_mobile/actions/session_checker.dart';
import 'package:quickie_mobile/utils/url.dart';

void likePost(int post_id) async {
  URL url = URL();

  var userBox = await Hive.openBox('myBox');
  int userId = userBox.get('userId');

  final Map<String, dynamic> jsonData = {"user_id": userId, "post_id": post_id};

  final Map<String, dynamic> queryParams = {
    "operation": "likePost",
    "json": jsonEncode(jsonData)
  };

  try {
    http.Response res = await http.post(
      Uri.parse(url.postsApiURL),
      body: queryParams,
    );

    if (res.statusCode != 200) {
      print("Status Error: ${res.statusCode}");
      return;
    }

    var response = jsonDecode(res.body);

    if (response.containsKey('error')) {
      print("Error: ${response['error']}");
    } else {
      print("Post liked successfully");
    }
  } catch (e) {
    print(e);
  }
}
