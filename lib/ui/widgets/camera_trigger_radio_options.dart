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

  CameraTriggerRadioOptions({Key key, this.selectedAction}) : super(key: key);

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
      description: "Video Desc...",
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
        Expanded(
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Text(options
                .firstWhere((e) => e.action == widget.selectedAction)
                .description),
          ),
        ),
      ],
    );
  }
}
