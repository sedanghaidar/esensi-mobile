import 'dart:typed_data';

import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:absensi_kegiatan/app/utils/download_and_pdf.dart';
import 'package:get/get.dart';

import '../../../data/model/NotulenModel.dart';
import '../../../data/model/repository/StatusRequestModel.dart';

class PreviewNotulenController extends GetxController {
  ApiProvider repository = Get.find();

  String? id;

  final notulen = StatusRequestModel<NotulenModel>().obs;
  Uint8List? pdf;

  getNotulen() {
    notulen.value = StatusRequestModel.loading();
    repository.getNotulen(id ?? "").then((value) async {
      pdf = await createPdfNotulen(value.data);
      notulen.value = value;
    }, onError: (e) {
      final err = repository.handleError<NotulenModel>(e);
      notulen.value = err;
    });
  }

  @override
  void onInit() {
    id = Get.parameters["id"];
    getNotulen();
    super.onInit();
  }
}
