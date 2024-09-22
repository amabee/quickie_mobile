import 'package:flutter/material.dart';
import 'package:quickie_mobile/data/user_data.dart';

class AuthProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<void> login(String email, String password) async {
    // Implement your login logic here (e.g., API call)
    // Mock user data for demonstration
    _user = User(
      'John',
      'Doe',
      'john_doe',
      'This is my bio.',
      'path/to/profile_image.jpg',
      user_id: '123',
      email: email,
    );
    notifyListeners();
  }

  Future<void> signup(String firstName, String lastName, String username, String email, String password) async {
    _user = User(
      firstName,
      lastName,
      username,
      'This is my bio.',
      'path/to/profile_image.jpg',
      user_id: '123',
      email: email,
    );
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
