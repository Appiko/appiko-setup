/// {@category Model}
/// {@subCategory Sensor}
/// {@category SenseBeRx}
class SensorSetting {}

/// {@category Model}
/// {@subCategory Sensor}
/// {@category SensePi}
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
