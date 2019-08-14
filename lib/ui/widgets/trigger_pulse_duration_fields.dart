import 'package:flutter/material.dart';
import 'package:setup/ui/widgets/advanced_option_wrapper.dart';
import 'package:setup/ui/widgets/single_text_field.dart';

/// {@category Compound Widget}
/// {@category Design}
///
/// Trigger pulse duration field, to be displayed when advanced option is on
class TriggerPulseDuration extends StatelessWidget {
  final bool isVideo;
  TriggerPulseDuration({
    Key key,
    @required this.localAdvancedOption,
    @required this.triggerPulseDurationController,
    this.isVideo = false,
  }) : super(key: key) {
    if (triggerPulseDurationController.text == "") {
      triggerPulseDurationController.text = "0.3";
    }
  }

  final bool localAdvancedOption;
  final TextEditingController triggerPulseDurationController;

  @override
  Widget build(BuildContext context) {
    return AdvancedOptionWrapper(
      advancedOptionController: localAdvancedOption,
      child: SingleTextField(
        title: "Trigger pulse duration*",
        description: isVideo
            ? "Duration of trigger pulse for the video"
            : "Duration of trigger pulse for the picture",
        textField: TextFormField(
          controller: triggerPulseDurationController,
          decoration: InputDecoration(
            labelText: "seconds",
            helperText: "0.3s to 25.0s",
            counterText: "",
          ),
          maxLength: 4,
          validator: (val) {
            double value = double.tryParse(val);
            if (value == null) {
              return "Cannot be empty";
            }
            if (value < 0.3 || value > 25) {
              return "Not valid range";
            }
            return null;
          },
          autovalidate: true,
          keyboardType: TextInputType.numberWithOptions(
            decimal: true,
            signed: false,
          ),
        ),
      ),
    );
  }
}
