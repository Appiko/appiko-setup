import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/models/sense_be_rx.dart';
import 'package:setup/core/services/sense_be_rx_service.dart';
import 'package:setup/core/services/shared_prefs.dart';
import 'package:setup/core/view_models/time_of_day_fields_model.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/devices/sense_be/1.0/settings/camera_trriger_view.dart';
import 'package:setup/ui/widgets/ambient_fields.dart';
import 'package:setup/ui/widgets/custom_app_bar.dart';
import 'package:setup/ui/widgets/custom_radio_field.dart';
import 'package:setup/ui/widgets/page_navigation_bar.dart';
import 'package:setup/ui/widgets/time_of_day_fields.dart';

class SettingTimepickerScreen extends StatefulWidget {
  @override
  _SettingTimepickerScreenState createState() =>
      _SettingTimepickerScreenState();
}

class _SettingTimepickerScreenState extends State<SettingTimepickerScreen> {
  OperationTime localSelectedOperationTime =
      locator<SenseBeRxService>().operationTimeToSet;

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<SharedPrefs>(context).darkTheme;

    /// TODO: #RENAME
    int operationTimeIndex =
        Provider.of<SenseBeRxService>(context).operationTimeIndex;

    // null / None
    OperationTime selectedOperationTime = Provider.of<SenseBeRxService>(context)
        .structure
        .operationTime[operationTimeIndex];

    // if (selectedOperationTime == null) {
    //   localSelectedOperationTime =
    //       Provider.of<SenseBeRxService>(context).operationTimeToSet;
    // }

    return WillPopScope(
      onWillPop: () async {
        Provider.of<SenseBeRxService>(context).closeFlow();

        String popUntilName = Provider.of<SenseBeRxService>(context)
            .getCameraSettingDownArrowPageName();
        Navigator.popUntil(context, ModalRoute.withName(popUntilName));
        return false;
      },
      child: Scaffold(
        backgroundColor: isDark ? null : Colors.white,
        appBar: CustomAppBar(title: "Time"),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomRadioField(
                  description: !(selectedOperationTime == OperationTime.NONE ||
                          selectedOperationTime == null)
                      ? "Only \"${selectedOperationTime.toString().toLowerCase().split('.')[1].replaceAllMapped('_', (_) => ' ').split(' ').join(" ").toUpperCase()}\" is enabled as it was selected previously"
                      : "",
                  radioList: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: OperationTime.values.map((operationTime) {
                      if (operationTime == OperationTime.NONE) {
                        return Container();
                      }
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
                        groupValue:
                            (selectedOperationTime == OperationTime.NONE ||
                                    selectedOperationTime == null)
                                ? localSelectedOperationTime
                                : selectedOperationTime,
                        onChanged: ((operationTime != selectedOperationTime) &&
                                !(selectedOperationTime == OperationTime.NONE ||
                                    selectedOperationTime == null))
                            // false
                            ? null
                            : (val) {
                                setState(() {
                                  localSelectedOperationTime = val;
                                });
                              },
                      );
                    }).toList(),
                  ),
                ),
                if (selectedOperationTime == OperationTime.TIME_OF_DAY ||
                    ((selectedOperationTime == null ||
                            selectedOperationTime == OperationTime.NONE) &&
                        localSelectedOperationTime ==
                            OperationTime.TIME_OF_DAY))
                  TimeOfDayFields(),
                if (selectedOperationTime == OperationTime.AMBIENT ||
                    ((selectedOperationTime == null ||
                            selectedOperationTime == OperationTime.NONE) &&
                        localSelectedOperationTime == OperationTime.AMBIENT))
                  AmbientFields(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: PageNavigationBar(
          showNext: true,
          showPrevious: false,
          onNext: (Provider.of<TimeOfDayFieldsModel>(context).timeOverlap &&
                  ((selectedOperationTime == null ||
                              selectedOperationTime == OperationTime.NONE)
                          ? localSelectedOperationTime
                          : selectedOperationTime) ==
                      OperationTime.TIME_OF_DAY)
              ? null
              : () {
                  locator<SenseBeRxService>().setTime(
                      (selectedOperationTime == null ||
                              selectedOperationTime == OperationTime.NONE)
                          ? localSelectedOperationTime
                          : selectedOperationTime);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CameraTriggerView()));
                },
        ),
      ),
    );
  }
}
