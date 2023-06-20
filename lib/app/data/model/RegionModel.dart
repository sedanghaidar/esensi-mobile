// To parse this JSON data, do
//
//     final regionModel = regionModelFromJson(jsonString);

import 'dart:convert';

RegionModel regionModelFromJson(String str) => RegionModel.fromJson(json.decode(str));

String regionModelToJson(RegionModel data) => json.encode(data.toJson());

class RegionModel {
  String? id;
  String? name;

  RegionModel({
    this.id,
    this.name,
  });

  RegionModel copyWith({
    String? id,
    String? name,
  }) =>
      RegionModel(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory RegionModel.fromJson(Map<String, dynamic> json) => RegionModel(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
