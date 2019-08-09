import 'package:flutter/foundation.dart';
import 'package:setup/core/models/time.dart';

class AmbientFieldsModel extends ChangeNotifier {
  AmbientLight ambientLight = AmbientLight.DAY_ONLY;

  List<AmbientLight> _disabledFields = [];

  List<AmbientLight> get disabledFields => _disabledFields;

  set disabledFields(List<AmbientLight> disabledFields) {
    _disabledFields = disabledFields;
    for (AmbientLight light in AmbientLight.values) {
      if (light.index == 0) continue;
      if (!disabledFields.contains(light)) {
        ambientLight = light;
        break;
      }
    }
    notifyListeners();
  }

  /// change [ambientLight]
  change(AmbientLight a) {
    ambientLight = a;
    notifyListeners();
  }

  // for (AmbientLight light in AmbientLight.values) {
  //   if (light.index == 0) continue;
  //   if (!disabledFields.contains(light)) {
  //     selectedLightMode = light;
  //     break;
  //   }
  // }

  /// Returns Instance of [Ambient] class from
  Ambient getAmbientLight([AmbientLight a]) =>
      Ambient(ambientLight: a ?? ambientLight);

  setDisabledFields(List<AmbientLight> list) {
    disabledFields = list;
    notifyListeners();
  }
}
