import 'dart:convert';

import 'package:driving_license_test/views/models/version.dart';
import 'package:driving_license_test/views/resource/constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeController extends GetxController {
  dynamic selectedVersion = "None".obs;
  dynamic selectedTestType = "None".obs;
  SharedPreferences prf;

  WelcomeController() {
    SharedPreferences.getInstance().then((value) => prf = value);
  }

  changeVersion(String version) async {
    selectedVersion = version;
  }

  changeType(String type) async {
    selectedTestType = type;
  }

  saveChanges() async {
    VersionModel model = VersionModel();
    model.version = selectedVersion;
    model.type = selectedTestType;
    prf.setString(kVersion, jsonEncode(model.toJson()));
  }

  VersionModel loadVersion() {
    if (prf != null && prf.getString(kVersion) != null) {
      print("VALUE IS NOT NULL");
      return VersionModel.fromJson(jsonDecode(prf.getString(kVersion)));
    }
    return null;
  }
}
