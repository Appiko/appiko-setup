import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:setup/core/models/generic/battery.dart';
import 'package:setup/core/models/generic/camera.dart';
import 'package:setup/core/models/devices/sense_be_rx/1.0/sense_be_rx.dart';
import 'package:setup/core/models/generic/device_info.dart';
import 'package:setup/core/models/generic/meta.dart';
import 'package:setup/core/models/generic/operation_time.dart';
import 'package:setup/core/models/generic/radio_setting.dart';
import 'package:setup/core/models/generic/sensor_setting.dart';
import 'package:setup/core/models/generic/time.dart' as time;
import 'package:setup/core/services/bluetooth_IO.dart';
import 'package:setup/core/services/bluetooth_connection.dart';
import 'package:setup/core/view_models/ambient_fields_model.dart';
import 'package:setup/core/view_models/camera_trigger_radio_options_model.dart';
import 'package:setup/core/view_models/half_press_fields_model.dart';
import 'package:setup/core/view_models/time_of_day_fields_model.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/devices/sense_be_rx/1.0/settings/half_press_settings_view.dart';
import 'package:setup/ui/devices/sense_be_rx/1.0/settings/long_press_settings.dart';
import 'package:setup/ui/devices/sense_be_rx/1.0/settings/motion_settings_view.dart';
import 'package:setup/ui/devices/sense_be_rx/1.0/settings/multiple_pictures_settings_view.dart';
import 'package:setup/ui/devices/sense_be_rx/1.0/settings/single_picture_settings_view.dart';
import 'package:setup/ui/devices/sense_be_rx/1.0/settings/timer_settings_view.dart';
import 'package:setup/ui/devices/sense_be_rx/1.0/settings/video_settings_view.dart';

enum TriggerType { MOTION_TRIGGER, TIMER_TRIGGER }

/// {@category Service}
/// {@category SenseBeRx}
/// {@category Algorithm}
class SenseBeRxService extends ChangeNotifier {
  SenseBeRx structure = SenseBeRx();

  MetaStructure metaStructure = MetaStructure();
  bool _shouldPassSetting = false;

  int settingToUpdate;

  bool shouldSave = false;

  int ambientStateToAdd = 0;

  OperationTime operationTimeToSet = OperationTime.ALL_TIME;

  RadioSetting radioSettingToEdit;

  int ambientStateToSubtract = 0;

  DeviceInfo deviceInfo;

  // Map deviceInfoMap;
  bool get shouldPassSetting => _shouldPassSetting;

  set shouldPassSetting(bool shouldPassSetting) {
    _shouldPassSetting = shouldPassSetting;
    notifyListeners();
  }

  int activeSettingIndex = 0;
  TriggerType activeTriggerType = TriggerType.MOTION_TRIGGER;
  OperationTime operationTime = OperationTime.TIME_OF_DAY;
  time.AmbientLight ambientLight = time.AmbientLight.DAY_ONLY;

  bool settingFlowComplete = false;

  BeRxSetting get activeSetting => structure.settings[activeSettingIndex];
  int get operationTimeIndex =>
      activeTriggerType == TriggerType.MOTION_TRIGGER ? 0 : 1;

  int get numberofMotionSettings => structure.settings
      .where((setting) =>
          setting.sensorSetting.runtimeType == MotionSetting &&
          setting.index != 8)
      .length;

  int get numberofTimerSettings => structure.settings
      .where((setting) =>
          setting.sensorSetting.runtimeType == TimerSetting &&
          setting.index != 8)
      .length;

  int get numberofOccupiedSettings => structure.settings
      .where((setting) =>
          (setting.sensorSetting.runtimeType == MotionSetting ||
              setting.sensorSetting.runtimeType == TimerSetting) &&
          setting.index != 8)
      .length;

  ///
  ///
  ///
  ///
  /// setActiveIndex()
  /// setTime()
  /// setCameraMode()
  /// setCameraSettting()
  /// setSensorSetting()
  ///
  ///
  ///
  ///

  void setAdvancedOptions(bool val) {
    metaStructure.advancedOptionsEnabled[activeSettingIndex] = val;
  }

  void setDeviceSpeed(value) {
    structure.deviceSpeed = value;
    notifyListeners();
  }

  /// Get sensor setting view
  getSensorView() {
    return activeTriggerType == TriggerType.MOTION_TRIGGER
        ? shouldPassSetting
            ? MotionSettingsView(
                setting: structure.settings[activeSettingIndex])
            : MotionSettingsView()
        : shouldPassSetting
            ? TimerSettingsView(setting: structure.settings[activeSettingIndex])
            : TimerSettingsView();
  }

  setActiveIndex({int tabIndex, BeRxSetting setting}) {
    ambientStateToSubtract = 0;
    settingFlowComplete = false;
    // locator<TimeOfDayFieldsModel>().startTime = time.getDateTimefromSeconds(0);
    // locator<TimeOfDayFieldsModel>().endTime = time.getDateTimefromSeconds(0);
    // locator<TimeOfDayFieldsModel>().timeOverlap = true;

    if (setting == null) {
      activeSettingIndex = null;
      BeRxSetting s = structure.settings.firstWhere(
          (setting) => (setting.sensorSetting.runtimeType == SensorSetting),
          orElse: () {
        print("Setting length extended!");
        return BeRxSetting(index: 999);
      });
      activeSettingIndex = s.index;

      if (tabIndex == 0) {
        activeTriggerType = TriggerType.MOTION_TRIGGER;
        structure.settings[activeSettingIndex].sensorSetting = MotionSetting();
        locator<AmbientFieldsModel>().disabledFields =
            getModesToBeDisabled(state: structure.motionAmbientState);
      } else {
        activeTriggerType = TriggerType.TIMER_TRIGGER;
        structure.settings[activeSettingIndex].sensorSetting = TimerSetting();
        locator<AmbientFieldsModel>().disabledFields =
            getModesToBeDisabled(state: structure.timerAmbientState);
      }

      print(structure.settings[activeSettingIndex].sensorSetting);
    } else {
      activeSettingIndex = 8;
      settingToUpdate = setting.index;

      structure.settings[activeSettingIndex] =
          BeRxSetting.clone(setting: setting, index: 8);

      metaStructure.advancedOptionsEnabled[8] =
          metaStructure.advancedOptionsEnabled[settingToUpdate];

      switch (setting.sensorSetting.runtimeType) {
        case MotionSetting:
          activeTriggerType = TriggerType.MOTION_TRIGGER;
          if (numberofMotionSettings == 1) {
            operationTimeToSet = setting.time.runtimeType == time.TimeOfDay
                ? OperationTime.TIME_OF_DAY
                : (setting.time.runtimeType == time.Ambient &&
                        (setting.time as time.Ambient).ambientLight ==
                            time.AmbientLight.ALL_TIME)
                    ? OperationTime.ALL_TIME
                    : OperationTime.AMBIENT;
            structure.operationTime[0] = null;
          }
          if (setting.time.runtimeType == time.Ambient) {
            locator<AmbientFieldsModel>().disabledFields = getModesToBeDisabled(
                state: structure.motionAmbientState,
                change: true,
                selectedAmbientLight:
                    (setting.time as time.Ambient).ambientLight);
          }
          break;
        case TimerSetting:
          activeTriggerType = TriggerType.TIMER_TRIGGER;
          if (numberofTimerSettings == 1) {
            operationTimeToSet = setting.time.runtimeType == time.TimeOfDay
                ? OperationTime.TIME_OF_DAY
                : setting.time.runtimeType == time.Ambient
                    ? OperationTime.AMBIENT
                    : OperationTime.ALL_TIME;
            structure.operationTime[1] = null;
          }
          if (setting.time.runtimeType == time.Ambient) {
            locator<AmbientFieldsModel>().disabledFields = getModesToBeDisabled(
                state: structure.timerAmbientState,
                change: true,
                selectedAmbientLight:
                    (setting.time as time.Ambient).ambientLight);
          }
          break;
        default:
      }
      switch (setting.time.runtimeType) {
        case time.Ambient:
          locator<AmbientFieldsModel>().ambientLight =
              (setting.time as time.Ambient).ambientLight;
          ambientStateToSubtract = time.AmbientStateValues.getValue(
            (setting.time as time.Ambient).ambientLight,
          );

          break;
        case time.TimeOfDay:
          locator<TimeOfDayFieldsModel>().startTime =
              time.getDateTimefromSeconds(
                  (setting.time as time.TimeOfDay).startTime);
          locator<TimeOfDayFieldsModel>().endTime = time
              .getDateTimefromSeconds((setting.time as time.TimeOfDay).endTime);
          break;
        default:
      }

      locator<CameraTriggerRadioOptionsModel>()
          .setSelectedAction(setting.cameraSetting.mode);

      // Pass settings to config screens
      shouldPassSetting = true;
    }
  }

  setTime(OperationTime operationTime) {
    ambientStateToAdd = 0;
    switch (operationTime) {
      case OperationTime.AMBIENT:
        structure.settings[activeSettingIndex].time =
            locator<AmbientFieldsModel>().getAmbientLight();
        ambientStateToAdd += time.AmbientStateValues.getValue(
            (structure.settings[activeSettingIndex].time as time.Ambient)
                .ambientLight);
        break;
      case OperationTime.ALL_TIME:
        structure.settings[activeSettingIndex].time =
            locator<AmbientFieldsModel>()
                .getAmbientLight(time.AmbientLight.ALL_TIME);
        break;
      case OperationTime.TIME_OF_DAY:
        structure.settings[activeSettingIndex].time =
            locator<TimeOfDayFieldsModel>().getTime();
        break;
      default:
    }
    operationTimeToSet = operationTime;

    print("operationTimes");
    structure.operationTime.forEach(print);
  }

  setCameraOption() {
    switch (locator<CameraTriggerRadioOptionsModel>().selectedAction) {
      case CameraAction.SINGLE_PICTURE:
        structure.settings[activeSettingIndex].cameraSetting =
            CameraSetting(mode: CameraAction.SINGLE_PICTURE);
        break;
      case CameraAction.MULTIPLE_PICTURES:
        structure.settings[activeSettingIndex].cameraSetting =
            MultiplePicturesSetting();
        break;
      case CameraAction.VIDEO:
        structure.settings[activeSettingIndex].cameraSetting = VideoSetting();
        break;
      case CameraAction.LONG_PRESS:
        structure.settings[activeSettingIndex].cameraSetting =
            LongPressSetting();
        break;
      case CameraAction.HALF_PRESS:
        structure.settings[activeSettingIndex].cameraSetting =
            CameraSetting(mode: CameraAction.HALF_PRESS);
        break;
      case CameraAction.NONE:
        structure.settings[activeSettingIndex].cameraSetting =
            CameraSetting(mode: CameraAction.NONE);
        break;
    }
    print(structure.settings[activeSettingIndex].cameraSetting);
    print("active index $activeSettingIndex");
  }

  void setSinglePicture(
      {double triggerPulseDuration, double halfPressDuration}) {
    structure.settings[activeSettingIndex].cameraSetting =
        CameraSetting(mode: CameraAction.SINGLE_PICTURE)
          ..triggerPulseDuration = (triggerPulseDuration * 10).toInt()
          ..preFocusPulseDuration = (halfPressDuration * 10).toInt()
          ..enablePreFocus = locator<HalfPressFieldsModel>().isHalfPressEnabled;

    print(structure.settings[activeSettingIndex].cameraSetting);
  }

  void setLongPress({
    double halfPressDuration,
    Duration longPressDuration,
  }) {
    structure.settings[activeSettingIndex].cameraSetting = LongPressSetting()
      ..preFocusPulseDuration = (halfPressDuration * 10).toInt()
      ..enablePreFocus = locator<HalfPressFieldsModel>().isHalfPressEnabled
      ..longPressDuration = longPressDuration.inMilliseconds ~/ 100;

    print(structure.settings[activeSettingIndex].cameraSetting);
  }

  void updateSetting() {
    if (structure.operationTime[operationTimeIndex] == null ||
        structure.operationTime[operationTimeIndex] == OperationTime.NONE) {
      structure.operationTime[operationTimeIndex] = operationTimeToSet;
    }

    structure.settings[settingToUpdate] = activeSetting;
    structure.settings[settingToUpdate].index = settingToUpdate;
    metaStructure.advancedOptionsEnabled[settingToUpdate] =
        metaStructure.advancedOptionsEnabled[8];
    structure.settings[8] = BeRxSetting(index: 8);
    metaStructure.advancedOptionsEnabled[8] = false;
    shouldPassSetting = false;
    ambientStateToAdd = 0;
    ambientStateToSubtract = 0;
    notifyListeners();
  }

  void setMultiplePicture({
    double triggerPulseDuration,
    double halfPressDuration,
    double picuteInterval,
    int numberOfPictures,
  }) {
    structure.settings[activeSettingIndex].cameraSetting =
        MultiplePicturesSetting()
          ..triggerPulseDuration = (triggerPulseDuration * 10).toInt()
          ..preFocusPulseDuration = (halfPressDuration * 10).toInt()
          ..enablePreFocus = locator<HalfPressFieldsModel>().isHalfPressEnabled
          ..pictureInterval = (picuteInterval * 10).toInt()
          ..numberOfPictures = numberOfPictures;
    print(structure.settings[activeSettingIndex].cameraSetting);
  }

  void setVideo({
    double triggerPulseDuration,
    double halfPressDuration,
    Duration videoDuration,
    bool isVideoOnFullPress,
    int numberOfExtensions,
    bool extendVideos,
    int extensionTime,
  }) {
    structure.settings[activeSettingIndex].cameraSetting = VideoSetting()
      ..triggerPulseDuration = ((triggerPulseDuration ?? 0) * 10).toInt()
      ..preFocusPulseDuration = ((halfPressDuration ?? 0) * 10).toInt()
      ..enablePreFocus = false
      ..videoDuration = videoDuration.inMilliseconds ~/ 100
      ..videoWithFullPress = isVideoOnFullPress
      ..extensionTime = extensionTime * 10
      ..numberOfExtensions = numberOfExtensions;

    print(structure.settings[activeSettingIndex].cameraSetting);
  }

  void setHalfPress({
    double halfPressDuration,
  }) {
    structure.settings[activeSettingIndex].cameraSetting =
        CameraSetting(mode: CameraAction.HALF_PRESS)
          ..preFocusPulseDuration = (halfPressDuration * 10).toInt();

    print(structure.settings[activeSettingIndex].cameraSetting);
  }

  void setRadio(bool isRadioEnabled) {
    structure.settings[activeSettingIndex].cameraSetting.enableRadio =
        isRadioEnabled;

    notifyListeners();
  }

  void setMotion({double sensitivity, int numberOfTriggers, double downtime}) {
    structure.settings[activeSettingIndex].sensorSetting = MotionSetting(
      downtime: (downtime * 10).toInt(),
      numberOfTriggers: numberOfTriggers,
      sensitivity: sensitivity.toInt(),
    );

    structure.motionAmbientState = structure.motionAmbientState +
        ambientStateToAdd -
        ambientStateToSubtract;
    if (structure.motionAmbientState > 7) {
      throw Exception(
          "Motion Ambient state more than 7: ${structure.motionAmbientState}");
    }

    if ((structure.operationTime[operationTimeIndex] == null ||
            structure.operationTime[operationTimeIndex] ==
                OperationTime.NONE) &&
        !shouldPassSetting) {
      structure.operationTime[operationTimeIndex] = operationTimeToSet;
    }

    ambientStateToAdd = 0;
    ambientStateToSubtract = 0;
    settingFlowComplete = true;
    shouldSave = true;

    print(structure.settings[activeSettingIndex].sensorSetting);
  }

  void setTimer({Duration interval}) {
    structure.settings[activeSettingIndex].sensorSetting = TimerSetting(
      interval: interval.inMilliseconds ~/ 100,
    );

    structure.timerAmbientState = structure.timerAmbientState +
        ambientStateToAdd -
        ambientStateToSubtract;
    if (structure.timerAmbientState > 7) {
      throw Exception(
          "Timer Ambient state more than 7: ${structure.timerAmbientState}");
    }

    if ((structure.operationTime[operationTimeIndex] == null ||
            structure.operationTime[operationTimeIndex] ==
                OperationTime.NONE) &&
        !shouldPassSetting) {
      structure.operationTime[operationTimeIndex] = operationTimeToSet;
    }

    ambientStateToAdd = 0;
    ambientStateToSubtract = 0;
    settingFlowComplete = true;
    shouldSave = true;

    print(structure.settings[activeSettingIndex].sensorSetting);
  }

  closeFlow() {
    if (!settingFlowComplete && !shouldPassSetting) {
      structure.settings[activeSettingIndex] =
          BeRxSetting(index: activeSettingIndex);
      notifyListeners();
    }
  }

  String getCameraSettingDownArrowPageName() {
    if (shouldPassSetting) {
      return '/br/setting-summary';
    }
    return getCloseSummaryPath();
  }

  deleteSetting(BeRxSetting setting) {
    if (setting.index == 8) {
      setting = structure.settings[settingToUpdate];
    }
    structure.settings[setting.index] = BeRxSetting(index: setting.index);
    subtactStateIfAmbient(setting);

    if (setting.sensorSetting.runtimeType == MotionSetting) {
      if (numberofMotionSettings == 0) {
        resetTime(MotionSetting);
      }
    } else if (setting.sensorSetting.runtimeType == TimerSetting) {
      if (numberofTimerSettings == 0) {
        resetTime(TimerSetting);
      }
    }
    notifyListeners();
  }

  deleteAllSettings(Type type) {
    structure.settings = structure.settings.map((setting) {
      if (setting.sensorSetting.runtimeType == type) {
        print("Deleting");
        subtactStateIfAmbient(setting);
        return BeRxSetting(index: setting.index);
      }
      return setting;
    }).toList();

    resetTime(type);
    notifyListeners();
  }

  subtactStateIfAmbient(setting) {
    if (setting.time.runtimeType == time.Ambient) {
      if (setting.sensorSetting.runtimeType == MotionSetting) {
        structure.motionAmbientState -= time.AmbientStateValues.getValue(
            (setting.time as time.Ambient).ambientLight);
      }
      if (setting.sensorSetting.runtimeType == TimerSetting) {
        structure.timerAmbientState -= time.AmbientStateValues.getValue(
            (setting.time as time.Ambient).ambientLight);
      }
    }
  }

  resetTime(Type type) {
    if (type == MotionSetting) {
      structure.operationTime[0] = null;
      structure.motionAmbientState = 0;
    } else if (type == TimerSetting) {
      structure.operationTime[1] = null;
      structure.timerAmbientState = 0;
    }
  }

  void reset() {
    structure = SenseBeRx();
    metaStructure = MetaStructure();
    activeSettingIndex = null;
    activeTriggerType = null;
    structure.motionAmbientState = 0;
    structure.timerAmbientState = 0;
    shouldSave = false;
  }

  void setStartTime(int settingIndex, DateTime t) {
    (structure.settings[settingIndex].time as time.TimeOfDay).startTime =
        time.getTimeInSeconds(t);
    notifyListeners();
  }

  void setEndTime(int settingIndex, DateTime t) {
    (structure.settings[settingIndex].time as time.TimeOfDay).endTime =
        time.getTimeInSeconds(t);
    notifyListeners();
  }

  void setAmbientLight(int settingIndex) {
    if (structure.settings[settingIndex].sensorSetting.runtimeType ==
        MotionSetting) {
      structure.motionAmbientState -= time.AmbientStateValues.getValue(
          (structure.settings[settingIndex].time as time.Ambient).ambientLight);
      structure.motionAmbientState += time.AmbientStateValues.getValue(
          locator<AmbientFieldsModel>().ambientLight);
    } else {
      structure.timerAmbientState -= time.AmbientStateValues.getValue(
          (structure.settings[settingIndex].time as time.Ambient).ambientLight);

      structure.timerAmbientState += time.AmbientStateValues.getValue(
          locator<AmbientFieldsModel>().ambientLight);
    }

    structure.settings[settingIndex].time =
        locator<AmbientFieldsModel>().getAmbientLight();
    notifyListeners();
  }

  getSelectedActionSettingsView() {
    locator<HalfPressFieldsModel>().isHalfPressEnabled =
        structure.settings[activeSettingIndex].cameraSetting.enablePreFocus;
    switch (locator<CameraTriggerRadioOptionsModel>().selectedAction) {
      case CameraAction.SINGLE_PICTURE:
        return shouldPassSetting
            ? SinglePictureSettingsView(
                setting: structure.settings[activeSettingIndex])
            : SinglePictureSettingsView();
      case CameraAction.MULTIPLE_PICTURES:
        print(structure.settings[activeSettingIndex].cameraSetting);
        return shouldPassSetting
            ? MultiplePicturesSettingsView(
                setting: structure.settings[activeSettingIndex])
            : MultiplePicturesSettingsView();
      case CameraAction.VIDEO:
        return shouldPassSetting
            ? VideoSettingsView(setting: structure.settings[activeSettingIndex])
            : VideoSettingsView();
      case CameraAction.LONG_PRESS:
        return shouldPassSetting
            ? LongPressSettingsView(
                setting: structure.settings[activeSettingIndex])
            : LongPressSettingsView();
      case CameraAction.HALF_PRESS:
        return shouldPassSetting
            ? HalfPressSettingsView(
                setting: structure.settings[activeSettingIndex])
            : HalfPressSettingsView();
      default:
        return getSensorView();
    }
  }

  void setRadioChannel(channel) {
    radioSettingToEdit.radioChannel = channel;
    notifyListeners();
  }

  // void setRadioParameters(int operationDuration, int operationFreq) {
  //   structure.radioSetting.radioOperationDuration = operationDuration;
  //   structure.radioSetting.radioOperationFrequency = operationFreq;
  // }

  void setRadioSettings(RadioSpeed speed) {
    structure.radioSetting = RadioSetting(
      speed: speed,
      radioChannel: radioSettingToEdit.radioChannel,
    );
    notifyListeners();
  }

  String timeCheck({int pickerEndTime, int pickerStartTime, int settingIndex}) {
    print("$pickerStartTime, $pickerEndTime");

    if (pickerStartTime == pickerEndTime) {
      return "Cannot have same start and end time";
    }
    // For Change
    if (settingIndex != null || shouldPassSetting) {
      activeSettingIndex = settingIndex ?? settingToUpdate;
      activeTriggerType = structure.settings[settingIndex ?? settingToUpdate]
                  .sensorSetting.runtimeType ==
              MotionSetting
          ? TriggerType.MOTION_TRIGGER
          : TriggerType.TIMER_TRIGGER;
    }
    for (int i = 0; i < 8; i++) {
      BeRxSetting setting = structure.settings[i];

      if (setting.index != 8 &&
          setting.index != activeSettingIndex &&
          setting.sensorSetting.runtimeType ==
              (activeTriggerType.index == 0 ? MotionSetting : TimerSetting)) {
        // BeRxSetting start and end times
        int startTime = (setting.time as time.TimeOfDay).startTime;
        int endTime = (setting.time as time.TimeOfDay).endTime;
        print("Setting $startTime, $endTime");

        // if (startTime < endTime) {
        //   if (((pickerStartTime < startTime) && (pickerEndTime < startTime)) ||
        //       ((pickerStartTime > endTime) && (pickerEndTime > endTime)) ||
        //       ((pickerStartTime > endTime) && (pickerEndTime < startTime))) {
        //   } else {
        //     return "Time overlaps with other setting";
        //   }
        // } else {
        //   if (!((pickerStartTime > endTime) &&
        //       (pickerEndTime < startTime) &&
        //       (pickerStartTime < pickerEndTime))) {
        //     return "Time overlaps with other setting";
        //   }
        // }

        if (startTime < endTime) {
          if (((pickerStartTime < startTime) &&
                  (pickerEndTime < startTime) &&
                  (pickerStartTime < pickerEndTime)) ||
              ((pickerStartTime > endTime) &&
                  (pickerEndTime > endTime) &&
                  (pickerStartTime < pickerEndTime)) ||
              ((pickerStartTime > endTime) &&
                  (pickerEndTime < startTime) &&
                  (pickerStartTime > pickerEndTime))) {
          } else {
            return "Time overlaps with other setting";
          }
        } else {
          if (!((pickerStartTime > endTime) &&
              (pickerEndTime < startTime) &&
              (pickerStartTime < pickerEndTime))) {
            return "Time overlaps with other setting";
          }
        }
      }
    }

    return "";
  }

  List<time.AmbientLight> getModesToBeDisabled(
      {@required int state,
      change = false,
      time.AmbientLight selectedAmbientLight}) {
    List<time.AmbientLight> fieldsToDisable = [];

    if (change) {
      // subtract from state
      state = state - time.AmbientStateValues.getValue(selectedAmbientLight);
    }

    time.AmbientLight.values.forEach((ambientLight) {
      if ((state & time.AmbientStateValues.getValue(ambientLight)) > 0) {
        fieldsToDisable.add(ambientLight);
      }
    });

    return fieldsToDisable;
  }

  String getCloseSummaryPath() {
    return locator<BluetoothConnectionService>().deviceState ==
            BluetoothDeviceState.connected
        ? '/devices/br'
        : '/devices/br/profile-summary';
  }

  // TODO: Remove onPressed
  showDeleteSettingModal({all = false, context, onPressed}) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(all ? "Delete all settings?" : "Delete setting?"),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "CANCEL",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                    child: Text(
                      all ? "DELETE ALL" : "DELETE",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      onPressed();
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName(getCloseSummaryPath()),
                      );
                    }),
              ],
            ));
  }

  SnackBar advancedSettingOffSnackbar = SnackBar(
    content: Text("Advanced options reset to default"),
    duration: Duration(seconds: 1),
    // backgroundColor: Colors.accentColor,
  );

  void resetRadio() {
    structure.radioSetting = RadioSetting(
      speed: RadioSpeed.NORMAL,
      radioChannel: RadioChannel.CHANNEL_0,
    );
    notifyListeners();
  }

  void editRadioSettings() {
    radioSettingToEdit = RadioSetting.clone(structure.radioSetting);
  }

  void setRadioAdvancedOption(bool val) {
    metaStructure.radioAdvancedOption = val;
  }

  void closeChangeFlow() {
    BeRxSetting setting;
    shouldPassSetting = false;
    ambientStateToSubtract = 0;
    ambientStateToAdd = 0;
    if (activeTriggerType == TriggerType.MOTION_TRIGGER) {
      setting = structure.settings.firstWhere(
          (setting) => setting.sensorSetting.runtimeType == MotionSetting);
      structure.operationTime[0] = setting.time.runtimeType == time.TimeOfDay
          ? OperationTime.TIME_OF_DAY
          : setting.time.runtimeType == time.Ambient &&
                  (setting.time as time.Ambient).ambientLight ==
                      time.AmbientLight.ALL_TIME
              ? OperationTime.ALL_TIME
              : OperationTime.AMBIENT;
    } else {
      setting = structure.settings.firstWhere(
          (setting) => setting.sensorSetting.runtimeType == TimerSetting);
      structure.operationTime[1] = setting.time.runtimeType == time.TimeOfDay
          ? OperationTime.TIME_OF_DAY
          : setting.time.runtimeType == time.Ambient &&
                  (setting.time as time.Ambient).ambientLight ==
                      time.AmbientLight.ALL_TIME
              ? OperationTime.ALL_TIME
              : OperationTime.AMBIENT;
    }
    notifyListeners();
  }

  void handleDownArrowPress(BuildContext context,
      [GlobalKey<FormState> key, VoidCallback onSave]) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          // shouldPassSetting
          // ? "Do you make to save changes before closing?" :
          "Do you want to discard the setting?",
        ),
        actions: <Widget>[
          FlatButton(
              child: Text(
                "CANCEL",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
              onPressed:
                  // shouldPassSetting
                  // ? () {
                  //     // TODO:
                  //     // closeChangeFlow();
                  //     Navigator.popUntil(
                  //       context,
                  //       ModalRoute.withName(
                  //         '/devices/sense-be-rx/setting-summary',
                  //       ),
                  //     );
                  //   }
                  // :
                  () {
                Navigator.pop(context);
              }),
          FlatButton(
            child: Text(
              // shouldPassSetting
              // ? "SAVE" :
              "DISCARD",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: shouldPassSetting
                ? () {
                    // updateSetting();
                    discardChangeFlow();
                    // onSave();
                    Navigator.popUntil(
                      context,
                      ModalRoute.withName(getCameraSettingDownArrowPageName()),
                    );
                  }
                : () {
                    closeFlow();
                    Navigator.popUntil(
                      context,
                      ModalRoute.withName(getCameraSettingDownArrowPageName()),
                    );
                  },
          ),
        ],
      ),
    );
  }

  void discardChangeFlow() {
    structure.settings[8] =
        BeRxSetting.clone(setting: structure.settings[settingToUpdate]);
  }

  void readFromDevice() async {
    await locator<BluetoothIOService>().readSetting();
    deviceInfo = await locator<BluetoothIOService>().readDeviceInfo();

    deviceInfo.name = structure.deviceName;
    deviceInfo.batteryType = structure.batteryType;
    // deviceInfoMap = deviceInfo.toMap();
    // deviceInfoMap['Device Name'] = structure.deviceName;
    // deviceInfoMap['Battery Type'] = structure.batteryType.toString();
    setOperationTime();
    notifyListeners();
  }

  void setOperationTime() {
    if (numberofMotionSettings == 0) {
      structure.operationTime[0] = OperationTime.NONE;
    }
    if (numberofTimerSettings == 0) {
      structure.operationTime[1] = OperationTime.NONE;
    }
  }

  void setDeviceInfo(String name, BatteryType batteryType) {
    structure.deviceName = name;
    structure.batteryType = batteryType;
    deviceInfo.name = name.trim();
    deviceInfo.batteryType = batteryType;
    notifyListeners();
  }
}
