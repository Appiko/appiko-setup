import 'package:flutter/material.dart';

/// Custom app bar, with option to convert the default, back arrow to down arrow.
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

/// {@category Widget}
/// {@category Design}
///
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;

  /// Should show [Icons.keyboard_arrow_down] instead of [Icons.arrow_back]
  final bool downArrow;
  final VoidCallback onDownArrowPressed;

  /// Trailing actions
  final List<Widget> actions;

  const CustomAppBar(
      {Key key,
      @required this.title,
      this.downArrow,
      this.onDownArrowPressed,
      this.subtitle,
      this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: AppBar(
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title),
              subtitle != null
                  ? Text(
                      subtitle,
                      style: Theme.of(context).textTheme.subtitle,
                    )
                  : Container()
            ],
          ),
        ),
        actions: actions,
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
