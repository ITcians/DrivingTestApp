import 'package:driving_license_test/views/resource/constants.dart';

class VersionModel {
  dynamic version;
  dynamic type;

  VersionModel({this.version, this.type});

  factory VersionModel.fromJson(Map<String, dynamic> map) =>
      VersionModel(type: map[kType], version: map[kVersion]);

  Map<String, dynamic> toJson() => {kType: type, kVersion: version};
}
