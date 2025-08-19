// To parse this JSON data, do
//
//     final instansiModel = instansiModelFromJson(jsonString);

import 'dart:convert';

import 'KegiatanModel.dart';

class NotulenModel {
  NotulenModel({
    this.id,
    this.jabatan,
    this.pangkat,
    this.nip,
    this.nama,
    this.hasil,
    this.delta,
    this.nosurat,
    this.image1,
    this.image2,
    this.image3,
    this.kegiatan,
    this.peserta,
  });

  int? id;
  String? jabatan;
  String? pangkat;
  String? nip;
  String? nama;
  String? nosurat;
  String? hasil;
  String? delta;
  String? image1;
  String? image2;
  String? image3;
  KegiatanModel? kegiatan;
  List<String>? peserta;

  factory NotulenModel.fromRawJson(String str) =>
      NotulenModel.fromJson(json.decode(str));

  factory NotulenModel.fromJson(Map<String, dynamic> json) => NotulenModel(
        id: json["id"] == null ? null : json["id"],
        nama: json["nama"] == null ? null : json["nama"],
        jabatan: json["jabatan"] == null ? null : json["jabatan"],
        pangkat: json["pangkat"] == null ? null : json["pangkat"],
        nip: json["nip"] == null ? null : json["nip"],
        hasil: json["hasil"] == null ? null : json["hasil"],
        delta: json["delta"] == null ? null : json["delta"],
        nosurat: json["nosurat"] == null ? null : json["nosurat"],
        image1: json["image1"] == null ? null : json["image1"],
        image2: json["image2"] == null ? null : json["image2"],
        image3: json["image3"] == null ? null : json["image3"],
        kegiatan: json["kegiatan"] == null
            ? null
            : KegiatanModel.fromJson(json["kegiatan"]),
        peserta:
            json["peserta"] == null ? null : List<String>.from(json["peserta"]),
      );
}
