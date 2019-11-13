import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:rubber/rubber.dart';
import 'package:setup/core/models/devices/sense_be_rx/1.0/sense_be_rx.dart';
import 'package:setup/core/models/generic/battery.dart';
import 'package:setup/core/models/generic/operation_time.dart';
import 'package:setup/core/models/generic/sensor_setting.dart';
import 'package:setup/core/services/bluetooth_IO.dart';
import 'package:setup/core/services/bluetooth_connection.dart';
import 'package:setup/core/services/bluetooth_scan.dart';
import 'package:setup/core/services/device.dart';
import 'package:setup/core/services/profiles.dart';
import 'package:setup/core/services/sense_be_rx_service.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/devices/sense_be_rx/1.0/profiles/profile_summary_view.dart';
import 'package:setup/ui/devices/sense_be_rx/1.0/settings/motion_tab_contents.dart';
import 'package:setup/ui/devices/sense_be_rx/1.0/settings/radio_tab_contents.dart';
import 'package:setup/ui/devices/sense_be_rx/1.0/settings/setting_summary_card.dart';
import 'package:setup/ui/devices/sense_be_rx/1.0/settings/setting_timepicker_screen.dart';
import 'package:setup/ui/devices/sense_be_rx/1.0/settings/timer_tab_contents.dart';
import 'package:setup/ui/widgets/bottom_action_bar.dart';
import 'package:setup/ui/widgets/custom_divider.dart';
import 'package:setup/ui/widgets/profile_name_dialog.dart';

/// {@category Page}
///
/// TODO:.
class DeviceSettingsView extends StatefulWidget {
  @override
  _DeviceSettingsViewState createState() => _DeviceSettingsViewState();
}

class _DeviceSettingsViewState extends State<DeviceSettingsView>
    with TickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollViewController;
  RubberAnimationController _controller;
  int _activeIndex = 0;
  Future profiles = locator<ProfilesService>().getProfiles();
  bool _hideFAB = false;

  ScrollController _scrollController;
  AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    _controller = RubberAnimationController(
      vsync: this,
      lowerBoundValue: AnimationControllerValue(pixel: 0),
      halfBoundValue: AnimationControllerValue(pixel: 200),
      upperBoundValue: AnimationControllerValue(percentage: 0.96),
      duration: Duration(milliseconds: 200),

      // dismissable: true,
    );
    _controller.addStatusListener(profilesBottomSheetListener);
    _tabController.addListener(setIndex);

    _scrollViewController = ScrollController(initialScrollOffset: 0);
    _scrollController = ScrollController();

    //  Reset
    locator<ProfilesService>().activeProfile = null;
    locator<SenseBeRxService>().reset();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProfileFile profileFile =
        Provider.of<ProfilesService>(context).activeProfile;
    BluetoothDeviceState deviceState =
        Provider.of<BluetoothConnectionService>(context).deviceState;
    bool _isBluetoothOn =
        Provider.of<BluetoothScanService>(context).isBluetoothOn;
    SenseBeRx structure = Provider.of<SenseBeRxService>(context).structure;

    List<SettingSummaryCard> motionSettingCards =
        getSettingsCards(structure.settings, MotionSetting, context);
    List<SettingSummaryCard> timerSettingCards =
        getSettingsCards(structure.settings, TimerSetting, context);

    String motionFABDisabledMessage = '';
    String timerFABDisabledMessage = '';

    if (Provider.of<SenseBeRxService>(context).numberofOccupiedSettings == 8) {
      timerFABDisabledMessage = maxNumberReachedErrorMessage;
      motionFABDisabledMessage = maxNumberReachedErrorMessage;
    }

    if (Provider.of<SenseBeRxService>(context).structure.operationTime[0] ==
        OperationTime.ALL_TIME) {
      motionFABDisabledMessage = allTimeErrorMessage;
    } else if (Provider.of<SenseBeRxService>(context)
            .structure
            .motionAmbientState ==
        7) {
      motionFABDisabledMessage = maxAmbientReachedErrorMessage;
    }

    if (Provider.of<SenseBeRxService>(context).structure.operationTime[1] ==
        OperationTime.ALL_TIME) {
      timerFABDisabledMessage = allTimeErrorMessage;
    } else if (Provider.of<SenseBeRxService>(context)
            .structure
            .timerAmbientState ==
        7) {
      timerFABDisabledMessage = maxAmbientReachedErrorMessage;
    }

    print("Rebuilding ${this.runtimeType}");

    if (deviceState == BluetoothDeviceState.disconnected || !_isBluetoothOn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.popUntil(context, ModalRoute.withName('/'));
      });
      return Scaffold();
    }

    if (deviceState == BluetoothDeviceState.connecting || deviceState == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Connecting..."),
              SizedBox(height: 30),
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
    }

    if (deviceState == BluetoothDeviceState.connected && _isBluetoothOn) {
      _memoizer.runOnce(() {
        locator<SenseBeRxService>().readFromDevice();
      });
      return Provider.of<SenseBeRxService>(context).deviceInfo == null
          ? Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Reading data..."),
                    SizedBox(height: 30),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            )
          : WillPopScope(
              child: Scaffold(
                body: RubberBottomSheet(
                  lowerLayer: RubberLower(
                    scrollViewController: _scrollViewController,
                    tabController: _tabController,
                    motionSettingCards: motionSettingCards,
                    timerSettingCards: timerSettingCards,
                  ),
                  upperLayer: Container(
                    color: Colors.white,
                    height: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            // TODO: Check if profile active and hide update button if not.
                            children: <Widget>[
                              Builder(
                                builder: (context) => OutlineButton(
                                  child: Text(
                                    "SAVE AS NEW PROFILE",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                  highlightedBorderColor: Colors.black,
                                  onPressed: () async {
                                    _controller.collapse();
                                    await showDialog(
                                        context: context,
                                        builder: (context) => ProfileNameDialog(
                                              fileNameController:
                                                  TextEditingController(
                                                text: "",
                                              ),
                                              profileFile: profileFile,
                                              deviceType: Device.SENSE_BE_RX,
                                            ));
                                    SnackBar s = SnackBar(
                                      backgroundColor:
                                          Theme.of(context).accentColor,
                                      duration: Duration(seconds: 3),
                                      content: Text("Saved successfully 🎉 "),
                                    );
                                    Scaffold.of(context).showSnackBar(s);
                                  },
                                ),
                              ),
                              Builder(
                                builder: (context) => (profileFile != null)
                                    ? OutlineButton(
                                        child: Text(
                                          "UPDATE SELECTED PROFILE",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                        highlightedBorderColor: Colors.black,
                                        onPressed: () {
                                          _controller.collapse();
                                          locator<ProfilesService>()
                                              .updateProfile(
                                                  profileFile.filePath);
                                          SnackBar s = SnackBar(
                                            backgroundColor:
                                                Theme.of(context).accentColor,
                                            duration: Duration(seconds: 3),
                                            content: Text(
                                                "${profileFile.fileName} updated 🎉 "),
                                          );
                                          Scaffold.of(context).showSnackBar(s);
                                        },
                                      )
                                    : Container(width: 0),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Load from saved profiles",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              FutureBuilder(
                                  future: profiles,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data.length == 0) {
                                        return ListTile(
                                          title: Text(
                                            "No profiles created for this device yet!",
                                          ),
                                        );
                                      }
                                      return ListView.separated(
                                        separatorBuilder: (_, __) =>
                                            CustomDivider(),
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, i) => ListTile(
                                          title:
                                              Text(snapshot.data[i].fileName),
                                          onTap: () {
                                            _controller.collapse();
                                            locator<ProfilesService>()
                                                .createStructure(
                                              snapshot.data[i].filePath,
                                              snapshot.data[i].deviceType,
                                            );
                                            locator<ProfilesService>()
                                                .setActiveProfile(
                                                    snapshot.data[i]);
                                            setState(() {});
                                          },
                                        ),
                                        itemCount: snapshot.data.length,
                                      );
                                    }
                                    if (snapshot.hasError) {
                                      return ListTile(
                                        title: Text(
                                          "No profiles created for this device yet!",
                                        ),
                                      );
                                    }
                                    return Container();
                                  }),
                            ],
                          ),
                        ],
                      ),
                      physics: NeverScrollableScrollPhysics(),
                      controller: _scrollController,
                    ),
                  ),
                  animationController: _controller,
                  scrollController: _scrollController,
                ),
                // body: RubberBottomSheet(
                //   animationController: _controller,
                //   lowerLayer: Container(color: Colors.orange),
                //   upperLayer: Container(color: Colors.red),
                // ),

                floatingActionButton: Builder(
                  builder: (context) => (_activeIndex != 2 && !_hideFAB)
                      ? FloatingActionButton(
                          backgroundColor: (_tabController.index == 0 &&
                                      motionFABDisabledMessage.isEmpty) ||
                                  (_tabController.index == 1 &&
                                      timerFABDisabledMessage.isEmpty)
                              ? null
                              : Colors.grey,
                          child: Icon(Icons.add),
                          onPressed: (_tabController.index == 0 &&
                                      motionFABDisabledMessage.isEmpty) ||
                                  (_tabController.index == 1 &&
                                      timerFABDisabledMessage.isEmpty)
                              ? () {
                                  locator<SenseBeRxService>().setActiveIndex(
                                      tabIndex: _tabController.index);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SettingTimepickerScreen(),
                                    ),
                                  );
                                }
                              : () {
                                  SnackBar s = SnackBar(
                                    backgroundColor:
                                        Theme.of(context).errorColor,
                                    duration: Duration(seconds: 3),
                                    action: SnackBarAction(
                                      label: "OK",
                                      textColor: Colors.white,
                                      onPressed: () => Scaffold.of(context)
                                          .hideCurrentSnackBar(),
                                    ),
                                    content: Text(
                                      _tabController.index == 0
                                          ? motionFABDisabledMessage
                                          : timerFABDisabledMessage,
                                    ),
                                  );
                                  Scaffold.of(context).showSnackBar(s);
                                },
                        )
                      : Container(),
                ),
                bottomNavigationBar: Builder(
                  builder: (context) => BottomActionBar(
                    actionLabel: "Write",
                    showProfileButton: true,
                    onActionPressed: () async {
                      await locator<BluetoothIOService>()
                          .write(pack(locator<SenseBeRxService>().structure));
                    },
                    onClosePressed: () {
                      closeConnection(context);
                    },
                    onProfileButtonPressed: () {
                      _scrollController.animateTo(
                        0,
                        duration: Duration(milliseconds: 200),
                        curve: ElasticInCurve(),
                      );
                      if (_controller.value <= 0) {
                        _controller.halfExpand();
                        setState(() {
                          _hideFAB = true;
                        });
                      } else {
                        _controller.collapse();
                        setState(() {
                          _hideFAB = false;
                        });
                      }
                    },
                  ),
                ),
              ),
              onWillPop: () async {
                await closeConnection(context);
                return false;
              },
            );
    }
    return Container();
  }

  closeConnection(BuildContext context) {
    print("Called close connection");
    if (locator<SenseBeRxService>().shouldSave) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Write to device before closing?"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "CLOSE",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              onPressed: () {
                // Navigator.popUntil(context, ModalRoute.withName('/'));
                Provider.of<BluetoothConnectionService>(context).disconnect();
              },
            ),
            FlatButton(
                child: Text(
                  "WRITE AND CLOSE",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  //TODO:
                  locator<SenseBeRxService>().shouldSave = false;
                  await locator<BluetoothIOService>()
                      .write(pack(locator<SenseBeRxService>().structure));
                  // Navigator.popUntil(context, ModalRoute.withName('/'));
                  Provider.of<BluetoothConnectionService>(context).disconnect();
                }),
          ],
        ),
      );
    } else {
      Provider.of<BluetoothConnectionService>(context).disconnect();
    }
  }

  void setIndex() {
    setState(() {
      _activeIndex = _tabController.index;
    });
  }

  void profilesBottomSheetListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (_controller.value <= 0.1) {
        setState(() {
          _hideFAB = false;
        });
      }
    }
  }
}

class RubberLower extends StatelessWidget {
  const RubberLower({
    Key key,
    @required ScrollController scrollViewController,
    @required TabController tabController,
    @required this.motionSettingCards,
    @required this.timerSettingCards,
  })  : _scrollViewController = scrollViewController,
        _tabController = tabController,
        super(key: key);

  final ScrollController _scrollViewController;
  final TabController _tabController;
  final List<SettingSummaryCard> motionSettingCards;
  final List<SettingSummaryCard> timerSettingCards;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: _scrollViewController,
      headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              locator<SenseBeRxService>().structure.deviceName,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                children: <Widget>[
                  SizedBox(height: 85),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            DeviceHelper.getString(Device.SENSE_BE_RX),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                BatteryHelper.getString(
                                  Provider.of<SenseBeRxService>(context)
                                      .deviceInfo
                                      .batteryType,
                                ),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              Icon(
                                Icons.battery_std,
                                color: Colors.white,
                              ),
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
                                  Provider.of<SenseBeRxService>(context)
                                      .deviceInfo
                                      .firmwareVersion
                                      .toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20,
                                  ),
                                ),
                                // IconButton(
                                //   splashColor: Theme.of(context).accentColor,
                                //   icon: Icon(
                                //     Icons.update,
                                //     color: Colors.white,
                                //   ),
                                //   onPressed: () {},
                                // ),
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
                ],
              ),
            ),
            pinned: true,
            expandedHeight: 180,
            forceElevated: boxIsScrolled,
            actions: <Widget>[
              IconButton(
                icon: Icon(OMIcons.edit),
                onPressed: () {
                  TextEditingController name = TextEditingController(
                    text: Provider.of<SenseBeRxService>(context)
                        .structure
                        .deviceName
                        .trim(),
                  );
                  showDialog(
                      context: context,
                      builder: (context) => SingleFeildDialogBox(
                            title: "Device Name",
                            textEditingController: name,
                            onActionPressed: () {
                              locator<SenseBeRxService>()
                                  .setDeviceName(name.text);
                              Navigator.pop(context);
                            },
                          ));
                },
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
                Tab(text: "More"),
              ],
              controller: _tabController,
            ),
          )
        ];
      },
      body: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            MotionTabContents(motionSettingCards: motionSettingCards),
            TimerTabContents(timerSettingCards: timerSettingCards),
            MoreTabContents(),
          ],
          controller: _tabController,
        ),
      ),
    );
  }
}
