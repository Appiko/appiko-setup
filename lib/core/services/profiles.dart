import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:setup/core/models/devices/sense_be_rx/1.0/sense_be_rx.dart';
import 'package:setup/core/services/device.dart';
import 'package:setup/core/services/sense_be_rx_service.dart';
import 'package:setup/locators.dart';

/// {@category Model}
class ProfileFile {
  String filePath;
  String fileName;
  Device deviceType;

  ProfileFile({
    @required this.filePath,
  }) {
    var realFileName = basename(this.filePath);
    fileName = realFileName.split('​')[0];
    //TODO:Add swtich to check for other devies
    deviceType =
        realFileName.contains("RX") ? Device.SENSE_BE_RX : Device.SENSE_BE_TX;
  }
}

/// {@category Service}
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

  _generateFilePath(String profileName, Device deviceType) async {
    final path = await _localPath;
    getProfiles();
    return "$path/profiles/$profileName​$deviceType​${DateTime.now().millisecondsSinceEpoch}";
  }

  addProfile({
    @required String profileName,
    @required Device deviceType,
    referActiveStructure = false,
  }) async {
    SenseBeRx senseBeRx = referActiveStructure
        ? locator<SenseBeRxService>().structure
        : SenseBeRx();
    MetaStructure metaStructure = referActiveStructure
        ? locator<SenseBeRxService>().metaStructure
        : MetaStructure();

    // seprated by a Zero width space character U+200B `​`​
    final path = await _localPath;
    Directory("$path/profiles").createSync();
    File file = File(await _generateFilePath(profileName, deviceType));
    var packedData = pack(senseBeRx);
    file.writeAsBytesSync(packedData);
    var metaString = "META\n" + jsonEncode(metaStructure);
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

  Future getProfiles() async {
    // return _memoizer.runOnce(() async {
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
    return profiles;
    // });
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

  void createStructure(String filePath, Device deviceType) {
    File profileFile = File(filePath);
    var data = profileFile.readAsBytesSync();
    locator<SenseBeRxService>().structure =
        locator<SenseBeRxService>().metaStructure = null;
    locator<SenseBeRxService>().structure = unpack(data)['structure'];
    locator<SenseBeRxService>().structure = unpack(data)['meta'];

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
