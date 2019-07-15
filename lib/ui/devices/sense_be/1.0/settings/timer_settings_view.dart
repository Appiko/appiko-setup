import 'package:flutter/material.dart';
import 'package:setup/ui/widgets/custom_app_bar.dart';
import 'package:setup/ui/widgets/dual_text_field.dart';
import 'package:setup/ui/widgets/page_navigation_bar.dart';

class TimerSettingsView extends StatefulWidget {
  @override
  _TimerSettingsViewState createState() => _TimerSettingsViewState();
}

class _TimerSettingsViewState extends State<TimerSettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Timer",
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
                DualTextField(
                  title: "Interval",
                  description: "Interval between timer events",
                  firstFieldLabel: "minutes",
                  secondFieldLabel: "seconds",
                  firstFieldMax: 12,
                  secondFieldMax: 60,
                  firstFieldMin: 00,
                  secondFieldMin: 00,
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
