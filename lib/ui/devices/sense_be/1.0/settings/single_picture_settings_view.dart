import 'package:flutter/material.dart';
import 'package:setup/ui/widgets/advanced_option_tile.dart';
import 'package:setup/ui/widgets/advanced_option_wrapper.dart';
import 'package:setup/ui/widgets/custom_app_bar.dart';
import 'package:setup/ui/widgets/custom_switch_field.dart';
import 'package:setup/ui/widgets/page_navigation_bar.dart';
import 'package:setup/ui/widgets/single_text_field.dart';

class SinglePictureSettingsViewe extends StatefulWidget {
  @override
  _SinglePictureSettingsVieweState createState() =>
      _SinglePictureSettingsVieweState();
}

class _SinglePictureSettingsVieweState
    extends State<SinglePictureSettingsViewe> {
  var x = false;
  bool advancedOption = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Single Picture",
        downArrow: true,
        onDownArrowPressed: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
        child: Column(
          children: <Widget>[
            AdvancedOptionTile(
              value: advancedOption,
              onChanged: (bool value) {
                setState(() {
                  advancedOption = value;
                });
              },
            ),
            AdvancedOptionWrapper(
              advancedOptionController: advancedOption,
              child: SingleTextField(
                title: "Tirgger pulse duration*",
                description: "Duration of trigger pulse for the picture",
                textField: TextField(
                  decoration: InputDecoration(
                    labelText: "seconds",
                    helperText: "0.2s to 25.0s",
                  ),
                  autofocus: true,
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                ),
              ),
            ),
            CustomSwitchField(
              title: "Half press",
              description: "Do you want to half press (focus) before trigger?",
              materialSwitch: Switch.adaptive(
                onChanged: (val) {
                  setState(() {
                    x = val;
                  });
                },
                value: x,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PageNavigationBar(
        showPrevious: true,
        showNext: true,
        onPrevious: () {
          Navigator.pop(context);
        },
        onNext: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
