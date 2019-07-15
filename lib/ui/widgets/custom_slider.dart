import 'package:flutter/material.dart';

///Example
///
///
///``` dart
///   int x = 2;
///   CustomSlider(
///         title: "Slider",
///         description: "This is a description",
///         slider: Slider(
///           activeColor: Theme.of(context).accentColor,
///           inactiveColor: Theme.of(context).accentColor.withAlpha(100),
///           onChanged: (double value) {
///             x = value.floor();
///             setState(() {});
///           },
///           value: x.floorToDouble(),
///           min: 1,
///           max: 8,
///           divisions: 7,
///         ),
///        );
///```
///

class CustomSlider extends StatelessWidget {
  final String title;
  final String description;
  final Slider slider;

  const CustomSlider({
    Key key,
    @required this.title,
    @required this.description,
    @required this.slider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.title.copyWith(fontSize: 24.0),
          ),
          Text(
            description,
            style: Theme.of(context).textTheme.body2,
          ),
          SizedBox(height: 20),
          slider
        ],
      ),
    );
  }
}
