import 'package:flutter/foundation.dart';
import 'package:setup/core/models/camera.dart';

class CameraTriggerRadioOptionsModel extends ChangeNotifier {
  CameraAction selectedAction = CameraAction.SINGLE_PICTURE;

  setSelectedAction(CameraAction cameraAction) {
    selectedAction = cameraAction;
    notifyListeners();
  }
}
