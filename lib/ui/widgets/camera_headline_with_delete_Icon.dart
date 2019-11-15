import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

/// {@category Widget}
/// {@category Design}
///
/// Trigger text on [SettingSummaryCard] like `Multiple Pictures` with a delete Icon to the right.

class CameraHeadlineWithDeleteIcon extends StatelessWidget {
  final String value;

  final VoidCallback onDeletePressed;

  const CameraHeadlineWithDeleteIcon(
      {Key key, @required this.value, this.onDeletePressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 18,
          child: Text(
            value,
            style: Theme.of(context).textTheme.title.copyWith(fontSize: 20),
          ),
        ),
        Flexible(
          flex: 2,
          child: IconButton(
            icon: Icon(OMIcons.delete),
            onPressed: onDeletePressed,
            padding: EdgeInsets.only(right: 12, top: 12, bottom: 12, left: 8),
          ),
        )
      ],
    );
  }
}
