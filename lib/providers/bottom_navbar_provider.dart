import 'package:flutter/cupertino.dart';

class NavbarProvider with ChangeNotifier {
  int _index = 0;
  get index => _index;
  void changeIndex(int index) {
    _index = index;
    notifyListeners();
  }
}
