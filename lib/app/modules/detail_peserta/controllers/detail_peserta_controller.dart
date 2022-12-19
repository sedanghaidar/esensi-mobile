import 'package:absensi_kegiatan/app/data/model/PesertaModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequestModel.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiHelper.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailPesertaController extends GetxController {
  ApiProvider repository = Get.find();
  final GlobalKey qrKey = GlobalKey();

  final peserta = StatusRequestModel<PesertaModel>().obs;

  getPesertaById(String? id) {
    peserta.value = StatusRequestModel.loading();
    repository.getDetailPeserta(id).then((value) {
      peserta.value = value;
    }, onError: (e) {
      debugPrint("${e}");
      peserta.value = StatusRequestModel.error(failure2(e));
    });
  }
}
