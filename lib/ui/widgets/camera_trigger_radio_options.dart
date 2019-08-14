import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/models/devices/sense_be_rx/1.0/camera.dart';
import 'package:setup/core/services/sense_be_rx_service.dart';
import 'package:setup/core/view_models/camera_trigger_radio_options_model.dart';

class CameraTriggerOption {
  final String label;
  final CameraAction action;
  final String motionDescription;

  final String timerDescription;

  CameraTriggerOption({
    @required this.label,
    @required this.action,
    this.motionDescription,
    this.timerDescription,
  });
}

/// {@category Widget}
/// {@category Design}
///
/// Radio options to list all possible camera options
class CameraTriggerRadioOptions extends StatefulWidget {
  CameraTriggerRadioOptions({Key key}) : super(key: key);

  @override
  _CameraTriggerRadioOptionsState createState() =>
      _CameraTriggerRadioOptionsState();
}

class _CameraTriggerRadioOptionsState extends State<CameraTriggerRadioOptions> {
  List<CameraTriggerOption> options = [
    CameraTriggerOption(
      label: "Single Picture",
      motionDescription: "Click a single picture, when the device is triggered",
      timerDescription: "Click a single picture, when the device is triggered",
      action: CameraAction.SINGLE_PICTURE,
    ),
    CameraTriggerOption(
      label: "Long Press",
      motionDescription:
          "On Motion event, send a Trigger Pulse of a specified long duration to the camera. This is useful when the camera is set in bulb mode, especially for night photgraphy with flash(es) to illuminate the foreground and long exposure to have a visible background such as the landscape or starry nights. Also, this mode is useful when the camera is set in burst mode to take multiple pictures as quick as possible.",
      timerDescription:
          "On Timer event, send a Trigger Pulse of a specified long duration to the camera. This is useful when the camera is set in bulb mode, especially for night photgraphy with flash(es) to illuminate the foreground and long exposure to have a visible background such as the landscape or starry nights. Also, this mode is useful when the camera is set in burst mode to take multiple pictures as quick as possible.",
      action: CameraAction.LONG_PRESS,
    ),
    CameraTriggerOption(
      label: "Multiple Pictures",
      motionDescription:
          """At every Motion event, two or more pictures are taken by sending the required number of Trigger Pulses at pre-defined time intervals.""",
      timerDescription:
          """At every Timer event, two or more pictures are taken by sending the required number of Trigger Pulses at pre-defined time intervals.""",
      action: CameraAction.MULTIPLE_PICTURES,
    ),
    CameraTriggerOption(
      label: "Video",
      motionDescription:
          """Record video by asserting the camera's shutter button to start and also to stop the recording. The motion sensor will start sensing again after the configured Downtime (in motion settings) and there is an option to extend the end of the video if motion is detected.\nWARNING: As pulses sent to the camera to start and stop the video are identical, it is essential to ensure that the camera starts recording when there is a Motion Event from the sensor. If needed turn the video recording off manually before allowing the sensor to trigger a new recording.""",
      timerDescription:
          """Record video by asserting the camera’s shutter button to start and also to stop the recording.\nWARNING: As pulses sent to the camera to start and stop the video are identical, it is essential to ensure that the camera starts recording when there is a Timer Event from the sensor. If needed turn the video recording off manually before allowing the sensor to trigger a new recording.""",
      action: CameraAction.VIDEO,
    ),
    CameraTriggerOption(
      label: "Half Press",
      motionDescription:
          "Sends a Half-Press Pulse to the camera, which usually wakes it up and/or activates the autofocus if the camera is set in this mode. Note that this can also be used to start video recording on Canon Cameras with Magic Lantern firmware installed (see the chapter on Video Recording in the User’s Manual). ",
      timerDescription:
          "Sends a Half-Press Pulse to the camera, which usually wakes it up and/or activates the autofocus if the camera is set in this mode. Note that this can also be used to start video recording on Canon Cameras with Magic Lantern firmware installed (see the chapter on Video Recording in the User’s Manual). ",
      action: CameraAction.HALF_PRESS,
    ),
    // CameraTriggerOption(
    //   label: "No Action",
    //   action: CameraAction.NONE,
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    CameraAction selectedAction =
        Provider.of<CameraTriggerRadioOptionsModel>(context).selectedAction;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: options.length,
            itemBuilder: (_, int index) => RadioListTile(
              // dense: true,
              groupValue: selectedAction,
              value: options[index].action,
              title: Text(options[index].label),
              onChanged: (CameraAction a) {
                Provider.of<CameraTriggerRadioOptionsModel>(context)
                    .setSelectedAction(a);
              },
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Text(
                Provider.of<SenseBeRxService>(context)
                            .activeTriggerType
                            .index ==
                        0
                    ? options
                            .firstWhere((e) => e.action == selectedAction)
                            .motionDescription
                            ?.trim() ??
                        ""
                    : options
                            .firstWhere((e) => e.action == selectedAction)
                            .timerDescription
                            ?.trim() ??
                        "",
                style:
                    Theme.of(context).textTheme.caption.copyWith(fontSize: 13)),
          ),
        ),
      ],
    );
  }
}
