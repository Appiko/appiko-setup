import 'package:flutter/widgets.dart';

class HalfPressFieldsModel with ChangeNotifier {
  bool isHalfPressEnabled = false;

  setHalfPress(val) {
    isHalfPressEnabled = val;
    notifyListeners();
  }
}
