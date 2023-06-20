// To parse this JSON data, do
//
//     final instansiModel = instansiModelFromJson(jsonString);

import 'dart:convert';

class InstansiModel {
  InstansiModel(
      {this.id,
      this.name,
      this.shortName,
      this.wilayahId,
      this.wilayahName,
      this.parent});

  int? id;
  String? name;
  String? shortName;
  int? wilayahId;
  String? wilayahName;
  InstansiModel? parent;

  InstansiModel copyWith({
    int? id,
    String? name,
    String? shortName,
    int? wilayahId,
    String? wilayahName,
    InstansiModel? parent,
  }) =>
      InstansiModel(
          id: id ?? this.id,
          name: name ?? this.name,
          shortName: shortName ?? this.shortName,
          wilayahId: wilayahId ?? this.wilayahId,
          wilayahName: wilayahName ?? this.wilayahName,
          parent: parent ?? this.parent);

  factory InstansiModel.fromRawJson(String str) =>
      InstansiModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InstansiModel.fromJson(Map<String, dynamic> json) => InstansiModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        shortName: json["short_name"] == null ? null : json["short_name"],
        wilayahId: json["region_id"] == null
            ? null
            : int.parse(json["region_id"].toString()),
        wilayahName: json["region_name"] == null ? null : json["region_name"],
        parent: json["parent"] == null
            ? null
            : InstansiModel.fromJson(json["parent"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "short_name": shortName == null ? null : shortName,
        "region_id": wilayahId == null ? null : wilayahId,
        "rgion_name": wilayahName == null ? null : wilayahName,
        "parent": parent == null ? null : parent
      };
}
