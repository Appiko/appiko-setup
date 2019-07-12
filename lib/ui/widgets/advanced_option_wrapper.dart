import 'package:flutter/material.dart';

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
