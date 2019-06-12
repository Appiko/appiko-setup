import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/services/shared_prefs.dart';
import 'package:setup/core/view_models/bottom_nav_model.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    final BottomNavModel bottomNavModel = Provider.of<BottomNavModel>(context);
    final bool darkTheme = Provider.of<SharedPrefs>(context).darkTheme;
    return BottomNavigationBar(
      showUnselectedLabels: true,
      unselectedItemColor: darkTheme
          ? Colors.white.withAlpha(90)
          : Theme.of(context).primaryColor.withAlpha(90),
      selectedItemColor:
          darkTheme ? Colors.white : Theme.of(context).primaryColor,
      currentIndex: bottomNavModel.index,
      onTap: (value) => bottomNavModel.handleTap(value),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.bluetooth_searching),
          title: Text("SCAN"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.collections_bookmark),
          title: Text("Profiles"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.check),
          title: Text("Test"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          title: Text("Shop"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz),
          title: Text("More"),
        ),
      ],
    );
  }
}
