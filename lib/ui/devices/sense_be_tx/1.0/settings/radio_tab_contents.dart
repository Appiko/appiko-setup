import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/models/devices/sense_be_tx/1.0/sense_be_tx.dart';
import 'package:setup/core/models/generic/device_speed.dart';
import 'package:setup/core/models/generic/radio_setting.dart';
import 'package:setup/core/services/sense_be_tx_service.dart';
import 'package:setup/core/services/shared_prefs.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/devices/sense_be_tx/1.0/settings/radio_settings_view.dart';
import 'package:setup/ui/devices/sense_be_tx/1.0/settings/setting_summary_page.dart';
import 'package:setup/ui/widgets/advanced_option_tile.dart';
import 'package:setup/ui/widgets/advanced_option_wrapper.dart';
import 'package:setup/ui/widgets/custom_dropdown_button.dart';

class MoreTabContents extends StatefulWidget {
  final bool showBeam;
  MoreTabContents({
    Key key,
    this.showBeam = true,
  }) : super(key: key);

  @override
  _MoreTabContentsState createState() => _MoreTabContentsState();
}

class _MoreTabContentsState extends State<MoreTabContents> {
  bool advancedOptionMoreTab = locator<SharedPrefs>().advancedOptions;
  bool firstBuild = true;

  @override
  Widget build(BuildContext context) {
    final bool showBeam = widget.showBeam;
    RadioSetting radioSetting =
        Provider.of<SenseBeTxService>(context).structure.radioSetting;
    if (firstBuild) {
      advancedOptionMoreTab = Provider.of<SenseBeTxService>(context)
          .metaStructure
          .radioAdvancedOption;
      firstBuild = false;
    }
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListCard(
            child: Builder(
              builder: (context) => AdvancedOptionTile(
                value: advancedOptionMoreTab,
                onChanged: (val) {
                  setState(() {
                    advancedOptionMoreTab = val;
                    if (!val) {
                      locator<SenseBeTxService>().resetRadio();
                      Provider.of<SenseBeTxService>(context)
                          .setDeviceSpeed(DeviceSpeed.FAST);
                      Scaffold.of(context).showSnackBar(
                          locator<SenseBeTxService>()
                              .advancedSettingOffSnackbar);
                    }
                    locator<SenseBeTxService>().setRadioAdvancedOption(val);
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 10),
          AdvancedOptionWrapper(
            advancedOptionController: advancedOptionMoreTab,
            child: ListCard(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: ListTile(
                  onTap: () {
                    locator<SenseBeTxService>().editRadioSettings();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RadioSettingsView(),
                      ),
                    );
                  },
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Radio",
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    children: <Widget>[
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Channel"),
                          Text(
                              "${int.tryParse(radioSetting.radioChannel.toString().split(".")[1].split("_")[1]) + 1}"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Speed"),
                          Text(
                              "${radioSetting.speed.toString().split('.')[0].split("_").join(" ")}"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          AdvancedOptionWrapper(
            advancedOptionController: advancedOptionMoreTab,
            child: showBeam ? BeamSpeed() : Container(height: 0),
          ),
          SizedBox(height: 10),
          ListCard(
            child: Column(
              children: <Widget>[
                CustomDropdownButton(
                  title: 'Range',
                  dropdownButton: DropdownButton<Range>(
                    value:
                        Provider.of<SenseBeTxService>(context).structure.range,
                    underline: Container(),
                    style: Theme.of(context).textTheme.title.copyWith(
                          fontSize: 18,
                        ),
                    items: Range.values
                        .map((Range range) => DropdownMenuItem(
                              child: range == Range.HIGH
                                  ? Text("8-12m")
                                  : range == Range.MEDIUM
                                      ? Text("4-8m")
                                      : Text("0-4m"),
                              value: range,
                            ))
                        .toList(),
                    onChanged: (Range range) {
                      Provider.of<SenseBeTxService>(context).setRange(range);
                    },
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "This selects the distance between the receiver and transmitter, by configuring the intensity of the transmitted infrared beam.",
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
          SizedBox(height: 60),
          AdvancedOptionWrapper(
            advancedOptionController: advancedOptionMoreTab,
            child: showBeam ? ImportantBeamMessage() : Container(height: 0),
          ),
        ],
      ),
    );
  }
}

class ImportantBeamMessage extends StatelessWidget {
  const ImportantBeamMessage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        "IMPORTANT: Make sure the radio settings and beam speed is same on other devices which will communicate with this device.",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class BeamSpeed extends StatelessWidget {
  const BeamSpeed({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListCard(
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Beam Speed",
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 20),
                  ),
                  DropdownButton(
                    value: Provider.of<SenseBeTxService>(context)
                        .structure
                        .deviceSpeed,
                    underline: Container(),
                    style: Theme.of(context).textTheme.title.copyWith(
                          fontSize: 18,
                        ),
                    items: DeviceSpeed.values.map((speed) {
                      String text =
                          speed.toString().split(".")[1].toLowerCase();
                      return DropdownMenuItem<DeviceSpeed>(
                          value: speed,
                          child: Text(
                            text.replaceFirst(RegExp(r'.', dotAll: true),
                                text[0].toUpperCase()),
                          ));
                    }).toList(),
                    onChanged: (value) {
                      Provider.of<SenseBeTxService>(context)
                          .setDeviceSpeed(value);
                    },
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                "This configures how frequent the beam pulses are expected. Set this based on the targeted animal speed. Faster mode decreases battery life.",
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
