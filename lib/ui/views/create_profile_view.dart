import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:setup/core/services/device.dart';
import 'package:setup/core/services/helper_functions.dart';
import 'package:setup/core/services/profiles.dart';
import 'package:setup/core/services/sense_be_rx_service.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/widgets/custom_app_bar.dart';
import 'package:setup/ui/widgets/page_navigation_bar.dart';

/// {@category Page}
/// {@category Design}
///
/// Screen shown when creating a new profile
class CreateProfileView extends StatefulWidget {
  @override
  _CreateProfileViewState createState() => _CreateProfileViewState();
}

class _CreateProfileViewState extends State<CreateProfileView> {
  final _newProfileForm = GlobalKey<FormState>();
  final TextEditingController _profileNameController = TextEditingController();
  Device _selectedDevice = Device.SENSE_BE_RX;
  @override
  Widget build(BuildContext context) {
    // _selectedDevice = Device.SENSE_BE_RX;
    return Scaffold(
      appBar: CustomAppBar(title: "Create Profile"),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Form(
          key: _newProfileForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Profile Name",
                style: Theme.of(context).textTheme.body1,
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _profileNameController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Enter a profile name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 40.0),
              Text(
                "Device Type",
                style: Theme.of(context).textTheme.body1,
              ),
              SizedBox(height: 8.0),
              DropdownButtonFormField(
                decoration: InputDecoration(),
                value: _selectedDevice,
                onChanged: (value) {
                  setState(() {
                    _selectedDevice = value;
                  });
                },
                items: Device.values
                    .map<DropdownMenuItem<Device>>((Device device) {
                  return DropdownMenuItem<Device>(
                    value: device,
                    child: Text(DeviceHelper.getString(device)),
                  );
                }).toList(),
              ),
              SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: PageNavigationBar(
        showPrevious: false,
        showNext: true,
        nextLabel: "CREATE",
        onNext: () async {
          locator<SenseBeRxService>().reset();
          if (_newProfileForm.currentState.validate()) {
            //  Set active device
            activeDevice = _selectedDevice;

            ProfileFile profileFile = ProfileFile(
              filePath: await locator<ProfilesService>().addProfile(
                profileName: _profileNameController.text,
                deviceType: _selectedDevice,
              ),
            );

            locator<ProfilesService>().setActiveProfile(profileFile);

            Navigator.pushNamed(context, getProfileSummaryPath());
          }
        },
      ),
    );
  }
}
