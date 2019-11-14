import 'dart:typed_data';

import 'package:flutter/material.dart';
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
import 'package:setup/ui/widgets/profile_name_dialog.dart';

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

showDisconnectedDialog(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
            title: Text("Connection lost"),
            content: Text(
                "The connection to the device is lost. You can still edit the settings and save as a profile or go back and reconnect to the device"),
            actions: <Widget>[
              FlatButton(
                child: Text("GO BACK"),
                onPressed: () =>
                    Navigator.popUntil(context, ModalRoute.withName('/')),
              ),
              FlatButton(
                child: Text("CONTINUE"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ));
}

saveAsProfile(
  BuildContext sContext,
  ProfileFile profileFile,
  Device deviceType,
) async {
  await showDialog(
      context: sContext,
      builder: (context) => ProfileNameDialog(
            fileNameController: TextEditingController(
              text: "",
            ),
            profileFile: profileFile,
            deviceType: deviceType,
            scaffoldContext: sContext,
          ));
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

showWriteSuccessfulSnackbar(BuildContext context) {
  SnackBar s = SnackBar(
    backgroundColor: Theme.of(context).accentColor,
    duration: Duration(seconds: 1),
    action: SnackBarAction(
        label: "OK",
        textColor: Colors.white,
        onPressed: () {
          Scaffold.of(context).hideCurrentSnackBar();
        }),
    content: Text(
      "Write Successful   🎉",
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
  Scaffold.of(context).showSnackBar(s);
}

Device activeDevice;
bool workingOnDevice;
