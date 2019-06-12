import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/services/shared_prefs.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/setup_theme.dart';
import 'package:setup/ui/views/more_view.dart';
import 'package:setup/ui/views/profiles_view.dart';
import 'package:setup/ui/views/scan_view.dart';
import 'package:setup/ui/views/shop_view.dart';
import 'package:setup/ui/widgets/bottom_nav.dart';

import 'package:setup/core/view_models/bottom_nav_model.dart';
import 'package:setup/ui/widgets/custom_app_bar.dart';

void main() {
  setupLocator();
  runApp(
    MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider.value(value: locator<SharedPrefs>()),
        ChangeNotifierProvider.value(value: locator<BottomNavModel>()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: Provider.of<SharedPrefs>(context).darkTheme
          ? locator<SetupTheme>().appikoDarkTheme
          : locator<SetupTheme>().appikoDefualtTheme,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Map<String, dynamic> views = {
    "Sense Devices": ScanView(),
    "Profiles": ProfilesView(),
    "Test Devices": Container(),
    "Shop": ShopView(),
    "More": MoreView(),
  };

  @override
  Widget build(BuildContext context) {
    BottomNavModel bottomNavModel = Provider.of<BottomNavModel>(context);

    return Scaffold(
      appBar: bottomNavModel.index != 3 // Ignoring Appbar for Shop
          ? CustomAppBar(title: views.keys.toList()[bottomNavModel.index])
          : PreferredSize(
              child: Container(),
              preferredSize: Size(double.infinity, 0),
            ),
      body: views.values.toList()[bottomNavModel.index],
      bottomNavigationBar: BottomNav(),
    );
  }
}
