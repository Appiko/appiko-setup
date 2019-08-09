import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/services/bluetooth_connection.dart';
import 'package:setup/core/services/bluetooth_scan.dart';
import 'package:setup/core/services/profiles.dart';
import 'package:setup/core/services/sense_be_rx_service.dart';
import 'package:setup/core/services/shared_prefs.dart';
import 'package:setup/core/view_models/ambient_fields_model.dart';
import 'package:setup/core/view_models/camera_trigger_radio_options_model.dart';
import 'package:setup/core/view_models/half_press_fields_model.dart';
import 'package:setup/core/view_models/time_of_day_fields_model.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/devices/sense_be/1.0/profiles/profile_summary_view.dart';
import 'package:setup/ui/devices/sense_be/1.0/settings/camera_trriger_view.dart';
import 'package:setup/ui/devices/sense_be/1.0/settings/setting_summary_page.dart';
import 'package:setup/ui/setup_theme.dart';
import 'package:setup/ui/views/create_profile_view.dart';
import 'package:setup/ui/views/device_info_view.dart';
import 'package:setup/ui/views/device_settings_view.dart';
import 'package:setup/ui/views/more_view.dart';
import 'package:setup/ui/views/profiles_view.dart';
import 'package:setup/ui/views/scan_view.dart';
import 'package:setup/ui/views/shop_view.dart';
import 'package:setup/ui/widgets/bottom_nav.dart';
import 'package:setup/ui/devices/sense_pi/1.0/device_settings_view.dart' as pi;
import 'package:setup/ui/devices/sense_be/1.0/device_settings_view.dart' as be;

import 'package:setup/core/view_models/bottom_nav_model.dart';
import 'package:setup/ui/widgets/custom_app_bar.dart';

Future main() async {
  setupLocator(); // For inital class instances

  // Preferred Orientation - Potrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider.value(value: locator<SharedPrefs>()),
        ChangeNotifierProvider.value(value: locator<BottomNavModel>()),
        ChangeNotifierProvider.value(value: locator<BluetoothScanService>()),
        ChangeNotifierProvider.value(
            value: locator<BluetoothConnectionService>()),
        ChangeNotifierProvider.value(value: locator<ProfilesService>()),
        ChangeNotifierProvider.value(value: locator<SenseBeRxService>()),
        ChangeNotifierProvider.value(value: locator<AmbientFieldsModel>()),
        ChangeNotifierProvider.value(
            value: locator<CameraTriggerRadioOptionsModel>()),
        ChangeNotifierProvider.value(value: locator<HalfPressFieldsModel>()),
        ChangeNotifierProvider.value(value: locator<TimeOfDayFieldsModel>()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("Rebuilding app");
    return MaterialApp(
      theme: Provider.of<SharedPrefs>(context).darkTheme
          ? locator<SetupTheme>().appikoDarkTheme
          : locator<SetupTheme>().appikoLightTheme,
      darkTheme: locator<SetupTheme>().appikoDarkTheme,
      routes: {
        '/': (_) => MyHomePage(),
        '/device-settings': (_) => DeviceSettingsView(),
        '/device-info': (_) => DeviceInfoView(),
        '/profiles/new': (_) => CreateProfileView(),
        '/profiles/new': (_) => CreateProfileView(),
        '/camera-trigger-options': (_) => CameraTriggerView(),
        '/devices/sense-be': (_) => be.DeviceSettingsView(),
        '/devices/sense-be-rx/profile-summary': (_) => ProfileSummaryView(),
        '/devices/sense-be-rx/setting-summary': (_) => SettingSummaryPage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Map<String, Widget> views = {
    "Sense Devices": ScanView(),
    "Profiles": ProfilesView(),
    "Shop": ShopView(),
    "More": MoreView(),
  };

  @override
  Widget build(BuildContext context) {
    BottomNavModel bottomNavModel = Provider.of<BottomNavModel>(context);

    return Scaffold(
      appBar: bottomNavModel.index !=
              views.keys.toList().indexOf("Shop") // Ignoring Appbar for Shop
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
