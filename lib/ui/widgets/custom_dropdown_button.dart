import 'package:flutter/material.dart';

/// {@category Widget}
/// {@category Design}
///
///
/// Dropdown button with a title and description.
/// Can be arranged in a row or a column.
///
///
/// Example
///  ```dart
///              CustomDropdownButton(
///                title: "Channel",
///                dropdownButton: DropdownButton(
///                  value: Provider.of<SenseBeRxService>(context)
///                      .structure
///                      .radioSetting
///                      .radioChannel,
///                  underline: Container(),
///                  style: Theme.of(context).textTheme.title.copyWith(
///                        fontSize: 18,
///                      ),
///                  items: RadioChannel.values.map((channel) {
///                    String text = (int.tryParse(channel
///                                .toString()
///                                .split(".")[1]
///                                .split("_")[1]) +
///                            1)
///                        .toString();
///                    return DropdownMenuItem<RadioChannel>(
///                      value: channel,
///                      child: Text(text),
///                    );
///                  }).toList(),
///                  onChanged: (value) {
///                    Provider.of<SenseBeRxService>(context)
///                        .setRadioChannel(value);
///                  },
///                ),
///              ),
///  ```

class CustomDropdownButton extends StatelessWidget {
  final String title;
  final String description;
  final DropdownButton dropdownButton;

  /// If it should return a Column. i.e., the dropdown button is placed below the title.
  final bool isColumn;

  CustomDropdownButton({
    Key key,
    @required this.title,
    this.description,
    @required this.dropdownButton,
    this.isColumn = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12, bottom: 12),
      child: isColumn
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(fontSize: 20.0),
                ),
                Container(
                  width: double.infinity,
                  child: description != null
                      ? Text(
                          description,
                          style: Theme.of(context).textTheme.body2,
                        )
                      : Container(),
                ),
                dropdownButton,
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(fontSize: 20.0),
                    ),
                    description != null
                        ? Text(
                            description,
                            style: Theme.of(context).textTheme.body2,
                            overflow: TextOverflow.ellipsis,
                          )
                        : Container(),
                  ],
                ),
                dropdownButton,
              ],
            ),
    );
  }
}
