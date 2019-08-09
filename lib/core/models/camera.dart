enum CameraAction {
  SINGLE_PICTURE,
  MULTIPLE_PICTURES,
  LONG_PRESS,
  VIDEO,
  HALF_PRESS,
  NONE
}

class CameraSetting {
  // Enable pre-focus
  bool enablePreFocus = true;
  bool videoWithFullPress = true;

  bool enableRadio = false;

  /// multiple of 100ms, 25s max, 300ms default
  int triggerPulseDuration = 3;

  /// multiple of 100ms, 25 sec max, 200ms default
  int preFocusPulseDuration = 2;

  CameraAction mode;

  CameraSetting({this.mode}) {
    if (mode == null) {
      mode = CameraAction.NONE;
    }
  }

  @override
  String toString() {
    return 'CameraSetting{enablePreFocus: $enablePreFocus, videoWithFullPress: $videoWithFullPress, enableRadio: $enableRadio, triggerPulseDuration: $triggerPulseDuration, preFocusPulseDuration: $preFocusPulseDuration, mode: $mode,}';
  }

  static CameraSetting clone(CameraSetting cameraSetting) {
    return CameraSetting()
      ..enablePreFocus = cameraSetting.enablePreFocus
      ..enableRadio = cameraSetting.enableRadio
      ..mode = cameraSetting.mode
      ..preFocusPulseDuration = cameraSetting.preFocusPulseDuration
      ..triggerPulseDuration = cameraSetting.triggerPulseDuration
      ..videoWithFullPress = cameraSetting.videoWithFullPress;
  }
}

class MultiplePicturesSetting extends CameraSetting {
  static CameraAction _mode = CameraAction.MULTIPLE_PICTURES;

  /// [numberOfPictures] to capture; from a minimum of 2 to 32
  int numberOfPictures = 2;

  /// [pictureInterval] multiple of 100ms; from a minimum of 0.5s to 100min
  int pictureInterval = 10;

  MultiplePicturesSetting() : super(mode: _mode);

  static MultiplePicturesSetting clone(MultiplePicturesSetting cameraSetting) {
    return MultiplePicturesSetting()
      ..enablePreFocus = cameraSetting.enablePreFocus
      ..enableRadio = cameraSetting.enableRadio
      ..videoWithFullPress = cameraSetting.videoWithFullPress
      ..preFocusPulseDuration = cameraSetting.preFocusPulseDuration
      ..triggerPulseDuration = cameraSetting.triggerPulseDuration
      ..numberOfPictures = cameraSetting.numberOfPictures
      ..pictureInterval = cameraSetting.pictureInterval;
  }

  MultiplePicturesSetting.copyWith(CameraSetting cameraSetting) {
    MultiplePicturesSetting()
      ..enablePreFocus = cameraSetting.enablePreFocus
      ..enableRadio = cameraSetting.enableRadio
      ..videoWithFullPress = cameraSetting.videoWithFullPress
      ..preFocusPulseDuration = cameraSetting.preFocusPulseDuration
      ..triggerPulseDuration = cameraSetting.triggerPulseDuration;
  }

  @override
  String toString() {
    return 'MultiplePicturesSetting{numberOfPicutes: $numberOfPictures, pictureInterval: $pictureInterval}';
  }
}

class VideoSetting extends CameraSetting {
  static CameraAction _mode = CameraAction.VIDEO;

  /// 1s to 1000m
  int videoDuration = 20;

  /// 1s to 250s
  int extensionTime = 0;

  /// 1 to 20
  int numberOfExtensions = 0;

  VideoSetting() : super(mode: _mode);

  static VideoSetting clone(VideoSetting cameraSetting) {
    return VideoSetting()
      ..enablePreFocus = cameraSetting.enablePreFocus
      ..enableRadio = cameraSetting.enableRadio
      ..videoWithFullPress = cameraSetting.videoWithFullPress
      ..preFocusPulseDuration = cameraSetting.preFocusPulseDuration
      ..triggerPulseDuration = cameraSetting.triggerPulseDuration
      ..videoDuration = cameraSetting.videoDuration
      ..extensionTime = cameraSetting.extensionTime
      ..numberOfExtensions = cameraSetting.numberOfExtensions;
  }

  VideoSetting.copyWith(CameraSetting cameraSetting) {
    VideoSetting()
      ..enablePreFocus = cameraSetting.enablePreFocus
      ..enableRadio = cameraSetting.enableRadio
      ..videoWithFullPress = cameraSetting.videoWithFullPress
      ..preFocusPulseDuration = cameraSetting.preFocusPulseDuration
      ..triggerPulseDuration = cameraSetting.triggerPulseDuration;
  }

  @override
  String toString() {
    return 'VideoSetting{videoDuration: $videoDuration, extensionTime: $extensionTime, numberOfExtentions: $numberOfExtensions}';
  }
}

class LongPressSetting extends CameraSetting {
  static CameraAction _mode = CameraAction.LONG_PRESS;

  /// 3s to 24h in multiples of 100ms
  int longPressDuration = 30;

  LongPressSetting() : super(mode: _mode);

  static LongPressSetting clone(LongPressSetting cameraSetting) {
    return LongPressSetting()
      ..enablePreFocus = cameraSetting.enablePreFocus
      ..enableRadio = cameraSetting.enableRadio
      ..videoWithFullPress = cameraSetting.videoWithFullPress
      ..preFocusPulseDuration = cameraSetting.preFocusPulseDuration
      ..triggerPulseDuration = cameraSetting.triggerPulseDuration
      ..longPressDuration = cameraSetting.longPressDuration;
  }

  LongPressSetting.copyWith(CameraSetting cameraSetting) {
    LongPressSetting()
      ..enablePreFocus = cameraSetting.enablePreFocus
      ..enableRadio = cameraSetting.enableRadio
      ..videoWithFullPress = cameraSetting.videoWithFullPress
      ..preFocusPulseDuration = cameraSetting.preFocusPulseDuration
      ..triggerPulseDuration = cameraSetting.triggerPulseDuration;
  }

  @override
  String toString() {
    return 'LongPressSetting{longPressDuration: $longPressDuration}';
  }
}
