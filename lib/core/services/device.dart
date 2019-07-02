enum Device {
  SENSE_PI,
  SENSE_BE_TX,
  SENSE_BE_RX,
}

class Devices {

  static const Map<String,Device> devices = {
    "SP04011805310018": Device.SENSE_PI,
    "SB0300190610R000": Device.SENSE_BE_RX,
  };
}