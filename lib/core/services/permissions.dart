import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:setup/core/services/platform_services.dart';

/// {@category Service}
/// Service to handle permissions
class PermissionsService {
  Map<PermissionGroup, PermissionStatus> permissions = {};

  Future<bool> hasLocationAccess() async {
    PermissionStatus locationStatus = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationWhenInUse);
    return (locationStatus == PermissionStatus.disabled ||
        locationStatus == PermissionStatus.granted);
  }

  Future<dynamic> requestLoctionAccess({@required BuildContext context}) async {
    return _showInfoDialog(context);
  }

  _showInfoDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: new Text("Location"),
            content: new Text(
                "Location is needed to interact with Bluetooth devices on Android.\nPlease allow location to scan for devices."),
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
                    Navigator.of(context).pop();
                    permissions.addAll(
                      await PermissionHandler().requestPermissions(
                          [PermissionGroup.locationWhenInUse]),
                    );
                    // PlatformServies().requestLocationService();
                  }),
            ],
          );
        });
  }
}
