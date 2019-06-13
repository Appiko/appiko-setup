import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/services/bluetooth_scan.dart';
import 'package:setup/ui/widgets/custom_divider.dart';

class ScanView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool _isScanning = Provider.of<BluetoothScanService>(context).isScanning;
    Map<DeviceIdentifier, ScanResult> _scanResults =
        Provider.of<BluetoothScanService>(context).scanResults;

    return Scaffold(
      body: Column(
        children: <Widget>[
          _isScanning ? LinearProgressIndicator() : Container(height: 6.0),
          Expanded(
            flex: 1,
            child: ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (_, __) => CustomDivider(),
              itemCount: _scanResults.length,
              itemBuilder: (_, int index) {
                return ListTile(
                  title: Text(_scanResults.values
                      .toList()[index]
                      .advertisementData
                      .localName),
                  trailing:
                      Text(_scanResults.values.toList()[index].rssi.toString()),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: !_isScanning
          ? FloatingActionButton.extended(
              icon: Icon(Icons.adjust),
              label: Text("SCAN"),
              onPressed: Provider.of<BluetoothScanService>(context).startScan,
            )
          : FloatingActionButton.extended(
              icon: Icon(Icons.stop),
              label: Text("STOP SCAN"),
              onPressed: Provider.of<BluetoothScanService>(context).stopScan,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
