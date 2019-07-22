import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:setup/ui/widgets/ambient_fields.dart';
import 'package:setup/ui/widgets/custom_app_bar.dart';
import 'package:setup/ui/widgets/custom_radio_field.dart';
import 'package:setup/ui/widgets/page_navigation_bar.dart';
import 'package:setup/ui/widgets/time_of_day_fields.dart';

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
