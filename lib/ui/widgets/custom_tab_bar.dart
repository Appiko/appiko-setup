import 'package:flutter/material.dart';

/// {@category Widget}
/// {@category Design}
///
class CustomTabBar extends StatefulWidget implements PreferredSizeWidget {
  final TabController tabController;
  final String moreTabName;

  const CustomTabBar({
    Key key,
    @required this.tabController,
    @required this.moreTabName,
  }) : super(key: key);
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
        if (widget.moreTabName.isNotEmpty)
          Tab(text: widget.moreTabName.toUpperCase())
      ],
    );
  }
}
