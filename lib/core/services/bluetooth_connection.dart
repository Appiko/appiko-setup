import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:setup/core/services/device.dart';
import 'package:setup/core/services/helper_functions.dart';

/// {@category Service}
class BluetoothConnectionService with ChangeNotifier {
  BluetoothDevice device;
  BluetoothDeviceState deviceState;
  Device connectedDeviceType;

  connect({
    @required BluetoothDevice device,
    @required String uuid,
  }) async {
    deviceState = null;
    this.device = device;
    await this.device.connect(autoConnect: false);
    connectedDeviceType = _getDeviceType(uuid);
    activeDevice = connectedDeviceType;
    print("Connected to $connectedDeviceType");
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
    connectedDeviceType = null;
    activeDevice = null;
    notifyListeners();
  }

  Device _getDeviceType(String uuid) {
    print(uuid.split("-")[0]);
    switch (uuid.split("-")[0]) {
      case "3c73dc10":
        return Device.SENSE_PI;
        break;
      case "3c73dc20":
        return Device.SENSE_BE_TX;
        break;
      case "3c73dc30":
        return Device.SENSE_BE_RX;
        break;
      //TODO: Make this according to the table.
      case "3c73dc60":
        return Device.SENSE_PI;
        break;
    }
    return null;
  }
}
