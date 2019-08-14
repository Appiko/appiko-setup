import 'package:flutter/material.dart';

/// {@category Widget}
/// {@category Design}
///
///
/// Wrapper class to hide widgets when advanced option is turned off.
///
///Example
///```
///AdvancedOptionWrapper(
///      advancedOptionController: localAdvancedOption,
///      child: SingleTextField(
///        title: "Trigger pulse duration*",
///        description: "Duration of trigger pulse for the video"
///        textField: TextFormField(
///          controller: triggerPulseDurationController,
///        ),
///      ),
///    );
///```
class AdvancedOptionWrapper extends StatefulWidget {
  final Widget child;
  final bool advancedOptionController;

  const AdvancedOptionWrapper(
      {Key key, this.advancedOptionController, this.child})
      : super(key: key);
  @override
  _AdvancedOptionWrapperState createState() => _AdvancedOptionWrapperState();
}

class _AdvancedOptionWrapperState extends State<AdvancedOptionWrapper> {
  @override
  Widget build(BuildContext context) {
    return widget.advancedOptionController ? widget.child : Container();
  }
}
