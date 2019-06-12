import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: AppBar(
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(title),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 90);
}
