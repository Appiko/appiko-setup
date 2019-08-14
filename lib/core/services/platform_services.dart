import 'package:flutter/services.dart';

/// {@category Service}
/// Platform Specific functions.
class PlatformServies {
  static const platform = MethodChannel('setup.appiko.org/services');

  Future<void> requestLocationService() async {
    try {
      await platform.invokeMethod('requestLocationService');
    } on PlatformException catch (e) {
      print(e.message);
    }
  }
}
