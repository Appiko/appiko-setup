import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs with ChangeNotifier {
  SharedPreferences _prefs;

  bool get darkTheme {
    bool x;
    try {
      x = _prefs.getBool("darkTheme") ?? false;
    } catch (e) {}
    return x ?? false;
  }

  bool get advancedOptions => _prefs.getBool("advancedOptions") ?? false;

  SharedPrefs() {
    prefsInit();
  }

  prefsInit() async {
    _prefs = await SharedPreferences.getInstance();
    notifyListeners();
  }

  Future setDarkTheme(bool value) async {
    await _prefs.setBool("darkTheme", value);
    notifyListeners();
  }

  Future setAdvancedOptions(bool value) async {
    await _prefs.setBool("advancedOptions", value);
    notifyListeners();
  }
}
