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

  UserModel copyWith({
    int? id,
    String? name,
    String? username,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? token,
  }) =>
      UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        username: username ?? this.username,
        email: email ?? this.email,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        token: token ?? this.token,
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
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "username": username == null ? null : username,
        "email": email == null ? null : email,
        "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
        "token": token == null ? null : token,
      };

  @override
  String toString() {
    return "id=${id}, name:${name}, username:${username}, email:${email}, token:${token}";
  }
}
