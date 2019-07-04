import 'dart:io';

import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/services/profiles.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/widgets/custom_divider.dart';

class ProfilesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<ProfileFile> profiles = Provider.of<ProfilesService>(context).profiles;
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (_, __) => CustomDivider(),
                itemBuilder: (_, index) {
                  if (index < profiles.length) {
                    return ListTile(
                      title: Text(
                        profiles[index].fileName,
                        style: Theme.of(context).textTheme.body1,
                      ),
                      subtitle: Text(
                        profiles[index].deviceType,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(OMIcons.share),
                              onPressed: () {
                                locator<ProfilesService>()
                                    .shareProfile(profiles[index].filePath);
                              }),
                          IconButton(
                              icon: Icon(OMIcons.delete),
                              onPressed: () {
                                locator<ProfilesService>()
                                    .deleteProfile(profiles[index].filePath);
                              }),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                            context, '/devices/sense-pi/profile-summary');
                      },
                    );
                  }
                  if (index == profiles.length) {
                    return ListTile(title: SizedBox(height: 80.0));
                  }
                },
                itemCount: profiles.length + 1,
              ),
            ),
            // ...profiles.map<ListTile>((ProfileFile profile) {
            //   ListTile(
            //     title: Text(profile.fileName),
            //     subtitle: Text(profile.deviceType),
            //     onTap: () {},
            //     onLongPress: () {
            //       locator<ProfilesService>().deleteProfile(profile.filePath);
            //     },
            //   );
            // }).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("CREATE NEW PROFILE"),
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/profiles/new');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
