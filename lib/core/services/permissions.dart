import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  Map<PermissionGroup, PermissionStatus> permissions = {};

  Future<bool> hasLocationAccess() async {
    PermissionStatus locationStatus = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationWhenInUse);
    return (locationStatus == PermissionStatus.granted);
  }

  Future<dynamic> requestLoctionAccess({@required BuildContext context}) async {
    // if (await _showInfoDialog(context)) {
    return _showInfoDialog(context);
    // } else {
    // return false;
    // }
  }

  _showInfoDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: new Text("Location Access"),
            content: new Text("Access location for .... "),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "NOT NOW",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: Text(
                    "CONTINUE",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () async {
                    permissions.addAll(
                      await PermissionHandler().requestPermissions(
                          [PermissionGroup.locationWhenInUse]),
                    );
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }
}
