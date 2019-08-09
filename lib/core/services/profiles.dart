import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:setup/core/models/sense_be_rx.dart';
import 'package:setup/core/services/sense_be_rx_service.dart';
import 'package:setup/locators.dart';
import 'package:share_extend/share_extend.dart';

class ProfileFile {
  String filePath;
  String fileName;
  String deviceType;

  ProfileFile({
    @required this.filePath,
  }) {
    var realFileName = basename(this.filePath);
    fileName = realFileName.split('​')[0];
    deviceType = realFileName.split('​')[1];
  }
}

class ProfilesService with ChangeNotifier {
  List<ProfileFile> profiles = [];
  ProfileFile activeProfile;

  ProfilesService() {
    fetchProfiles();
  }

  fetchProfiles() async {
    await getProfiles();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  _generateFilePath(String profileName, String deviceType) async {
    final path = await _localPath;
    getProfiles();
    return "$path/profiles/$profileName​$deviceType​${DateTime.now().millisecondsSinceEpoch}";
  }

  addProfile({@required profileName, @required deviceType}) async {
    // seprated by a Zero width space character U+200B `​`​
    final path = await _localPath;
    Directory("$path/profiles").createSync();
    File file = File(await _generateFilePath(profileName, deviceType));
    var packedData = pack(SenseBeRx());
    file.writeAsBytesSync(packedData);
    var metaString = "META\n" + jsonEncode(MetaStructure());
    file.writeAsStringSync(metaString, mode: FileMode.append);
    notifyListeners();
    getProfiles();
    return file.path;
  }

  deleteProfile(String filePath) {
    File file = File(filePath);
    file.delete();
    notifyListeners();
    getProfiles();
  }

  renameProfile(ProfileFile profile) async {
    File file = File(profile.filePath);
    String newFilePath =
        await _generateFilePath(profile.fileName, profile.deviceType);
    file.rename(newFilePath);
    getProfiles();
    profile = ProfileFile(filePath: newFilePath);
    setActiveProfile(profile);
    notifyListeners();
    print("Renamed to ${profile.filePath}");
  }

  // shareProfile(String filePath) async {
  //   ShareExtend.share(filePath, "file");
  // }

  getProfiles() async {
    final dir = Directory("${await _localPath}/profiles");
    profiles.clear();
    if (dir.existsSync()) {
      dir.listSync().forEach((FileSystemEntity f) {
        profiles.add(ProfileFile(
          filePath: f.path,
        ));
      });
      notifyListeners();
    }
  }

  updateProfile(String profilePath) {
    // seprated by a Zero width space character U+200B `​`​
    File profileFile = File(profilePath);
    var packedData = pack(locator<SenseBeRxService>().structure);
    var test = BytesBuilder();
    test.add(packedData.toList());
    profileFile.writeAsBytesSync(test.toBytes());

    var metaString =
        "META\n" + jsonEncode(locator<SenseBeRxService>().metaStructure);
    profileFile.writeAsStringSync(metaString, mode: FileMode.append);

    notifyListeners();
  }

  void createStructure(String filePath, String deviceType) {
    File profileFile = File(filePath);
    var data = profileFile.readAsBytesSync();
    locator<SenseBeRxService>().structure = null;
    locator<SenseBeRxService>().structure = unpack(data);

    List<int> metaData = profileFile.readAsBytesSync();
    var metaString = Utf8Codec(allowMalformed: true).decode(metaData);
    metaString = metaString.split("META\n")[1];
    Map userMap = jsonDecode(metaString);
    MetaStructure meta = MetaStructure.fromJson(userMap);
    print(meta.toString());

    locator<SenseBeRxService>().metaStructure = meta;
  }

  void setActiveProfile(ProfileFile profile) {
    activeProfile = profile;
    notifyListeners();
  }
}
