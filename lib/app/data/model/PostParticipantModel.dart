// To parse this JSON data, do
//
//     final postPartipantModel = postPartipantModelFromJson(jsonString);

import 'dart:convert';

class PostPartipantModel {
  PostPartipantModel({
    this.activityId,
    this.organizationName,
    this.maxParticipant,
  });

  int? activityId;
  String? organizationName;
  int? maxParticipant;

  PostPartipantModel copyWith({
    int? activityId,
    String? organizationName,
    int? maxParticipant,
  }) =>
      PostPartipantModel(
        activityId: activityId ?? this.activityId,
        organizationName: organizationName ?? this.organizationName,
        maxParticipant: maxParticipant ?? this.maxParticipant,
      );

  factory PostPartipantModel.fromRawJson(String str) => PostPartipantModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostPartipantModel.fromJson(Map<String, dynamic> json) => PostPartipantModel(
    activityId: json["activity_id"] == null ? null : json["activity_id"],
    organizationName: json["organization_name"] == null ? null : json["organization_name"],
    maxParticipant: json["max_participant"] == null ? null : json["max_participant"],
  );

  Map<String, dynamic> toJson() => {
    "activity_id": activityId == null ? null : activityId,
    "organization_name": organizationName == null ? null : organizationName,
    "max_participant": maxParticipant == null ? null : maxParticipant,
  };
}
