import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothConnectionService extends ChangeNotifier {
  BluetoothDevice device;
  BluetoothDeviceState deviceState;

  connect(BluetoothDevice device) async {
    deviceState = null;
    this.device = device;
    await this.device.connect(autoConnect: false);
    this.device.state.listen((BluetoothDeviceState bluetoothDeviceState) {
      print("$bluetoothDeviceState");
      deviceState = bluetoothDeviceState;
      notifyListeners();
    });
  }

  disconnect() {
    device.disconnect();
    device = null;
    deviceState = null;
    notifyListeners();
  }
}
