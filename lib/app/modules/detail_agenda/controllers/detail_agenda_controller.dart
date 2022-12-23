import 'package:absensi_kegiatan/app/data/model/KegiatanModel.dart';
import 'package:absensi_kegiatan/app/data/model/PesertaModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequestModel.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiHelper.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/error.dart';
import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailAgendaController extends GetxController {
  ApiProvider repository = Get.find();

  String? id = "0";
  final kegiatan = StatusRequestModel<KegiatanModel>().obs;
  final peserta = StatusRequestModel<List<PesertaModel>>().obs;
  RxList<PesertaModel> pesertaFilter = <PesertaModel>[].obs;

  final controllerSearch = TextEditingController();
  RxString filter = "".obs;
  RxInt totalInstansi = 0.obs;
  RxInt totalScanned = 0.obs;
  RxInt totalUnScanned = 0.obs;

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
        totalUnScanned.value = 0;
        totalScanned.value = 0;
        totalInstansi.value = 0;
      } else {
        peserta.value = value;
        totalUnScanned.value = (peserta.value.data ?? [])
            .where((element) => element.scannedAt == null)
            .length;
        totalScanned.value = (peserta.value.data ?? [])
            .where((element) => element.scannedAt != null)
            .length;
        totalInstansi.value = groupBy(
                (peserta.value.data ?? []), <PesertaModel>(obj) => obj.instansi)
            .length;
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
