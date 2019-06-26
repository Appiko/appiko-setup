import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/view_models/bottom_nav_model.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    final BottomNavModel bottomNavModel = Provider.of<BottomNavModel>(context);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).accentColor,
      currentIndex: bottomNavModel.index,
      onTap: (value) => bottomNavModel.handleTap(value),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(OMIcons.bluetooth),
          activeIcon: Icon(OMIcons.bluetoothSearching),
          title: Text("SCAN"),
        ),
        BottomNavigationBarItem(
          icon: Icon(OMIcons.collectionsBookmark),
          activeIcon: Icon(Icons.collections_bookmark),
          title: Text("Profiles"),
        ),
        BottomNavigationBarItem(
          icon: Icon(OMIcons.shoppingCart),
          activeIcon: Icon(Icons.shopping_cart),
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
