import 'package:flutter/foundation.dart';

/// [AmbientLight] options
enum AmbientLight {
  ALL_TIME,
  DAY_ONLY,
  NIGHT_ONLY,
  DAY_AND_TWILIGHT,
  NIGHT_AND_TWILIGHT,
  TWILIGHT_ONLY,
}

/// {@category Model}
/// {@category SenseBeRx}
/// {@subCategory Time}
///
/// This class has a static function to get the state values of ambient light
class AmbientStateValues {
  static getValue(AmbientLight ambientLight) {
    switch (ambientLight) {
      case AmbientLight.ALL_TIME:
        return 0;
        break;
      case AmbientLight.DAY_ONLY:
        return 4;
        break;
      case AmbientLight.NIGHT_ONLY:
        return 2;
        break;
      case AmbientLight.DAY_AND_TWILIGHT:
        return 5;
        break;
      case AmbientLight.NIGHT_AND_TWILIGHT:
        return 3;
        break;
      case AmbientLight.TWILIGHT_ONLY:
        return 1;
        break;
    }
  }
}

/// {@category Model}
/// {@category SenseBeRx}
/// {@subCategory Time}
class Time {}

/// [TimeOfDay] selection
///
/// Select time from 00:00 to 11:59
/// Converting that to seconds is `0s to 86400s`
///
/// {@category Model}
/// {@category SenseBeRx}
/// {@subCategory Time}
class TimeOfDay extends Time {
  int startTime;
  int endTime;

  TimeOfDay({
    @required this.startTime,
    @required this.endTime,
  });

  static TimeOfDay clone(TimeOfDay time) {
    return TimeOfDay(startTime: time.startTime, endTime: time.endTime);
  }

  @override
  String toString() {
    return 'TimeOfDay{startTime: $startTime, endTime: $endTime}';
  }
}

/// {@category Model}
/// {@category SenseBeRx}
/// {@subCategory Time}
class Ambient extends Time {
  /// [TODO:] Change default `128` to ambient values
  /// TODO: update packing if state is 6
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
  /// Device will be working if ambient light is lower than this threshold
  int higherThreshold;

  static Ambient clone(Ambient time) {
    return Ambient(ambientLight: time.ambientLight);
  }

  Ambient.inverse({
    @required this.lowerThreshold,
    @required this.higherThreshold,
  }) {
    if (lowerThreshold == x2 && higherThreshold == 0xFFFFFFFF) {
      ambientLight = AmbientLight.DAY_ONLY;
    } else if (lowerThreshold == 0 && higherThreshold == x2) {
      ambientLight = AmbientLight.NIGHT_ONLY;
    } else if (lowerThreshold == 0 && higherThreshold == 0xFFFFFFFF) {
      ambientLight = AmbientLight.ALL_TIME;
    } else if (lowerThreshold == x1 && higherThreshold == 0xFFFFFFFF) {
      ambientLight = AmbientLight.DAY_AND_TWILIGHT;
    } else if (lowerThreshold == 0 && higherThreshold == x3) {
      ambientLight = AmbientLight.NIGHT_AND_TWILIGHT;
    } else if (lowerThreshold == x1 && higherThreshold == x3) {
      ambientLight = AmbientLight.TWILIGHT_ONLY;
    }
  }
  Ambient({@required this.ambientLight}) {
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
      case AmbientLight.TWILIGHT_ONLY:
        lowerThreshold = x1;
        higherThreshold = x3;
        break;
      case AmbientLight.ALL_TIME:
        lowerThreshold = 0;
        higherThreshold = 0xFFFFFFFF;
        break;
    }
  }

  @override
  String toString() {
    return 'Ambient{ambientLight: $ambientLight, lowerThreshold: $lowerThreshold, higherThreshold: $higherThreshold}';
  }
}

/// {@category Helper}
/// {@subCategory Time}
int getTimeInSeconds(DateTime dateTime) {
  int seconds = dateTime.hour * 60 * 60;
  seconds += dateTime.minute * 60;
  seconds += dateTime.second;
  return seconds;
}

String _getMinString(Duration d) {
  return d.toString().split(":")[1];
}

String _getSecString(Duration d) {
  return d.toString().split(":")[2].substring(0, 4);
}

/// {@category Helper}
/// {@subCategory Time}
String getMinSecTimeString(
  /// [duration] should have milliseconds set.
  Duration duration,
) {
  String min = _getMinString(duration);
  String sec = _getSecString(duration);
  return "$min m $sec s";
}

/// {@category Helper}
/// {@subCategory Time}
DateTime getDateTimefromSeconds(int seconds) {
  int hours = seconds ~/ 3600;
  int minutes = seconds % 3600 ~/ 60;

  return DateTime(DateTime.now().year, 0, 0, hours, minutes);
}

/// {@category Helper}
/// {@subCategory Time}
String getTimeString({DateTime dateTime, AmbientLight ambientLight}) {
  if (dateTime != null) {
    int hours = dateTime.hour;
    int minutes = dateTime.minute;
    String indicator = "AM";

    if (hours >= 12) {
      hours %= 12;
      indicator = "PM";
    }

    if (hours == 0) {
      hours = 12;
    }

    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} $indicator";
  }
  if (ambientLight != null) {
    return ambientLight
        .toString()
        .split('.')[1]
        .replaceAllMapped('_', (_) => ' ');
  }
  return null;
}
