import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:setup/core/models/devices/sense_be_rx/1.0/camera.dart';
import 'package:setup/core/models/devices/sense_be_rx/1.0/time.dart';

/// [BatteryTypes]s supported by Be Rx
enum BatteryType {
  STANDARD,
  RECHARGEABLE,
}

/// [DeviceSpeed]s supported
enum DeviceSpeed {
  /// 5ms
  LIGHTNING,

  /// 25ms
  FAST,

  /// 100ms
  NORMAL,

  /// 250ms
  SLOW
}

enum Trigger {
  MOTION_ONLY,
  TIMER_ONLY,

  /// Not used in the app
  MOTION_AND_TIMER,
  NONE,
}

enum OperationTime {
  ALL_TIME,
  TIME_OF_DAY,
  AMBIENT,
  NONE,
}

enum RadioChannel {
  /// 2497 MHz
  CHANNEL_0,

  /// 2489 MHz
  CHANNEL_1,

  /// 2483 MHz
  CHANNEL_2,

  /// 2479 MHz
  CHANNEL_3,

  /// 2473 MHz
  CHANNEL_4,

  /// 2471 MHz
  CHANNEL_5,

  /// 2467 MHz
  CHANNEL_6,

  /// 2461 MHz
  CHANNEL_7,

  /// 2459 MHz
  CHANNEL_8,

  /// 2453 MHz
  CHANNEL_9,
}

/// {@category Model}
/// {@subCategory Sensor}
/// {@category SenseBeRx}
class SensorSetting {}

/// {@category Model}
/// {@subCategory Sensor}
/// {@category SenseBeRx}
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
/// {@subCategory Sensor}
/// {@category SenseBeRx}
class TimerSetting extends SensorSetting {
  int interval;

  TimerSetting({this.interval = 200});

  static TimerSetting clone(TimerSetting sensorSetting) {
    return TimerSetting(
      interval: sensorSetting.interval,
    );
  }

  @override
  String toString() {
    return 'TimerSetting{interval: $interval}';
  }
}

/// {@category Model}
/// {@category SenseBeRx}
class Setting {
  SensorSetting sensorSetting;
  CameraSetting cameraSetting;
  Time time;
  int index;
  Setting({this.sensorSetting, this.cameraSetting, this.time, this.index}) {
    sensorSetting = SensorSetting();
    cameraSetting = CameraSetting();
    time = Time();
  }

  @override
  String toString() {
    return 'Setting{sensorSetting: $sensorSetting, cameraSetting: $cameraSetting, time: $time}';
  }

  static Setting clone({Setting setting, int index}) {
    var x = new Setting();

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

    x.index = index ?? setting.index;
    return x;
  }
}

enum RadioSpeed {
  VERY_FAST,
  FAST,
  NORMAL,
  SLOW,
  VERY_SLOW,
}

/// {@category Model}
/// {@category SenseBeRx}
/// {@subCategory Radio}
class RadioSetting {
  // TODO: set default
  RadioChannel radioChannel = RadioChannel.CHANNEL_0;

  /// Once the radio is switched on how long should it be on **multiple of 25ms**
  int radioOperationDuration = 4; //(100ms)

  /// Interval between two radio on operations. **multiple of 100us**
  int radioOperationFrequency = 10;

  RadioSpeed speed;

  static RadioSetting clone(RadioSetting setting) {
    return RadioSetting(
      speed: setting.speed,
      radioChannel: setting.radioChannel,
    );
  }

  RadioSetting({@required this.speed, this.radioChannel}) {
    switch (speed) {
      case RadioSpeed.VERY_FAST:
        radioOperationDuration = 1;
        radioOperationFrequency = 1;
        break;
      case RadioSpeed.FAST:
        radioOperationDuration = 2;
        radioOperationFrequency = 2;
        break;
      case RadioSpeed.NORMAL:
        radioOperationDuration = 3;
        radioOperationFrequency = 3;
        break;
      case RadioSpeed.SLOW:
        radioOperationDuration = 4;
        radioOperationFrequency = 4;
        break;
      case RadioSpeed.VERY_SLOW:
        radioOperationDuration = 5;
        radioOperationFrequency = 5;
        break;
    }
  }

  RadioSetting.inverse({
    @required this.radioOperationDuration,
    @required this.radioOperationFrequency,
    @required this.radioChannel,
  }) {
    switch (radioOperationDuration) {
      case 1:
        this.speed = RadioSpeed.VERY_FAST;
        break;
      case 2:
        this.speed = RadioSpeed.FAST;
        break;
      case 3:
        this.speed = RadioSpeed.NORMAL;
        break;
      case 4:
        this.speed = RadioSpeed.SLOW;
        break;
      case 5:
        this.speed = RadioSpeed.VERY_SLOW;
        break;
    }
  }

  @override
  String toString() {
    return 'RadioSetting{radioChannel: $radioChannel, radioOperationDuration: $radioOperationDuration, radioOperationFrequency: $radioOperationFrequency}';
  }
}

///
/// {@category Model}
/// {@category SenseBeRx}
///
class SenseBeRx with ChangeNotifier {
  List<OperationTime> operationTime = List(2); // for motion and timer

  ///[Ambient Light States]
  int motionAmbientState = 0;
  int timerAmbientState = 0;

  /// 8 + 1 for duplication
  List<Setting> settings = List.generate(9, (i) => Setting(index: i));
  RadioSetting radioSetting = RadioSetting(
    speed: RadioSpeed.NORMAL,
    radioChannel: RadioChannel.CHANNEL_0,
  );
  DeviceSpeed deviceSpeed = DeviceSpeed.FAST;
  BatteryType batteryType = BatteryType.STANDARD;
  DateTime today = DateTime.now();
  String deviceName = '';

  @override
  String toString() {
    return 'Structure{settings: $settings, radioSetting: $radioSetting, deviceSpeed: $deviceSpeed, batteryType: $batteryType, today: $today, deviceName: $deviceName}';
  }
}

Uint8List pack(SenseBeRx structure) {
  ByteData packedData = ByteData(206);

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
          // TODO: Implement the sensitivity table
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

  // ** Device Speed 1 Byte
  packedData.setUint8(offset += 1, structure.deviceSpeed.index);

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

  assert(offset == 205);
  return packedData.buffer.asUint8List();
}

unpack(List<int> intData) {
  ByteBuffer buffer = Uint8List.fromList(intData).buffer;
  ByteData data = ByteData.view(buffer, 0, 206);
  SenseBeRx structure = SenseBeRx();

  int offset = -1;
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
        structure.settings[i].sensorSetting =
            TimerSetting(interval: data.getUint32(offset += 1, Endian.little));
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

    switch (structure.settings[i].cameraSetting.mode) {
      case CameraAction.MULTIPLE_PICTURES:
        structure.settings[i].cameraSetting = MultiplePicturesSetting()
          ..numberOfPictures = data.getUint16(offset += 1, Endian.little)
          ..pictureInterval = data.getUint16(offset += 2, Endian.little)
          ..enablePreFocus = structure.settings[i].cameraSetting.enablePreFocus
          ..videoWithFullPress =
              structure.settings[i].cameraSetting.videoWithFullPress
          ..enableRadio = structure.settings[i].cameraSetting.enableRadio
          ..preFocusPulseDuration =
              structure.settings[i].cameraSetting.preFocusPulseDuration
          ..triggerPulseDuration =
              structure.settings[i].cameraSetting.triggerPulseDuration;
        break;
      case CameraAction.VIDEO:
        structure.settings[i].cameraSetting = VideoSetting()
          ..videoDuration = data.getUint16(offset += 1, Endian.little)
          ..extensionTime = data.getUint8(offset += 2)
          ..numberOfExtensions = data.getUint8(offset += 1)
          ..enablePreFocus = structure.settings[i].cameraSetting.enablePreFocus
          ..videoWithFullPress =
              structure.settings[i].cameraSetting.videoWithFullPress
          ..enableRadio = structure.settings[i].cameraSetting.enableRadio
          ..preFocusPulseDuration =
              structure.settings[i].cameraSetting.preFocusPulseDuration
          ..triggerPulseDuration =
              structure.settings[i].cameraSetting.triggerPulseDuration;
        break;
      case CameraAction.LONG_PRESS:
        structure.settings[i].cameraSetting = LongPressSetting()
          ..longPressDuration = data.getUint32(offset += 1, Endian.little)
          ..enablePreFocus = structure.settings[i].cameraSetting.enablePreFocus
          ..videoWithFullPress =
              structure.settings[i].cameraSetting.videoWithFullPress
          ..enableRadio = structure.settings[i].cameraSetting.enableRadio
          ..preFocusPulseDuration =
              structure.settings[i].cameraSetting.preFocusPulseDuration
          ..triggerPulseDuration =
              structure.settings[i].cameraSetting.triggerPulseDuration;
        break;
      default:
    }
    offset = offsetBeforeCam + 5;

    structure.settings[i].cameraSetting
      ..triggerPulseDuration = data.getUint8(offset += 1)
      ..preFocusPulseDuration = data.getUint8(offset += 1);

    // Time Setting
    if ((triggerType == Trigger.MOTION_ONLY &&
            motionTime == OperationTime.TIME_OF_DAY) ||
        (triggerType == Trigger.TIMER_ONLY &&
            timerTime == OperationTime.TIME_OF_DAY)) {
      structure.settings[i].time = TimeOfDay(
        startTime: data.getInt32(offset += 1, Endian.little),
        endTime: data.getUint32(offset += 4, Endian.little),
      );
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

  structure.batteryType = BatteryType.values[data.getUint8(offset += 1)];
  structure.deviceName = '';
  for (int i = 0; i < 16; i++) {
    structure.deviceName += AsciiCodec().decode([data.getUint8(offset += 1)]);
  }

  assert(offset == 198);
  return structure;
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

class MetaStructure {
  MetaStructure();
  List advancedOptionsEnabled = List.filled(9, false);
  bool radioAdvancedOption = false;

  Map<String, dynamic> toJson() => {
        'advancedOptionsEnabled': advancedOptionsEnabled,
        'radioAdvancedOption': radioAdvancedOption,
      };

  MetaStructure.fromJson(Map<String, dynamic> json)
      : advancedOptionsEnabled = json['advancedOptionsEnabled'],
        radioAdvancedOption = json['radioAdvancedOption'];

  @override
  String toString() {
    return "$advancedOptionsEnabled\n$radioAdvancedOption";
  }
}
