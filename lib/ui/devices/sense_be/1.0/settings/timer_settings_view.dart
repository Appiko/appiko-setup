import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/models/sense_be_rx.dart';
import 'package:setup/core/services/sense_be_rx_service.dart';
import 'package:setup/ui/widgets/custom_app_bar.dart';
import 'package:setup/ui/widgets/custom_switch_field.dart';
import 'package:setup/ui/widgets/dual_text_field.dart';
import 'package:setup/ui/widgets/page_navigation_bar.dart';

class TimerSettingsView extends StatefulWidget {
  Setting setting;

  TimerSettingsView({Key key, this.setting}) : super(key: key);
  @override
  _TimerSettingsViewState createState() => _TimerSettingsViewState();
}

class _TimerSettingsViewState extends State<TimerSettingsView> {
  TextEditingController t1Controller = TextEditingController();
  TextEditingController t2Controller = TextEditingController();

  var _timerFormKey = GlobalKey<FormState>();

  bool isRadioEnabled = false;

  bool firstBuild = true;

  _TimerSettingsViewState();

  @override
  Widget build(BuildContext context) {
    if (firstBuild &&
        widget.setting?.sensorSetting?.runtimeType == TimerSetting) {
      t1Controller.text =
          ((widget.setting.sensorSetting as TimerSetting).interval ~/ 600)
              .toString()
              .padLeft(2, "0");
      t2Controller.text =
          ((widget.setting.sensorSetting as TimerSetting).interval % 600 / 10)
              .toString()
              .padLeft(2, "0");
      isRadioEnabled = widget.setting.cameraSetting.enableRadio;
      firstBuild = false;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Timer",
        downArrow: true,
        onDownArrowPressed: () {
          Provider.of<SenseBeRxService>(context).closeFlow();
          String popUntilName = Provider.of<SenseBeRxService>(context)
              .getCameraSettingDownArrowPageName();
          Navigator.popUntil(context, ModalRoute.withName(popUntilName));
        },
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Form(
              key: _timerFormKey,
              child: Column(
                children: <Widget>[
                  DualTextField(
                    t1Controller: t1Controller,
                    t2Controller: t2Controller,
                    title: "Interval",
                    secondFieldValue: 01,
                    description: "Interval between timer events",
                    firstFieldLabel: "minutes",
                    secondFieldLabel: "seconds",
                    firstFieldMax: 1439,
                    secondFieldMax: 59,
                    firstFieldMin: 00,
                    secondFieldMin: 0.5,
                  ),
                  SizedBox(height: 60)
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: PageNavigationBar(
        showNext: true,
        showPrevious: true,
        nextLabel: "DONE",
        onNext: () {
          if (_timerFormKey.currentState.validate()) {
            Provider.of<SenseBeRxService>(context).setTimer(
              interval: Duration(
                minutes: int.tryParse(t1Controller.text),
                seconds: double.tryParse(t2Controller.text).floor(),
                milliseconds: int.tryParse((double.tryParse(t2Controller.text))
                        .toString()
                        .split(".")[1]
                        .split("")[0]) *
                    100,
              ),
            );
            String popUntilName = Provider.of<SenseBeRxService>(context)
                .getCameraSettingDownArrowPageName();
            Navigator.popUntil(context, ModalRoute.withName(popUntilName));
          }
        },
        onPrevious: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Provider.of<SenseBeRxService>(context)
                  .getSelectedActionSettingsView(),
            ),
          );
        },
      ),
    );
  }
}
