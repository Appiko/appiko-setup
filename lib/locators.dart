import 'package:get_it/get_it.dart';
import 'package:setup/core/models/devices/sense_be_rx/1.0/sense_be_rx.dart';
import 'package:setup/core/services/bluetooth_IO.dart';
import 'package:setup/core/services/bluetooth_connection.dart';
import 'package:setup/core/services/bluetooth_scan.dart';
import 'package:setup/core/services/profiles.dart';
import 'package:setup/core/services/sense_be_rx_service.dart';
import 'package:setup/core/services/sense_pi_service.dart';
import 'package:setup/core/services/shared_prefs.dart';
import 'package:setup/core/view_models/ambient_fields_model.dart';
import 'package:setup/core/view_models/bottom_nav_model.dart';
import 'package:setup/core/view_models/camera_trigger_radio_options_model.dart';
import 'package:setup/core/view_models/half_press_fields_model.dart';
import 'package:setup/core/view_models/time_of_day_fields_model.dart';
import 'package:setup/ui/setup_theme.dart';

GetIt locator = GetIt();

void setupLocator() {
  locator.registerLazySingleton<SharedPrefs>(() => SharedPrefs());
  locator.registerLazySingleton(() => SetupTheme());
  locator.registerLazySingleton(() => BottomNavModel());
  locator.registerLazySingleton(() => BluetoothScanService());
  locator.registerLazySingleton(() => BluetoothConnectionService());
  locator.registerLazySingleton(() => ProfilesService());
  locator.registerLazySingleton(() => AmbientFieldsModel());
  locator.registerLazySingleton(() => SenseBeRxService());
  locator.registerLazySingleton(() => SensePiService());
  locator.registerLazySingleton(() => TimeOfDayFieldsModel());
  locator.registerLazySingleton(() => CameraTriggerRadioOptionsModel());
  locator.registerLazySingleton(() => HalfPressFieldsModel());
  locator.registerLazySingleton(() => BeRxSetting(index: 999));
  locator.registerLazySingleton(() => BluetoothIOService());
}
