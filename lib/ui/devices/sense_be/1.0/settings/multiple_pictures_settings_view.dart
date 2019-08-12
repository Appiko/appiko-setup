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
import 'package:setup/ui/widgets/single_text_field.dart';
import 'package:setup/ui/widgets/trigger_pulse_duration_fields.dart';

class MultiplePicturesSettingsView extends StatefulWidget {
  Setting setting;

  MultiplePicturesSettingsView({Key key, this.setting}) : super(key: key);

  @override
  _MultiplePicturesSettingsViewState createState() =>
      _MultiplePicturesSettingsViewState();
}

class _MultiplePicturesSettingsViewState
    extends State<MultiplePicturesSettingsView> {
  bool localAdvancedOption = locator<SharedPrefs>().advancedOptions;
  TextEditingController triggerPulseDurationController =
      TextEditingController();
  TextEditingController halfPressPulseDurationController =
      TextEditingController();
  TextEditingController pictureIntervalController =
      TextEditingController(text: "1");
  TextEditingController numberOfPicturesController =
      TextEditingController(text: "2");

  var _multiplePicturesFormKey = GlobalKey<FormState>();

  bool firstBuild = true;

  @override
  Widget build(BuildContext context) {
    if (firstBuild &&
        widget.setting?.cameraSetting?.runtimeType == MultiplePicturesSetting) {
      numberOfPicturesController.text =
          (widget.setting.cameraSetting as MultiplePicturesSetting)
              .numberOfPictures
              .toString();
      pictureIntervalController.text =
          ((widget.setting.cameraSetting as MultiplePicturesSetting)
                      .pictureInterval /
                  10)
              .toString();
      triggerPulseDurationController.text =
          (widget.setting.cameraSetting.triggerPulseDuration / 10).toString();
      halfPressPulseDurationController.text =
          (widget.setting.cameraSetting.preFocusPulseDuration / 10).toString();
      localAdvancedOption = Provider.of<SenseBeRxService>(context)
          .metaStructure
          .advancedOptionsEnabled[widget.setting.index];
      firstBuild = false;
    }
    bool isDark = Provider.of<SharedPrefs>(context).darkTheme;
    return Scaffold(
      backgroundColor: isDark ? null : Colors.white,
      appBar: CustomAppBar(
        title: "Multiple Pictures",
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
              key: _multiplePicturesFormKey,
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
                  SingleTextField(
                    title: "Number of pictures",
                    textField: TextFormField(
                      decoration: InputDecoration(
                        helperText: "2 to 32 pictures",
                        labelText: "pictures",
                      ),
                      controller: numberOfPicturesController,
                      keyboardType: TextInputType.number,
                      validator: (str) {
                        int n = int.tryParse(str);
                        if (n == null) {
                          return "Cannot be empty";
                        }
                        if (n < 2 || n > 32) {
                          return "Not in valid range";
                        }
                        return null;
                      },
                      maxLength: 2,
                      autovalidate: true,
                    ),
                  ),
                  SingleTextField(
                    title: "Time interval between pictures",
                    textField: TextFormField(
                      decoration: InputDecoration(
                        helperText: "0.5s to 1000.0s",
                        labelText: "seconds",
                      ),
                      controller: pictureIntervalController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (str) {
                        double interval = double.tryParse(str);
                        if (interval == null) {
                          return "Cannot be empty";
                        }
                        if (interval < 0.5 || interval > 1000) {
                          return "Not in valid range";
                        }
                        return null;
                      },
                      maxLength: 4,
                      autovalidate: true,
                    ),
                  ),
                  TriggerPulseDuration(
                    localAdvancedOption: localAdvancedOption,
                    triggerPulseDurationController:
                        triggerPulseDurationController,
                  ),
                  HalfPress(
                    halfPressPulseDurationController:
                        halfPressPulseDurationController,
                    localAdvancedOption: localAdvancedOption,
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
        onNext: () {
          if (_multiplePicturesFormKey.currentState.validate()) {
            Provider.of<SenseBeRxService>(context).setMultiplePicture(
              triggerPulseDuration:
                  double.tryParse(triggerPulseDurationController.text),
              halfPressDuration:
                  double.tryParse(halfPressPulseDurationController.text),
              picuteInterval: double.tryParse(pictureIntervalController.text),
              numberOfPictures: int.tryParse(numberOfPicturesController.text),
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
        onPrevious: () {
          Navigator.popAndPushNamed(context, "/camera-trigger-options");
        },
      ),
    );
  }
}
