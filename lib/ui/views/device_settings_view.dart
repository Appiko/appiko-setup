import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/services/bluetooth_connection.dart';

class DeviceSettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                elevation: 0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(),
                  title: Text(
                    Provider.of<BluetoothConnectionService>(context)
                        .device
                        .name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Center(
            child: Text(
                "Connected? ${Provider.of<BluetoothConnectionService>(context).state}"),
          ),
        ),
      ),
      onWillPop: () async {
        await Provider.of<BluetoothConnectionService>(context).disconnect();
        return true;
      },
    );
  }
}
