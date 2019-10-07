import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/models/generic/setting.dart';
import 'package:setup/core/services/sense_be_tx_service.dart';
import 'package:setup/core/services/shared_prefs.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/widgets/custom_app_bar.dart';
import 'package:setup/ui/widgets/half_press_field.dart';
import 'package:setup/ui/widgets/page_navigation_bar.dart';

/// {@category Page}
/// {@category SenseBeTx}
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
          // Provider.of<SenseBeTxService>(context).closeFlow();
          // String popUntilName = Provider.of<SenseBeTxService>(context)
          //     .getCameraSettingDownArrowPageName();
          // Navigator.popUntil(context, ModalRoute.withName(popUntilName));
          locator<SenseBeTxService>().handleDownArrowPress(context);
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
            Provider.of<SenseBeTxService>(context).setHalfPress(
                halfPressDuration: double.tryParse(halfPressController.text));
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
        onPrevious: () {
          Navigator.popAndPushNamed(context, "/br/camera-trigger-options");
        },
      ),
    );
  }
}
