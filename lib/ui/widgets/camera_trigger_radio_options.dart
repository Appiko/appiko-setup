import 'package:flutter/material.dart';

class CameraTriggerOption {
  final String label;
  final CameraAction action;
  final String description;

  CameraTriggerOption({
    @required this.label,
    @required this.action,
    @required this.description,
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
      description: "Desc...",
      action: CameraAction.SINGLE_PICTURE,
    ),
    CameraTriggerOption(
      label: "Long Press",
      description: "Long press Desc...",
      action: CameraAction.LONG_PRESS,
    ),
    CameraTriggerOption(
      label: "Multiple Pictures",
      description: "multiple pictures Desc...",
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
      description: "Half Press Desc...",
      action: CameraAction.HALF_PRESS,
    ),
    CameraTriggerOption(
      label: "No Action",
      description: "No Desc...",
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
                    .trim(),
                style:
                    Theme.of(context).textTheme.caption.copyWith(fontSize: 13)),
          ),
        ),
      ],
    );
  }
}
