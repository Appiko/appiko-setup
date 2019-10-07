import 'package:flutter/foundation.dart';

enum RadioSpeed {
  VERY_FAST,
  FAST,
  NORMAL,
  SLOW,
  VERY_SLOW,
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
/// {@category SenseBeRx}
/// {@subCategory Radio}
class RadioSetting {
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
