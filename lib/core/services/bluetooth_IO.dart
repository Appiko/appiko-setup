import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:setup/core/models/generic/device_info.dart';
import 'package:setup/core/services/bluetooth_connection.dart';
import 'package:setup/core/services/helper_functions.dart';
import 'package:setup/locators.dart';

/// {@category service}
class BluetoothIOService extends ChangeNotifier {
  // void write async(ByteData a) {
  //   await
  // }

  write(Uint8List data) async {
    BluetoothDevice device = locator<BluetoothConnectionService>().device;
    if (device != null) {
      List<BluetoothService> services = await device.discoverServices();
      print(services.length);
      // for (var service in services) {
      //   for (var chr in service.characteristics) {
      //     print("${service.uuid}  ${await chr.read()}");
      //   }
      // }
      await services[2].characteristics[1].write(
            data,
            withoutResponse: false,
          );
    }
  }

  readSetting() async {
    BluetoothDevice device = locator<BluetoothConnectionService>().device;
    if (device != null) {
      List<BluetoothService> services = await device.discoverServices();

      createStructureFromData(
          data: await services[2].characteristics[1].read());
    }
    return null;
  }

  Future<DeviceInfo> readDeviceInfo() async {
    BluetoothDevice device = locator<BluetoothConnectionService>().device;
    if (device != null) {
      List<BluetoothService> services = await device.discoverServices();

      return DeviceInfo.unpack(
        await services[2].characteristics[0].read(),
        mac: device.id.id,
      );
    }
    return null;
  }
}
