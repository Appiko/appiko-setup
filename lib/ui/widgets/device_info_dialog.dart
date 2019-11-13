import 'package:flutter/material.dart';
import 'package:setup/core/models/generic/battery.dart';
import 'package:setup/ui/widgets/custom_dropdown_button.dart';
import 'package:setup/ui/widgets/single_text_field.dart';

class DeviceInfoDialog extends StatefulWidget {
  const DeviceInfoDialog({
    Key key,
    @required this.textEditingController,
    @required this.batteryType,
    @required this.onActionPressed,
    this.onCancelPressed,
    this.actionLabel,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final BatteryType batteryType;
  final VoidCallback onCancelPressed;
  final Function(BatteryType t) onActionPressed;
  final String actionLabel;

  @override
  _DeviceInfoDialogState createState() => _DeviceInfoDialogState();
}

class _DeviceInfoDialogState extends State<DeviceInfoDialog> {
  BatteryType batteryType;
  @override
  Widget build(BuildContext context) {
    if (batteryType == null) {
      batteryType = widget.batteryType;
    }
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SingleTextField(
                title: "Device Name",
                textField: TextFormField(
                  controller: widget.textEditingController,
                ),
              ),
              CustomDropdownButton(
                hasOutline: true,
                dropdownButton: DropdownButton(
                  isExpanded: true,
                  value: batteryType,
                  underline: Container(),
                  onChanged: (t) => setState(() {
                    batteryType = t;
                  }),
                  items: BatteryType.values
                      .map((batteryType) => DropdownMenuItem<BatteryType>(
                            value: batteryType,
                            child: Text(BatteryHelper.getString(batteryType)),
                          ))
                      .toList(),
                ),
                title: 'Battery Type',
                isColumn: true,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    child: Text(
                      "CANCEL",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                    onPressed:
                        widget.onCancelPressed ?? () => Navigator.pop(context),
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    child: Text(
                      widget.actionLabel ?? "SAVE",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    onPressed: () => widget.onActionPressed(batteryType),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
