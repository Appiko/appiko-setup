import 'package:flutter/material.dart';

/// {@category Widget}
/// {@category Design}
///
/// Popup Menu (In app bar) Item.
class PopupMenuItemButton extends StatelessWidget {
  final Icon icon;
  final String label;
  final VoidCallback onPressed;

  const PopupMenuItemButton({
    Key key,
    this.icon,
    this.label,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label),
          icon,
        ],
      ),
      onPressed: onPressed,
    );
  }
}
