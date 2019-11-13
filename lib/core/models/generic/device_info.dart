import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:setup/core/models/generic/battery.dart';

///
/// {@category Model}
/// {@category DeviceInfo}
///
class DeviceInfo with ChangeNotifier {
  String name;
  String id;
  BatteryType batteryType;
  String firmwareVersion;
  String batteryVoltage;
  String macAddress;

  DeviceInfo.unpack(
    List<int> intData, {
    @required String mac,
  }) {
    ByteBuffer buffer = Uint8List.fromList(intData).buffer;
    ByteData data = ByteData.view(buffer, 0, intData.length);
    int offset = -1;

    id = '';
    for (int i = 0; i < 16; i++) {
      id += AsciiCodec().decode([data.getUint8(offset += 1)]);
    }

    batteryVoltage =
        ((data.getUint8(offset += 1) * 3.6) / 255).toStringAsPrecision(2) + 'V';

    macAddress = mac;

    firmwareVersion =
        ("${data.getUint8(offset += 1)}.${data.getUint8(offset += 1)}.${data.getUint8(offset += 1)}");
  }

  Map<dynamic, dynamic> toMap() {
    return {
      "Device Name": this.name,
      "Device ID": this.id,
      "Battery Voltage": this.batteryVoltage,
      "Battery Type": BatteryHelper.getString(this.batteryType),
      "Firmware Version": this.firmwareVersion,
      "MAC Address": macAddress,
    };
  }
}
