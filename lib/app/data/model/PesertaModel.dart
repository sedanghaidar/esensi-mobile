// To parse this JSON data, do
//
//     final pesertaModel = pesertaModelFromJson(jsonString);

import 'dart:convert';

import 'package:absensi_kegiatan/app/data/model/InstansiModel.dart';
import 'package:absensi_kegiatan/app/data/model/KegiatanModel.dart';

class PesertaModel {
  PesertaModel({
    this.activityId,
    this.name,
    this.nip,
    this.jabatan,
    this.instansi,
    this.instansiDetail,
    this.wilayahId,
    this.wilayahName,
    this.nohp,
    this.signature,
    this.qrCode,
    this.updatedAt,
    this.createdAt,
    this.scannedAt,
    this.kegiatan,
    this.id,
  });

  int? activityId;
  String? name;
  String? nip;
  String? jabatan;
  String? instansi;
  InstansiModel? instansiDetail;
  int? wilayahId;
  String? wilayahName;
  String? nohp;
  String? signature;
  String? qrCode;
  DateTime? updatedAt;
  DateTime? createdAt;
  DateTime? scannedAt;
  int? id;
  KegiatanModel? kegiatan;

  PesertaModel copyWith({
    int? activityId,
    String? name,
    String? nip,
    String? jabatan,
    String? instansi,
    InstansiModel? instansiDetail,
    int? wilayahId,
    String? wilayahName,
    String? nohp,
    String? signature,
    String? qrCode,
    DateTime? updatedAt,
    DateTime? createdAt,
    DateTime? scannedAt,
    KegiatanModel? kegiatan,
    int? id,
  }) =>
      PesertaModel(
        activityId: activityId ?? this.activityId,
        name: name ?? this.name,
        nip: nip ?? this.nip,
        jabatan: jabatan ?? this.jabatan,
        instansi: instansi ?? this.instansi,
        instansiDetail: instansiDetail ?? this.instansiDetail,
        wilayahId: wilayahId ?? this.wilayahId,
        wilayahName: wilayahName ?? this.wilayahName,
        nohp: nohp ?? this.nohp,
        signature: signature ?? this.signature,
        qrCode: qrCode ?? this.qrCode,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
        scannedAt: createdAt ?? this.scannedAt,
        kegiatan: kegiatan ?? this.kegiatan,
        id: id ?? this.id,
      );

  factory PesertaModel.fromRawJson(String str) =>
      PesertaModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PesertaModel.fromJson(Map<String, dynamic> json) => PesertaModel(
        activityId: json["activity_id"] == null
            ? null
            : int.parse(json["activity_id"].toString()),
        name: json["name"] == null ? null : json["name"],
        nip: json["nip"],
        jabatan: json["jabatan"] == null ? null : json["jabatan"],
        instansi: json["instansi"] == null ? null : json["instansi"],
        instansiDetail: json["parent"] == null
            ? null
            : InstansiModel.fromJson(json["parent"]),
        wilayahId: json["region_id"] == null
            ? null
            : int.parse(json["region_id"].toString()),
        wilayahName: json["region_name"] == null ? null : json["region_name"],
        nohp: json["nohp"] == null ? null : json["nohp"],
        signature: json["signature"] == null ? null : json["signature"],
        qrCode: json["qr_code"] == null ? null : json["qr_code"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        scannedAt: json["scanned_at"] == null
            ? null
            : DateTime.parse(json["scanned_at"]),
        kegiatan: json["kegiatan"] == null
            ? null
            : KegiatanModel.fromJson(json["kegiatan"]),
        id: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "activity_id": activityId == null ? null : activityId,
        "name": name == null ? null : name,
        "nip": nip,
        "jabatan": jabatan == null ? null : jabatan,
        "instansi": instansi == null ? null : instansi,
        "nohp": nohp == null ? null : nohp,
        "signature": signature == null ? null : signature,
        "qr_code": qrCode == null ? null : qrCode,
        "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
        "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
        "scanned_at": scannedAt == null ? null : scannedAt?.toIso8601String(),
        "id": id == null ? null : id,
      };
}
