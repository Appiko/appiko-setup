import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/models/generic/time.dart';
import 'package:setup/core/services/device.dart';
import 'package:setup/core/services/helper_functions.dart';
import 'package:setup/core/services/sense_be_rx_service.dart';
import 'package:setup/core/services/sense_be_tx_service.dart';
import 'package:setup/core/services/sense_pi_service.dart';
import 'package:setup/core/view_models/time_of_day_fields_model.dart';
import 'package:setup/locators.dart';

/// {@category Widget}
/// {@category Design}
/// Time of day  (Cupertino Date Pickers) displayed in [SettingTimepickerScreen]
class TimeOfDayFields extends StatefulWidget {
  @override
  _TimeOfDayFieldsState createState() => _TimeOfDayFieldsState();
}

class _TimeOfDayFieldsState extends State<TimeOfDayFields> {
  int endTime = 0;
  int startTime = 0;

  String errorMessage = '';

  bool firstBuild = true;

  @override
  void initState() {
    super.initState();
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          errorMessage = getErrorMessage();
        });
        if (errorMessage.isNotEmpty) {
          locator<TimeOfDayFieldsModel>().timeOverlap = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (firstBuild) {
      endTime = getTimeInSeconds(locator<TimeOfDayFieldsModel>().endTime);
      startTime = getTimeInSeconds(locator<TimeOfDayFieldsModel>().startTime);
      firstBuild = false;
    }
    print("rebuilding");
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 24),
        Text(
          "Start time",
          style: Theme.of(context).textTheme.title.copyWith(fontSize: 20.0),
        ),
        SizedBox(height: 20),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 80, maxHeight: 150),
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            minuteInterval: 5,
            onDateTimeChanged: (DateTime value) {
              setState(() {
                startTime = getTimeInSeconds(value);
              });
              errorMessage = Provider.of<SenseBeRxService>(context).timeCheck(
                pickerStartTime: startTime,
                pickerEndTime: endTime,
              );

              if (errorMessage.isEmpty) {
                Provider.of<TimeOfDayFieldsModel>(context).timeOverlap = false;
                Provider.of<TimeOfDayFieldsModel>(context).startTime = value;
                Provider.of<TimeOfDayFieldsModel>(context).endTime =
                    getDateTimefromSeconds(endTime);
              } else {
                Provider.of<TimeOfDayFieldsModel>(context).timeOverlap = true;
              }
            },
            use24hFormat: false,
            initialDateTime: getDateTimefromSeconds(startTime),
          ),
        ),
        SizedBox(height: 24),
        Text(
          "End time",
          style: Theme.of(context).textTheme.title.copyWith(fontSize: 20.0),
        ),
        SizedBox(height: 20),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 80, maxHeight: 150),
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            minuteInterval: 5,
            onDateTimeChanged: (DateTime value) {
              setState(() {
                endTime = getTimeInSeconds(value);
              });
              errorMessage = Provider.of<SenseBeRxService>(context).timeCheck(
                pickerStartTime: startTime,
                pickerEndTime: endTime,
              );

              if (errorMessage.isEmpty) {
                Provider.of<TimeOfDayFieldsModel>(context).timeOverlap = false;
                Provider.of<TimeOfDayFieldsModel>(context).endTime = value;
                Provider.of<TimeOfDayFieldsModel>(context).startTime =
                    getDateTimefromSeconds(startTime);
              } else {
                Provider.of<TimeOfDayFieldsModel>(context).timeOverlap = true;
              }
            },
            use24hFormat: false,
            initialDateTime: getDateTimefromSeconds(endTime),
          ),
        ),
        SizedBox(height: 10),
        errorMessage.isNotEmpty
            ? Text(
                errorMessage,
                style: TextStyle(color: Theme.of(context).errorColor),
              )
            : Text(""),
        SizedBox(height: 10),
      ],
    );
  }

  String getErrorMessage() {
    String errMsg;
    switch (activeDevice) {
      case Device.SENSE_BE_TX:
        errMsg = locator<SenseBeTxService>()
            .timeCheck(pickerStartTime: startTime, pickerEndTime: endTime);
        break;
      case Device.SENSE_BE_RX:
        errMsg = locator<SenseBeRxService>()
            .timeCheck(pickerStartTime: startTime, pickerEndTime: endTime);
        break;
      case Device.SENSE_PI:
        errMsg = locator<SensePiService>()
            .timeCheck(pickerStartTime: startTime, pickerEndTime: endTime);
        break;
    }
    return errMsg;
  }
}
