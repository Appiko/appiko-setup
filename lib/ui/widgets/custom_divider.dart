import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
          right: 20.0,
        ),
        child: Divider(
          height: 2,
          indent: 20.0,
        ));
  }
}
