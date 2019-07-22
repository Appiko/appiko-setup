import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeOfDayFields extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 24),
          Text(
            "Start time",
            style: Theme.of(context).textTheme.title.copyWith(fontSize: 24.0),
          ),
          SizedBox(height: 20),
          Expanded(
            child: CupertinoDatePicker(
              // child: CupertinoTimerPicker(
              mode: CupertinoDatePickerMode.time,
              minuteInterval: 5, onDateTimeChanged: (DateTime value) {},
              use24hFormat: false,
              initialDateTime: DateTime.now().add(
                Duration(minutes: 5 - (DateTime.now().minute % 5)),
              ),
            ),
          ),
          SizedBox(height: 24),
          Text(
            "End time",
            style: Theme.of(context).textTheme.title.copyWith(fontSize: 24.0),
          ),
          SizedBox(height: 20),
          Expanded(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              minuteInterval: 5,
              onDateTimeChanged: (DateTime value) {},
              use24hFormat: false,
              initialDateTime: DateTime.now().add(
                Duration(minutes: 5 - (DateTime.now().minute % 5), hours: 2),
              ),
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
