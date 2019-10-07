import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/models/devices/sense_be_tx/1.0/sense_be_tx.dart';
import 'package:setup/core/models/generic/camera.dart';
import 'package:setup/core/models/generic/setting.dart';
import 'package:setup/core/services/sense_be_tx_service.dart';
import 'package:setup/core/services/shared_prefs.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/widgets/advanced_option_tile.dart';
import 'package:setup/ui/widgets/custom_app_bar.dart';
import 'package:setup/ui/widgets/custom_divider.dart';
import 'package:setup/ui/widgets/half_press.dart';
import 'package:setup/ui/widgets/page_navigation_bar.dart';
import 'package:setup/ui/widgets/trigger_pulse_duration_fields.dart';

/// {@category Page}
/// {@category SenseBeTx}
/// {@category Design}
///
/// Single picture configuration screen.
class SinglePictureSettingsView extends StatefulWidget {
  // Accepts setting as a parameter, to prefill fields with actual setting values.
  final Setting setting;

  const SinglePictureSettingsView({Key key, this.setting}) : super(key: key);

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

  var siglePictureFormKey = GlobalKey<FormState>();

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
      localAdvancedOption = Provider.of<SenseBeTxService>(context)
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
          // Provider.of<SenseBeTxService>(context).closeFlow();
          // String popUntilName = Provider.of<SenseBeTxService>(context)
          //     .getCameraSettingDownArrowPageName();
          // Navigator.popUntil(context, ModalRoute.withName(popUntilName));
          locator<SenseBeTxService>().handleDownArrowPress(context);
          // siglePictureFormKey.currentState.validate()
          //     ? print("dsa")
          //     : print("nooooo");

          // downArrowPress();
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
              key: siglePictureFormKey,
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
                                (locator<BeTxSetting>()
                                            .cameraSetting
                                            .triggerPulseDuration /
                                        10)
                                    .toString();
                            halfPressPulseDurationController.text =
                                (locator<BeTxSetting>()
                                            .cameraSetting
                                            .preFocusPulseDuration /
                                        10)
                                    .toString();
                            Scaffold.of(context).showSnackBar(
                                locator<SenseBeTxService>()
                                    .advancedSettingOffSnackbar);
                          }
                          locator<SenseBeTxService>().setAdvancedOptions(value);
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
          Navigator.popAndPushNamed(context, "/br/camera-trigger-options");
        },
        onNext: () {
          if (siglePictureFormKey.currentState.validate()) {
            setSinglePicture();
            Widget view = Provider.of<SenseBeTxService>(context)
                .getSensorView(context: context);
            if (view != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => view,
                ),
              );
            }
          }
        },
      ),
    );
  }

  void setSinglePicture() {
    locator<SenseBeTxService>().setSinglePicture(
      triggerPulseDuration:
          double.tryParse(triggerPulseDurationController.text),
      halfPressDuration: double.tryParse(halfPressPulseDurationController.text),
    );
  }

  // void downArrowPress() {
  //   var shouldPassSetting = locator<SenseBeTxService>().shouldPassSetting;
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: Text(shouldPassSetting
  //           ? "Do you make to save changes before closing?"
  //           : "Do you want to discard the config setting?"),
  //       actions: <Widget>[
  //         FlatButton(
  //             child: Text(
  //               "CANCEL",
  //               style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 color: Theme.of(context).primaryColorLight,
  //               ),
  //             ),
  //             onPressed: shouldPassSetting
  //                 ? () {
  //                     // TODO:
  //                     // closeChangeFlow();
  //                     Navigator.popUntil(
  //                       context,
  //                       ModalRoute.withName(
  //                         '/devices/sense-be-rx/setting-summary',
  //                       ),
  //                     );
  //                   }
  //                 : () {
  //                     Navigator.pop(context);
  //                   }),
  //         FlatButton(
  //           child: Text(
  //             shouldPassSetting ? "SAVE" : "DISCARD",
  //             style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           onPressed: shouldPassSetting
  //               ? siglePictureFormKey.currentState.validate()
  //                   ? () {
  //                       // updateSetting();

  //                       setSinglePicture();
  //                       Navigator.popUntil(
  //                         context,
  //                         ModalRoute.withName(
  //                             '/devices/sense-be-rx/setting-summary'),
  //                       );
  //                     }
  //                   : () {
  //                       SnackBar snackBar = SnackBar(
  //                         content: Text(
  //                             "Cannot save with an invalid value, please resolve the error"),
  //                       );
  //                       Scaffold.of(context).showSnackBar(snackBar);
  //                     }
  //               : () {
  //                   locator<SenseBeTxService>().closeFlow();
  //                   Navigator.popUntil(
  //                       context,
  //                       ModalRoute.withName(
  //                           '/devices/sense-be-rx/profile-summary'));
  //                 },
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
