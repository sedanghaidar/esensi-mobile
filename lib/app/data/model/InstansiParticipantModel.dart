import 'dart:convert';

import 'package:absensi_kegiatan/app/data/model/InstansiModel.dart';

class InstansiPartipantModel {
  InstansiPartipantModel({
    this.id,
    this.activityId,
    this.organizationId,
    this.maxParticipant,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.organization,
  });

  int? id;
  int? activityId;
  int? organizationId;
  int? maxParticipant;
  int? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  InstansiModel? organization;

  InstansiPartipantModel copyWith({
    int? id,
    int? activityId,
    int? organizationId,
    int? maxParticipant,
    int? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    InstansiModel? organization,
  }) =>
      InstansiPartipantModel(
        id: id ?? this.id,
        activityId: activityId ?? this.activityId,
        organizationId: organizationId ?? this.organizationId,
        maxParticipant: maxParticipant ?? this.maxParticipant,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        organization: organization ?? this.organization,
      );

  factory InstansiPartipantModel.fromRawJson(String str) => InstansiPartipantModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InstansiPartipantModel.fromJson(Map<String, dynamic> json) => InstansiPartipantModel(
    id: json["id"] == null ? null : json["id"],
    activityId: json["activity_id"] == null ? null : json["activity_id"],
    organizationId: json["organization_id"] == null ? null : json["organization_id"],
    maxParticipant: json["max_participant"] == null ? null : int.parse(json["max_participant"].toString()),
    createdBy: json["created_by"] == null ? null : json["created_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    organization: json["organization"] == null ? null : InstansiModel.fromJson(json["organization"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "activity_id": activityId == null ? null : activityId,
    "organization_id": organizationId == null ? null : organizationId,
    "max_participant": maxParticipant == null ? null : maxParticipant,
    "created_by": createdBy == null ? null : createdBy,
    "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
    "deleted_at": deletedAt == null ? null : deletedAt?.toIso8601String(),
    "organization": organization == null ? null : organization?.toJson(),
  };
}