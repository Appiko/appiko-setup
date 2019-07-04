import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/services/shared_prefs.dart';
import 'package:setup/ui/widgets/custom_tab_bar.dart';
import 'package:setup/ui/widgets/popup_menu_item_button.dart';

import '../colors.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final title;
  final subtitle;

  const ProfileAppBar({
    Key key,
    @required this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<SharedPrefs>(context).darkTheme;

    return AppBar(
        backgroundColor: black,
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            if (subtitle != null)
              Visibility(
                visible: true,
                child: Text(
                  subtitle,
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
            onPressed: () {},
          ),

          //  More Options
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                  child: PopupMenuItemButton(
                    onPressed: () {},
                    label: "Delete",
                    icon: Icon(OMIcons.delete),
                  ),
                ),
                PopupMenuItem(
                  child: PopupMenuItemButton(
                    onPressed: () {},
                    label: "Delete",
                    icon: Icon(OMIcons.delete),
                  ),
                ),
              ];
            },
          ),
        ],
        bottom: CustomTabBar());
  }

  @override
  Size get preferredSize => Size(double.infinity, 120);
}
