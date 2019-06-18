import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/services/bluetooth_connection.dart';

class DeviceSettingsView extends StatefulWidget {
  @override
  _DeviceSettingsViewState createState() => _DeviceSettingsViewState();
}

class _DeviceSettingsViewState extends State<DeviceSettingsView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollViewController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _scrollViewController = ScrollController(initialScrollOffset: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollViewController,
          headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Theme.of(context).primaryColor,
                iconTheme: IconThemeData(color: Colors.white),
                title: Text(
                  Provider.of<BluetoothConnectionService>(context).device.name,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    fontSize: 26,
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "SenseBe",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 22,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "Rechargeable AA",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              Icon(
                                Icons.battery_std,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "0.0.3",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 22,
                                  ),
                                ),
                                IconButton(
                                  splashColor: Theme.of(context).accentColor,
                                  icon: Icon(
                                    Icons.update,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            height: 42,
                          ),
                          Text(
                            "Firmware Version",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                pinned: true,
                expandedHeight: 240,
                forceElevated: boxIsScrolled,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(OMIcons.edit),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.info_outline),
                    onPressed: () {
                      Navigator.pushNamed(context, '/device-info');
                    },
                  ),
                ],
                bottom: TabBar(
                  tabs: <Widget>[
                    Tab(text: "Motion"),
                    Tab(text: "Timer"),
                    Tab(text: "Radio"),
                  ],
                  controller: _tabController,
                ),
              )
            ];
          },
          body: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: TabBarView(
              children: <Widget>[
                Container(
                  child: Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(38.0),
                        child: Text("A"),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(38.0),
                        child: Text("B"),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(38.0),
                        child: Text("C"),
                      ),
                    ),
                  ),
                ),
              ],
              controller: _tabController,
            ),
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
