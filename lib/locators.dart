import 'package:get_it/get_it.dart';
import 'package:setup/core/services/shared_prefs.dart';
import 'package:setup/core/view_models/bottom_nav_model.dart';
import 'package:setup/ui/setup_theme.dart';

GetIt locator = GetIt();

void setupLocator() {
  locator.registerLazySingleton<SharedPrefs>(() => SharedPrefs());
  locator.registerLazySingleton(() => SetupTheme());
  locator.registerLazySingleton(() => BottomNavModel());
}
