import 'package:flutter/material.dart';
import 'package:setup/core/services/device.dart';
import 'package:setup/core/services/profiles.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/widgets/single_text_field.dart';

class ProfileNameDialog extends StatelessWidget {
  final TextEditingController fileNameController;
  final ProfileFile profileFile;

  /// using this only if the profile file is `null`
  final Device deviceType;

  ProfileNameDialog({
    Key key,
    @required this.fileNameController,
    @required this.profileFile,
    this.deviceType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SingleFeildDialogBox(
        textEditingController: fileNameController,
        onActionPressed: () async {
          if (deviceType != null) {
            locator<ProfilesService>().addProfile(
              profileName: fileNameController.text,
              deviceType: deviceType,
              referActiveStructure: true,
            );
          } else {
            profileFile?.fileName = fileNameController.text;
            locator<ProfilesService>().renameProfile(profileFile);
          }
          Navigator.pop(context);
        },
        actionLabel: deviceType != null ? "SAVE" : "RENAME");
  }
}

class SingleFeildDialogBox extends StatelessWidget {
  const SingleFeildDialogBox({
    Key key,
    @required this.textEditingController,
    @required this.onActionPressed,
    this.onCancelPressed,
    this.actionLabel,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final VoidCallback onCancelPressed;
  final VoidCallback onActionPressed;
  final String actionLabel;
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
                title: "Profile Name",
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
