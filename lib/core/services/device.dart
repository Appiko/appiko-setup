enum Device {
  SENSE_PI,
  SENSE_BE_RX,
  SENSE_BE_TX,
}

class DeviceHelper {
  static String getString(Device device) {
    switch (device) {
      case Device.SENSE_PI:
        return "SensePi";
        break;
      case Device.SENSE_BE_RX:
        return "SenseBe Rx";
      case Device.SENSE_BE_TX:
        return "SenseBe Tx";
      default:
        return "hmm, Not a sense device.";
    }
  }

  static String getDeviceId(Device device) {
    switch (device) {
      case Device.SENSE_PI:
        return "SP04011805310018";
        break;
      case Device.SENSE_BE_RX:
        return "SB0300190610R000";

      case Device.SENSE_BE_TX:
        return "00000000000000000000";
      default:
        return "0000000000000000000";
    }
  }
}

/// {@category Model}
/// TODO:
class Devices {
  static const Map<String, Device> devices = {
    "SP04011805310018": Device.SENSE_PI,
    "SB0300190610R000": Device.SENSE_BE_RX,
  };
}
