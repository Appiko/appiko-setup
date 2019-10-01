// TODO: Place file in proper path

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/models/devices/sense_be_rx/1.0/camera.dart';
import 'package:setup/core/services/sense_be_rx_service.dart';
import 'package:setup/core/services/shared_prefs.dart';
import 'package:setup/core/view_models/camera_trigger_radio_options_model.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/devices/sense_be_rx/1.0/settings/setting_timepicker_screen.dart';
import 'package:setup/ui/widgets/camera_trigger_radio_options.dart';
import 'package:setup/ui/widgets/custom_app_bar.dart';
import 'package:setup/ui/widgets/page_navigation_bar.dart';

/// {@category Page}
/// {@category SenseBeRx}
/// {@category Design}
///
/// Page to select camera options.
/// Uses [CameraTriggerRadioOptions]
class CameraTriggerView extends StatelessWidget {
  final bool passSetting;
  CameraAction previouslySelectedOption;
  CameraTriggerView({Key key, this.passSetting = false}) : super(key: key) {
    previouslySelectedOption =
        locator<CameraTriggerRadioOptionsModel>().selectedAction;
  }
  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<SharedPrefs>(context).darkTheme;
    return Scaffold(
      backgroundColor: isDark ? null : Colors.white,
      appBar: CustomAppBar(
        title: "Camera Trigger",
        downArrow: true,
        onDownArrowPressed: () {
          // Provider.of<SenseBeRxService>(context).closeFlow();
          // String popUntilName = Provider.of<SenseBeRxService>(context)
          //     .getCameraSettingDownArrowPageName();
          // Navigator.popUntil(context, ModalRoute.withName(popUntilName));
          locator<SenseBeRxService>().handleDownArrowPress(context);
        },
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: CameraTriggerRadioOptions() ?? Container(),
          ),
          PageNavigationBar(
            showNext: true,
            showPrevious: true,
            onPrevious: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingTimepickerScreen(),
                  ));
            },
            onNext: () {
              if (Provider.of<CameraTriggerRadioOptionsModel>(context)
                          .selectedAction !=
                      previouslySelectedOption ||
                  !passSetting) {
                Provider.of<SenseBeRxService>(context).setCameraOption();
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Provider.of<SenseBeRxService>(context)
                      .getSelectedActionSettingsView(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
