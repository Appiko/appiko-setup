import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/view_models/half_press_fields_model.dart';
import 'package:setup/ui/widgets/custom_switch_field.dart';
import 'package:setup/ui/widgets/half_press_field.dart';

import 'advanced_option_wrapper.dart';

/// {@category Compound Widget}
/// {@category Design}
///
/// Half Press On off switch in combination with [HalfPressField]
class HalfPress extends StatefulWidget {
  final bool localAdvancedOption;
  final TextEditingController halfPressPulseDurationController;

  HalfPress({
    Key key,
    @required this.localAdvancedOption,
    @required this.halfPressPulseDurationController,
  }) : super(key: key);

  @override
  _HalfPressState createState() => _HalfPressState();
}

class _HalfPressState extends State<HalfPress> {
  @override
  Widget build(BuildContext context) {
    bool isHalfPressEnabled =
        Provider.of<HalfPressFieldsModel>(context).isHalfPressEnabled;
    return Column(
      children: <Widget>[
        CustomSwitchField(
          title: "Half press",
          description: "Do you want to half press (focus) before trigger?",
          materialSwitch: Switch.adaptive(
            onChanged: (val) {
              Provider.of<HalfPressFieldsModel>(context).setHalfPress(val);
            },
            value: isHalfPressEnabled,
          ),
        ),
        AdvancedOptionWrapper(
          advancedOptionController:
              widget.localAdvancedOption && isHalfPressEnabled,
          child: HalfPressField(
            controller: widget.halfPressPulseDurationController,
          ),
        ),
      ],
    );
  }
}
