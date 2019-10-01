import 'package:flutter/foundation.dart';
import 'package:setup/core/models/generic/camera.dart';
import 'package:setup/ui/widgets/camera_trigger_radio_options.dart';

/// {@category Model}
/// Interact with [CameraTriggerRadioOptions]
class CameraTriggerRadioOptionsModel extends ChangeNotifier {
  CameraAction selectedAction = CameraAction.SINGLE_PICTURE;

  setSelectedAction(CameraAction cameraAction) {
    selectedAction = cameraAction;
    notifyListeners();
  }
}
