import 'package:absensi_kegiatan/app/data/model/repository/FailureModel.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';

import '../model/repository/StatusRequestModel.dart';

class ApiProvider extends GetConnect{
  static const String BASE_URL = "https://laporgub.jatengprov.go.id";

  @override
  void onInit() {
    httpClient.baseUrl = BASE_URL;

    httpClient.addRequestModifier<dynamic>((request2) {
      ///TODO GET TOKEN FROM HIVE
      var token = "";
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

  Future<StatusRequestModel<FailureModel>> login(String email, String password, String? token) async {
    final response =
    await post("/api/login", {'phonemail': email, 'password': password});
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(model.data);
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

}
