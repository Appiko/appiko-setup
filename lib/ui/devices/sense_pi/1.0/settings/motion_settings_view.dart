import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/models/devices/sense_be_rx/1.0/sense_be_rx.dart';
import 'package:setup/core/models/generic/setting.dart';
import 'package:setup/core/services/sense_pi_service.dart';
import 'package:setup/core/services/shared_prefs.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/widgets/custom_app_bar.dart';
import 'package:setup/ui/widgets/custom_slider.dart';
import 'package:setup/ui/widgets/page_navigation_bar.dart';
import 'package:setup/ui/widgets/single_text_field.dart';

/// {@category Page}
/// {@category SensePi}
/// {@category Design}
///
/// Motion settings configuration screen.
class MotionSettingsView extends StatefulWidget {
  final Setting setting;

  MotionSettingsView({Key key, this.setting, @required device})
      : super(key: key);
  @override
  _MotionSettingsViewState createState() => _MotionSettingsViewState();
}

class _MotionSettingsViewState extends State<MotionSettingsView> {
  double sensitivity = 2;

  var _motionFormKey = GlobalKey<FormState>();

  TextEditingController numberOfTriggersController =
      TextEditingController(text: "1");
  TextEditingController downtimeController = TextEditingController(text: "1");

  bool isRadioEnabled = false;

  bool firstBuild = true;
  @override
  Widget build(BuildContext context) {
    if (firstBuild &&
        widget.setting?.sensorSetting?.runtimeType == MotionSetting) {
      numberOfTriggersController.text =
          (widget.setting.sensorSetting as MotionSetting)
              .numberOfTriggers
              .toString();
      downtimeController.text =
          ((widget.setting.sensorSetting as MotionSetting).downtime ~/ 10)
              .toString();
      sensitivity =
          (widget.setting.sensorSetting as MotionSetting).sensitivity + 0.0;

      isRadioEnabled = widget.setting.cameraSetting.enableRadio;
      firstBuild = false;
    }
    bool isDark = Provider.of<SharedPrefs>(context).darkTheme;
    return Scaffold(
      backgroundColor: isDark ? null : Colors.white,
      appBar: CustomAppBar(
        title: "Motion",
        downArrow: true,
        onDownArrowPressed: () {
          // Provider.of<SensePiService>(context).closeFlow();
          // String popUntilName = Provider.of<SensePiService>(context)
          //     .getCameraSettingDownArrowPageName();
          // Navigator.popUntil(context, ModalRoute.withName(popUntilName));
          locator<SensePiService>().handleDownArrowPress(context);
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
              key: _motionFormKey,
              child: Column(
                children: <Widget>[
                  CustomSlider(
                    title: "Sensitivity",
                    description:
                        "Configure the number of beam pulses that need to be missed to trigger.",
                    slider: Slider.adaptive(
                      label: "${sensitivity.toString().split(".")[0]} / 6",
                      onChanged: (val) {
                        setState(() {
                          sensitivity = val;
                        });
                      },
                      value: sensitivity,
                      activeColor: Theme.of(context).accentColor,
                      inactiveColor:
                          Theme.of(context).accentColor.withAlpha(100),
                      divisions: 5,
                      min: 1,
                      max: 6,
                    ),
                  ),
                  SingleTextField(
                    title: "Downtime",
                    description:
                        "Once motion is detected, how long should the sensor be switched off?",
                    textField: TextFormField(
                      controller: downtimeController,
                      decoration: InputDecoration(
                        labelText: "seconds",
                        helperText: "0.1s to 600.0s",
                      ),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (str) {
                        var downtime = double.tryParse(str);
                        if (downtime == null) {
                          return "Cannot be empty";
                        }
                        if (downtime < 0.1 || downtime > 600.0) {
                          return "Not in range";
                        }
                        return null;
                      },
                      autovalidate: true,
                    ),
                  ),
                  // CustomSwitchField(
                  //   title: "Radio",
                  //   description:
                  //       "Communicate the trigger wirelessly to other devices",
                  //   materialSwitch: Switch.adaptive(
                  //     value: isRadioEnabled,
                  //     onChanged: (val) {
                  //       setState(() {
                  //         isRadioEnabled = val;
                  //       });
                  //     },
                  //   ),
                  // ),
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
        nextLabel: "SAVE",
        onNext: () {
          if (_motionFormKey.currentState.validate()) {
            Provider.of<SensePiService>(context).setMotion(
              sensitivity: sensitivity,
              downtime: double.tryParse(downtimeController.text),
            );
            Provider.of<SensePiService>(context).setRadio(isRadioEnabled);
            String popUntilName =
                locator<SensePiService>().getCameraSettingDownArrowPageName();
            Navigator.popUntil(context, ModalRoute.withName(popUntilName));
          }
        },
        onPrevious: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Provider.of<SensePiService>(context)
                  .getSelectedActionSettingsView(),
            ),
          );
        },
      ),
    );
  }
}
