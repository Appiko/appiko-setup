import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/widgets.dart';

class BluetoothScanService extends ChangeNotifier {
  FlutterBlue _flutterBlue = FlutterBlue.instance;
  Duration _scanTimeoutDuration = Duration(seconds: 15);

  var _scanSubscription;
  var _bluetoothStateSubscription;

  Map<DeviceIdentifier, ScanResult> scanResults = {};
  bool isScanning = false;
  bool isBluetoothOn = true;

  BluetoothScanService() {
    bluetoothStateListner();
  }

  startScan() {
    isScanning = true;
    scanResults.clear();
    notifyListeners();
    _scanSubscription = _flutterBlue.scan(timeout: _scanTimeoutDuration)
      ..listen(
        (ScanResult s) {
          if (s.advertisementData.localName != "") {
            scanResults[s.device.id] = s;
            notifyListeners();
          }
        },
        onDone: () {
          stopScan();
        },
      );
  }

  stopScan() {
    /// TODO: cancel [_bluetoothStateSubscroption]
    _scanSubscription?.cancel();
    _scanSubscription = null;
    isScanning = false;
    notifyListeners();
  }

  void bluetoothStateListner() {
    _bluetoothStateSubscription = _flutterBlue.onStateChanged()
      ..listen(
        (bluetoothState) {
          isBluetoothOn = bluetoothState == BluetoothState.on;
          print(bluetoothState);
          notifyListeners();
        },
      );
  }
}
