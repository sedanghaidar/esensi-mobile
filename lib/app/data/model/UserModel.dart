// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:absensi_kegiatan/app/utils/constant.dart';
import 'package:hive/hive.dart';

/// Sebuah Kelas model yang digunakan untuk menampung data User sekaligus dapat digunakan pada Hive
///
/// nb : Ketika menambahkan atau mengurangi field, jangan lupa untuk menyesuaikan field pada HiveUserAdapter.kt
@HiveType(typeId: HIVE_USER_ID)
class UserModel {
  UserModel({
    this.id,
    this.name,
    this.username,
    this.email,
    this.createdAt,
    this.updatedAt,
    this.token,
    this.roleId,
    this.dinasId,
    this.bidangId,
    this.phone
  });

  @HiveField(0, defaultValue: null)
  int? id;

  @HiveField(1, defaultValue: null)
  String? name;

  @HiveField(2, defaultValue: null)
  String? username;

  @HiveField(3, defaultValue: null)
  String? email;

  @HiveField(4, defaultValue: null)
  DateTime? createdAt;

  @HiveField(5, defaultValue: null)
  DateTime? updatedAt;

  @HiveField(6, defaultValue: null)
  String? token;

  @HiveField(7, defaultValue: null)
  int? roleId;

  @HiveField(8, defaultValue: null)
  int? dinasId;

  @HiveField(9, defaultValue: null)
  int? bidangId;

  @HiveField(10, defaultValue: null)
  String? phone;

  UserModel copyWith({
    int? id,
    String? name,
    String? username,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? token,
    int? roleId,
    int? bidangId,
    int? dinasId,
    String? phone
  }) =>
      UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        username: username ?? this.username,
        email: email ?? this.email,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        token: token ?? this.token,
        roleId: roleId ?? this.roleId,
        bidangId: bidangId ?? this.bidangId,
        dinasId: dinasId ?? this.dinasId,
        phone: phone ?? this.phone,
      );

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        username: json["username"] == null ? null : json["username"],
        email: json["email"] == null ? null : json["email"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        token: json["token"] == null ? null : json["token"],
        roleId: json["role_id"] == null ? null : json["role_id"],
        bidangId: json["bidang_id"] == null ? null : json["bidang_id"],
        dinasId: json["dinas_id"] == null ? null : json["dinas_id"],
        phone: json["phone"] == null ? null : json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "username": username == null ? null : username,
        "email": email == null ? null : email,
        "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
        "token": token == null ? null : token,
        "role_id": roleId == null ? null : roleId,
        "bidang_id": bidangId == null ? null : bidangId,
        "dinas_id": dinasId == null ? null : dinasId,
        "phone": phone == null ? null : phone,
      };

  @override
  String toString() {
    return "id=${id}, name:${name}, username:${username}, email:${email}, token:${token}, roleId:$roleId, bidangId:$bidangId, dinasId:$dinasId, phone:$phone";
  }
}
