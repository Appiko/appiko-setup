import 'package:flutter/widgets.dart';
import 'package:setup/ui/widgets/half_press_field.dart';

/// {@category Model}
/// interacts with [HalfPressField]
class HalfPressFieldsModel with ChangeNotifier {
  bool isHalfPressEnabled = false;

  setHalfPress(val) {
    isHalfPressEnabled = val;
    notifyListeners();
  }
}
