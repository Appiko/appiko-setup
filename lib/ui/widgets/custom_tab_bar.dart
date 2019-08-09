import 'package:flutter/material.dart';
import 'package:setup/core/view_models/custom_tab_bar_model.dart';
import 'package:setup/locators.dart';

class CustomTabBar extends StatefulWidget implements PreferredSizeWidget {
  final TabController tabController;

  const CustomTabBar({Key key, @required this.tabController}) : super(key: key);
  @override
  _CustomTabBarState createState() => _CustomTabBarState();

  @override
  Size get preferredSize => Size(double.infinity, 90);
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: false,
      controller: widget.tabController,
      onTap: (index) {
        widget.tabController.index = index;
      },
      tabs: <Widget>[
        Tab(text: "MOTION"),
        Tab(text: "TIMER"),
        Tab(text: "MORE"),
      ],
    );
  }
}
