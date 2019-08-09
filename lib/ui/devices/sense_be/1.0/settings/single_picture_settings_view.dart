import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/models/camera.dart';
import 'package:setup/core/models/sense_be_rx.dart';
import 'package:setup/core/services/sense_be_rx_service.dart';
import 'package:setup/core/services/shared_prefs.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/widgets/advanced_option_tile.dart';
import 'package:setup/ui/widgets/custom_app_bar.dart';
import 'package:setup/ui/widgets/custom_divider.dart';
import 'package:setup/ui/widgets/half_press.dart';
import 'package:setup/ui/widgets/page_navigation_bar.dart';
import 'package:setup/ui/widgets/trigger_pulse_duration_fields.dart';

class SinglePictureSettingsView extends StatefulWidget {
  Setting setting;

  SinglePictureSettingsView({Key key, this.setting}) : super(key: key);

  @override
  _SinglePictureSettingsViewState createState() =>
      _SinglePictureSettingsViewState();
}

class _SinglePictureSettingsViewState extends State<SinglePictureSettingsView> {
  CameraSetting setting = CameraSetting();

  TextEditingController triggerPulseDurationController =
      TextEditingController();
  TextEditingController halfPressPulseDurationController =
      TextEditingController();

  var _formKey = GlobalKey<FormState>();

  bool localAdvancedOption = locator<SharedPrefs>().advancedOptions;

  /// Consider widget setting(if passed) only for fistbuild
  bool firstBuild = true;
  @override
  Widget build(BuildContext context) {
    if (firstBuild &&
        widget.setting?.cameraSetting?.runtimeType == CameraSetting) {
      triggerPulseDurationController.text =
          (widget.setting.cameraSetting.triggerPulseDuration / 10).toString();
      halfPressPulseDurationController.text =
          (widget.setting.cameraSetting.preFocusPulseDuration / 10).toString();
      localAdvancedOption = Provider.of<SenseBeRxService>(context)
          .metaStructure
          .advancedOptionsEnabled[widget.setting.index];
      firstBuild = false;
    }
    bool darkTheme = Provider.of<SharedPrefs>(context).darkTheme;
    return Scaffold(
      backgroundColor:
          !darkTheme ? Colors.white : Theme.of(context).canvasColor,
      appBar: CustomAppBar(
        title: "Single Picture",
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
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Builder(
                    builder: (context) => AdvancedOptionTile(
                      value: localAdvancedOption,
                      onChanged: (bool value) {
                        setState(() {
                          // if advanced option turnedoff
                          if (!value) {
                            triggerPulseDurationController.text =
                                (locator<Setting>()
                                            .cameraSetting
                                            .triggerPulseDuration /
                                        10)
                                    .toString();
                            halfPressPulseDurationController.text =
                                (locator<Setting>()
                                            .cameraSetting
                                            .preFocusPulseDuration /
                                        10)
                                    .toString();
                            Scaffold.of(context).showSnackBar(
                                locator<SenseBeRxService>()
                                    .advancedSettingOffSnackbar);
                          }
                          locator<SenseBeRxService>().setAdvancedOptions(value);
                          localAdvancedOption = value;
                        });
                      },
                    ),
                  ),
                  CustomDivider(),
                  TriggerPulseDuration(
                      localAdvancedOption: localAdvancedOption,
                      triggerPulseDurationController:
                          triggerPulseDurationController),
                  HalfPress(
                      localAdvancedOption: localAdvancedOption,
                      halfPressPulseDurationController:
                          halfPressPulseDurationController),
                  SizedBox(height: 60)
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: PageNavigationBar(
        showPrevious: true,
        showNext: true,
        onPrevious: () {
          Navigator.popAndPushNamed(context, "/camera-trigger-options");
        },
        onNext: () {
          if (_formKey.currentState.validate()) {
            Provider.of<SenseBeRxService>(context).setSinglePicture(
              triggerPulseDuration:
                  double.tryParse(triggerPulseDurationController.text),
              halfPressDuration:
                  double.tryParse(halfPressPulseDurationController.text),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Provider.of<SenseBeRxService>(context).getSensorView(),
              ),
            );
          }
        },
      ),
    );
  }
}
