import 'dart:typed_data';

import 'package:setup/core/models/devices/sense_be_rx/1.0/sense_be_rx.dart'
    as br;
import 'package:setup/core/models/devices/sense_pi/1.0/sense_pi.dart' as sp;
import 'package:setup/core/models/generic/meta.dart';
import 'package:setup/core/services/device.dart';
import 'package:setup/core/services/profiles.dart';
import 'package:setup/core/services/sense_be_rx_service.dart';
import 'package:setup/core/services/sense_pi_service.dart';
import 'package:setup/locators.dart';

getProfileSummaryPath() {
  switch (locator<ProfilesService>().activeProfile.deviceType) {
    case Device.SENSE_PI:
      return '/devices/sp/profile-summary';
      break;
    case Device.SENSE_BE_TX:
      // TODO:
      return '/devices/br/profile-summary';
      break;
    case Device.SENSE_BE_RX:
      return '/devices/br/profile-summary';
      break;
  }
}

// getCloseSummaryPath() {
//   if (locator<BluetoothConnectionService>().deviceState ==
//       BluetoothDeviceState.connected) {
//     switch (locator<BluetoothConnectionService>().connectedDeviceType) {
//       case Device.SENSE_PI:
//         return '/devices/sp';
//         break;
//       case Device.SENSE_BE_TX:
//         return '/devices/bt';
//         break;
//       case Device.SENSE_BE_RX:
//         return '/devices/br';
//         break;
//     }
//   } else {
//     return getProfileSummaryPath();
//   }
// }

// getCameraSettingDownArrowPageName() {
//   bool shouldPassSetting = false;

//   switch (activeDevice) {
//     case Device.SENSE_PI:
//       shouldPassSetting = locator<SensePiService>().shouldPassSetting;
//       break;
//     case Device.SENSE_BE_RX:
//       shouldPassSetting = locator<SenseBeRxService>().shouldPassSetting;
//       break;
//     case Device.SENSE_BE_TX:
//       // TODO:
//       // shouldPassSetting =  locator<SenseBeTxService>().shouldPassSetting;
//       break;
//   }

//   if (shouldPassSetting) {
//     return 'setting-summary';
//   }

//   return getCloseSummaryPath();
// }

getStructure({shouldReferActiveStructure = false}) {
  switch (activeDevice) {
    case Device.SENSE_PI:
      return shouldReferActiveStructure
          ? locator<SensePiService>().structure
          : sp.SensePi();
      break;
    case Device.SENSE_BE_RX:
      return shouldReferActiveStructure
          ? locator<SenseBeRxService>().structure
          : br.SenseBeRx();
      break;
    case Device.SENSE_BE_TX:
      // TODO:
      break;
  }
}

getMetaStructure({shouldReferActiveStructure = false}) {
  switch (activeDevice) {
    case Device.SENSE_PI:
      return shouldReferActiveStructure
          ? locator<SensePiService>().metaStructure
          : MetaStructure();
      break;
    case Device.SENSE_BE_RX:
      return shouldReferActiveStructure
          ? locator<SenseBeRxService>().metaStructure
          : MetaStructure();
      break;
    case Device.SENSE_BE_TX:
      // TODO:
      return MetaStructure();
      break;
  }
}

setMetaStructure(MetaStructure metaStructure) {
  switch (activeDevice) {
    case Device.SENSE_PI:
      locator<SensePiService>().metaStructure = metaStructure;
      break;
    case Device.SENSE_BE_RX:
      locator<SenseBeRxService>().metaStructure = metaStructure;
      break;
    case Device.SENSE_BE_TX:
      // TODO:
      return MetaStructure();
      break;
  }
}

getPackedData([struct]) {
  switch (activeDevice) {
    case Device.SENSE_PI:
      return sp.pack(struct ?? getStructure(shouldReferActiveStructure: true));
      break;
    case Device.SENSE_BE_RX:
      return br.pack(struct ?? getStructure(shouldReferActiveStructure: true));
      break;
    case Device.SENSE_BE_TX:
      // TODO:
      break;
  }
}

createStructureFromData({Uint8List data}) {
  switch (activeDevice) {
    case Device.SENSE_PI:
      Map unpackedData = sp.unpack(data);
      locator<SensePiService>().structure = unpackedData['structure'];
      locator<SensePiService>().metaStructure = unpackedData['meta'];

      break;
    case Device.SENSE_BE_RX:
      Map unpackedData = br.unpack(data);
      locator<SenseBeRxService>().structure = unpackedData['structure'];
      locator<SenseBeRxService>().metaStructure = unpackedData['meta'];
      break;
    case Device.SENSE_BE_TX:
      // TODO:
      break;
  }
}

Device activeDevice;
