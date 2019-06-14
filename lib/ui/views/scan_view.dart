import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/services/bluetooth_connection.dart';
import 'package:setup/core/services/bluetooth_scan.dart';
import 'package:setup/ui/views/device_settings_view.dart';
import 'package:setup/ui/widgets/custom_divider.dart';

class ScanView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool _isScanning = Provider.of<BluetoothScanService>(context).isScanning;
    List _scanResults =
        Provider.of<BluetoothScanService>(context).scanResults.values.toList();
    bool _isConnected =
        Provider.of<BluetoothConnectionService>(context).isConnected;

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
                    title:
                        Text(_scanResults[index].advertisementData.localName),
                    trailing: Text(_scanResults[index].rssi.toString()),
                    onTap: () {
                      Provider.of<BluetoothConnectionService>(context)
                          .connect(_scanResults[index].device);
                      Navigator.pushNamed(context, '/device-settings');
                    });
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
