import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:setup/core/services/device.dart';
import 'package:setup/core/services/profiles.dart';
import 'package:setup/ui/devices/sense_be_rx/1.0/profiles/profile_summary_view.dart';
import 'package:setup/ui/widgets/custom_tab_bar.dart';
import 'package:setup/ui/widgets/profile_name_dialog.dart';

import '../colors.dart';

/// {@category Compound Widget}
/// {@category Design}
///
/// Profies app bar displayed in [ProfileSummaryView]
class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ProfileFile profileFile;
  final TabController tabController;

  final VoidCallback onDeletePressed;

  final TextEditingController fileNameController = TextEditingController();

  final String moreTabName;

  ProfileAppBar({
    Key key,
    @required this.profileFile,
    @required this.tabController,
    @required this.moreTabName,
    this.onDeletePressed,
  }) : super(key: key) {
    fileNameController.text = profileFile.fileName;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: black,
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              profileFile.fileName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            if (profileFile.deviceType != null)
              Visibility(
                visible: true,
                child: Text(
                  DeviceHelper.getString(profileFile.deviceType),
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: Colors.white),
                ),
              ),
          ],
        ),
        actions: <Widget>[
          // Edit Button
          IconButton(
            icon: Icon(OMIcons.edit),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => ProfileNameDialog(
                        fileNameController: fileNameController,
                        profileFile: profileFile,
                      ));
            },
          ),

          onDeletePressed != null
              ? IconButton(
                  icon: Icon(OMIcons.delete),
                  onPressed: () => showDialog(
                      builder: (context) => AlertDialog(
                            title: Text("Delete Profile?"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  "CANCEL",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                              FlatButton(
                                child: Text(
                                  "DELETE",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onPressed: onDeletePressed,
                              ),
                            ],
                          ),
                      context: context),
                )
              : Container(),
          //  More Options
          // PopupMenuButton(
          //   icon: Icon(Icons.more_vert),
          //   itemBuilder: (_) {
          //     return [
          //       PopupMenuItem(
          //         child: PopupMenuItemButton(
          //           onPressed: () {},
          //           label: "Share",
          //           icon: Icon(OMIcons.delete),
          //         ),
          //       ),
          // PopupMenuItem(
          //   child: PopupMenuItemButton(
          //     onPressed: () {},
          //     label: "Delete",
          //     icon: Icon(OMIcons.delete),
          // ),
          // ),
          // ];
          //   },
          // ),
        ],
        bottom: CustomTabBar(
            tabController: tabController, moreTabName: moreTabName));
  }

  @override
  Size get preferredSize => Size(double.infinity, 120);
}
