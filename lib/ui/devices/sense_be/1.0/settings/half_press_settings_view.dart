import 'package:flutter/material.dart';
import 'package:setup/ui/widgets/custom_app_bar.dart';
import 'package:setup/ui/widgets/page_navigation_bar.dart';
import 'package:setup/ui/widgets/single_text_field.dart';

class HalfPressSettingsView extends StatefulWidget {
  @override
  _HalfPressSettingsViewState createState() => _HalfPressSettingsViewState();
}

class _HalfPressSettingsViewState extends State<HalfPressSettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Half press",
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
                SingleTextField(
                  title: "Half press pulse duration",
                  description: "Duration of half press before trigger event",
                  textField: TextField(
                    decoration: InputDecoration(
                        labelText: "seconds", helperText: "0.2s to 25.0s"),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                )
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
