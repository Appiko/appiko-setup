import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/models/camera.dart';
import 'package:setup/core/models/sense_be_rx.dart';
import 'package:setup/core/models/time.dart' as time;
import 'package:setup/core/services/sense_be_rx_service.dart';
import 'package:setup/core/services/shared_prefs.dart';
import 'package:setup/core/view_models/ambient_fields_model.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/devices/sense_be/1.0/settings/setting_summary_page.dart';
import 'package:setup/ui/widgets/ambient_fields.dart';
import 'package:setup/ui/widgets/custom_divider.dart';

class SettingSummaryCard extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onDeletePressed;
  final Setting setting;

  const SettingSummaryCard(
      {Key key, this.onTap, this.onDeletePressed, this.setting})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget cameraRow;
    switch (setting.cameraSetting.mode) {
      case CameraAction.SINGLE_PICTURE:
        cameraRow = ListTile(
          title: Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            child: TriggerInfoText(
              value: "Single Picture",
              onDeletePressed: onDeletePressed,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              HalfPressRow(setting: setting.cameraSetting),
              Provider.of<SenseBeRxService>(context)
                      .metaStructure
                      .advancedOptionsEnabled[setting.index]
                  ? setting.cameraSetting.enablePreFocus
                      ? HalfPressAndTriggerPulseDurationRow(
                          setting: setting.cameraSetting)
                      : TriggerPulseDurationRow(setting: setting.cameraSetting)
                  : Container()
            ],
          ),
        );
        break;
      case CameraAction.MULTIPLE_PICTURES:
        cameraRow = MultiplePicturesRow(
          setting: setting.cameraSetting,
          index: setting.index,
          onDeletePressed: onDeletePressed,
        );
        break;
      case CameraAction.LONG_PRESS:
        cameraRow = LongPressRow(
          longPressSetting: setting.cameraSetting,
          onDeletePressed: onDeletePressed,
          index: setting.index,
        );
        break;
      case CameraAction.VIDEO:
        cameraRow = VideoRow(
          videoSetting: setting.cameraSetting,
          onDeletePressed: onDeletePressed,
          timer: setting.sensorSetting.runtimeType == TimerSetting,
          index: setting.index,
        );
        break;
      case CameraAction.HALF_PRESS:
        cameraRow = ListTile(
          title: Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            child: TriggerInfoText(
              value: "Half Press",
              onDeletePressed: onDeletePressed,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              HalfPressRow(setting: setting.cameraSetting),
              HalfPressTriggerTimeRow(setting: setting.cameraSetting),
            ],
          ),
        );
        break;
      case CameraAction.NONE:
        cameraRow = ListTile(
          title: Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            child: TriggerInfoText(
              value: "No Action",
              onDeletePressed: onDeletePressed,
            ),
          ),
        );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            top: 0,
            left: 0,
            bottom: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      setting.time.runtimeType == time.TimeOfDay
                          ? TimeButton(
                              time: time.getTimeString(
                                dateTime: time.getDateTimefromSeconds(
                                    (setting.time as time.TimeOfDay).startTime),
                              ),
                              onPressed: () {
                                showTimePickerBottomSheet(
                                  time: time.getDateTimefromSeconds(
                                    (setting.time as time.TimeOfDay).startTime,
                                  ),
                                  context: context,
                                  settingIndex: setting.index,
                                  isStartTime: true,
                                );
                              },
                            )
                          : (setting.time.runtimeType == time.Ambient)
                              ? TimeButton(
                                  time: time.getTimeString(
                                      ambientLight:
                                          (setting.time as time.Ambient)
                                              .ambientLight),
                                  onPressed: ((setting.time as time.Ambient)
                                              .ambientLight !=
                                          time.AmbientLight.ALL_TIME)
                                      ? () {
                                          showAmbientOptionsBottomSheet(
                                            ambientLight:
                                                (setting.time as time.Ambient)
                                                    .ambientLight,
                                            context: context,
                                            setting: setting,
                                          );
                                        }
                                      : null,
                                )
                              : Container(),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 12, 0, 12),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: CustomPaint(
                                    painter: CirclePainter(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    color: Theme.of(context).primaryColor,
                                    width: 3,
                                  ),
                                ),
                                Container(
                                  child: CustomPaint(
                                    painter: CirclePainter(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      setting.time.runtimeType == time.TimeOfDay
                          ? TimeButton(
                              time: time.getTimeString(
                                  dateTime: time.getDateTimefromSeconds(
                                      (setting.time as time.TimeOfDay)
                                          .endTime)),
                              onPressed: () {
                                showTimePickerBottomSheet(
                                  time: time.getDateTimefromSeconds(
                                      (setting.time as time.TimeOfDay).endTime),
                                  settingIndex: setting.index,
                                  isStartTime: false,
                                  context: context,
                                );
                              },
                            )
                          : Container(height: 25),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(),
              ),
              Expanded(
                flex: 27,
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 40),
                    child: Container(
                      width: double.infinity,
                      child: InkWell(
                        onTap: onTap,
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Text(setting.cameraSetting.mode.toString()),
                                // Text(setting.sensorSetting.toString()),
                                cameraRow,
                                SizedBox(height: 12),
                                CustomDivider(),
                                SizedBox(height: 12),
                                (setting.sensorSetting.runtimeType ==
                                        MotionSetting)
                                    ? MotionRow(setting: setting)
                                    : (setting.sensorSetting.runtimeType ==
                                            TimerSetting)
                                        ? TimerRow(setting: setting)
                                        : null,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> showAmbientOptionsBottomSheet({
    time.AmbientLight ambientLight,
    BuildContext context,
    Setting setting,
  }) {
    int state = 0;

    if (setting.sensorSetting.runtimeType == MotionSetting) {
      state = locator<SenseBeRxService>().structure.motionAmbientState;
    } else {
      state = locator<SenseBeRxService>().structure.timerAmbientState;
    }
    locator<AmbientFieldsModel>().disabledFields =
        locator<SenseBeRxService>().getModesToBeDisabled(
      state: state,
      selectedAmbientLight: (setting.time as time.Ambient).ambientLight,
      change: true,
    );
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AmbientFields(),
                FloatingActionButton.extended(
                    // color: Theme.of(context).primaryColor,
                    label: Text(
                      "OK".padLeft(4).padRight(6),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Provider.of<SenseBeRxService>(context)
                          .setAmbientLight(setting.index);
                      Navigator.pop(context);
                    }),
                SizedBox(height: 16)
              ],
            ),
          );
        });
  }
}

Future<void> showTimePickerBottomSheet({
  DateTime time,
  BuildContext context,
  int settingIndex,
  // If not isStartTime then its endtime :)
  bool isStartTime,
}) {
  DateTime t = time;
  return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => ChangeTimeBottomSheet(
            isStartTime: isStartTime,
            settingIndex: settingIndex,
            time: time,
          ));
}

class ChangeTimeBottomSheet extends StatefulWidget {
  final DateTime time;
  final int settingIndex;
  // If not isStartTime then its endtime :)
  final bool isStartTime;

  const ChangeTimeBottomSheet({
    Key key,
    @required this.time,
    @required this.settingIndex,
    @required this.isStartTime,
  }) : super(key: key);

  @override
  _ChangeTimeBottomSheetState createState() =>
      _ChangeTimeBottomSheetState(t: time);
}

class _ChangeTimeBottomSheetState extends State<ChangeTimeBottomSheet> {
  bool overlap = false;
  DateTime t;
  String errorMessage = "";

  _ChangeTimeBottomSheetState({@required this.t});

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 8),
            child: Text(
              widget.isStartTime ? "Start Time" : "End Time",
              style: Theme.of(context).textTheme.title.copyWith(fontSize: 20.0),
            ),
          ),
        ),
        Container(
          height: 250,
          child: CupertinoDatePicker(
            minuteInterval: 5,
            mode: CupertinoDatePickerMode.time,
            initialDateTime: t,
            onDateTimeChanged: (val) {
              setState(() {
                t = val;
                errorMessage = locator<SenseBeRxService>().timeCheck(
                    settingIndex: widget.settingIndex,
                    pickerStartTime: time.getTimeInSeconds(t),
                    pickerEndTime: (locator<SenseBeRxService>()
                            .structure
                            .settings[widget.settingIndex]
                            .time as time.TimeOfDay)
                        .endTime);
                if (widget.isStartTime) {
                  errorMessage = locator<SenseBeRxService>().timeCheck(
                      settingIndex: widget.settingIndex,
                      pickerStartTime: time.getTimeInSeconds(t),
                      pickerEndTime: (locator<SenseBeRxService>()
                              .structure
                              .settings[widget.settingIndex]
                              .time as time.TimeOfDay)
                          .endTime);
                } else {
                  errorMessage = locator<SenseBeRxService>().timeCheck(
                      settingIndex: widget.settingIndex,
                      pickerEndTime: time.getTimeInSeconds(t),
                      pickerStartTime: (locator<SenseBeRxService>()
                              .structure
                              .settings[widget.settingIndex]
                              .time as time.TimeOfDay)
                          .startTime);
                }
                overlap = errorMessage.isNotEmpty;
              });
            },
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
            child: overlap
                ? Text(
                    errorMessage,
                    style: TextStyle(color: Theme.of(context).errorColor),
                  )
                : Text(""),
          ),
        ),
        FloatingActionButton.extended(
            backgroundColor: overlap ? Theme.of(context).disabledColor : null,
            elevation: overlap ? 0 : 4,
            label: Text("OK".padLeft(4).padRight(6),
                style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: overlap
                ? null
                : () {
                    if (widget.isStartTime) {
                      Provider.of<SenseBeRxService>(context)
                          .setStartTime(widget.settingIndex, t);
                    } else {
                      Provider.of<SenseBeRxService>(context)
                          .setEndTime(widget.settingIndex, t);
                    }
                    Navigator.pop(context);
                  }),
        SizedBox(height: 16)
      ],
    );
  }
}

class TimeButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String time;
  const TimeButton({
    Key key,
    @required this.time,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      child: OutlineButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Text(
          time,
          style: Theme.of(context).textTheme.caption.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
        borderSide: BorderSide(
          width: 1,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final Color color;

  CirclePainter({this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = color ?? Colors.black;

    // center of the canvas is (x,y) => (width/2, height/2)
    var center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, 5.0, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class MotionRow extends StatelessWidget {
  final Setting setting;

  const MotionRow({Key key, @required this.setting}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Sensitivity"),
              Text("${(setting.sensorSetting as MotionSetting).sensitivity}/8"),
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
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Number of triggers"),
              Text(
                  "${(setting.sensorSetting as MotionSetting).numberOfTriggers}"),
            ],
          ),
          SizedBox(height: 4),
          RadioRow(setting: setting.cameraSetting),
        ],
      ),
    );
  }
}

class TimerRow extends StatelessWidget {
  final Setting setting;

  const TimerRow({Key key, @required this.setting}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Interval"),
              Text(
                  "${time.getMinSecTimeString(Duration(milliseconds: (setting.sensorSetting as TimerSetting).interval * 100))}"),
            ],
          ),
          SizedBox(height: 4),
        ],
      ),
    );
  }
}

class TriggerInfoText extends StatelessWidget {
  final String value;

  final VoidCallback onDeletePressed;

  const TriggerInfoText({Key key, @required this.value, this.onDeletePressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 18,
          child: Text(
            value,
            style: Theme.of(context).textTheme.title.copyWith(fontSize: 20),
          ),
        ),
        Flexible(
          flex: 1,
          child: IconButton(
            icon: Icon(OMIcons.delete),
            onPressed: onDeletePressed,
            padding: EdgeInsets.all(0),
          ),
        )
      ],
    );
  }
}

class MultiplePicturesRow extends StatelessWidget {
  final MultiplePicturesSetting setting;
  final int index;
  final VoidCallback onDeletePressed;

  const MultiplePicturesRow(
      {Key key, @required this.setting, this.onDeletePressed, this.index})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            child: TriggerInfoText(
              value: "Multiple Pictures",
              onDeletePressed: onDeletePressed,
            ),
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
              Provider.of<SenseBeRxService>(context)
                      .metaStructure
                      .advancedOptionsEnabled[index]
                  ? setting.enablePreFocus
                      ? HalfPressAndTriggerPulseDurationRow(setting: setting)
                      : TriggerPulseDurationRow(setting: setting)
                  : Container()
            ],
          ),
        ),
      ],
    );
  }
}

class VideoRow extends StatelessWidget {
  final VideoSetting videoSetting;
  final int index;
  final bool timer;
  final VoidCallback onDeletePressed;

  const VideoRow(
      {Key key,
      @required this.videoSetting,
      this.onDeletePressed,
      this.index,
      this.timer})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            child: TriggerInfoText(
              value: "Video",
              onDeletePressed: onDeletePressed,
            ),
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
              Provider.of<SenseBeRxService>(context)
                      .metaStructure
                      .advancedOptionsEnabled[index]
                  ? TriggerPulseDurationRow(setting: videoSetting)
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}

class LongPressRow extends StatelessWidget {
  final LongPressSetting longPressSetting;
  final int index;
  final VoidCallback onDeletePressed;

  const LongPressRow({
    Key key,
    @required this.longPressSetting,
    this.onDeletePressed,
    this.index,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: TriggerInfoText(
                value: "Long Press",
                onDeletePressed: onDeletePressed,
              )),
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
              Provider.of<SenseBeRxService>(context)
                          .metaStructure
                          .advancedOptionsEnabled[index] &&
                      longPressSetting.enablePreFocus
                  ? HalfPressTriggerTimeRow(setting: longPressSetting)
                  : Container()
            ],
          ),
        ),
      ],
    );
  }
}

// class RadioAndHalfPressRow extends StatelessWidget {
//   final CameraSetting cameraSetting;

//   const RadioAndHalfPressRow({Key key, this.cameraSetting}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text("Half Press"),
//             Text("${cameraSetting.enablePreFocus ? 'On' : 'Off'}"),
//           ],
//         ),
//       ],
//     );
//   }
// }
