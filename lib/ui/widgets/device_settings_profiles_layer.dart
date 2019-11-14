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
  })  : _controller = controller,
        _scrollController = scrollController,
        super(key: key);

  final RubberAnimationController _controller;
  final ProfileFile profileFile;

  final Device deviceType;
  final ScrollController _scrollController;

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
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: activeProfile != null
                  ? Text(
                      "SELECTED PROFILE: ${activeProfile.fileName}",
                      style: Theme.of(context).textTheme.title,
                      textAlign: TextAlign.left,
                    )
                  : Container(),
            ),
            activeProfile != null ? CustomDivider() : Container(),
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Column(
                    children: <Widget>[
                      Builder(
                        builder: (context) => OutlineButton(
                          child: Text(
                            "SAVE AS NEW PROFILE",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                          highlightedBorderColor: Colors.black,
                          onPressed: () async {
                            widget._controller.collapse();
                            saveAsProfile(context, widget.profileFile,
                                Device.SENSE_BE_RX);
                          },
                        ),
                      ),
                      Builder(
                        builder: (context) => (widget.profileFile != null)
                            ? OutlineButton(
                                child: Text(
                                  "UPDATE SELECTED PROFILE",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                                highlightedBorderColor: Colors.black,
                                onPressed: () {
                                  widget._controller.collapse();
                                  locator<ProfilesService>().updateProfile(
                                      widget.profileFile.filePath);
                                  SnackBar s = SnackBar(
                                    backgroundColor:
                                        Theme.of(context).accentColor,
                                    duration: Duration(seconds: 3),
                                    content: Text(
                                        "${widget.profileFile.fileName} updated 🎉 "),
                                  );
                                  Scaffold.of(context).showSnackBar(s);
                                },
                              )
                            : Container(width: 0),
                      ),
                    ],
                  ),
                ),
                activeProfile != null ? CustomDivider() : Container(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
                    child: Container(
                      width: double.infinity,
                      child: Text(
                        "Load from saved profiles".toUpperCase(),
                        style: Theme.of(context).textTheme.title,
                        textAlign: TextAlign.center,
                      ),
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
                          separatorBuilder: (_, __) => CustomDivider(),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, i) => ListTile(
                            title: Text(_profiles[i].fileName),
                            onTap: () {
                              widget._controller.collapse();
                              locator<ProfilesService>().createStructure(
                                _profiles[i].filePath,
                                _profiles[i].deviceType,
                              );
                              locator<ProfilesService>()
                                  .setActiveProfile(_profiles[i]);
                              final SnackBar profileSelectedSnackBar = SnackBar(
                                content: Text(
                                  "Selected ${_profiles[i].fileName}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                elevation: 5,
                                backgroundColor: Theme.of(context).accentColor,
                                duration: Duration(seconds: 1),
                                behavior: SnackBarBehavior.fixed,
                              );
                              Scaffold.of(context)
                                  .showSnackBar(profileSelectedSnackBar);
                              setState(() {});
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
                      return Container();
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
