import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/models/generic/radio_setting.dart';
import 'package:setup/core/services/sense_be_tx_service.dart';
import 'package:setup/core/services/shared_prefs.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/widgets/custom_app_bar.dart';
import 'package:setup/ui/widgets/custom_dropdown_button.dart';
import 'package:setup/ui/widgets/custom_radio_field.dart';
import 'package:setup/ui/widgets/page_navigation_bar.dart';

/// {@category Page}
/// {@category SenseBeTx}
/// {@category Design}
///
/// Radio settings configuration screen.
class RadioSettingsView extends StatefulWidget {
  RadioSettingsView({Key key}) : super(key: key);

  @override
  _RadioSettingsViewState createState() => _RadioSettingsViewState();
}

class _RadioSettingsViewState extends State<RadioSettingsView> {
  var selectedSpeed = locator<SenseBeTxService>().radioSettingToEdit.speed;

  @override
  Widget build(BuildContext context) {
    bool darkTheme = Provider.of<SharedPrefs>(context).darkTheme;
    return Scaffold(
      backgroundColor:
          !darkTheme ? Colors.white : Theme.of(context).canvasColor,
      appBar: CustomAppBar(
        title: "Radio",
        downArrow: true,
        onDownArrowPressed: () {
          locator<SenseBeTxService>().handleDownArrowPress(context);
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 30),
              Text(
                  "This changes the radio configuration settings, which will be used to communicate the trigger with other devices"),
              CustomDropdownButton(
                title: "Channel",
                dropdownButton: DropdownButton(
                  value: Provider.of<SenseBeTxService>(context)
                      .radioSettingToEdit
                      .radioChannel,
                  underline: Container(),
                  style: Theme.of(context).textTheme.title.copyWith(
                        fontSize: 18,
                      ),
                  items: RadioChannel.values.map((channel) {
                    String text = (int.tryParse(channel
                                .toString()
                                .split(".")[1]
                                .split("_")[1]) +
                            1)
                        .toString();
                    return DropdownMenuItem<RadioChannel>(
                      value: channel,
                      child: Text(text),
                    );
                  }).toList(),
                  onChanged: (value) {
                    Provider.of<SenseBeTxService>(context)
                        .setRadioChannel(value);
                  },
                ),
              ),
              CustomRadioField(
                title: "Radio Speed",
                description:
                    "Higher the speed decreases the communication lag and decreases the battery life",
                radioList: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    ...RadioSpeed.values
                        .map(
                          (speed) => RadioListTile(
                            title: Text(speed
                                .toString()
                                .split(".")[1]
                                .split("_")
                                .join(" ")),
                            groupValue: selectedSpeed,
                            onChanged: (value) {
                              setState(() {
                                selectedSpeed = value;
                              });
                            },
                            value: speed,
                          ),
                        )
                        .toList(),
                    SizedBox(height: 24),
                    Text(
                      "IMPORTANT: Make sure the radio settings are the same on other devices which will communicate with this device.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: PageNavigationBar(
        showPrevious: false,
        showNext: true,
        nextLabel: "SAVE",
        onNext: () {
          locator<SenseBeTxService>().setRadioSettings(selectedSpeed);
          Navigator.pop(context);
        },
      ),
    );
  }
}
