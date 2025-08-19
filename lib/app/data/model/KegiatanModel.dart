// To parse this JSON data, do
//
//     final kegiatanModel = kegiatanModelFromJson(jsonString);

import 'dart:convert';

class KegiatanModel {

  KegiatanModel({
    this.id,
    this.name,
    this.date,
    this.time,
    this.location,
    this.information,
    this.messageVerifivation,
    this.dateEnd,
    this.isLimitParticipant,
    this.codeUrl,
    this.type,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int? id;
  String? name;
  DateTime? date;
  String? time;
  String? location;
  String? information;
  String? messageVerifivation;
  DateTime? dateEnd;
  bool? isLimitParticipant = false;
  int? createdBy;
  String? codeUrl;
  int? type;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  KegiatanModel copyWith({
    int? id,
    String? name,
    DateTime? date,
    String? time,
    String? location,
    String? information,
    String? messageVerification,
    DateTime? dateEnd,
    bool? isLimitParticipant,
    String? codeUrl,
    int? type,
    int? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) =>
      KegiatanModel(
        id: id ?? this.id,
        name: name ?? this.name,
        date: date ?? this.date,
        time: time ?? this.time,
        location: location ?? this.location,
        information: information ?? this.information,
        messageVerifivation: messageVerifivation ?? this.messageVerifivation,
        dateEnd: dateEnd ?? this.dateEnd,
        isLimitParticipant: isLimitParticipant ?? this.isLimitParticipant,
        codeUrl: codeUrl ?? this.codeUrl,
        type: type ?? this.type,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
      );

  factory KegiatanModel.fromRawJson(String str) =>
      KegiatanModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory KegiatanModel.fromJson(Map<String, dynamic> json) => KegiatanModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        time: json["time"] == null ? null : json["time"],
        location: json["location"] == null ? null : json["location"],
        information: json["information"] == null ? null : json["information"],
        messageVerifivation: json["verification_message"] == null
            ? null
            : json["verification_message"],
        dateEnd:
            json["max_date"] == null ? null : DateTime.parse(json["max_date"]),
        isLimitParticipant:
            json["limit_participant"] == null || json["limit_participant"] == 0
                ? false
                : true,
        codeUrl: json["code_url"] == null ? null : json["code_url"],
        type: json["type"] == null ? null : int.parse(json["type"].toString()),
        createdBy: json["created_by"] == null ? null : json["created_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"] == null
            ? null
            : DateTime.parse(json["deleted_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "date": date == null
            ? null
            : "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
        "time": time == null ? null : time,
        "location": location == null ? null : location,
        "information": information == null ? null : information,
        "verification_message": messageVerifivation == null ? null : messageVerifivation,
        "max_date": dateEnd == null ? null : dateEnd?.toIso8601String(),
        "limit_participant":
            isLimitParticipant == null ? false : isLimitParticipant,
        "code_url": codeUrl == null ? null : codeUrl,
        "created_by": createdBy == null ? null : createdBy,
        "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
        "deleted_at": deletedAt == null ? null : updatedAt?.toIso8601String(),
      };
}
