// To parse this JSON data, do
//
//     final instansiModel = instansiModelFromJson(jsonString);

import 'dart:convert';

class InstansiModel {
  InstansiModel({
    this.id,
    this.name,
    this.shortName,
  });

  int? id;
  String? name;
  String? shortName;

  InstansiModel copyWith({
    int? id,
    String? name,
    String? shortName,
  }) =>
      InstansiModel(
        id: id ?? this.id,
        name: name ?? this.name,
        shortName: shortName ?? this.shortName,
      );

  factory InstansiModel.fromRawJson(String str) => InstansiModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InstansiModel.fromJson(Map<String, dynamic> json) => InstansiModel(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    shortName: json["short_name"] == null ? null : json["short_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "short_name": shortName == null ? null : shortName,
  };
}
