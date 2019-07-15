// TODO: Place file in proper path

import 'package:flutter/material.dart';
import 'package:setup/ui/widgets/camera_trigger_radio_options.dart';
import 'package:setup/ui/widgets/custom_app_bar.dart';
import 'package:setup/ui/widgets/page_navigation_bar.dart';

class CameraTriggerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Camera Trigger",
        downArrow: true,
        onDownArrowPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: CameraTriggerRadioOptions(
              selectedAction: CameraAction.SINGLE_PICTURE,
            ),
          ),
          PageNavigationBar(
            showNext: true,
            showPrevious: false,
            onNext: () {
              // TODO: Add proper path to navigate
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
