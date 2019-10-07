import 'package:flutter/foundation.dart';
import 'package:setup/core/models/generic/camera.dart';
import 'package:setup/core/models/generic/sensor_setting.dart';
import 'package:setup/core/models/generic/time.dart';

class Setting {
  SensorSetting sensorSetting;
  CameraSetting cameraSetting;
  Time time;
  int index;
  Setting({
    this.sensorSetting,
    this.cameraSetting,
    this.time,
    @required this.index,
  }) {
    sensorSetting = SensorSetting();
    cameraSetting = CameraSetting();
    time = Time();
  }

  @override
  String toString() {
    return 'Setting{sensorSetting: $sensorSetting, cameraSetting: $cameraSetting, time: $time}';
  }
}
