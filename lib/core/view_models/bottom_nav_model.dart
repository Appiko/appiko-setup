import 'package:flutter/material.dart';

class BottomNavModel extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void handleTap(int value) {
    if (value != _index) {
      _index = value;
      print("Setting index to $_index");
      notifyListeners();
    }
  }
}
