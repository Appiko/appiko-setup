import 'package:flutter/material.dart';

///Example
///
///  ```dart
///    CustomRadioField(
///      title: "Video recording starts on",
///      description:
///          "Does your camera start recording video on full press or a half press?",
///      radioList: ListView(
///        children: <Widget>[
///          shrinkWrap: true, //IMPORTANT if things dont fit
///          RadioListTile(
///            title: Text("Full Press"),
///            value: 0,
///            groupValue: 0,
///            onChanged: (int value) {},
///          ),
///          RadioListTile(
///            title: Text("Full Press"),
///            value: 1,
///            groupValue: 0,
///            onChanged: (int value) {},
///          ),
///        ],
///      ),
///    );
///  ```

class CustomRadioField extends StatelessWidget {
  final String title;
  final String description;
  final ListView radioList;

  const CustomRadioField({
    Key key,
    this.title,
    @required this.radioList,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          (title != null)
              ? Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(fontSize: 20.0),
                )
              : Container(),
          (description != null)
              ? Text(
                  description,
                  style: Theme.of(context).textTheme.body2,
                )
              : Container(height: 0),
          (description != null && title != null)
              ? SizedBox(height: 10)
              : Container(),
          radioList,
        ],
      ),
    );
  }
}
