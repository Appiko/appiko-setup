import 'package:flutter/material.dart';
import 'package:setup/ui/widgets/advanced_option_tile.dart';
import 'package:setup/ui/widgets/advanced_option_wrapper.dart';
import 'package:setup/ui/widgets/custom_app_bar.dart';
import 'package:setup/ui/widgets/custom_divider.dart';
import 'package:setup/ui/widgets/custom_radio_field.dart';
import 'package:setup/ui/widgets/custom_switch_field.dart';
import 'package:setup/ui/widgets/dual_text_field.dart';
import 'package:setup/ui/widgets/page_navigation_bar.dart';
import 'package:setup/ui/widgets/single_text_field.dart';

class VideoSettingsView extends StatefulWidget {
  @override
  _VideoSettingsViewState createState() => _VideoSettingsViewState();
}

class _VideoSettingsViewState extends State<VideoSettingsView> {
  bool advancedOption = false;
  bool halfPress = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Video",
        downArrow: true,
        onDownArrowPressed: () {
          Navigator.pop(context);
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
            child: Column(
              children: <Widget>[
                AdvancedOptionTile(
                  onChanged: (val) {
                    setState(() {
                      advancedOption = val;
                    });
                  },
                  value: advancedOption,
                ),
                CustomDivider(),
                DualTextField(
                  title: "Video duration",
                  firstFieldMax: 12,
                  firstFieldMin: 00,
                  secondFieldMax: 00,
                  secondFieldMin: 00,
                  firstFieldLabel: "minutes",
                  secondFieldLabel: "seconds",
                  firstFieldValue: 01,
                  secondFieldValue: 00,
                ),
                CustomRadioField(
                  title: "Video recording starts on",
                  description:
                      "Does your camera start recording video on full press or a half press?",
                  radioList: ListView(
                    padding: EdgeInsets.all(0),
                    children: <Widget>[
                      RadioListTile(
                        title: Text("Full Press"),
                        value: 0,
                        groupValue: 0,
                        onChanged: (int value) {},
                      ),
                      RadioListTile(
                        title: Text("Half Press"),
                        value: 1,
                        groupValue: 0,
                        onChanged: (int value) {},
                      ),
                    ],
                  ),
                ),
                AdvancedOptionWrapper(
                  advancedOptionController: advancedOption,
                  child: SingleTextField(
                    title: "Trigger pulse duration*",
                    description: "Duration of trigger pulse for each picture",
                    textField: TextField(
                      decoration: InputDecoration(
                          labelText: "seconds", helperText: "0.2 to 25.0s"),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ),
                CustomSwitchField(
                  title: "Half press",
                  description: "Half press (focus) before trigger event?",
                  materialSwitch: Switch.adaptive(
                    onChanged: (val) {
                      setState(() {
                        halfPress = val;
                      });
                    },
                    value: halfPress,
                  ),
                ),
                AdvancedOptionWrapper(
                    advancedOptionController: advancedOption && halfPress,
                    child: SingleTextField(
                      title: "Half press pulse duration*",
                      description:
                          "Duration of half press before trigger event",
                      textField: TextField(
                        decoration: InputDecoration(
                            labelText: "seconds", helperText: "0.2s to 25.0s"),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: PageNavigationBar(
        showNext: true,
        showPrevious: true,
        onNext: () {
          Navigator.pop(context);
        },
        onPrevious: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
