import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:rubber/rubber.dart';
import 'package:setup/core/models/devices/sense_pi/1.0/sense_pi.dart';
import 'package:setup/core/models/generic/battery.dart';
import 'package:setup/core/models/generic/operation_time.dart';
import 'package:setup/core/models/generic/sensor_setting.dart';
import 'package:setup/core/services/bluetooth_IO.dart';
import 'package:setup/core/services/bluetooth_connection.dart';
import 'package:setup/core/services/bluetooth_scan.dart';
import 'package:setup/core/services/device.dart';
import 'package:setup/core/services/helper_functions.dart';
import 'package:setup/core/services/profiles.dart';
import 'package:setup/core/services/sense_pi_service.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/devices/sense_pi/1.0/profiles/profile_summary_view.dart';
import 'package:setup/ui/devices/sense_pi/1.0/settings/motion_tab_contents.dart';
import 'package:setup/ui/devices/sense_pi/1.0/settings/setting_summary_card.dart';
import 'package:setup/ui/devices/sense_pi/1.0/settings/setting_timepicker_screen.dart';
import 'package:setup/ui/devices/sense_pi/1.0/settings/timer_tab_contents.dart';
import 'package:setup/ui/widgets/bottom_action_bar.dart';
import 'package:setup/ui/widgets/custom_divider.dart';
import 'package:setup/ui/widgets/device_info_dialog.dart';
import 'package:setup/ui/widgets/device_settings_profiles_layer.dart';

/// {@category Page}
///
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
  Future<List<ProfileFile>> profiles = locator<ProfilesService>().getProfiles();
  bool _hideFAB = false;

  ScrollController _scrollController;
  AsyncMemoizer _memoizer = AsyncMemoizer();

  bool showedDissconnectDialog = false;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
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
    locator<SensePiService>().reset();
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
    SensePi structure = Provider.of<SensePiService>(context).structure;
    bool isDisconnected =
        deviceState == BluetoothDeviceState.disconnected || !_isBluetoothOn;
    List<SettingSummaryCard> motionSettingCards =
        getSettingsCards(structure.settings, MotionSetting, context);
    List<SettingSummaryCard> timerSettingCards =
        getSettingsCards(structure.settings, TimerSetting, context);

    String motionFABDisabledMessage = '';
    String timerFABDisabledMessage = '';

    if (Provider.of<SensePiService>(context).numberofOccupiedSettings == 8) {
      timerFABDisabledMessage = maxNumberReachedErrorMessage;
      motionFABDisabledMessage = maxNumberReachedErrorMessage;
    }

    if (Provider.of<SensePiService>(context).structure.operationTime[0] ==
        OperationTime.ALL_TIME) {
      motionFABDisabledMessage = allTimeErrorMessage;
    } else if (Provider.of<SensePiService>(context)
            .structure
            .motionAmbientState ==
        7) {
      motionFABDisabledMessage = maxAmbientReachedErrorMessage;
    }

    if (Provider.of<SensePiService>(context).structure.operationTime[1] ==
        OperationTime.ALL_TIME) {
      timerFABDisabledMessage = allTimeErrorMessage;
    } else if (Provider.of<SensePiService>(context)
            .structure
            .timerAmbientState ==
        7) {
      timerFABDisabledMessage = maxAmbientReachedErrorMessage;
    }

    print("Rebuilding ${this.runtimeType}");

    if (isDisconnected && !showedDissconnectDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDisconnectedDialog(context);
        showedDissconnectDialog = true;
      });
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
        locator<SensePiService>().readFromDevice();
      });
    }
    return Provider.of<SensePiService>(context).deviceInfo == null
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
                upperLayer: DeviceSettingProfilesLayer(
                  controller: _controller,
                  profileFile: profileFile,
                  deviceType: Device.SENSE_PI,
                  scrollController: _scrollController,
                ),
                animationController: _controller,
                scrollController: _scrollController,
              ),
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
                                locator<SensePiService>().setActiveIndex(
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
                                  backgroundColor: Theme.of(context).errorColor,
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
                  onActionPressed: isDisconnected
                      ? () {
                          SnackBar s = SnackBar(
                            backgroundColor: Theme.of(context).errorColor,
                            duration: Duration(seconds: 3),
                            action: SnackBarAction(
                                label: "SAVE",
                                textColor: Colors.white,
                                onPressed: () {
                                  Scaffold.of(context).hideCurrentSnackBar();
                                  saveAsProfile(
                                      context, profileFile, Device.SENSE_PI);
                                }),
                            content:
                                Text("Device disconnected, save as profile?"),
                          );
                          Scaffold.of(context).showSnackBar(s);
                        }
                      : () async {
                          await locator<BluetoothIOService>()
                              .write(pack(locator<SensePiService>().structure));
                          locator<SensePiService>().shouldSave = false;
                          showWriteSuccessfulSnackbar(context);
                        },
                  onClosePressed: () {
                    closeConnection(context, isDisconnected);
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
              await closeConnection(context, isDisconnected);
              return false;
            },
          );
  }

  closeConnection(BuildContext context, bool isDisconnected) {
    print("Called close connection");
    if (locator<SensePiService>().shouldSave && !isDisconnected) {
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
                workingOnDevice = false;
                Navigator.popUntil(context, ModalRoute.withName('/'));
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
                  locator<SensePiService>().shouldSave = false;
                  await locator<BluetoothIOService>()
                      .write(pack(locator<SensePiService>().structure));
                  workingOnDevice = false;
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                  Provider.of<BluetoothConnectionService>(context).disconnect();
                }),
          ],
        ),
      );
    } else if (locator<SensePiService>().shouldSave && isDisconnected) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text("Discard changes?"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "CANCEL",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
                child: Text(
                  "DISCARD",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  workingOnDevice = false;
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                }),
          ],
        ),
      );
    } else {
      if (!isDisconnected) {
        Provider.of<BluetoothConnectionService>(context).disconnect();
      }
      workingOnDevice = false;
      Navigator.popUntil(context, ModalRoute.withName('/'));
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
              locator<SensePiService>().structure.deviceName,
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
                            DeviceHelper.getString(Device.SENSE_PI),
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
                                  Provider.of<SensePiService>(context)
                                      .deviceInfo
                                      .batteryType,
                                ),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 25),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Icon(
                                  BatteryHelper.getIcon(
                                    Provider.of<SensePiService>(context)
                                        .deviceInfo
                                        .batteryType,
                                    Provider.of<SensePiService>(context)
                                        .deviceInfo
                                        .batteryVoltage,
                                  ),
                                  size: 16,
                                  color: Colors.white,
                                ),
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
                                  Provider.of<SensePiService>(context)
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
                    text: Provider.of<SensePiService>(context)
                        .structure
                        .deviceName
                        .trim(),
                  );
                  showDialog(
                      context: context,
                      builder: (context) => DeviceInfoDialog(
                            batteryType:
                                locator<SensePiService>().structure.batteryType,
                            textEditingController: name,
                            onActionPressed: (BatteryType batteryType) {
                              locator<SensePiService>()
                                  .setDeviceInfo(name.text, batteryType);
                              Navigator.pop(context);
                            },
                          ));
                },
              ),
              IconButton(
                icon: Icon(Icons.info_outline),
                onPressed: () {
                  Navigator.pushNamed(context, '/sp/device-info');
                },
              ),
            ],
            bottom: TabBar(
              tabs: <Widget>[
                Tab(text: "Motion"),
                Tab(text: "Timer"),
                // Tab(text: "Radio"),
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
            // MoreTabContents(),
          ],
          controller: _tabController,
        ),
      ),
    );
  }
}
