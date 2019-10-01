import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/models/generic/time.dart';
import 'package:setup/core/view_models/ambient_fields_model.dart';
import 'package:setup/ui/widgets/custom_radio_field.dart';

/// {@category Compound Widget}
/// {@category Design}
///
/// Ambient Light radio buttons.
class AmbientFields extends StatefulWidget {
  @override
  _AmbientFieldsState createState() => _AmbientFieldsState();
}

class _AmbientFieldsState extends State<AmbientFields> {
  @override
  Widget build(BuildContext context) {
    AmbientLight selectedLightMode =
        Provider.of<AmbientFieldsModel>(context).ambientLight;

    List<AmbientLight> disabledFields =
        Provider.of<AmbientFieldsModel>(context).disabledFields;

    return Column(
      children: <Widget>[
        SizedBox(height: 24),
        CustomRadioField(
          title: "Ambient Light Options",
          radioList: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: AmbientLight.values.map((light) {
              if (light == AmbientLight.ALL_TIME) {
                return Container();
              }
              return RadioListTile(
                value: light,
                title: Text(
                  light
                      .toString()
                      .split('.')[1]
                      .replaceAllMapped('_', (_) => ' '),
                ),
                groupValue: selectedLightMode,
                onChanged: disabledFields.contains(light)
                    ? null
                    : (val) {
                        Provider.of<AmbientFieldsModel>(context).change(val);
                      },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
