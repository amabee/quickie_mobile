import 'package:hive_flutter/hive_flutter.dart';

class SessionChecker {
  late Box box;

  SessionChecker() {
    box = Hive.box('myBox');
  }

  Future<void> setSession(int id, String username, bool hasSession,
      String email, String firstname, String lastname, String image) async {
    await box.put("hasSession", hasSession);
    await box.put("userId", id);
    await box.put("username", username);
    await box.put("email", email);
    await box.put("fullname", firstname);
    await box.put("lastname", lastname);
    await box.put("image", image);
  }

  Future<bool> checkSession() async {
    return box.get("hasSession", defaultValue: false);
  }
}
