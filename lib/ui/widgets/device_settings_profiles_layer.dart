import 'package:flutter/material.dart';
import 'package:rubber/rubber.dart';
import 'package:setup/core/services/device.dart';
import 'package:setup/core/services/helper_functions.dart';
import 'package:setup/core/services/profiles.dart';
import 'package:setup/locators.dart';
import 'package:setup/ui/widgets/custom_divider.dart';

class DeviceSettingProfilesLayer extends StatefulWidget {
  const DeviceSettingProfilesLayer({
    Key key,
    @required RubberAnimationController controller,
    @required this.profileFile,
    @required this.deviceType,
    @required ScrollController scrollController,
    @required this.shouldSave,
  })  : _controller = controller,
        _scrollController = scrollController,
        super(key: key);

  final RubberAnimationController _controller;
  final ProfileFile profileFile;

  final Device deviceType;
  final ScrollController _scrollController;

  final bool shouldSave;
  @override
  _DeviceSettingProfilesLayerState createState() =>
      _DeviceSettingProfilesLayerState();
}

class _DeviceSettingProfilesLayerState
    extends State<DeviceSettingProfilesLayer> {
  Future<List<ProfileFile>> profiles;

  @override
  void initState() {
    profiles = locator<ProfilesService>().getProfiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProfileFile activeProfile = locator<ProfilesService>().activeProfile;

    return Container(
      color: Colors.white,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
              child: activeProfile != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 8,
                          child: Text(
                            "SELECTED PROFILE: ${activeProfile.fileName}",
                            style: Theme.of(context).textTheme.body1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: IconButton(
                            icon: Icon(Icons.save),
                            onPressed: () {
                              widget._controller.collapse();
                              locator<ProfilesService>()
                                  .updateProfile(widget.profileFile.filePath);
                              SnackBar s = SnackBar(
                                backgroundColor: Theme.of(context).accentColor,
                                duration: Duration(seconds: 3),
                                content: Text(
                                    "${widget.profileFile.fileName} updated 🎉 "),
                              );
                              Scaffold.of(context).showSnackBar(s);
                            },
                          ),
                        )
                      ],
                    )
                  : Container(height: 0),
            ),
            activeProfile != null ? CustomDivider() : Container(height: 0),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Load from saved profiles".toUpperCase(),
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                ),
                FutureBuilder(
                    future: profiles,
                    builder:
                        (context, AsyncSnapshot<List<ProfileFile>> snapshot) {
                      if (snapshot.hasData) {
                        List<ProfileFile> _profiles = snapshot.data
                            .where((profileFile) =>
                                profileFile.deviceType == Device.SENSE_BE_RX)
                            .toList();
                        if (_profiles.length == 0) {
                          return ListTile(
                            title: Text(
                              "No profiles created for this device yet!",
                            ),
                          );
                        }
                        return ListView.separated(
                          padding: EdgeInsets.all(0),
                          separatorBuilder: (_, __) => CustomDivider(),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, i) => ListTile(
                            title: Text(_profiles[i].fileName),
                            onTap: () {
                              if (widget.shouldSave) {
                                showDiscardDialog(
                                    context: context,
                                    content: Text(
                                        "Selecting this profile will discard the current configuration"),
                                    onDiscardPressed: () {
                                      Navigator.pop(context);
                                      widget._controller.collapse();
                                      locator<ProfilesService>()
                                          .createStructure(
                                        _profiles[i].filePath,
                                        _profiles[i].deviceType,
                                      );
                                      locator<ProfilesService>()
                                          .setActiveProfile(_profiles[i]);
                                      final SnackBar profileSelectedSnackBar =
                                          SnackBar(
                                        content: Text(
                                          "Selected ${_profiles[i].fileName}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        elevation: 5,
                                        backgroundColor:
                                            Theme.of(context).accentColor,
                                        duration: Duration(seconds: 1),
                                        behavior: SnackBarBehavior.fixed,
                                      );
                                      Scaffold.of(context).showSnackBar(
                                          profileSelectedSnackBar);
                                      setState(() {});
                                    });
                              } else {
                                widget._controller.collapse();
                                locator<ProfilesService>().createStructure(
                                  _profiles[i].filePath,
                                  _profiles[i].deviceType,
                                );
                                locator<ProfilesService>()
                                    .setActiveProfile(_profiles[i]);
                                final SnackBar profileSelectedSnackBar =
                                    SnackBar(
                                  content: Text(
                                    "Selected ${_profiles[i].fileName}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  elevation: 5,
                                  backgroundColor:
                                      Theme.of(context).accentColor,
                                  duration: Duration(seconds: 1),
                                  behavior: SnackBarBehavior.fixed,
                                );
                                Scaffold.of(context)
                                    .showSnackBar(profileSelectedSnackBar);
                                setState(() {});
                              }
                            },
                          ),
                          itemCount: _profiles.length,
                        );
                      }
                      if (snapshot.hasError) {
                        return ListTile(
                          title: Text(
                            "No profiles created for this device yet!",
                          ),
                        );
                      }
                      return Container(height: 0);
                    }),
              ],
            ),
          ],
        ),
        physics: NeverScrollableScrollPhysics(),
        controller: widget._scrollController,
      ),
    );
  }
}
