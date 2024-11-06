import 'package:absensi_kegiatan/app/data/model/RegionModel.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiHelper.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_connect/connect.dart';

import '../model/repository/FailureModel.dart';
import '../model/repository/StatusRequestModel.dart';

class LaporgubProvider extends GetConnect {
  static String BASE_URL = "https://laporgub.jatengprov.go.id";

  @override
  void onInit() {
    httpClient.baseUrl = BASE_URL;

    httpClient.addResponseModifier((request, response) {
      // debugPrint(
      //   '\n╔══════════════════════════ Response ══════════════════════════\n'
      //   '╟ REQUEST ║ ${request.method.toUpperCase()}\n'
      //   '╟ url: ${request.url}\n'
      //   '╟ Headers: ${request.headers}\n'
      //   // // '╟ Body: ${request.bodyBytes.map((event) => event.asMap().toString()) ?? ''}\n'
      //   '╟ Status Code: ${response.statusCode}\n'
      //   '╟ Data: ${response.bodyString?.toString() ?? ''}'
      //   '\n╚══════════════════════════ Response ══════════════════════════\n',
      //   wrapWidth: 1024,
      // );

      httpClient.timeout = const Duration(minutes: 1);

      return response;
    });
    super.onInit();
  }

  StatusRequestModel<T> handleError<T>(dynamic e) {
    if (e is StatusRequestModel<T>) {
      return e;
    } else {
      return StatusRequestModel.error(FailureModel(400, "$e", "$e"));
    }
  }

  Future<StatusRequestModel<List<RegionModel>>> getRegion() async {
    final response = await get("/api/get-city");
    final model = toDefaultLaporgubModel(response.body);
    if (response.isOk) {
      List<RegionModel> list = List<RegionModel>.from((model.dataLaporgub).map((u) => RegionModel.fromJson(u)));
      list.add(RegionModel(id: "33", name: "PROVINSI JAWA TENGAH"));
      list.sort((a, b) => (int.parse(a.id ?? "0")).compareTo(int.parse(b.id ?? "0")));
      return StatusRequestModel.success(list);
    } else {
      throw StatusRequestModel.error(failure(response.statusCode, model));
    }
  }
}
