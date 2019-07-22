import 'package:flutter/material.dart';
import 'package:setup/ui/widgets/custom_radio_field.dart';

enum AmbientLight {
  DAY_ONLY,
  NIGHT_ONLY,
  DAY_AND_TWILIGHT,
  NIGHT_AND_TWILIGHT,
}

class AmbientFields extends StatefulWidget {
  @override
  _AmbientFieldsState createState() => _AmbientFieldsState();
}

class _AmbientFieldsState extends State<AmbientFields> {
  AmbientLight selectedLightMode = AmbientLight.DAY_ONLY;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 24),
        CustomRadioField(
          title: "Ambient Light Options",
          radioList: ListView(
            shrinkWrap: true,
            children: AmbientLight.values.map((light) {
              return RadioListTile(
                value: light,
                title: Text(light
                    .toString()
                    .split('.')[1]
                    .replaceAllMapped('_', (_) => ' ')),
                groupValue: selectedLightMode,
                onChanged: (val) {
                  setState(() {
                    selectedLightMode = val;
                  });
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
