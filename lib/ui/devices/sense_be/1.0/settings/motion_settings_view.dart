import 'package:flutter/material.dart';
import 'package:setup/ui/widgets/custom_app_bar.dart';
import 'package:setup/ui/widgets/custom_slider.dart';
import 'package:setup/ui/widgets/page_navigation_bar.dart';
import 'package:setup/ui/widgets/single_text_field.dart';

class MotionSettingsView extends StatefulWidget {
  @override
  _MotionSettingsViewState createState() => _MotionSettingsViewState();
}

class _MotionSettingsViewState extends State<MotionSettingsView> {
  double x = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Motion",
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
                CustomSlider(
                  title: "Sensitivity",
                  description: "",
                  slider: Slider.adaptive(
                    onChanged: (val) {
                      setState(() {
                        x = val;
                      });
                    },
                    value: x,
                    activeColor: Theme.of(context).accentColor,
                    inactiveColor: Theme.of(context).accentColor.withAlpha(100),
                    divisions: 7,
                    min: 1,
                    max: 8,
                  ),
                ),
                Center(
                  child: Text("${x.toInt()}/8"),
                ),
                SingleTextField(
                  title: "Downtime",
                  description:
                      "Once motion is detected, how long should the sensor be switched off?",
                  textField: TextField(
                    decoration: InputDecoration(
                      labelText: "seconds",
                      helperText: "0s to 100s",
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
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
