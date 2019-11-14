import 'package:flutter/material.dart';
import 'package:setup/core/services/device.dart';
import 'package:setup/core/services/profiles.dart';
import 'package:setup/core/services/sense_be_rx_service.dart';
import 'package:setup/core/services/sense_be_tx_service.dart';
import 'package:setup/core/services/sense_pi_service.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/widgets/single_text_field.dart';

class ProfileNameDialog extends StatelessWidget {
  final TextEditingController fileNameController;
  final ProfileFile profileFile;

  /// using this only if the profile file is `null`
  final Device deviceType;
  final BuildContext scaffoldContext;

  ProfileNameDialog({
    Key key,
    @required this.fileNameController,
    @required this.profileFile,
    @required this.scaffoldContext,
    this.deviceType,
  }) : super(key: key);
  unsetShouldSave(Device device) {
    switch (device) {
      case Device.SENSE_BE_TX:
        locator<SenseBeTxService>().shouldSave = false;
        break;
      case Device.SENSE_BE_RX:
        locator<SenseBeRxService>().shouldSave = false;

        break;
      case Device.SENSE_PI:
        locator<SensePiService>().shouldSave = false;

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new SingleFieldDialogBox(
        textEditingController: fileNameController,
        onActionPressed: () async {
          if (deviceType != null) {
            await locator<ProfilesService>().addProfile(
              profileName: fileNameController.text,
              deviceType: deviceType,
              referActiveStructure: true,
            );
            unsetShouldSave(deviceType);
            SnackBar s = SnackBar(
              backgroundColor: Theme.of(context).accentColor,
              duration: Duration(seconds: 3),
              content: Text("Saved successfully 🎉 "),
            );

            Scaffold.of(scaffoldContext).showSnackBar(s);
          } else {
            profileFile?.fileName = fileNameController.text;
            await locator<ProfilesService>().renameProfile(profileFile);
            SnackBar s = SnackBar(
              backgroundColor: Theme.of(context).accentColor,
              duration: Duration(seconds: 3),
              content: Text("Renamed successfully 🎉 "),
            );

            Scaffold.of(scaffoldContext).showSnackBar(s);
          }
          Navigator.pop(context);
        },
        actionLabel: deviceType != null ? "SAVE" : "RENAME");
  }
}

class SingleFieldDialogBox extends StatelessWidget {
  const SingleFieldDialogBox({
    Key key,
    @required this.textEditingController,
    @required this.onActionPressed,
    this.title,
    this.onCancelPressed,
    this.actionLabel,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final VoidCallback onCancelPressed;
  final VoidCallback onActionPressed;
  final String actionLabel;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SingleTextField(
                title: title ?? "Profile Name",
                textField: TextFormField(
                  controller: textEditingController,
                  autofocus: true,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    child: Text(
                      "CANCEL",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                    onPressed: onCancelPressed ?? () => Navigator.pop(context),
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    child: Text(
                      actionLabel ?? "SAVE",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    onPressed: onActionPressed,
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
