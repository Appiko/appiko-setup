import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:setup/core/sense_be_rx.dart';
import 'package:setup/ui/widgets/custom_app_bar.dart';
import 'package:setup/ui/widgets/custom_radio_field.dart';
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

enum OperationTime {
  TIME_OF_DAY,
  AMBIENT,
  ALL_TIME,
}

class _SettingTimepickerScreenState extends State<SettingTimepickerScreen> {
  OperationTime selectedOperationTime = OperationTime.TIME_OF_DAY;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Time"),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Column(
          children: <Widget>[
            CustomRadioField(
              title: "",
              radioList: ListView(
                shrinkWrap: true,
                children: OperationTime.values.map((operationTime) {
                  return RadioListTile(
                    value: operationTime,
                    title: Text(operationTime
                        .toString()
                        .toLowerCase()
                        .split('.')[1]
                        .replaceAllMapped('_', (_) => ' ')
                        .split(' ')
                        .map((word) =>
                            "${word.replaceFirst(RegExp(r'.', dotAll: true), word[0].toUpperCase())}")
                        .join(' ')),
                    groupValue: selectedOperationTime,
                    onChanged: (val) {
                      setState(() {
                        selectedOperationTime = val;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            if (selectedOperationTime == OperationTime.TIME_OF_DAY)
              TimeOfDayFields(),
            if (selectedOperationTime == OperationTime.AMBIENT) AmbientFields(),
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

enum AmbientLight {
  DAY_ONLY,
  NIGHT_ONLY,
  DAY_AND_TWILIGHT,
  NIGHT_AND_TWILIGHT,
}

class AmbientFields extends StatefulWidget {
  @override
  _AmbientFieldsState createState() => _AmbientFieldsState();
}

class _AmbientFieldsState extends State<AmbientFields> {
  AmbientLight selectedLightMode = AmbientLight.DAY_ONLY;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 24),
        CustomRadioField(
          title: "Ambient Light Options",
          radioList: ListView(
            shrinkWrap: true,
            children: AmbientLight.values.map((light) {
              return RadioListTile(
                value: light,
                title: Text(light
                    .toString()
                    .split('.')[1]
                    .replaceAllMapped('_', (_) => ' ')),
                groupValue: selectedLightMode,
                onChanged: (val) {
                  setState(() {
                    selectedLightMode = val;
                  });
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
