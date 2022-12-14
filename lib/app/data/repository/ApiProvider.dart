import 'package:absensi_kegiatan/app/data/model/KegiatanModel.dart';
import 'package:absensi_kegiatan/app/data/model/UserModel.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiHelper.dart';
import 'package:absensi_kegiatan/app/data/repository/HiveProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';

import '../model/repository/StatusRequestModel.dart';

class ApiProvider extends GetConnect {
  static const String BASE_URL = "http://172.100.31.106:8000";

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

  Future<StatusRequestModel<KegiatanModel>> deleteKegiatan(String? id) async {
    final response = await post("/api/kegiatan/delete/$id", {});
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(KegiatanModel.fromJson(model.data));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  Future<StatusRequestModel<KegiatanModel>> getKegiatanByCode(String? code) async {
    final response = await get("/api/kegiatan/kode/$code");
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(KegiatanModel.fromJson(model.data));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }
}
