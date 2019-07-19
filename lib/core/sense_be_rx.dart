import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

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

/// TODO: Trigger combinations
enum Trigger {
  MOTION_ONLY,
  TIMER_ONLY,

  /// Not used in the app side
  MOTION_AND_TIMER,
  NONE,
}

/// TODO: Discuss all time - Make UI
enum OperationTime {
  ALL_TIME,
  TIME_OF_DAY,
  AMBIENT,
}

/// [AmbientLight] options
enum AmbientLight {
  DAY_ONLY,
  NIGHT_ONLY,
  DAY_AND_TWILIGHT,
  NIGHT_AND_TWILIGHT,
}

enum RadioChannel {
  /// 2497 MHz
  CHANNEL_2497,

  /// 2489 MHz
  CHANNEL_2489,

  /// 2483 MHz
  CHANNEL_2483,

  /// 2479 MHz
  CHANNEL_2479,

  /// 2473 MHz
  CHANNEL_2473,

  /// 2471 MHz
  CHANNEL_2471,

  /// 2467 MHz
  CHANNEL_2467,

  /// 2461 MHz
  CHANNEL_2461,

  /// 2459 MHz
  CHANNEL_2459,

  /// 2453 MHz
  CHANNEL_2453,
}

/// [AmbientLightThreshold]
class AmbientLightThreshold {}

enum CameraAction {
  SINGLE_PICTURE,
  MULTIPLE_PICTURES,
  LONG_PRESS,
  VIDEO,
  HALF_PRESS,
  NONE
}

class SensorSetting {}

class Time {}

/// Set mode for Single Picture or Half Press
/// manually.

class CameraSetting {
  // Enable pre-focus
  bool enablePreFocus = true;
  bool videoWithFullPress = true;

  // TODO: Make UI
  bool enableRadio = false;

  /// multiple of 100ms, 25s max, 300ms default
  int triggerPulseDuration = 3;

  /// multiple of 100ms, 25 sec max, 200ms default
  int preFocusPulseDuration = 2;

  CameraAction mode;

  CameraSetting({this.mode});

  @override
  String toString() {
    return 'CameraSetting{enablePreFocus: $enablePreFocus, videoWithFullPress: $videoWithFullPress, enableRadio: $enableRadio, triggerPulseDuration: $triggerPulseDuration, preFocusPulseDuration: $preFocusPulseDuration, mode: $mode,}';
  }
}

/// [TimeOfDay] selection
///
/// Select time from 00:00 to 11:59
/// Converting that to seconds is `0s to 86400s`
class TimeOfDay extends Time {
  int startTime;
  int endTime;

  TimeOfDay({
    @required this.startTime,
    @required this.endTime,
  });

  @override
  String toString() {
    return 'TimeOfDay{startTime: $startTime, endTime: $endTime}';
  }
}

class Ambient extends Time {
  /// [TODO:] Change default `128` to ambient values
  AmbientLight ambientLight;
  int x1 = 100;
  int x2 = 200;
  int x3 = 300;
  // x3 > x2 > x1
  ///All day   :  0
  ///Day Only   :  x2
  ///Night Only   :  0
  ///Twilight only : x1
  ///Day & Twilight   :  x1
  ///Night & Twilight   :  0
  int lowerThreshold;

  ///All day   :  0xFFFFFFFF
  ///Day Only   :  0xFFFFFFFF
  ///Night Only   :  x2
  ///Twilight only : x3
  ///Day & Twilight   :  0xFFFFFFFF
  ///Night & Twilight   :  x3
  /** Device will be working if ambient light is lower than this threshold */
  int higherThreshold;

  Ambient.inverse({
    @required this.lowerThreshold,
    @required this.higherThreshold,
  }) {
    if (lowerThreshold == x2 && higherThreshold == 0xFFFFFFFF) {
      ambientLight = AmbientLight.DAY_ONLY;
    } else if (lowerThreshold == 0 && higherThreshold == x2) {
      ambientLight = AmbientLight.NIGHT_ONLY;
    } else if (lowerThreshold == x1 && higherThreshold == 0xFFFFFF) {
      ambientLight = AmbientLight.DAY_AND_TWILIGHT;
    } else if (lowerThreshold == 0 && higherThreshold == x3) {
      ambientLight = AmbientLight.NIGHT_AND_TWILIGHT;
    }
  }
  Ambient({@required this.ambientLight}) {
    //TODO: Discuss TwilightOnly

    switch (ambientLight) {
      case AmbientLight.DAY_ONLY:
        lowerThreshold = x2;
        higherThreshold = 0xFFFFFFFF;
        break;
      case AmbientLight.DAY_AND_TWILIGHT:
        lowerThreshold = x1;
        higherThreshold = 0xFFFFFFFF;
        break;
      case AmbientLight.NIGHT_ONLY:
        lowerThreshold = 0;
        higherThreshold = x2;
        break;
      case AmbientLight.NIGHT_AND_TWILIGHT:
        lowerThreshold = 0;
        higherThreshold = x3;
        break;
      default:
        break;
    }
  }

  @override
  String toString() {
    return 'Ambient{ambientLight: $ambientLight, lowerThreshold: $lowerThreshold, higherThreshold: $higherThreshold}';
  }
}

class MotionSetting extends SensorSetting {
  int downtime;
  int sensitivity;
  // TODO: Make UI
  int numberOfTriggers;

  MotionSetting({
    @required this.downtime,
    @required this.sensitivity,
    @required this.numberOfTriggers,
  });

  @override
  String toString() {
    return 'MotionSetting{downtime: $downtime, sensitivity: $sensitivity, numberOfTriggers: $numberOfTriggers}';
  }
}

class TimerSetting extends SensorSetting {
  int interval;

  TimerSetting({@required this.interval});

  @override
  String toString() {
    return 'TimerSetting{interval: $interval}';
  }
}

class Setting {
  SensorSetting sensorSetting = SensorSetting();
  CameraSetting cameraSetting = CameraSetting();
  Time time = Time();
  Setting({
    this.sensorSetting,
    this.cameraSetting,
    this.time,
  });

  @override
  String toString() {
    return 'Setting{sensorSetting: $sensorSetting, cameraSetting: $cameraSetting, time: $time}';
  }
}

class MultiplePicturesSetting extends CameraSetting {
  static CameraAction _mode = CameraAction.MULTIPLE_PICTURES;

  /// [numberOfPictures] to capture; from a minimum of 2 to 32
  int numberOfPictures = 4;

  /// [pictureInterval] multiple of 100ms; from a minimum of 0.5s to 100min
  int pictureInterval = 5;

  MultiplePicturesSetting() : super(mode: _mode);

  MultiplePicturesSetting.copyWith(CameraSetting cameraSetting) {
    MultiplePicturesSetting()
      ..mode = cameraSetting.mode
      ..enablePreFocus = cameraSetting.enablePreFocus
      ..enableRadio = cameraSetting.enableRadio
      ..videoWithFullPress = cameraSetting.videoWithFullPress
      ..preFocusPulseDuration = cameraSetting.preFocusPulseDuration
      ..triggerPulseDuration = cameraSetting.triggerPulseDuration;
  }
  @override
  String toString() {
    return 'MultiplePicturesSetting{numberOfPicutes: $numberOfPictures, pictureInterval: $pictureInterval}';
  }
}

class VideoSetting extends CameraSetting {
  static CameraAction _mode = CameraAction.VIDEO;

  /// 1s to 1000m
  int videoDuration;

  /// 1s to 250s
  int extensionTime;

  /// 1 to 20
  int numberOfExtensions;

  VideoSetting() : super(mode: _mode);

  VideoSetting.copyWith(CameraSetting cameraSetting) {
    VideoSetting()
      ..mode = cameraSetting.mode
      ..enablePreFocus = cameraSetting.enablePreFocus
      ..enableRadio = cameraSetting.enableRadio
      ..videoWithFullPress = cameraSetting.videoWithFullPress
      ..preFocusPulseDuration = cameraSetting.preFocusPulseDuration
      ..triggerPulseDuration = cameraSetting.triggerPulseDuration;
  }

  @override
  String toString() {
    return 'VideoSetting{videoDuration: $videoDuration, extensionTime: $extensionTime, numberOfExtentions: $numberOfExtensions}';
  }
}

class LongPressSetting extends CameraSetting {
  static CameraAction _mode = CameraAction.LONG_PRESS;

  /// 3s to 24h in multiples of 100ms
  int longPressDuration;

  LongPressSetting() : super(mode: _mode);

  LongPressSetting.copyWith(CameraSetting cameraSetting) {
    LongPressSetting()
      ..mode = cameraSetting.mode
      ..enablePreFocus = cameraSetting.enablePreFocus
      ..enableRadio = cameraSetting.enableRadio
      ..videoWithFullPress = cameraSetting.videoWithFullPress
      ..preFocusPulseDuration = cameraSetting.preFocusPulseDuration
      ..triggerPulseDuration = cameraSetting.triggerPulseDuration;
  }

  @override
  String toString() {
    return 'LongPressSetting{longPressDuration: $longPressDuration}';
  }
}

class RadioSetting {
  // TODO: set default
  RadioChannel radioChannel = RadioChannel.CHANNEL_2489;

  /// Once the radio is switched on how long should it be on **multiple of 25ms**
  int radioOperationDuration = 4; //(100ms)

  /// Interval between two radio on operations. **multiple of 100us**
  int radioOperationFrequency = 10;

  @override
  String toString() {
    return 'RadioSetting{radioChannel: $radioChannel, radioOperationDuration: $radioOperationDuration, radioOperationFrequency: $radioOperationFrequency}';
  }
}

//default values
class Structure {
  List<OperationTime> operaionTime = [
    OperationTime.ALL_TIME,
    OperationTime.AMBIENT
  ];
  List<Setting> settings = List.filled(8, Setting());
  RadioSetting radioSetting = RadioSetting();
  DeviceSpeed deviceSpeed = DeviceSpeed.LIGHTNING;
  BatteryType batteryType = BatteryType.STANDARD;
  DateTime today = DateTime.now();
  String deviceName = '';

  @override
  String toString() {
    return 'Structure{settings: $settings, radioSetting: $radioSetting, deviceSpeed: $deviceSpeed, batteryType: $batteryType, today: $today, deviceName: $deviceName}';
  }
}

pack(Structure structure) {
  ByteData packedData = ByteData(206);

  /// Adding Operation time in order of Motion - Timer
  int offset = -1;
  packedData.setUint8(offset += 1, structure.operaionTime[0].index);
  packedData.setUint8(offset += 1, structure.operaionTime[1].index);

  structure.settings.forEach((setting) {
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
        packedData.setUint8(offset += 1, Trigger.MOTION_ONLY.index);

        // Sensor Settings 6 Bytes
        packedData.setUint32(
            offset += 1, sensorSetting.interval, Endian.little);
        packedData.setUint16(offset += 4, 0, Endian.little);

        break;

      default:
        packedData.setUint8(offset += 1, Trigger.NONE.index);
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
    }
    offset = offsetBeforeCam + 4;
    packedData.setUint8(
        offset += 1, setting.cameraSetting.triggerPulseDuration);
    packedData.setUint8(
        offset += 1, setting.cameraSetting.preFocusPulseDuration);

    // ** Time Settings 8 Bytes**
    switch (setting.time.runtimeType) {
      case TimeOfDay:
        packedData.setUint32(
            offset += 1, (setting.time as TimeOfDay).startTime, Endian.little);
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
  return packedData;
}

int getTimeInSeconds(DateTime dateTime) {
  int seconds = dateTime.hour * 60 * 60;
  seconds += dateTime.minute * 60;
  seconds += dateTime.second;
  return seconds;
}

unpack(List<int> intData) {
  ByteBuffer buffer = Uint8List.fromList(intData).buffer;
  ByteData data = ByteData.view(buffer, 0, 206);

// Ignoring first two bytes
  int offset = -1;
  OperationTime motionTime = OperationTime.values[data.getUint8(offset += 1)];
  OperationTime timerTime = OperationTime.values[data.getUint8(offset += 1)];

  Structure structure = Structure();
  for (int i = 0; i < 8; i++) {
    print(offset + 1);
    Trigger triggerType = Trigger.values[data.getUint8(offset += 1)];
    switch (triggerType) {
      case Trigger.MOTION_ONLY:
        // Sensor Setting
        structure.settings[i].sensorSetting = MotionSetting()
          // skiping isEnable which is 1 by default
          ..numberOfTriggers = data.getUint8(offset += 2)
          ..sensitivity = data.getUint16(offset += 1, Endian.little)
          ..downtime = data.getUint16(offset += 2, Endian.little);
        offset += 1;
        break;
      case Trigger.TIMER_ONLY:
        structure.settings[i].sensorSetting =
            TimerSetting(data.getUint32(offset += 1, Endian.little));
        offset += 5;
        break;
      default:
    }

    // Camera Settings
    int offsetBeforeCam = offset;
    int cameraFirstByte = data.getUint8(offset += 1);
    structure.settings[i].cameraSetting = CameraSetting()
      // TODO: First byte

      ..enablePreFocus = ((cameraFirstByte & 248) >> 3) > 0 ? true : false
      ..videoWithFullPress = ((cameraFirstByte & 4) >> 2) > 0 ? true : false
      ..enableRadio = ((cameraFirstByte & 2) >> 1) > 0 ? true : false
      ..mode = CameraAction.values[((cameraFirstByte & 1))];

    switch (structure.settings[i].cameraSetting.mode) {
      case CameraAction.MULTIPLE_PICTURES:
        structure.settings[i].cameraSetting = MultiplePicturesSetting.copyWith(
            structure.settings[i].cameraSetting)
          ..numberOfPictures = data.getUint16(offset += 1, Endian.little)
          ..pictureInterval = data.getUint16(offset += 2, Endian.little);
        break;
      case CameraAction.VIDEO:
        structure.settings[i].cameraSetting =
            VideoSetting.copyWith(structure.settings[i].cameraSetting)
              ..videoDuration = data.getUint16(offset += 1, Endian.little)
              ..extensionTime = data.getUint8(offset += 2)
              ..numberOfExtensions = data.getUint8(offset += 1);
        break;
      case CameraAction.LONG_PRESS:
        structure.settings[i].cameraSetting =
            LongPressSetting.copyWith(structure.settings[i].cameraSetting)
              ..longPressDuration = data.getUint32(offset += 1, Endian.little);
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
      structure.settings[i].time = TimeOfDay()
        ..startTime = data.getInt32(offset += 1, Endian.little)
        ..endTime = data.getUint32(offset += 4, Endian.little);
    }
    if ((triggerType == Trigger.MOTION_ONLY &&
            (motionTime == OperationTime.AMBIENT ||
                motionTime == OperationTime.ALL_TIME)) ||
        (triggerType == Trigger.TIMER_ONLY &&
            (timerTime == OperationTime.AMBIENT ||
                timerTime == OperationTime.ALL_TIME))) {
      structure.settings[i].time = Ambient.inverse(
        lowerThreshold: data.getUint32(offset += 1, Endian.little),
        higherThreshold: data.getUint32(offset += 4, Endian.little),
      );
    }
    offset += 3;
  }
  structure.radioSetting = RadioSetting()
    ..radioChannel = RadioChannel.values[data.getUint8(offset += 1)]
    ..radioOperationDuration = data.getUint8(offset += 1)
    ..radioOperationFrequency = data.getUint8(offset += 1);

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
