import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/models/devices/sense_be_tx/1.0/sense_be_tx.dart';
import 'package:setup/core/models/generic/operation_time.dart';
import 'package:setup/core/models/generic/radio_setting.dart';
import 'package:setup/core/models/generic/sensor_setting.dart';
import 'package:setup/core/services/device.dart';
import 'package:setup/core/services/profiles.dart';
import 'package:setup/core/services/sense_be_tx_service.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/devices/sense_be_tx/1.0/settings/motion_tab_contents.dart';
import 'package:setup/ui/devices/sense_be_tx/1.0/settings/radio_tab_contents.dart';
import 'package:setup/ui/devices/sense_be_tx/1.0/settings/setting_summary_card.dart';
import 'package:setup/ui/devices/sense_be_tx/1.0/settings/setting_timepicker_screen.dart';
import 'package:setup/ui/devices/sense_be_tx/1.0/settings/timer_tab_contents.dart';

import 'package:setup/ui/views/profiles_view.dart';
import 'package:setup/ui/widgets/bottom_action_bar.dart';
import 'package:setup/ui/widgets/profile_app_bar.dart';

// TODO: Move
final String allTimeErrorMessage =
    "No other setting is possible when \"ALL TIME\" is selected";
final String maxAmbientReachedErrorMessage =
    "No other \"Ambient light\" combination is possible";
final String maxNumberReachedErrorMessage =
    "Reached the maximum number of settings";

/// {@category Page}
/// {@category SenseBeTx}
/// {@category Design}
///
///
/// Profile Summary screen, shown when a profile is clicked from [ProfilesView]
class ProfileSummaryView extends StatefulWidget {
  final Device device;
  const ProfileSummaryView({Key key, this.device}) : super(key: key);
  @override
  _ProfileSummaryViewState createState() => _ProfileSummaryViewState();
}

class _ProfileSummaryViewState extends State<ProfileSummaryView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  int _activeIndex = 0;

  TextEditingController radioOperationDurationController =
      TextEditingController();
  TextEditingController radioOperationFrequencyController =
      TextEditingController();

  @override
  initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(setIndex);
  }

  @override
  Widget build(BuildContext context) {
    ProfileFile profileFile =
        Provider.of<ProfilesService>(context).activeProfile;
    String profilePath = profileFile.filePath;
    SenseBeTx structure = Provider.of<SenseBeTxService>(context).structure;
    String motionFABDisabledMessage = '';
    String timerFABDisabledMessage = '';

    if (Provider.of<SenseBeTxService>(context).numberofOccupiedSettings == 8) {
      timerFABDisabledMessage = maxNumberReachedErrorMessage;
      motionFABDisabledMessage = maxNumberReachedErrorMessage;
    }

    if (structure.operationTime[0] == OperationTime.ALL_TIME) {
      motionFABDisabledMessage = allTimeErrorMessage;
    } else if (structure.motionAmbientState == 7) {
      motionFABDisabledMessage = maxAmbientReachedErrorMessage;
    }

    if (structure.operationTime[1] == OperationTime.ALL_TIME) {
      timerFABDisabledMessage = allTimeErrorMessage;
    } else if (structure.timerAmbientState == 7) {
      timerFABDisabledMessage = maxAmbientReachedErrorMessage;
    }

    List<SettingSummaryCard> motionSettingCards =
        getSettingsCards(structure.settings, MotionSetting, context);
    List<SettingSummaryCard> timerSettingCards =
        getSettingsCards(structure.settings, TimerSetting, context);

    RadioSetting radioSetting = structure.radioSetting;
// TODO: remove build error
    radioOperationDurationController.text =
        radioSetting.radioOperationDuration.toString();
    radioOperationFrequencyController.text =
        radioSetting.radioOperationFrequency.toString();

    return WillPopScope(
      child: Scaffold(
        appBar: ProfileAppBar(
          profileFile: profileFile,
          moreTabName: 'MORE',
          tabController: _tabController,
          onDeletePressed: () {
            Provider.of<ProfilesService>(context)
                .deleteProfile(profileFile.filePath);
            Navigator.popUntil(context, ModalRoute.withName('/'));
            Provider.of<SenseBeTxService>(context).reset();
          },
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: <Widget>[
            MotionTabContents(motionSettingCards: motionSettingCards),
            TimerTabContents(timerSettingCards: timerSettingCards),
            MoreTabContents(),
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
                          locator<SenseBeTxService>()
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
              locator<SenseBeTxService>().shouldSave = false;
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
            onClosePressed: () => closeSummary(profilePath),
          ),
        ),
      ),
      onWillPop: () async {
        closeSummary(profilePath);
        return false;
      },
    );
  }

  closeSummary(String profilePath) {
    if (Provider.of<SenseBeTxService>(context).shouldSave) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Save setting before closing?"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "CLOSE",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              onPressed: () =>
                  Navigator.popUntil(context, ModalRoute.withName('/')),
            ),
            FlatButton(
                child: Text(
                  "SAVE AND CLOSE",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  locator<ProfilesService>().updateProfile(profilePath);
                  locator<SenseBeTxService>().shouldSave = false;
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                }),
          ],
        ),
      );
    } else {
      /// clear structure when going back
      Provider.of<SenseBeTxService>(context).reset();
      Navigator.popUntil(context, ModalRoute.withName('/'));
    }
  }

  void setIndex() {
    setState(() {
      _activeIndex = _tabController.index;
    });
  }
}

List<SettingSummaryCard> getSettingsCards(
    List<BeTxSetting> settings, Type type, BuildContext context) {
  List<SettingSummaryCard> settingsCard = [];
  settings.forEach((setting) {
    if (setting.sensorSetting.runtimeType == type && setting.index != 8) {
      settingsCard.add(SettingSummaryCard(
          setting: setting,
          onTap: () {
            print(type);
            Provider.of<SenseBeTxService>(context)
                .setActiveIndex(setting: setting);

            Navigator.pushNamed(context, '/bt/setting-summary');
          },
          onDeletePressed: () {
            locator<SenseBeTxService>().showDeleteSettingModal(
              onPressed: () =>
                  locator<SenseBeTxService>().deleteSetting(setting),
              context: context,
            );
          }));
    }
  });
  return settingsCard;
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
        onPressed: () => locator<SenseBeTxService>().showDeleteSettingModal(
            all: true, onPressed: onPressed, context: context),
      ),
      SizedBox(height: 20),
    ]);
  }
}
