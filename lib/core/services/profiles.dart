import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

class ProfileFile {
  final String filePath;
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
    return "$path/profiles/$profileName$deviceType​${DateTime.now().millisecondsSinceEpoch}";
  }

  addProfile({@required profileName, @required deviceType}) async {
    // seprated by a Zero width space character U+200B `​`​
    final path = await _localPath;
    Directory("$path/profiles").createSync();
    File profileFile = File(await _generateFilePath(profileName, deviceType));
    profileFile.writeAsStringSync("123");
    notifyListeners();
    getProfiles();
  }

  deleteProfile(String filePath) {
    File file = File(filePath);
    file.delete();
    notifyListeners();
    getProfiles();
  }

  renameProfile(ProfileFile profile) {
    File file = File(profile.filePath);
    file.rename(_generateFilePath(profile.fileName, profile.deviceType));
  }

  shareProfile(String filePath) async {
    ShareExtend.share(filePath, "file");
  }

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
}
