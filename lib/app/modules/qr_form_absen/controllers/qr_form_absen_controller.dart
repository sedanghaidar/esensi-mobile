import 'package:absensi_kegiatan/app/utils/download_and_pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../data/model/KegiatanModel.dart';
import '../../../data/model/repository/StatusRequestModel.dart';
import '../../../data/repository/ApiProvider.dart';

class QrFormAbsenController extends GetxController {
  ApiProvider repository = Get.find();
  String? id = "";
  String url = "";

  TextEditingController controllerShortUrl = TextEditingController();
  RxString shortUrl = "".obs;

  final kegiatan = StatusRequestModel<KegiatanModel>().obs;

  Uint8List? pdf;
  String filename = "";

  @override
  void onInit() {
    id = Get.parameters["id"];
    super.onInit();
  }

  getDetailKegiatan() {
    kegiatan.value = StatusRequestModel.loading();
    repository.getKegiatanById(id).then((value) async {
      url = "${Uri.base.origin}/#/form/${value.data?.codeUrl}";
      filename = "QRCode_${value.data?.name}";
      kegiatan.value = value;
    }, onError: (e) {
      final err = repository.handleError<KegiatanModel>(e);
      kegiatan.value = err;
    });
  }

  @override
  void onReady() {
    getDetailKegiatan();
    super.onReady();
  }
}
