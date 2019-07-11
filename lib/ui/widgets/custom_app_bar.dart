import 'package:flutter/material.dart';

///
/// Example
///
///
/// ```dart
///     Scaffold(
///       backgroundColor: Colors.white,
///       appBar: CustomAppBar(
///         title: "Camera Trigger",
///         downArrow: true,
///         onDownArrowPressed: () {
///           Navigator.pop(context);
///         },
///       ),
///     );
/// ```
///

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool downArrow;
  final VoidCallback onDownArrowPressed;
  const CustomAppBar(
      {Key key, @required this.title, this.downArrow, this.onDownArrowPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: AppBar(
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(title),
        ),
        leading: downArrow != null
            ? IconButton(
                icon: Icon(Icons.keyboard_arrow_down),
                onPressed: onDownArrowPressed,
              )
            : null,
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 90);
}
