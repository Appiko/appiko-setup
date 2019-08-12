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
import 'package:setup/ui/widgets/dual_text_field.dart';
import 'package:setup/ui/widgets/half_press.dart';
import 'package:setup/ui/widgets/page_navigation_bar.dart';
import 'package:setup/ui/widgets/trigger_pulse_duration_fields.dart';

class LongPressSettingsView extends StatefulWidget {
  Setting setting;

  LongPressSettingsView({Key key, this.setting}) : super(key: key);

  @override
  _LongPressSettingsViewState createState() => _LongPressSettingsViewState();
}

class _LongPressSettingsViewState extends State<LongPressSettingsView> {
  bool localAdvancedOption = locator<SharedPrefs>().advancedOptions;
  TextEditingController t1Controller = TextEditingController();
  TextEditingController t2Controller = TextEditingController();

  TextEditingController halfPressPulseDurationController =
      TextEditingController();

  /// Consider widget setting(if passed) only for fistbuild
  bool firstBuild = true;

  var _longPressFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<SharedPrefs>(context).darkTheme;

    if (firstBuild &&
        widget.setting?.cameraSetting?.runtimeType == LongPressSetting) {
      t1Controller.text = ((widget.setting.cameraSetting as LongPressSetting)
                  .longPressDuration ~/
              600)
          .toString()
          .padLeft(2, "0");
      t2Controller.text = ((widget.setting.cameraSetting as LongPressSetting)
                  .longPressDuration %
              100 ~/
              10)
          .toString()
          .padLeft(2, "0");

      halfPressPulseDurationController.text =
          (widget.setting.cameraSetting.preFocusPulseDuration / 10).toString();
      localAdvancedOption = Provider.of<SenseBeRxService>(context)
          .metaStructure
          .advancedOptionsEnabled[widget.setting.index];
      firstBuild = false;
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: "Long press",
        downArrow: true,
        onDownArrowPressed: () {
          Provider.of<SenseBeRxService>(context).closeFlow();
          String popUntilName = Provider.of<SenseBeRxService>(context)
              .getCameraSettingDownArrowPageName();
          Navigator.popUntil(context, ModalRoute.withName(popUntilName));
        },
      ),
      backgroundColor: isDark ? null : Colors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Form(
              key: _longPressFormKey,
              child: Column(
                children: <Widget>[
                  Builder(
                    builder: (context) => AdvancedOptionTile(
                      value: localAdvancedOption,
                      onChanged: (bool value) {
                        setState(() {
                          // if advanced option turnedoff
                          if (!value) {
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
                  DualTextField(
                    t1Controller: t1Controller,
                    t2Controller: t2Controller,
                    title: "Long press duration",
                    description:
                        "Duration of trigger pulse, usually for bulb mode in the camera",
                    firstFieldMax: 1439,
                    firstFieldMin: 0,
                    secondFieldMax: 59,
                    secondFieldMin: 1,
                    firstFieldLabel: "minutes",
                    secondFieldLabel: "seconds",
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
          if (_longPressFormKey.currentState.validate()) {
            Provider.of<SenseBeRxService>(context).setLongPress(
              halfPressDuration:
                  double.tryParse(halfPressPulseDurationController.text),
              longPressDuration: Duration(
                minutes: int.tryParse(t1Controller.text),
                seconds: double.tryParse(t2Controller.text).floor(),
                milliseconds: int.tryParse((double.tryParse(t2Controller.text))
                        .toString()
                        .split(".")[1]
                        .split("")[0]) *
                    100,
              ),
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
