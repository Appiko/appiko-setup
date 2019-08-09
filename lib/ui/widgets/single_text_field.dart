import 'package:flutter/material.dart';

/// Example
/// ```dart
///    SingleTextField(
///      title: "Hello",
///      description: "This is a description",
///      textField: TextField(
///        decoration: InputDecoration(
///          labelText: "seconds",
///          helperText: "Cannot be more than 100s",
///        ),
///        keyboardType: TextInputType.number,
///      ),
///    );
/// ```

class SingleTextField extends StatelessWidget {
  final String title;
  final String description;
  final TextFormField textField;

  SingleTextField({
    Key key,
    @required this.title,
    this.description,
    @required this.textField,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.title.copyWith(fontSize: 24.0),
          ),
          description != null
              ? Text(
                  description,
                  style: Theme.of(context).textTheme.body2,
                )
              : Container(),
          SizedBox(height: 20),
          textField,
        ],
      ),
    );
  }
}
