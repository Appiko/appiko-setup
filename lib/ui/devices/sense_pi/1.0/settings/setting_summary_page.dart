import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/models/devices/sense_pi/1.0/sense_pi.dart';
import 'package:setup/core/models/generic/camera.dart';

import 'package:setup/core/models/generic/sensor_setting.dart';
import 'package:setup/core/models/generic/time.dart' as time;
import 'package:setup/core/models/generic/time.dart';
import 'package:setup/core/services/sense_pi_service.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/devices/sense_pi/1.0/settings/camera_trriger_view.dart';
import 'package:setup/ui/devices/sense_pi/1.0/settings/setting_summary_card.dart';
import 'package:setup/ui/devices/sense_pi/1.0/settings/setting_timepicker_screen.dart';
import 'package:setup/ui/widgets/custom_app_bar.dart';

class SettingSummaryPage extends StatefulWidget {
  const SettingSummaryPage({Key key}) : super(key: key);

  @override
  _SettingSummaryPageState createState() => _SettingSummaryPageState();
}

/// {@category Page}
/// {@category Design}
/// {@category SensePi}
///
/// This page is displayed after, tapping on any of the [SettingSummaryCard].
class _SettingSummaryPageState extends State<SettingSummaryPage> {
  bool isRadioEnabled;
  Widget cameraCard;
  String timeString;

  @override
  Widget build(BuildContext context) {
    PiSetting setting = Provider.of<SensePiService>(context).activeSetting;

    switch (setting.cameraSetting.mode) {
      case CameraAction.SINGLE_PICTURE:
        cameraCard = SinglePictureCard(
            singlePictureSetting: setting.cameraSetting, index: setting.index);
        break;
      case CameraAction.MULTIPLE_PICTURES:
        cameraCard = MultiplePicturesCard(
            setting: setting.cameraSetting, index: setting.index);
        break;
      case CameraAction.LONG_PRESS:
        cameraCard = LongPressCard(
            longPressSetting: setting.cameraSetting, index: setting.index);
        break;
      case CameraAction.VIDEO:
        cameraCard = VideoCard(
          timer: setting.sensorSetting.runtimeType == TimerSetting,
          videoSetting: setting.cameraSetting,
          index: setting.index,
        );
        break;
      case CameraAction.HALF_PRESS:
        cameraCard = HalfPressCard(halfPressSetting: setting.cameraSetting);
        break;
      case CameraAction.NONE:
        cameraCard = TriggerInfoCard(info: "No Action");
    }

    return WillPopScope(
      onWillPop: () async {
        locator<SensePiService>().updateSetting();

        locator<SensePiService>().closeChangeFlow();
// As cameraSettingPop is related
        Navigator.popAndPushNamed(
            context, locator<SensePiService>().getCloseSummaryPath());

        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title:
              "${setting.sensorSetting.runtimeType == MotionSetting ? "Motion Setting" : "Timer Setting"}",
          // subtitle: timeString,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                locator<SensePiService>().showDeleteSettingModal(
                    onPressed: () {
                      locator<SensePiService>().deleteSetting(setting);
                    },
                    context: context);
              },
              icon: Icon(OMIcons.delete),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 30),
              TimeRow(timeSetting: setting.time),
              SizedBox(height: 30),
              InkWell(
                child: cameraCard,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CameraTriggerView(passSetting: true),
                      ));
                },
              ),
              SizedBox(height: 12),
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        Provider.of<SensePiService>(context).getSensorView(),
                  ),
                ),
                child: (setting.sensorSetting.runtimeType == MotionSetting)
                    ? MotionListCard(setting: setting)
                    : (setting.sensorSetting.runtimeType == TimerSetting)
                        ? TimerListCard(setting: setting)
                        : null,
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text("DONE"),
          // FIXME: Infinite bounds error
          onPressed: () {
            locator<SensePiService>().updateSetting();
            // Navigator.popUntil(context,
            //     ModalRoute.withName('/devices/sense-be-rx/profile-summary'));
            // locator<SensePiService>().getCameraSettingDownArrowPageName();
            Navigator.pop(context);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

/// {@category Widget}
/// {@category Design}
/// {@category SensePi}
///
/// Returns a row displaying the half press trigger duration.
class HalfPressTriggerTimeRow extends StatelessWidget {
  const HalfPressTriggerTimeRow({
    Key key,
    @required this.setting,
  }) : super(key: key);

  final CameraSetting setting;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Half press pulse duration*"),
        Text("${setting.preFocusPulseDuration / 10}s"),
      ],
    );
  }
}

/// {@category Widget}
/// {@category Design}
/// {@category SensePi}
///
/// Returns a row displayig the trigger pulse duration.
class TriggerPulseDurationRow extends StatelessWidget {
  const TriggerPulseDurationRow({
    Key key,
    @required this.setting,
  }) : super(key: key);

  final CameraSetting setting;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Trigger pulse duration*"),
        Text("${setting.triggerPulseDuration / 10}s"),
      ],
    );
  }
}

/// {@category Compound Widget}
/// {@category Design}
/// {@category SensePi}
///
/// Combination of [HalfPressTriggerTimeRow] and [TriggerPulseDurationRow]
class HalfPressAndTriggerPulseDurationRow extends StatelessWidget {
  const HalfPressAndTriggerPulseDurationRow({
    Key key,
    @required this.setting,
  }) : super(key: key);

  final CameraSetting setting;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 4),
        HalfPressTriggerTimeRow(setting: setting),
        SizedBox(height: 4),
        TriggerPulseDurationRow(setting: setting)
      ],
    );
  }
}

/// {@category Widget}
/// {@category Design}
/// {@category SensePi}
///
/// Returns a row, displaying if the half press is on/off.
class HalfPressRow extends StatelessWidget {
  const HalfPressRow({
    Key key,
    @required this.setting,
  }) : super(key: key);

  final CameraSetting setting;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Half press"),
        Text("${setting.enablePreFocus ? 'On' : 'Off'}"),
      ],
    );
  }
}

/// {@category Widget}
/// {@category Design}
/// {@category SensePi}
///
/// Displays if radio should be on or off, for a particular setting.
class RadioRow extends StatelessWidget {
  final CameraSetting setting;

  const RadioRow({Key key, this.setting}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Radio"),
        Text("${setting.enableRadio ? 'On' : 'Off'}"),
      ],
    );
  }
}

/// {@category Compound Widget}
/// {@category Design}
/// {@category SensePi}
///
/// Returns the time ROW which is displayed in the [SettingSummaryPage]
class TimeRow extends StatelessWidget {
  final Time timeSetting;

  const TimeRow({Key key, this.timeSetting}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: timeSetting.runtimeType == time.TimeOfDay
          ? Row(
              children: <Widget>[
                TimeButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SettingTimepickerScreen(),
                          ));
                    },
                    time: time.getTimeString(
                        dateTime: time.getDateTimefromSeconds(
                            (timeSetting as time.TimeOfDay).startTime))),
                SizedBox(width: 10),
                CustomPaint(
                  painter: CirclePainter(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Flexible(
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    width: double.infinity,
                    height: 2,
                  ),
                ),
                CustomPaint(
                  painter: CirclePainter(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(width: 10),
                TimeButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SettingTimepickerScreen(),
                          ));
                    },
                    time: time.getTimeString(
                        dateTime: time.getDateTimefromSeconds(
                            (timeSetting as time.TimeOfDay).endTime))),
              ],
            )
          : timeSetting.runtimeType == time.Ambient
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CustomPaint(
                      painter: CirclePainter(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Flexible(
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        width: double.infinity,
                        height: 2,
                      ),
                    ),
                    TimeButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SettingTimepickerScreen(),
                            ));
                      },
                      time: time.getTimeString(
                        ambientLight:
                            (timeSetting as time.Ambient).ambientLight,
                      ),
                    ),
                    Flexible(
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        width: double.infinity,
                        height: 2,
                      ),
                    ),
                    CustomPaint(
                      painter: CirclePainter(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                )
              : ListView(shrinkWrap: true),
    );
  }
}

/// {@category Widget}
/// {@category Design}
///
/// This can be used as a Wrapper, for elements wich needs to expand
/// to max width available to it.
///
/// Container card to be displayed on [SettingSummaryPage].
class ListCard extends StatelessWidget {
  final Widget child;

  const ListCard({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Card(
        margin: EdgeInsets.all(0),
        elevation: 0,
        clipBehavior: Clip.none,
        shape: ContinuousRectangleBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: child,
        ),
      ),
    );
  }
}

/// {@category Compound Widget}
/// {@category Design}
/// {@category SensePi}
///
/// Motion settings to be displayed on [SettingSummaryPage].
class MotionListCard extends StatelessWidget {
  final PiSetting setting;

  const MotionListCard({Key key, @required this.setting}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListCard(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: Text(
                "Sensor Settings",
                style: Theme.of(context).textTheme.title.copyWith(fontSize: 20),
              ),
            ),
            subtitle: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Sensitivity"),
                    Text(
                        "${(setting.sensorSetting as MotionSetting).sensitivity}/6"),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Downtime"),
                    Text(
                        "${(setting.sensorSetting as MotionSetting).downtime ~/ 10}s"),
                  ],
                ),
                // SizedBox(height: 4),
                // RadioRow(setting: setting.cameraSetting),
                SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// {@category Compound Widget}
/// {@category Design}
/// {@category SensePi}
///
/// Timer sensor settings to be displayed on [SettingSummaryPage].
class TimerListCard extends StatelessWidget {
  final PiSetting setting;

  const TimerListCard({Key key, @required this.setting}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListCard(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: Text(
                "Sensor Settings",
                style: Theme.of(context).textTheme.title.copyWith(fontSize: 20),
              ),
            ),
            subtitle: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Interval"),
                    Text(
                        "${time.getMinSecTimeString(Duration(milliseconds: (setting.sensorSetting as TimerSetting).interval * 100))}"),
                  ],
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// {@category Compound Widget}
/// {@category Design}
/// {@category SensePi}
///
/// Wraps trigger info like `Multiple Picture` in a List Card.
/// Uses [CameraSettingsTitleRow].
class TriggerInfoCard extends StatelessWidget {
  final String info;

  const TriggerInfoCard({Key key, @required this.info}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListCard(
      child: Column(
        children: <Widget>[
          ListTile(title: CameraSettingsTitleRow(value: info)),
        ],
      ),
    );
  }
}

/// {@category Compound Widget}
/// {@category Design}
/// {@category SensePi}
///
/// Multiple Picuture settings card to be displayed on [SettingSummaryPage].
class MultiplePicturesCard extends StatelessWidget {
  final MultiplePicturesSetting setting;
  final int index;

  const MultiplePicturesCard({Key key, @required this.setting, this.index})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListCard(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: CameraSettingsTitleRow(value: "Multiple Pictures"),
            ),
            subtitle: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Number of pictures"),
                    Text("${setting.numberOfPictures}"),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Time interval between pictures"),
                    Text("${setting.pictureInterval ~/ 10}s"),
                  ],
                ),
                SizedBox(height: 4),
                HalfPressRow(setting: setting),
                Provider.of<SensePiService>(context)
                        .metaStructure
                        .advancedOptionsEnabled[index]
                    ? setting.enablePreFocus
                        ? HalfPressAndTriggerPulseDurationRow(setting: setting)
                        : TriggerPulseDurationRow(setting: setting)
                    : Container(),
                SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// {@category Compound Widget}
/// {@category Design}
/// {@category SensePi}
///
/// Video settings card to be displayed on [SettingSummaryPage].
class VideoCard extends StatelessWidget {
  final VideoSetting videoSetting;
  final bool timer;
  final int index;

  const VideoCard({
    Key key,
    @required this.videoSetting,
    this.index,
    this.timer = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListCard(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: CameraSettingsTitleRow(value: "Video"),
            ),
            subtitle: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Video duration"),
                    Text(
                        "${time.getMinSecTimeString(Duration(milliseconds: videoSetting.videoDuration * 100)).split(".")[0]}s"),
                  ],
                ),

                /// If extention on
                SizedBox(height: 4),
                (videoSetting.extensionTime ~/ 10 > 0 && !timer)
                    ? Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Extention time"),
                              Text("${videoSetting.extensionTime ~/ 10}s"),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Number of extentions"),
                              Text("${videoSetting.numberOfExtensions}"),
                            ],
                          ),
                        ],
                      )
                    : !timer
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Extened videos"),
                              Text("Off"),
                            ],
                          )
                        : Container(),
                SizedBox(height: 4),

                Provider.of<SensePiService>(context)
                        .metaStructure
                        .advancedOptionsEnabled[index]
                    ? TriggerPulseDurationRow(setting: videoSetting)
                    : Container(),
                SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// {@category Widget}
/// {@category Design}
///
/// Return a row wich is spaced between a [Text] "Camera Setting" and a value like `Video`
///
class CameraSettingsTitleRow extends StatelessWidget {
  final String value;
  const CameraSettingsTitleRow({
    Key key,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "Camera Settings ",
          style: Theme.of(context).textTheme.title.copyWith(fontSize: 20),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.title.copyWith(fontSize: 14),
          softWrap: true,
        ),
      ],
    );
  }
}

/// {@category Compound Widget}
/// {@category Design}
/// {@category SensePi}
///
/// Long Press settings card to be displayed on [SettingSummaryPage].
class LongPressCard extends StatelessWidget {
  final LongPressSetting longPressSetting;
  final int index;

  const LongPressCard({Key key, @required this.longPressSetting, this.index})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListCard(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: CameraSettingsTitleRow(value: "Long Press")),
            subtitle: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Long Press duration"),
                    Text(
                        "${time.getMinSecTimeString(Duration(milliseconds: longPressSetting.longPressDuration * 100))}"),
                  ],
                ),
                SizedBox(height: 4),
                HalfPressRow(setting: longPressSetting),
                SizedBox(height: 4),
                Provider.of<SensePiService>(context)
                            .metaStructure
                            .advancedOptionsEnabled[index] &&
                        longPressSetting.enablePreFocus
                    ? HalfPressTriggerTimeRow(setting: longPressSetting)
                    : Container(),
                SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// {@category Compound Widget}
/// {@category Design}
/// {@category SensePi}
///
/// Single picture card to be displayed on [SettingSummaryPage].
class SinglePictureCard extends StatelessWidget {
  final CameraSetting singlePictureSetting;
  final int index;

  const SinglePictureCard(
      {Key key, @required this.singlePictureSetting, this.index})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListCard(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: CameraSettingsTitleRow(value: "Single Picture")),
            subtitle: Column(
              children: <Widget>[
                HalfPressRow(setting: singlePictureSetting),
                Provider.of<SensePiService>(context)
                        .metaStructure
                        .advancedOptionsEnabled[index]
                    ? singlePictureSetting.enablePreFocus
                        ? HalfPressAndTriggerPulseDurationRow(
                            setting: singlePictureSetting)
                        : TriggerPulseDurationRow(setting: singlePictureSetting)
                    : Container(),
                SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// {@category Compound Widget}
/// {@category Design}
/// {@category SensePi}
///
/// Half Pres card to be displayed on [SettingSummaryPage].
class HalfPressCard extends StatelessWidget {
  final CameraSetting halfPressSetting;

  const HalfPressCard({Key key, @required this.halfPressSetting})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListCard(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: CameraSettingsTitleRow(value: "Half Press")),
            subtitle: Column(
              children: <Widget>[
                HalfPressTriggerTimeRow(setting: halfPressSetting),
                SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
