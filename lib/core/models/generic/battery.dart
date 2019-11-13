import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/// [BatteryTypes]s supported by sense devices
enum BatteryType {
  STANDARD,
  RECHARGEABLE,
}

class BatteryHelper {
  static String getString(BatteryType batteryType) {
    switch (batteryType) {
      case BatteryType.RECHARGEABLE:
        return "RECHARGEBLE";
        break;
      case BatteryType.STANDARD:
        return "STANDARD";
      default:
        return "hmm, Unrecognized battery type.";
    }
  }

  // TODO: Change to bar icon, ones available
  static IconData getIcon(BatteryType batteryType, double voltage) {
    switch (batteryType) {
      case BatteryType.STANDARD:
        if (voltage >= 2.5) {
          return MdiIcons.battery90;
        } else if (voltage >= 2.3 && voltage < 2.5) {
          return MdiIcons.battery50;
        } else if (voltage > 0 && voltage < 2.3) {
          return MdiIcons.battery10;
        } else {
          return MdiIcons.batteryCharging100;
        }

        break;
      case BatteryType.RECHARGEABLE:
        if (voltage >= 3.05) {
          return MdiIcons.battery90;
        } else if (voltage >= 2.9 && voltage < 3.05) {
          return MdiIcons.battery50;
        } else if (voltage > 0 && voltage < 2.9) {
          return MdiIcons.battery10;
        } else {
          return MdiIcons.batteryCharging100;
        }
        break;
    }
  }
}
