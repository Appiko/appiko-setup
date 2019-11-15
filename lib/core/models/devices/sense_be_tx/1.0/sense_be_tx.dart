import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:setup/core/models/generic/battery.dart';
import 'package:setup/core/models/generic/camera.dart';
import 'package:setup/core/models/generic/device_speed.dart';
import 'package:setup/core/models/generic/meta.dart';
import 'package:setup/core/models/generic/operation_time.dart';
import 'package:setup/core/models/generic/radio_setting.dart';
import 'package:setup/core/models/generic/sensor_setting.dart';
import 'package:setup/core/models/generic/setting.dart';
import 'package:setup/core/models/generic/time.dart';
import 'package:setup/core/models/generic/tirgger.dart';
import 'package:setup/core/services/helper_functions.dart';

/// {@category Model}
/// {@subCategory Sensor}
/// {@category SenseBeTx}
class MotionSetting extends SensorSetting {
  int downtime = 0;
  int sensitivity;
  int numberOfTriggers;

  MotionSetting({
    this.downtime = 0,
    this.sensitivity = 1,
    this.numberOfTriggers = 0,
  });

  static MotionSetting clone(MotionSetting sensorSetting) {
    return MotionSetting(
      downtime: sensorSetting.downtime,
      numberOfTriggers: sensorSetting.numberOfTriggers,
      sensitivity: sensorSetting.sensitivity,
    );
  }

  @override
  String toString() {
    return 'MotionSetting{downtime: $downtime, sensitivity: $sensitivity, numberOfTriggers: $numberOfTriggers}';
  }
}

/// {@category Model}
/// {@category SenseBeTx}
class BeTxSetting extends Setting {
  BeTxSetting({
    SensorSetting sensorSetting,
    CameraSetting cameraSetting,
    Time time,
    @required int index,
  }) : super(
          sensorSetting: sensorSetting,
          cameraSetting: cameraSetting,
          time: time,
          index: index,
        );

  static BeTxSetting clone({BeTxSetting setting, int index}) {
    BeTxSetting x = new BeTxSetting(index: index ?? setting.index);

    SensorSetting sensorSetting = setting.sensorSetting;
    switch (setting.sensorSetting.runtimeType) {
      case MotionSetting:
        x.sensorSetting = MotionSetting.clone(sensorSetting);
        break;
      case TimerSetting:
        x.sensorSetting = TimerSetting.clone(sensorSetting);
        break;
      case SensorSetting:
        x.sensorSetting = SensorSetting();
    }

    CameraSetting cameraSetting = setting.cameraSetting;
    switch (cameraSetting.runtimeType) {
      case MultiplePicturesSetting:
        x.cameraSetting = MultiplePicturesSetting.clone(cameraSetting);
        break;
      case LongPressSetting:
        x.cameraSetting = LongPressSetting.clone(cameraSetting);
        break;
      case VideoSetting:
        x.cameraSetting = VideoSetting.clone(cameraSetting);
        break;
      case CameraSetting:
        x.cameraSetting = CameraSetting.clone(cameraSetting);
        break;
    }

    Time time = setting.time;
    switch (setting.time.runtimeType) {
      case Ambient:
        x.time = Ambient.clone(time);
        break;
      case TimeOfDay:
        x.time = TimeOfDay.clone(time);
        break;
      case Time:
        x.time = Time();
    }

    return x;
  }
}

enum Range {
  LOW,
  MEDIUM,
  HIGH,
}

///
/// {@category Model}
/// {@category SenseBeTx}
///
class SenseBeTx with ChangeNotifier {
  List<OperationTime> operationTime = List(2); // for motion and timer

  ///[Ambient Light States]
  int motionAmbientState = 0;
  int timerAmbientState = 0;

  /// 8 + 1 for duplication
  List<BeTxSetting> settings = List.generate(9, (i) => BeTxSetting(index: i));
  RadioSetting radioSetting = RadioSetting(
    speed: RadioSpeed.NORMAL,
    radioChannel: RadioChannel.CHANNEL_0,
  );
  DeviceSpeed deviceSpeed = DeviceSpeed.FAST;
  BatteryType batteryType = BatteryType.STANDARD;
  String deviceName = 'Device Name';
  Range range = Range.MEDIUM;

  @override
  String toString() {
    return 'Structure{settings: $settings, radioSetting: $radioSetting, deviceSpeed: $deviceSpeed, batteryType: $batteryType, deviceName: $deviceName}';
  }
}

Uint8List pack(SenseBeTx structure) {
  ByteData packedData = ByteData(209);

  /// Adding Operation time in order of Motion - Timer
  int offset = -1;
  packedData.setUint8(offset += 1, structure.operationTime[0]?.index ?? 3);
  packedData.setUint8(offset += 1, structure.operationTime[1]?.index ?? 3);

  structure.settings.forEach((setting) {
    // skip the last setting
    if (setting.index != 8) {
      switch (setting.sensorSetting.runtimeType) {
        case MotionSetting:
          MotionSetting sensorSetting = setting.sensorSetting;

          // **Trigger Type 1  Byte**
          packedData.setUint8(offset += 1, Trigger.MOTION_ONLY.index);

          // **Sensor Setting 6 Bytes**
          packedData.setUint8(offset += 1, 0x1); // Is enable
          packedData.setUint8(offset += 1, sensorSetting.numberOfTriggers);
          packedData.setUint16(
              offset += 1, sensorSetting.sensitivity, Endian.little);
          packedData.setUint16(
              offset += 2, sensorSetting.downtime, Endian.little);

          break;

        case TimerSetting:
          TimerSetting sensorSetting = setting.sensorSetting;
          // Trigger Type 1 Byte
          packedData.setUint8(offset += 1, Trigger.TIMER_ONLY.index);

          // Sensor Settings 6 Bytes
          packedData.setUint32(
              offset += 1, sensorSetting.interval, Endian.little);
          packedData.setUint16(offset += 4, 0, Endian.little);

          break;

        default:
          packedData.setUint8(offset += 1, Trigger.NONE.index);
          offset += 5;
      }

      // **Camera Setting 7 Bytes**
      packedData.setUint8(
          offset += 2,
          setting.cameraSetting.mode.index << 3 |
              (setting.cameraSetting.enableRadio ? 1 : 0) << 2 |
              (setting.cameraSetting.videoWithFullPress ? 1 : 0) << 1 |
              (setting.cameraSetting.enablePreFocus ? 1 : 0));

      /// **Set [offsetBeforeCam] to add up 4 in the end as each switch case's last Uint value is not the same.
      int offsetBeforeCam = offset;
      switch (setting.cameraSetting.runtimeType) {
        case MultiplePicturesSetting:
          MultiplePicturesSetting cameraSetting = setting.cameraSetting;
          packedData.setUint16(
              offset += 1, cameraSetting.numberOfPictures, Endian.little);
          packedData.setUint16(
              offset += 2, cameraSetting.pictureInterval, Endian.little);
          break;
        case VideoSetting:
          VideoSetting cameraSetting = setting.cameraSetting;
          packedData.setUint16(
              offset += 1, cameraSetting.videoDuration, Endian.little);
          packedData.setUint8(offset += 2, cameraSetting.extensionTime);
          packedData.setUint8(offset += 1, cameraSetting.numberOfExtensions);
          break;
        case LongPressSetting:
          LongPressSetting cameraSetting = setting.cameraSetting;
          packedData.setUint32(
              offset += 1, cameraSetting.longPressDuration, Endian.little);
          break;
        default:
      }
      offset = offsetBeforeCam + 4;
      packedData.setUint8(
          offset += 1, setting.cameraSetting.triggerPulseDuration);
      packedData.setUint8(
          offset += 1, setting.cameraSetting.preFocusPulseDuration);

      // ** Time Settings 8 Bytes**
      switch (setting.time.runtimeType) {
        case TimeOfDay:
          packedData.setUint32(offset += 1,
              (setting.time as TimeOfDay).startTime, Endian.little);
          packedData.setUint32(
              offset += 4, (setting.time as TimeOfDay).endTime, Endian.little);
          break;
        case Ambient:
          packedData.setUint32(offset += 1,
              (setting.time as Ambient).lowerThreshold, Endian.little);
          packedData.setUint32(offset += 4,
              (setting.time as Ambient).higherThreshold, Endian.little);
          break;
        default:
          offset += 5;
      }
      offset += 3;
    }
  });

  // ** Radio Settings 8 Bytes
  packedData.setUint8(offset += 1, structure.radioSetting.radioChannel.index);
  packedData.setUint8(
      offset += 1, structure.radioSetting.radioOperationDuration);
  packedData.setUint8(
      offset += 1, structure.radioSetting.radioOperationFrequency);

  // ** Device Speed and range 2 Byte
  packedData.setUint8(offset += 1, structure.deviceSpeed.index);
  packedData.setUint8(offset += 1, structure.range.index);
  // skip 2 bytes of common data
  offset += 2;

  // ** Battery Type 1 Byte
  packedData.setUint8(offset += 1, structure.batteryType.index);
  // ** Device Name 16 Bytes
  AsciiCodec()
      .encode(structure.deviceName.padRight(16))
      .forEach((byte) => packedData.setUint8(offset += 1, byte));

  // ** Current Time in seconds 4Bytes
  packedData.setUint32(
      offset += 1, getTimeInSeconds(DateTime.now()), Endian.little);

  // ** Today's date in dd, mm, yy format 3 Bytes
  packedData.setUint8(offset += 4, DateTime.now().day);
  packedData.setUint8(offset += 1, DateTime.now().month);
  packedData.setUint8(offset += 1, DateTime.now().year % 2000);

  assert(offset == 208);
  return packedData.buffer.asUint8List();
}

Map unpack(List<int> intData, {bool forProfile = false}) {
  ByteBuffer buffer = Uint8List.fromList(intData).buffer;
  ByteData data = ByteData.view(buffer, 0, 202);
  SenseBeTx structure = SenseBeTx();
  MetaStructure metaStructure = MetaStructure();
  int offset = -1;

  try {
    OperationTime motionTime = OperationTime.values[data.getUint8(offset += 1)];
    OperationTime timerTime = OperationTime.values[data.getUint8(offset += 1)];

    structure.operationTime[0] = motionTime;
    structure.operationTime[1] = timerTime;

    for (int i = 0; i < 8; i++) {
      /// 1,23,45,67,...
      // print(offset);
      Trigger triggerType = Trigger.values[data.getUint8(offset += 1)];
      switch (triggerType) {
        case Trigger.MOTION_ONLY:
          // Sensor Setting
          structure.settings[i].sensorSetting = MotionSetting(
            // skiping isEnable which is 1 by default
            numberOfTriggers: data.getUint8(offset += 2),
            sensitivity: data.getUint16(offset += 1, Endian.little),
            downtime: data.getUint16(offset += 2, Endian.little),
          );
          offset += 1;
          break;
        case Trigger.TIMER_ONLY:
          structure.settings[i].sensorSetting = TimerSetting(
              interval: data.getUint32(offset += 1, Endian.little));
          offset += 5;
          break;
        default:
          offset += 6;
      }

      // Camera Settings
      int offsetBeforeCam = offset;
      int cameraFirstByte = data.getUint8(offset += 1);
      structure.settings[i].cameraSetting = CameraSetting()
        // First byte

        ..mode = CameraAction.values[((cameraFirstByte & 248) >> 3)]
        ..enableRadio = ((cameraFirstByte & 4) >> 2) > 0 ? true : false
        ..videoWithFullPress = ((cameraFirstByte & 2) >> 1) > 0 ? true : false
        ..enablePreFocus = (cameraFirstByte & 1) > 0 ? true : false;

      if (!structure.settings[i].cameraSetting.videoWithFullPress) {
        metaStructure.advancedOptionsEnabled[i] = true;
      }

      switch (structure.settings[i].cameraSetting.mode) {
        case CameraAction.MULTIPLE_PICTURES:
          structure.settings[i].cameraSetting = MultiplePicturesSetting()
            ..numberOfPictures = data.getUint16(offset += 1, Endian.little)
            ..pictureInterval = data.getUint16(offset += 2, Endian.little)
            ..enablePreFocus =
                structure.settings[i].cameraSetting.enablePreFocus
            ..videoWithFullPress =
                structure.settings[i].cameraSetting.videoWithFullPress
            ..enableRadio = structure.settings[i].cameraSetting.enableRadio;
          // ..preFocusPulseDuration =
          //     structure.settings[i].cameraSetting.preFocusPulseDuration
          // ..triggerPulseDuration =
          //     structure.settings[i].cameraSetting.triggerPulseDuration;
          break;
        case CameraAction.VIDEO:
          structure.settings[i].cameraSetting = VideoSetting()
            ..videoDuration = data.getUint16(offset += 1, Endian.little)
            ..extensionTime = data.getUint8(offset += 2)
            ..numberOfExtensions = data.getUint8(offset += 1)
            ..enablePreFocus =
                structure.settings[i].cameraSetting.enablePreFocus
            ..videoWithFullPress =
                structure.settings[i].cameraSetting.videoWithFullPress
            ..enableRadio = structure.settings[i].cameraSetting.enableRadio;

          // ..preFocusPulseDuration =
          //     structure.settings[i].cameraSetting.preFocusPulseDuration
          // ..triggerPulseDuration =
          //     structure.settings[i].cameraSetting.triggerPulseDuration;
          break;
        case CameraAction.LONG_PRESS:
          structure.settings[i].cameraSetting = LongPressSetting()
            ..longPressDuration = data.getUint32(offset += 1, Endian.little)
            ..enablePreFocus =
                structure.settings[i].cameraSetting.enablePreFocus
            ..videoWithFullPress =
                structure.settings[i].cameraSetting.videoWithFullPress
            ..enableRadio = structure.settings[i].cameraSetting.enableRadio;
          // ..preFocusPulseDuration =
          //     structure.settings[i].cameraSetting.preFocusPulseDuration
          // ..triggerPulseDuration =
          //     structure.settings[i].cameraSetting.triggerPulseDuration;
          break;
        default:
      }
      offset = offsetBeforeCam + 5;

      structure.settings[i].cameraSetting
        ..triggerPulseDuration = data.getUint8(offset += 1)
        ..preFocusPulseDuration = data.getUint8(offset += 1);

      if (structure.settings[i].cameraSetting.triggerPulseDuration != 3 ||
          structure.settings[i].cameraSetting.preFocusPulseDuration != 2) {
        metaStructure.advancedOptionsEnabled[i] = true;
      }

      // Time Setting
      if ((triggerType == Trigger.MOTION_ONLY &&
              motionTime == OperationTime.TIME_OF_DAY) ||
          (triggerType == Trigger.TIMER_ONLY &&
              timerTime == OperationTime.TIME_OF_DAY)) {
        structure.settings[i].time = TimeOfDay(
          startTime: data.getUint32(offset += 1, Endian.little),
          endTime: data.getUint32(offset += 4, Endian.little),
        );

        /// Invalid setting --> will also work for 0xFFFFFFFF sent as default setting from the device.
        if ((structure.settings[i].time as TimeOfDay).startTime ==
            (structure.settings[i].time as TimeOfDay).endTime) {
          structure.settings[i] = BeTxSetting(index: i);
          offset += 3;
          continue;
        }
        print(structure.settings[i].time);
      } else if (triggerType == Trigger.MOTION_ONLY &&
          (motionTime == OperationTime.AMBIENT ||
              motionTime == OperationTime.ALL_TIME)) {
        structure.settings[i].time = Ambient.inverse(
          lowerThreshold: data.getUint32(offset += 1, Endian.little),
          higherThreshold: data.getUint32(offset += 4, Endian.little),
        );
        structure.motionAmbientState += AmbientStateValues.getValue(
            (structure.settings[i].time as Ambient).ambientLight);
      } else if (triggerType == Trigger.TIMER_ONLY &&
          (timerTime == OperationTime.AMBIENT ||
              timerTime == OperationTime.ALL_TIME)) {
        structure.settings[i].time = Ambient.inverse(
          lowerThreshold: data.getUint32(offset += 1, Endian.little),
          higherThreshold: data.getUint32(offset += 4, Endian.little),
        );
        structure.timerAmbientState += AmbientStateValues.getValue(
            (structure.settings[i].time as Ambient).ambientLight);
      } else {
        offset += 5;
      }
      offset += 3;
    }
    structure.radioSetting = RadioSetting.inverse(
      radioChannel: RadioChannel.values[data.getUint8(offset += 1)],
      radioOperationDuration: data.getUint8(offset += 1),
      radioOperationFrequency: data.getUint8(offset += 1),
    );
    structure.deviceSpeed = DeviceSpeed.values[data.getUint8(offset += 1)];
    structure.range = Range.values[data.getUint8(offset += 1)];
    // skip 2 bytes common
    offset += 2;
    if ((workingOnDevice && !forProfile) || (forProfile && !workingOnDevice)) {
      structure.batteryType = BatteryType.values[data.getUint8(offset += 1)];
      structure.deviceName = '';
      for (int i = 0; i < 16; i++) {
        structure.deviceName +=
            AsciiCodec().decode([data.getUint8(offset += 1)]);
      }
      // TODO: Device name not trimmed
      print("Length ${structure.deviceName.length}");
      structure.deviceName
          .replaceAll(RegExp('  '), '')
          .replaceFirst(RegExp(' \$'), '');
      print("Length ${structure.deviceName.length}");
    } else {
      offset += 17;
    }
    print("$offset");
    assert(offset == 201);

    return {
      'structure': structure,
      'meta': metaStructure,
    };
  } catch (e) {
    throw e;
  }
}

// main() {
//   Structure structure = Structure();

//   for (int i = 0; i < 8; i++) {
//     structure.settings[i] = Setting(
//       cameraSetting: MultiplePicturesSetting(),
//       sensorSetting: MotionSetting(
//         downtime: 0,
//         numberOfTriggers: 10,
//         sensitivity: 45,
//       ),
//       // time: TimeOfDay(
//       //   startTime: getTimeInSeconds(DateTime.now()),
//       //   endTime: getTimeInSeconds(DateTime.now().add(Duration(hours: 5))),
//       // ),

//       time: Ambient(ambientLight: AmbientLight.DAY_ONLY),
//     );
//   }

//   structure
//     ..batteryType = BatteryType.RECHARGEABLE
//     ..deviceName = "Hello"
//     ..deviceSpeed = DeviceSpeed.FAST
//     ..operaionTime = [
//       OperationTime.ALL_TIME,
//       OperationTime.TIME_OF_DAY,
//     ]
//     ..radioSetting = RadioSetting();

//   print(structure.toString());

//   print("\n\n\n\n");
//   ByteData packedData = pack(structure);

//   // print(packedData.buffer.asUint8List());

//   Structure structure2 = unpack(packedData.buffer.asUint8List());
//   print(structure2.toString());
// }
