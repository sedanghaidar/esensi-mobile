import 'package:absensi_kegiatan/app/data/model/KegiatanModel.dart';
import 'package:absensi_kegiatan/app/data/model/PesertaModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequestModel.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiHelper.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/error.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailAgendaController extends GetxController {
  ApiProvider repository = Get.find();

  String? id = "0";
  final kegiatan = StatusRequestModel<KegiatanModel>().obs;
  final peserta = StatusRequestModel<List<PesertaModel>>().obs;

  @override
  void onInit() {
    id = Get.parameters["id"];
    getDaftarPeserta();
    super.onInit();
  }

  getDetailKegiatan() {
    showLoading();
    repository.getKegiatanById(id).then((value) {
      hideLoading();
      if (value.statusRequest == StatusRequest.SUCCESS) {
        kegiatan.value = value;
      } else {
        dialogError(
            Get.context!,
            "Terjadi Kesalahan. ${value.failure?.msgShow}",
            () => getDetailKegiatan());
      }
    }, onError: (e) {
      hideLoading();
      dialogError(
          Get.context!, "Terjadi Kesalahan. $e", () => getDetailKegiatan());
    });
  }

  getDaftarPeserta() {
    peserta.value = StatusRequestModel.loading();
    repository.getPesertaByKegiatan(id).then((value) {
      if (value.data == null || value.data?.isEmpty == true) {
        peserta.value = StatusRequestModel.empty();
      } else {
        peserta.value = value;
      }
    }, onError: (e) {
      debugPrint(e);
      peserta.value = StatusRequestModel.error(failure2(e));
    });
  }

  @override
  void onReady() {
    getDetailKegiatan();
    super.onReady();
  }
}
