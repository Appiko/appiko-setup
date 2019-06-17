import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothScanService extends ChangeNotifier {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  var _scanSubscription;
  bool _isScanning = false;

  Map<DeviceIdentifier, ScanResult> _scanResults = {};

  bool get isScanning => _isScanning;
  Map<DeviceIdentifier, ScanResult> get scanResults => _scanResults;

  Duration _scanTimeoutDuration = Duration(seconds: 15);

  startScan() {
    _isScanning = true;
    _scanResults.clear();
    _scanSubscription =
        flutterBlue.scan(timeout: _scanTimeoutDuration).listen((ScanResult s) {
      if (s.advertisementData.localName != "") scanResults[s.device.id] = s;
      notifyListeners();
    }, onDone: () {
      stopScan();
    });
    notifyListeners();
  }

  stopScan() {
    _scanSubscription?.cancel();
    _scanSubscription = null;
    _isScanning = false;
    notifyListeners();
  }
}
