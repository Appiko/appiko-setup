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
}
