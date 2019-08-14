import 'package:flutter/material.dart';
import 'package:setup/ui/widgets/custom_app_bar.dart';
import 'package:setup/ui/widgets/custom_divider.dart';

/// {@category Page}
/// {@category Design}
///
/// Device Information screen
class DeviceInfoView extends StatelessWidget {
  final Map<String, String> deviceInfo = {
    "Name": "SenseBe #5",
    "Battery Type": "Rechargable AA",
    "Battery Voltage": "2.3V",
    "MAC Address": "C2:45:78:125",
    "Device Id": "SB0123489972130"
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Device Information",
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 32.0, bottom: 32.0),
            child: Container(
              // TODO: Remove overflow scroll animation
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (_, __) => CustomDivider(),
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      deviceInfo.keys.toList()[index],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(deviceInfo.values.toList()[index]),
                  );
                },
              ),
            ),
          ),
          OutlineButton(
            onPressed: () {},
            child: Text(
              "Show logs",
              style: TextStyle(fontFamily: "Monospace"),
            ),
            highlightedBorderColor: Theme.of(context).accentColor,
            splashColor: Theme.of(context).accentColor,
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
          ),
        ],
      ),
    );
  }
}
