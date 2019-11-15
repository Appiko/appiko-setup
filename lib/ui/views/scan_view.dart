import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/services/bluetooth_connection.dart';
import 'package:setup/core/services/bluetooth_scan.dart';
import 'package:setup/core/services/device.dart';
import 'package:setup/core/services/helper_functions.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/widgets/custom_divider.dart';

/// {@category Page}
/// {@category Design}
///
/// Scan page
class ScanView extends StatefulWidget {
  @override
  _ScanViewState createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  @override
  Widget build(BuildContext context) {
    bool _isScanning = Provider.of<BluetoothScanService>(context).isScanning;
    List<ScanResult> _scanResults =
        Provider.of<BluetoothScanService>(context).scanResults.values.toList();
    bool _isBluetoothOn =
        Provider.of<BluetoothScanService>(context).isBluetoothOn;

    return Scaffold(
      body: Column(
        children: <Widget>[
          _isBluetoothOn
              ? _isScanning ? LinearProgressIndicator() : Container(height: 6.0)
              : Container(
                  height: 6.0,
                ),
          _isBluetoothOn
              ? Expanded(
                  flex: 1,
                  child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (_, __) => CustomDivider(),
                    itemCount: _scanResults.length,
                    itemBuilder: (_, int index) {
                      return ListTile(
                          title: Text(
                              _scanResults[index].advertisementData.localName),
                          trailing: Text(_scanResults[index].rssi.toString()),
                          onTap: () async {
                            locator<BluetoothScanService>().stopScan();
                            await locator<BluetoothConnectionService>().connect(
                              device: _scanResults[index].device,
                              uuid: _scanResults[index]
                                  .advertisementData
                                  .serviceUuids[0],
                            );

                            Navigator.pushNamed(context, _getRoute());
                          });
                    },
                  ),
                )
              : Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Icon(
                      //   Icons.bluetooth_disabled,
                      //   size: 200,
                      //   color: Colors.grey,
                      // ),
                      FloatingActionButton.extended(
                        icon: Icon(Icons.bluetooth_searching),
                        label: Text("TURN ON BLUETOOTH"),
                        onPressed: () =>
                            Provider.of<BluetoothScanService>(context)
                                .turnOnBluetooth(),
                      ),
                    ],
                  ),
                ),
        ],
      ),
      floatingActionButton: !_isBluetoothOn
          ? null
          : !_isScanning
              ? FloatingActionButton.extended(
                  icon: Icon(Icons.adjust),
                  label: Text("SCAN"),
                  onPressed: () => Provider.of<BluetoothScanService>(context)
                      .startScan(context: context),
                )
              : FloatingActionButton.extended(
                  icon: Icon(Icons.stop),
                  label: Text("STOP SCAN"),
                  onPressed:
                      Provider.of<BluetoothScanService>(context).stopScan,
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

String _getRoute() {
  switch (activeDevice) {
    case Device.SENSE_PI:
      return "/devices/sp";
    case Device.SENSE_BE_RX:
      return "/devices/br";
    case Device.SENSE_BE_TX:
      return "/devices/bt";
  }
}
