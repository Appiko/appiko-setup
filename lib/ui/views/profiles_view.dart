import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:setup/core/services/profiles.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/widgets/custom_divider.dart';

/// {@category Page}
/// {@category Design}
///
/// Sreen which lists all saved profiles. Also contains add button create a new profile
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
                          // IconButton(
                          //     icon: Icon(OMIcons.share),
                          //     onPressed: () {
                          //       locator<ProfilesService>()
                          //           .shareProfile(profiles[index].filePath);
                          //     }),
                          IconButton(
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
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                            ),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                        FlatButton(
                                            child: Text(
                                              "DELETE",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {
                                              locator<ProfilesService>()
                                                  .deleteProfile(
                                                      profiles[index].filePath);
                                              Navigator.pop(context);
                                            }),
                                      ],
                                    ),
                                context: context),
                          ),
                        ],
                      ),
                      onTap: () {
                        locator<ProfilesService>().createStructure(
                            profiles[index].filePath,
                            profiles[index].deviceType);
                        locator<ProfilesService>()
                            .setActiveProfile(profiles[index]);
                        Navigator.pushNamed(
                          context,
                          '/devices/sense-be-rx/profile-summary',
                        );
                      },
                    );
                  }
                  if (index == profiles.length) {
                    return ListTile(title: SizedBox(height: 80.0));
                  }
                  return null;
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
