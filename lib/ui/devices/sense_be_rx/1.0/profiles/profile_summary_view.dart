import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/models/devices/sense_be_rx/1.0/sense_be_rx.dart';
import 'package:setup/core/services/profiles.dart';
import 'package:setup/core/services/sense_be_rx_service.dart';
import 'package:setup/core/services/shared_prefs.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/devices/sense_be_rx/1.0/profiles/setting_summary_card.dart';
import 'package:setup/ui/devices/sense_be_rx/1.0/profiles/setting_summary_page.dart';
import 'package:setup/ui/devices/sense_be_rx/1.0/settings/radio_settings_view.dart';
import 'package:setup/ui/devices/sense_be_rx/1.0/settings/setting_timepicker_screen.dart';
import 'package:setup/ui/views/profiles_view.dart';
import 'package:setup/ui/widgets/advanced_option_tile.dart';
import 'package:setup/ui/widgets/advanced_option_wrapper.dart';
import 'package:setup/ui/widgets/bottom_action_bar.dart';
import 'package:setup/ui/widgets/profile_app_bar.dart';

/// {@category Page}
/// {@category SenseBeRx}
/// {@category Design}
///
///
/// Profile Summary screen, shown when a profile is clicked from [ProfilesView]
class ProfileSummaryView extends StatefulWidget {
  @override
  _ProfileSummaryViewState createState() => _ProfileSummaryViewState();
}

class _ProfileSummaryViewState extends State<ProfileSummaryView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  int _activeIndex = 0;

  var visible;

  bool advancedOptionMoreTab = locator<SharedPrefs>().advancedOptions;
  bool firstBuild = true;

  TextEditingController radioOperationDurationController =
      TextEditingController();
  TextEditingController radioOperationFrequencyController =
      TextEditingController();

  final String allTimeErrorMessage =
      "No other setting is possible when \"ALL TIME\" is selected";
  final String maxAmbientReachedErrorMessage =
      "No other \"Ambient light\" combination is possible";
  final String maxNumberReachedErrorMessage =
      "Reached the maximum number of settings";

  @override
  initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(setIndex);
  }

  @override
  Widget build(BuildContext context) {
    if (firstBuild) {
      advancedOptionMoreTab = Provider.of<SenseBeRxService>(context)
          .metaStructure
          .radioAdvancedOption;
      firstBuild = false;
    }
    ProfileFile profileFile =
        Provider.of<ProfilesService>(context).activeProfile;
    String profilePath = profileFile.filePath;
    SenseBeRx structure = Provider.of<SenseBeRxService>(context).structure;
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

    List<SettingSummaryCard> motionSettingCards =
        getSettingsCards(structure.settings, MotionSetting);
    List<SettingSummaryCard> timerSettingCards =
        getSettingsCards(structure.settings, TimerSetting);

    RadioSetting radioSetting =
        Provider.of<SenseBeRxService>(context).structure.radioSetting;
// TODO: remove build error
    radioOperationDurationController.text =
        radioSetting.radioOperationDuration.toString();
    radioOperationFrequencyController.text =
        radioSetting.radioOperationFrequency.toString();

    return WillPopScope(
      child: Scaffold(
        appBar: ProfileAppBar(
          profileFile: profileFile,
          tabController: _tabController,
          onDeletePressed: () {
            Provider.of<ProfilesService>(context)
                .deleteProfile(profileFile.filePath);
            Navigator.popUntil(context, ModalRoute.withName('/'));
            Provider.of<SenseBeRxService>(context).reset();
          },
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ...motionSettingCards,
                  // Text(
                  //     "state: ${Provider.of<SenseBeRxService>(context).structure.motionAmbientState}"),
                  // Text(
                  //     "subtract: ${Provider.of<SenseBeRxService>(context).ambientStateToSubtract}"),
                  // Text(
                  //     "add: ${Provider.of<SenseBeRxService>(context).ambientStateToAdd}"),
                  motionSettingCards.length > 0
                      ? DeleteAllSettingsButton(onPressed: () {
                          locator<SenseBeRxService>()
                              .deleteAllSettings(MotionSetting);
                        })
                      : SizedBox(
                          height: MediaQuery.of(context).size.height - 220,
                          child: Center(
                            child: Text(
                              "Nothing here yet, add a new Motion setting.",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ...timerSettingCards,
                  timerSettingCards.length > 0
                      ? DeleteAllSettingsButton(
                          onPressed: () {
                            Provider.of<SenseBeRxService>(context)
                                .deleteAllSettings(TimerSetting);
                          },
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height - 220,
                          child: Center(
                            child: Text(
                              "Nothing here yet, add a new Timer setting.",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ListCard(
                    child: Builder(
                      builder: (context) => AdvancedOptionTile(
                        value: advancedOptionMoreTab,
                        onChanged: (val) {
                          setState(() {
                            advancedOptionMoreTab = val;
                            if (!val) {
                              locator<SenseBeRxService>().resetRadio();
                              Provider.of<SenseBeRxService>(context)
                                  .setDeviceSpeed(DeviceSpeed.FAST);
                              Scaffold.of(context).showSnackBar(
                                  locator<SenseBeRxService>()
                                      .advancedSettingOffSnackbar);
                            }
                            locator<SenseBeRxService>()
                                .setRadioAdvancedOption(val);
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  AdvancedOptionWrapper(
                    advancedOptionController: advancedOptionMoreTab,
                    child: ListCard(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: ListTile(
                          onTap: () {
                            locator<SenseBeRxService>().editRadioSettings();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RadioSettingsView(),
                              ),
                            );
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Radio",
                                style: Theme.of(context)
                                    .textTheme
                                    .title
                                    .copyWith(fontSize: 20),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            children: <Widget>[
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Channel"),
                                  Text(
                                      "${int.tryParse(radioSetting.radioChannel.toString().split(".")[1].split("_")[1]) + 1}"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Speed"),
                                  Text(
                                      "${radioSetting.speed.toString().split('.')[1].split("_").join(" ")}"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  AdvancedOptionWrapper(
                    advancedOptionController: advancedOptionMoreTab,
                    child: ListCard(
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Beam Speed",
                                    style: Theme.of(context)
                                        .textTheme
                                        .title
                                        .copyWith(fontSize: 20),
                                  ),
                                  DropdownButton(
                                    value:
                                        Provider.of<SenseBeRxService>(context)
                                            .structure
                                            .deviceSpeed,
                                    underline: Container(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .title
                                        .copyWith(
                                          fontSize: 18,
                                        ),
                                    items: DeviceSpeed.values.map((speed) {
                                      String text = speed
                                          .toString()
                                          .split(".")[1]
                                          .toLowerCase();
                                      return DropdownMenuItem<DeviceSpeed>(
                                          value: speed,
                                          child: Text(
                                            text.replaceFirst(
                                                RegExp(r'.', dotAll: true),
                                                text[0].toUpperCase()),
                                          ));
                                    }).toList(),
                                    onChanged: (value) {
                                      Provider.of<SenseBeRxService>(context)
                                          .setDeviceSpeed(value);
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Text(
                                "This configures how frequent the beam pulses are expected. Set this based on the targeted animal speed. Faster mode decreases battery life.",
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 60),
                  AdvancedOptionWrapper(
                    advancedOptionController: advancedOptionMoreTab,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "IMPORTANT: Make sure the radio settings and beam speed is same on other devices which will communicate with this device.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) => _activeIndex != 2
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
                          locator<SenseBeRxService>()
                              .setActiveIndex(tabIndex: _tabController.index);
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
                              onPressed: () =>
                                  Scaffold.of(context).hideCurrentSnackBar(),
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
            actionLabel: "Save",
            onActionPressed: () {
              locator<ProfilesService>().updateProfile(profilePath);
              locator<SenseBeRxService>().shouldSave = false;
              var x = SnackBar(
                content: Text(
                  "Saved Successfully  🎉",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                elevation: 5,
                backgroundColor: Theme.of(context).accentColor,
                duration: Duration(seconds: 1),
                behavior: SnackBarBehavior.fixed,
              );
              Scaffold.of(context).showSnackBar(x);
            },
            onClosePressed: () {
              if (Provider.of<SenseBeRxService>(context).shouldSave) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Save setting before closing?"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                          "JUST CLOSE",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        onPressed: () => Navigator.popUntil(
                            context, ModalRoute.withName('/')),
                      ),
                      FlatButton(
                          child: Text(
                            "SAVE AND CLOSE",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            locator<ProfilesService>()
                                .updateProfile(profilePath);
                            locator<SenseBeRxService>().shouldSave = false;
                            Navigator.popUntil(
                                context, ModalRoute.withName('/'));
                          }),
                    ],
                  ),
                );
              } else {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              }
            },
          ),
        ),
      ),
      onWillPop: () async {
        /// clear structure when going back
        Provider.of<SenseBeRxService>(context).reset();
        Navigator.popUntil(context, ModalRoute.withName('/'));
        return false;
      },
    );
  }

  void setIndex() {
    setState(() {
      _activeIndex = _tabController.index;
    });
  }

  List<SettingSummaryCard> getSettingsCards(List<Setting> settings, Type type) {
    List<SettingSummaryCard> settingsCard = [];
    settings.forEach((setting) {
      if (setting.sensorSetting.runtimeType == type && setting.index != 8) {
        settingsCard.add(SettingSummaryCard(
            setting: setting,
            onTap: () {
              print(type);
              Provider.of<SenseBeRxService>(context)
                  .setActiveIndex(setting: setting);

              Navigator.pushNamed(
                  context, '/devices/sense-be-rx/setting-summary');
            },
            onDeletePressed: () {
              locator<SenseBeRxService>().showDeleteSettingModal(
                onPressed: () =>
                    locator<SenseBeRxService>().deleteSetting(setting),
                context: context,
              );
            }));
      }
    });
    return settingsCard;
  }
}

class DeleteAllSettingsButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DeleteAllSettingsButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SizedBox(height: 20),
      FlatButton.icon(
        splashColor: Theme.of(context).errorColor.withAlpha(100),
        highlightColor: Colors.transparent,
        icon: Icon(
          OMIcons.delete,
          color: Theme.of(context).errorColor,
        ),
        label: Text(
          "Delete All Settings".toUpperCase(),
          style: TextStyle(
            color: Theme.of(context).errorColor,
          ),
        ),
        onPressed: () => locator<SenseBeRxService>().showDeleteSettingModal(
            all: true, onPressed: onPressed, context: context),
      ),
      SizedBox(height: 20),
    ]);
  }
}
