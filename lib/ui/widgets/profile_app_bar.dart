import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/services/profiles.dart';
import 'package:setup/ui/devices/sense_be_rx/1.0/profiles/profile_summary_view.dart';
import 'package:setup/ui/widgets/custom_tab_bar.dart';
import 'package:setup/ui/widgets/single_text_field.dart';

import '../colors.dart';

/// {@category Compound Widget}
/// {@category Design}
///
/// Profies app bar displayed in [ProfileSummaryView]
class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  ProfileFile profileFile;
  final TabController tabController;

  final VoidCallback onDeletePressed;

  final TextEditingController fileNameController = TextEditingController();
  ProfileAppBar({
    Key key,
    @required this.profileFile,
    @required this.tabController,
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
                  profileFile.deviceType,
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
                  builder: (context) => Dialog(
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
                                controller: fileNameController,
                                autofocus: true,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                FlatButton(
                                  padding: EdgeInsets.all(0),
                                  child: Text(
                                    "CLOSE",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                FlatButton(
                                  padding: EdgeInsets.all(0),
                                  child: Text(
                                    "RENAME",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                  onPressed: () async {
                                    this.profileFile.fileName =
                                        fileNameController.text;

                                    Provider.of<ProfilesService>(context)
                                        .renameProfile(profileFile);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      )));
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
        bottom: CustomTabBar(tabController: tabController));
  }

  @override
  Size get preferredSize => Size(double.infinity, 120);
}
