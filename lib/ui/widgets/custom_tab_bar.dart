import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: <Widget>[
        Tab(text: "Motion"),
        Tab(text: "Timer"),
        Tab(text: "Radio"),
      ],
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 90);
}
