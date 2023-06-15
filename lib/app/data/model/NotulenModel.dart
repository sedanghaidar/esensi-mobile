// To parse this JSON data, do
//
//     final instansiModel = instansiModelFromJson(jsonString);

import 'dart:convert';

class NotulenModel {
  NotulenModel({
    this.id,
    this.jabatan,
    this.pangkat,
    this.nip,
    this.nama,
    this.hasil,
    this.nosurat,
    this.image1,
    this.image2,
    this.image3,
  });

  int? id;
  String? jabatan;
  String? pangkat;
  String? nip;
  String? nama;
  String? nosurat;
  String? hasil;
  String? image1;
  String? image2;
  String? image3;

  factory NotulenModel.fromRawJson(String str) =>
      NotulenModel.fromJson(json.decode(str));

  factory NotulenModel.fromJson(Map<String, dynamic> json) => NotulenModel(
        id: json["id"] == null ? null : json["id"],
        nama: json["nama"] == null ? null : json["nama"],
        jabatan: json["jabatan"] == null ? null : json["jabatan"],
        pangkat: json["pangkat"] == null ? null : json["pangkat"],
        nip: json["nip"] == null ? null : json["nip"],
        hasil: json["hasil"] == null ? null : json["hasil"],
        nosurat: json["nosurat"] == null ? null : json["nosurat"],
        image1: json["image1"] == null ? null : json["image1"],
        image2: json["image2"] == null ? null : json["image2"],
        image3: json["image3"] == null ? null : json["image3"],
      );
}
