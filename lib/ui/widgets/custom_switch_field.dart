import 'package:flutter/material.dart';

///Example
///
///  ``` dart
///
///  bool x = false;
///  CustomSwitchField(
///      title: "Switch",
///      description: "description",
///      materialSwitch: Switch.adaptive(
///        onChanged: (value) {
///          setState(() {
///            x = value;
///          });
///        },
///        materialTapTargetSize: MaterialTapTargetSize.padded,
///        value: x,
///      ),
///    );
///
///  ```

/// {@category Widget}
/// {@category Design}
///
class CustomSwitchField extends StatelessWidget {
  final String title;
  final String description;
  final Switch materialSwitch;
  final EdgeInsetsGeometry padding;

  const CustomSwitchField({
    Key key,
    @required this.title,
    this.description,
    @required this.materialSwitch,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: padding ?? EdgeInsets.only(top: 12, bottom: 12),
      title: Text(
        title,
        style: Theme.of(context).textTheme.title.copyWith(fontSize: 20.0),
        textAlign: TextAlign.left,
      ),
      subtitle: description != null
          ? Text(
              description,
              style: Theme.of(context).textTheme.body2,
            )
          : null,
      trailing: materialSwitch,
    );
  }
}
