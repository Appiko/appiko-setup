import 'package:flutter/foundation.dart';
import 'package:setup/core/models/time.dart';

class TimeOfDayFieldsModel extends ChangeNotifier {
  DateTime startTime =
      DateTime.now().add(Duration(minutes: 5 - (DateTime.now().minute % 5)));

  DateTime endTime = DateTime.now()
      .add(Duration(minutes: 5 - (DateTime.now().minute % 5), hours: 2));

  bool _timeOverlap = false;

  bool get timeOverlap => _timeOverlap;

  set timeOverlap(bool timeOverlap) {
    _timeOverlap = timeOverlap;
    notifyListeners();
  }

  /// Returns [Time]
  TimeOfDay getTime() {
    return TimeOfDay(
      startTime: getTimeInSeconds(startTime),
      endTime: getTimeInSeconds(endTime),
    );
  }
}
