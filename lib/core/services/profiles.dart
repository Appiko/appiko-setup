import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:setup/core/models/generic/meta.dart';
import 'package:setup/core/services/device.dart';
import 'package:setup/core/services/helper_functions.dart';

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
    deviceType = realFileName.contains("RX")
        ? Device.SENSE_BE_RX
        : realFileName.contains('TX') ? Device.SENSE_BE_TX : Device.SENSE_PI;
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
    var struct = getStructure(shouldReferActiveStructure: referActiveStructure);
    MetaStructure metaStructure =
        getMetaStructure(shouldReferActiveStructure: referActiveStructure);
    // seprated by a Zero width space character U+200B `​`​
    final path = await _localPath;
    Directory("$path/profiles").createSync();
    File file = File(await _generateFilePath(profileName, deviceType));

    var packedData = getPackedData(struct);
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
    var packedData = getPackedData();
    var bytesBuilder = BytesBuilder();
    bytesBuilder.add(packedData.toList());
    profileFile.writeAsBytesSync(bytesBuilder.toBytes());

    var metaString = "META\n" + jsonEncode(getMetaStructure());
    profileFile.writeAsStringSync(metaString, mode: FileMode.append);

    notifyListeners();
  }

  void createStructure(String filePath, Device deviceType) {
    File profileFile = File(filePath);

    Uint8List data = profileFile.readAsBytesSync();
    createStructureFromData(data: data);

    List<int> metaData = profileFile.readAsBytesSync();
    String metaString = Utf8Codec(allowMalformed: true).decode(metaData);
    metaString = metaString.split("META\n")[1];
    Map userMap = jsonDecode(metaString);
    MetaStructure meta = MetaStructure.fromJson(userMap);

    setMetaStructure(meta);
  }

  void setActiveProfile(ProfileFile profile) {
    activeProfile = profile;
    activeDevice = profile.deviceType;
    notifyListeners();
  }
}
