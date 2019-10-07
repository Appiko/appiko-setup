import 'dart:typed_data';

import 'package:setup/core/models/devices/sense_be_rx/1.0/sense_be_rx.dart'
    as br;
import 'package:setup/core/models/devices/sense_be_tx/1.0/sense_be_tx.dart'
    as bt;
import 'package:setup/core/models/devices/sense_pi/1.0/sense_pi.dart' as sp;
import 'package:setup/core/models/generic/meta.dart';
import 'package:setup/core/services/device.dart';
import 'package:setup/core/services/profiles.dart';
import 'package:setup/core/services/sense_be_rx_service.dart';
import 'package:setup/core/services/sense_be_tx_service.dart';
import 'package:setup/core/services/sense_pi_service.dart';
import 'package:setup/locators.dart';

getProfileSummaryPath() {
  switch (locator<ProfilesService>().activeProfile.deviceType) {
    case Device.SENSE_PI:
      return '/devices/sp/profile-summary';
      break;
    case Device.SENSE_BE_TX:
      return '/devices/bt/profile-summary';
      break;
    case Device.SENSE_BE_RX:
      return '/devices/br/profile-summary';
      break;
  }
}

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
      return shouldReferActiveStructure
          ? locator<SenseBeTxService>().structure
          : bt.SenseBeTx();
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
      return shouldReferActiveStructure
          ? locator<SenseBeTxService>().metaStructure
          : MetaStructure();
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
      locator<SenseBeTxService>().metaStructure = metaStructure;
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
      return bt.pack(struct ?? getStructure(shouldReferActiveStructure: true));
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
      Map unpackedData = bt.unpack(data);
      locator<SenseBeTxService>().structure = unpackedData['structure'];
      locator<SenseBeTxService>().metaStructure = unpackedData['meta'];
      break;
  }
}

Device activeDevice;
