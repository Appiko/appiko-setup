import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/models/devices/sense_pi/1.0/sense_pi.dart';
import 'package:setup/core/models/generic/camera.dart';
import 'package:setup/core/models/generic/setting.dart';
import 'package:setup/core/services/sense_pi_service.dart';
import 'package:setup/core/services/shared_prefs.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/widgets/advanced_option_tile.dart';
import 'package:setup/ui/widgets/advanced_option_wrapper.dart';
import 'package:setup/ui/widgets/custom_app_bar.dart';
import 'package:setup/ui/widgets/custom_divider.dart';
import 'package:setup/ui/widgets/custom_dropdown_button.dart';
import 'package:setup/ui/widgets/custom_switch_field.dart';
import 'package:setup/ui/widgets/dual_text_field.dart';
import 'package:setup/ui/widgets/page_navigation_bar.dart';
import 'package:setup/ui/widgets/single_text_field.dart';
import 'package:setup/ui/widgets/trigger_pulse_duration_fields.dart';

/// {@category Page}
/// {@category Design}
/// {@category SensePi}
///
/// Video settings configuration screen.
class VideoSettingsView extends StatefulWidget {
  final Setting setting;

  const VideoSettingsView({Key key, this.setting}) : super(key: key);

  @override
  _VideoSettingsViewState createState() => _VideoSettingsViewState();
}

class _VideoSettingsViewState extends State<VideoSettingsView> {
  bool localAdvancedOption = locator<SharedPrefs>().advancedOptions;
  // TODO: Can pass default values from here!
  TextEditingController t1Controller = TextEditingController();
  TextEditingController t2Controller = TextEditingController();
  TextEditingController triggerPulseDurationController =
      TextEditingController();
  TextEditingController halfPressPulseDurationController =
      TextEditingController();
  TextEditingController extensionTimeController =
      TextEditingController(text: "0");
  TextEditingController numberOfExtensionsController =
      TextEditingController(text: "0");
  bool isVideoOnFullPress = false;
  var _videoFormKey = GlobalKey<FormState>();

  bool extendVideos = false;

  bool firstBuild = true;

  @override
  Widget build(BuildContext context) {
    if (firstBuild &&
        widget.setting?.cameraSetting?.runtimeType == VideoSetting) {
      t1Controller.text =
          ((widget.setting.cameraSetting as VideoSetting).videoDuration ~/ 600)
              .toString()
              .padLeft(2, "0");
      t2Controller.text =
          ((widget.setting.cameraSetting as VideoSetting).videoDuration %
                  100 ~/
                  10)
              .toString()
              .padLeft(2, "0");
      isVideoOnFullPress = widget.setting.cameraSetting.videoWithFullPress;

      isVideoOnFullPress =
          (widget.setting.cameraSetting as VideoSetting).videoWithFullPress;
      extendVideos =
          (widget.setting.cameraSetting as VideoSetting).numberOfExtensions == 0
              ? false
              : true;
      if (extendVideos) {
        numberOfExtensionsController.text =
            (widget.setting.cameraSetting as VideoSetting)
                .numberOfExtensions
                .toString();
        extensionTimeController.text =
            ((widget.setting.cameraSetting as VideoSetting).extensionTime ~/ 10)
                .toString();
      }
      triggerPulseDurationController.text =
          (widget.setting.cameraSetting.triggerPulseDuration / 10).toString();

      halfPressPulseDurationController.text =
          (widget.setting.cameraSetting.preFocusPulseDuration / 10).toString();
      localAdvancedOption = Provider.of<SensePiService>(context)
          .metaStructure
          .advancedOptionsEnabled[widget.setting.index];
      firstBuild = false;
    }

    bool isDark = Provider.of<SharedPrefs>(context).darkTheme;
    return Scaffold(
      backgroundColor: isDark ? null : Colors.white,
      appBar: CustomAppBar(
        title: "Video",
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
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Form(
              key: _videoFormKey,
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
                                (locator<PiSetting>()
                                            .cameraSetting
                                            .triggerPulseDuration /
                                        10)
                                    .toString();
                            halfPressPulseDurationController.text =
                                (locator<PiSetting>()
                                            .cameraSetting
                                            .preFocusPulseDuration /
                                        10)
                                    .toString();
                            isVideoOnFullPress = true;
                            Scaffold.of(context).showSnackBar(
                                locator<SensePiService>()
                                    .advancedSettingOffSnackbar);
                          }
                          extendVideos = extendVideos;
                          locator<SensePiService>().setAdvancedOptions(value);
                          localAdvancedOption = value;
                        });
                      },
                    ),
                  ),
                  CustomDivider(),
                  DualTextField(
                    t1Controller: t1Controller,
                    t2Controller: t2Controller,
                    title: "Video duration",
                    firstFieldMax: 11,
                    firstFieldMin: 00,
                    secondFieldMax: 59,
                    secondFieldMin: 01,
                    firstFieldLabel: "minutes",
                    secondFieldLabel: "seconds",
                  ),
                  AdvancedOptionWrapper(
                    advancedOptionController: localAdvancedOption,
                    child: CustomDropdownButton(
                      isColumn: true,
                      title: "Video starts/stops on",
                      description:
                          "Start or stop recording video on full press or half press?",
                      // radioList: ListView(
                      //   physics: NeverScrollableScrollPhysics(),
                      //   shrinkWrap: true,
                      //   padding: EdgeInsets.all(0),
                      //   children: <Widget>[
                      //     RadioListTile(
                      //       title: Text("Full Press"),
                      //       value: true,
                      //       groupValue: isVideoOnFullPress,
                      //       onChanged: (bool value) {
                      //         setState(() {
                      //           isVideoOnFullPress = value;
                      //         });
                      //       },
                      //     ),
                      //     RadioListTile(
                      //       title: Text("Half Press"),
                      //       value: false,
                      //       groupValue: isVideoOnFullPress,
                      //       onChanged: (bool value) {
                      //         setState(() {
                      //           isVideoOnFullPress = value;
                      //         });
                      //       },
                      dropdownButton: DropdownButton(
                        isExpanded: true,
                        value: isVideoOnFullPress,
                        items: [
                          DropdownMenuItem(
                            child: Text("Full Press"),
                            value: true,
                          ),
                          DropdownMenuItem(
                            child: Text("Half Press"),
                            value: false,
                          )
                        ],
                        onChanged: (value) {
                          setState(() {
                            isVideoOnFullPress = value;
                          });
                        },
                      ),
                    ),
                  ),
                  // ],
                  // ),
                  // ),
                  Provider.of<SensePiService>(context)
                              .activeTriggerType
                              .index ==
                          0
                      ? Column(
                          children: <Widget>[
                            CustomSwitchField(
                              title: "Extend videos",
                              description:
                                  "Extend video recording in case of motion",
                              materialSwitch: Switch.adaptive(
                                value: extendVideos,
                                onChanged: (val) {
                                  setState(() {
                                    extendVideos = val;
                                  });
                                  if (val) {
                                    extensionTimeController.text = '10';
                                    numberOfExtensionsController.text = '1';
                                  } else {
                                    extensionTimeController.text = '0';
                                    numberOfExtensionsController.text = '0';
                                  }
                                },
                              ),
                            ),

                            /// Here we are using the advanced option wrapper to hide the extension fields
                            AdvancedOptionWrapper(
                              advancedOptionController: extendVideos,
                              child: SingleTextField(
                                title: "Extension Time",
                                description:
                                    "Extends the video if the sensor detects movement after the downtime",
                                textField: TextFormField(
                                  decoration: InputDecoration(
                                    helperText: "1 to 250 seconds",
                                    labelText: "seconds",
                                  ),
                                  controller: extensionTimeController,
                                  keyboardType: TextInputType.number,
                                  buildCounter: (_,
                                          {int currentLength,
                                          int maxLength,
                                          bool isFocused}) =>
                                      null,
                                  validator: (str) {
                                    int n = int.tryParse(str);
                                    if (n == null) {
                                      return "Cannot be empty";
                                    }
                                    if (n < 1 || n > 250) {
                                      return "Not in valid range";
                                    }
                                    return null;
                                  },
                                  maxLength: 3,
                                  autovalidate: true,
                                ),
                              ),
                            ),
                            AdvancedOptionWrapper(
                                advancedOptionController: extendVideos,
                                child: SingleTextField(
                                  title: "Max number of extensions",
                                  description:
                                      "Maximum number of times to extend videos",
                                  textField: TextFormField(
                                    decoration: InputDecoration(
                                      helperText: "1 to 250 extensions",
                                      labelText: "extensions",
                                    ),
                                    controller: numberOfExtensionsController,
                                    buildCounter: (_,
                                            {int currentLength,
                                            int maxLength,
                                            bool isFocused}) =>
                                        null,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: false),
                                    validator: (str) {
                                      if (str.isEmpty ||
                                          (str.contains(".") &&
                                              str.length == 1)) {
                                        return "Cannot be empty";
                                      }
                                      int n = double.tryParse(str).floor();
                                      if (n == null) {
                                        return "Cannot be empty";
                                      }
                                      if (n < 1 || n > 250) {
                                        return "Not in valid range";
                                      }
                                      return null;
                                    },
                                    maxLength: 3,
                                    autovalidate: true,
                                  ),
                                )),
                          ],
                        )
                      : Container(),
                  TriggerPulseDuration(
                    isVideo: true,
                    triggerPulseDurationController:
                        triggerPulseDurationController,
                    localAdvancedOption: localAdvancedOption,
                  ),
                  // HalfPress(
                  //   halfPressPulseDurationController:
                  //       halfPressPulseDurationController,
                  //   localAdvancedOption: localAdvancedOption,
                  // ),
                  SizedBox(height: 60),
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
          if (_videoFormKey.currentState.validate()) {
            Provider.of<SensePiService>(context).setVideo(
              triggerPulseDuration:
                  double.tryParse(triggerPulseDurationController.text),
              halfPressDuration:
                  double.tryParse(halfPressPulseDurationController.text),
              videoDuration: Duration(
                minutes: double.tryParse(t1Controller.text).floor(),
                seconds: double.tryParse(t2Controller.text).floor(),
              ),
              extendVideos: extendVideos,
              numberOfExtensions:
                  double.tryParse(numberOfExtensionsController.text).floor(),
              extensionTime:
                  double.tryParse(extensionTimeController.text).floor(),
              isVideoOnFullPress: isVideoOnFullPress,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Provider.of<SensePiService>(context).getSensorView(),
              ),
            );
          }
        },
        onPrevious: () {
          Navigator.popAndPushNamed(context, "/sp/camera-trigger-options");
        },
      ),
    );
  }
}
