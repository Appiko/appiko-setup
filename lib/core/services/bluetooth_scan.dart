import 'dart:io';

import 'package:android_intent/android_intent.dart';
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

  bool isBluetoothAvailable = false;

  BluetoothScanService() {
    bluetoothStateListner();
  }

  startScan() async {
    if (!isBluetoothOn) {
      await turnOnBluetooth();
    }
    if (isBluetoothOn) {
      stopScan(); //Stop previously running scan
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
  }

  stopScan() {
    /// TODO: cancel [_bluetoothStateSubscroption]
    _flutterBlue.stopScan();
    isScanning = false;
    notifyListeners();
  }

  void bluetoothStateListner() {
    _bluetoothStateSubscription = _flutterBlue.state
      ..listen(
        (bluetoothState) {
          isBluetoothOn = bluetoothState == BluetoothState.on;
          print(bluetoothState);
          notifyListeners();
        },
      );
  }

  Future turnOnBluetooth() async {
    scanResults.clear();
    stopScan();
    if (Platform.isAndroid) {
      // This will trigger a dialog ("Application wants to turn on Bluetooth, do you want to allow it?")
      const intent = AndroidIntent(
        action: 'android.bluetooth.adapter.action.REQUEST_ENABLE',
      );
      await intent.launch();

      // We wait 5 seconds - fixed.
      // This is a tricky bit, because if the user waits on the aforementioned dialog for more than 5 seconds, we still have a disabled bluetooth adapter below.
      // Also can not wait forever, so prepare your UI to switch back to a "un-connected" status.
      await Future.delayed(Duration(seconds: 5));
    }
  }
}
