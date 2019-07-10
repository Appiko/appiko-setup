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

class CustomSwitchField extends StatelessWidget {
  final String title;
  final String description;
  final Switch materialSwitch;

  const CustomSwitchField({
    Key key,
    @required this.title,
    @required this.description,
    @required this.materialSwitch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.title.copyWith(fontSize: 24.0),
      ),
      subtitle: Text(
        description,
        style: Theme.of(context).textTheme.body2,
      ),
      trailing: materialSwitch,
    );
  }
}
