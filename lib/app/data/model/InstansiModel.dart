// To parse this JSON data, do
//
//     final instansiModel = instansiModelFromJson(jsonString);

import 'dart:convert';

class InstansiModel {
  InstansiModel({
    this.id,
    this.name,
    this.shortName,
    this.parent
  });

  int? id;
  String? name;
  String? shortName;
  InstansiModel? parent;

  InstansiModel copyWith({
    int? id,
    String? name,
    String? shortName,
    InstansiModel? parent,
  }) =>
      InstansiModel(
        id: id ?? this.id,
        name: name ?? this.name,
        shortName: shortName ?? this.shortName,
        parent: parent ?? this.parent
      );

  factory InstansiModel.fromRawJson(String str) => InstansiModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InstansiModel.fromJson(Map<String, dynamic> json) => InstansiModel(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    shortName: json["short_name"] == null ? null : json["short_name"],
    parent: json["parent"] == null ? null : InstansiModel.fromJson(json["parent"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "short_name": shortName == null ? null : shortName,
    "parent": parent == null ? null : parent
  };
}
