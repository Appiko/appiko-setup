import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/services/sense_be_rx_service.dart';
import 'package:setup/ui/widgets/custom_app_bar.dart';
import 'package:setup/ui/widgets/custom_divider.dart';

/// {@category Page}
/// {@category Design}
///
/// Device Information screen
class DeviceInfoView extends StatefulWidget {
  @override
  _DeviceInfoViewState createState() => _DeviceInfoViewState();
}

class _DeviceInfoViewState extends State<DeviceInfoView> {
  // final Map<String, String> deviceInfo = {
  //   "Name": "SenseBe #5",
  //   "Battery Type": "Rechargable AA",
  //   "Battery Voltage": "2.3V",
  //   "MAC Address": "C2:45:78:125",
  //   "Device Id": "SB0123489972130"
  // };
  // DeviceInfo _deviceInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Device Information",
      ),
      body: Provider.of<SenseBeRxService>(context).deviceInfo == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 32.0, bottom: 32.0),
                  child: Container(
                    // TODO: Remove overflow scroll animation
                    child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (_, __) => CustomDivider(),
                      itemCount: Provider.of<SenseBeRxService>(context)
                          .deviceInfo
                          .toMap()
                          .length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            Provider.of<SenseBeRxService>(context)
                                .deviceInfo
                                .toMap()
                                .keys
                                .toList()[index]
                                .toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(Provider.of<SenseBeRxService>(context)
                              .deviceInfo
                              .toMap()
                              .values
                              .toList()[index]
                              .toString()),
                        );
                      },
                    ),
                  ),
                ),
                // OutlineButton(
                //   onPressed: () {},
                //   child: Text(
                //     "Show logs",
                //     style: TextStyle(fontFamily: "Monospace"),
                //   ),
                //   highlightedBorderColor: Theme.of(context).accentColor,
                //   splashColor: Theme.of(context).accentColor,
                //   borderSide:
                //       BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
                // ),
              ],
            ),
    );
  }
}
