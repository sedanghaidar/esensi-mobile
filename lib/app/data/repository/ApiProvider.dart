import 'package:absensi_kegiatan/app/data/model/InstansiModel.dart';
import 'package:absensi_kegiatan/app/data/model/KegiatanModel.dart';
import 'package:absensi_kegiatan/app/data/model/PesertaModel.dart';
import 'package:absensi_kegiatan/app/data/model/UserModel.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiHelper.dart';
import 'package:absensi_kegiatan/app/data/repository/HiveProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';

import '../model/repository/StatusRequestModel.dart';

class ApiProvider extends GetConnect {
  // static const String BASE_URL = "http://172.100.31.40:5000";
  static const String BASE_URL = "http://10.99.1.171:8000";

  HiveProvider hive = HiveProvider();

  @override
  void onInit() {
    httpClient.baseUrl = BASE_URL;

    httpClient.addRequestModifier<dynamic>((request2) {
      String? token = "${hive.getUserModel()?.token}";
      request2.headers['Authorization'] = "Bearer $token";
      return request2;
    });

    httpClient.addResponseModifier((request, response) {
      debugPrint(
        '\n╔══════════════════════════ Response ══════════════════════════\n'
        '╟ REQUEST ║ ${request.method.toUpperCase()}\n'
        '╟ url: ${request.url}\n'
        '╟ Headers: ${request.headers}\n'
        // '╟ Body: ${request.bodyBytes.map((event) => event.asMap().toString()) ?? ''}\n'
        '╟ Status Code: ${response.statusCode}\n'
        '╟ Data: ${response.bodyString?.toString() ?? ''}'
        '\n╚══════════════════════════ Response ══════════════════════════\n',
        wrapWidth: 1024,
      );

      httpClient.timeout = const Duration(minutes: 1);

      return response;
    });
    super.onInit();
  }

  /// Api login ke dalam aplikasi
  Future<StatusRequestModel<UserModel>> login(
      String email, String password) async {
    final response =
        await post("/api/login", {'email': email, 'password': password});
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(UserModel.fromJson(model.data));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  /// Mendapatkan daftar kegiatan yang sudah dibuat
  Future<StatusRequestModel<List<KegiatanModel>>> getKegiatan() async {
    final response = await get("/api/kegiatan");
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(List<KegiatanModel>.from(
          (model.data).map((u) => KegiatanModel.fromJson(u))));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  /// Menghapus data kegiatan berdasarkan [id]
  Future<StatusRequestModel<KegiatanModel>> deleteKegiatan(String? id) async {
    final response = await post("/api/kegiatan/delete/$id", {});
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(KegiatanModel.fromJson(model.data));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  /// Mendapatkan data kegiatan berdasarkan [code]
  Future<StatusRequestModel<KegiatanModel>> getKegiatanByCode(
      String? code) async {
    final response = await get("/api/kegiatan/kode/$code");
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(KegiatanModel.fromJson(model.data));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  /// Mendapatkan data daftar semua instansi
  Future<StatusRequestModel<List<InstansiModel>>> getInstansiSemua() async {
    final response = await get("/api/organisasi");
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(List<InstansiModel>.from(
          (model.data).map((u) => InstansiModel.fromJson(u))));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  /// Mendapatkan data daftar semua instansi berdasarkan [id] kegiatan
  Future<StatusRequestModel<List<InstansiModel>>> getInstansi(
      String? id) async {
    final response = await get("/api/organisasi/kegiatan/$id");
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(List<InstansiModel>.from(
          (model.data).map((u) => InstansiModel.fromJson(u))));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  /// Input absen peserta dengan [peserta] adalah data peserta yang ditulis
  Future<StatusRequestModel<PesertaModel>> insertPeserta(
      Map<String, dynamic> peserta) async {
    final response = await post("/api/peserta/daftar", FormData(peserta));
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(PesertaModel.fromJson(model.data));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  /// Mendapatkan data detail peserta berdasarkan [id]
  Future<StatusRequestModel<PesertaModel>> getDetailPeserta(String? id) async {
    final response = await get("/api/peserta/$id");
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(PesertaModel.fromJson(model.data));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }
}
