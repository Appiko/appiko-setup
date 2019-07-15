import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:setup/ui/widgets/custom_app_bar.dart';
import 'package:setup/ui/widgets/page_navigation_bar.dart';

enum TimeSelectionMode {
  TIME_OF_DAY,
  AMBIENT,
}

class SettingTimepickerScreen extends StatefulWidget {
  @override
  _SettingTimepickerScreenState createState() =>
      _SettingTimepickerScreenState();
}

class _SettingTimepickerScreenState extends State<SettingTimepickerScreen> {
  TimeSelectionMode timeSelectionMode = TimeSelectionMode.TIME_OF_DAY;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Time"),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                // child: CupertinoTimerPicker(
                mode: CupertinoDatePickerMode.time,
                minuteInterval: 5, onDateTimeChanged: (DateTime value) {},
                use24hFormat: false,
                initialDateTime: DateTime.now().add(
                  Duration(minutes: 5 - (DateTime.now().minute % 5), hours: 2),
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: PageNavigationBar(
        showNext: true,
        showPrevious: true,
        onNext: () {
          Navigator.pop(context);
        },
        onPrevious: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
