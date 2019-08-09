import 'package:flutter/material.dart';
import 'package:setup/ui/widgets/single_text_field.dart';

class HalfPressField extends StatelessWidget {
  HalfPressField({
    Key key,
    @required this.controller,
  }) : super(key: key) {
    if (controller.text == "") controller.text = "0.2";
  }

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SingleTextField(
      title: "Half press pulse duration*",
      description: "Duration of half press before trigger event",
      textField: TextFormField(
        controller: controller,
        maxLength: 4,
        validator: (val) {
          double value = double.tryParse(val);
          if (value == null) {
            return "Cannot be empty";
          }
          if (value < 0.2 || value > 25) {
            return "Not valid range";
          }
          return null;
        },
        autovalidate: true,
        decoration: InputDecoration(
          labelText: "seconds",
          helperText: "0.2s to 25.0s",
          counterText: "",
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }
}
