import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:setup/core/models/devices/sense_be_rx/1.0/sense_be_rx.dart';
import 'package:setup/core/services/bluetooth_connection.dart';
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
      print(await services[2].characteristics[1].read());

      print(device.id.id);
      print(services[0].characteristics[1].uuid.toString());
//      RxBle
//      await RxBle.writeChar(
//        device.id.id,
//        services[0].characteristics[1].uuid.toString(),
//        utf8.encode("100"),
//      );
    }
  }

  Future<Map> readSetting() async {
    BluetoothDevice device = locator<BluetoothConnectionService>().device;
    if (device != null) {
      List<BluetoothService> services = await device.discoverServices();

      return unpack(await services[2].characteristics[1].read());
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
