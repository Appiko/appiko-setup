import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/models/generic/setting.dart';
import 'package:setup/core/services/sense_be_rx_service.dart';
import 'package:setup/core/services/shared_prefs.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/widgets/custom_app_bar.dart';
import 'package:setup/ui/widgets/half_press_field.dart';
import 'package:setup/ui/widgets/page_navigation_bar.dart';

/// {@category Page}
/// {@category SenseBeRx}
/// {@category Design}
///
/// Half press settings configuration screen.
class HalfPressSettingsView extends StatefulWidget {
  final Setting setting;

  const HalfPressSettingsView({Key key, this.setting}) : super(key: key);

  @override
  _HalfPressSettingsViewState createState() => _HalfPressSettingsViewState();
}

class _HalfPressSettingsViewState extends State<HalfPressSettingsView> {
  TextEditingController halfPressController = TextEditingController();
  var _halfPressFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<SharedPrefs>(context).darkTheme;
    return Scaffold(
      backgroundColor: isDark ? null : Colors.white,
      appBar: CustomAppBar(
        title: "Half press",
        downArrow: true,
        onDownArrowPressed: () {
          // Provider.of<SenseBeRxService>(context).closeFlow();
          // String popUntilName = Provider.of<SenseBeRxService>(context)
          //     .getCameraSettingDownArrowPageName();
          // Navigator.popUntil(context, ModalRoute.withName(popUntilName));
          locator<SenseBeRxService>().handleDownArrowPress(context);
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
                  key: _halfPressFormKey,
                  child: HalfPressField(controller: halfPressController))),
        ),
      ),
      bottomNavigationBar: PageNavigationBar(
        showNext: true,
        showPrevious: true,
        onNext: () {
          if (_halfPressFormKey.currentState.validate()) {
            Provider.of<SenseBeRxService>(context).setHalfPress(
                halfPressDuration: double.tryParse(halfPressController.text));
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
          Navigator.popAndPushNamed(context, "/br/camera-trigger-options");
        },
      ),
    );
  }
}
