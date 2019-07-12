import 'package:flutter/material.dart';

class CameraTriggerOption {
  final String label;
  final CameraAction action;
  final String description;

  CameraTriggerOption({
    @required this.label,
    @required this.action,
    this.description,
  });
}

enum CameraAction {
  SINGLE_PICTURE,
  LONG_PRESS,
  MULTIPLE_PICTURES,
  VIDEO,
  HALF_PRESS,
  NONE
}

class CameraTriggerRadioOptions extends StatefulWidget {
  CameraAction selectedAction;

  CameraTriggerRadioOptions({Key key, @required this.selectedAction})
      : super(key: key);

  @override
  _CameraTriggerRadioOptionsState createState() =>
      _CameraTriggerRadioOptionsState();
}

class _CameraTriggerRadioOptionsState extends State<CameraTriggerRadioOptions> {
  List<CameraTriggerOption> options = [
    CameraTriggerOption(
      label: "Single Picture",
      action: CameraAction.SINGLE_PICTURE,
    ),
    CameraTriggerOption(
      label: "Long Press",
      description:
          "On Motion event, send a Trigger Pulse of a specified long duration to the camera. This is useful when the camera is set in bulb mode, especially for night photgraphy with flash(es) to illuminate the foreground. Also, this mode is useful when the camera is set in burst mode to take multiple pictures as quick as possible.",
      action: CameraAction.LONG_PRESS,
    ),
    CameraTriggerOption(
      label: "Multiple Pictures",
      description:
          """At every Motion event, two or more pictures are taken by sending the required number of Trigger Pulses at pre-defined time intervals.""",
      action: CameraAction.MULTIPLE_PICTURES,
    ),
    CameraTriggerOption(
      label: "Video",
      description:
          """Record video by asserting the camera’s shutter button to start and also to stop the recording. The stopping of the video can also be extended if motion is detected at the end of the video. 
Warning: As pulses sent to the camera to start and stop the video are identical, it is essential to ensure that the camera starts recording when there is a Motion Event from the sensor. If needed turn the video recording off manually before allowing the sensor to trigger a new recording.""",
      action: CameraAction.VIDEO,
    ),
    CameraTriggerOption(
      label: "Half Press",
      description:
          "Sends a Half-Press Pulse to the camera, which usually wakes it up and/or activates the autofocus if the camera is set in this mode. Note that this can also be used to start video recording on Canon Cameras with Magic Lantern firmware installed (see the chapter on Video Recording in the User’s Manual). ",
      action: CameraAction.HALF_PRESS,
    ),
    CameraTriggerOption(
      label: "No Action",
      action: CameraAction.NONE,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(
          child: ListView.builder(
            itemCount: options.length,
            itemBuilder: (_, int index) => RadioListTile(
              groupValue: widget.selectedAction,
              value: options[index].action,
              title: Text(options[index].label),
              onChanged: (CameraAction a) {
                setState(() {
                  widget.selectedAction = a;
                });
              },
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
            child: Text(
                options
                        .firstWhere((e) => e.action == widget.selectedAction)
                        .description
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
