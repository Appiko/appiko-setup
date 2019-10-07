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
}
