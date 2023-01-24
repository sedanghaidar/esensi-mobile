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

import '../../../utils/colors.dart';

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

  scanQrPeserta(String? qrCode) {
    showLoading();
    Map<String, dynamic> data = {
      "qr_code": qrCode,
    };
    repository.scanPeserta(data).then((value) {
      hideLoading();
      if (value.statusRequest == StatusRequest.SUCCESS) {
        Get.defaultDialog(
          title: "Berhasil Scan",
          middleText: "Selamat datang, ${value.data?.name} - ${value.data?.instansi}",
          barrierDismissible: false,
          confirmTextColor: basicWhite,
          buttonColor: basicPrimary,
          onConfirm: () {
            Get.back();
            int? index = peserta.value.data?.indexWhere((element) => element.name == value.data?.name);
            if(index!=null){
              peserta.value.data?[index] = value.data!;
              peserta.value = StatusRequestModel.success(peserta.value.data??[]);
            }
          },
        );
      } else {
        if (value.failure?.code == 400) {
          Get.defaultDialog(
            title: "PERHATIAN",
            middleText: "${value.failure?.msgShow}",
            barrierDismissible: false,
            confirmTextColor: basicWhite,
            buttonColor: basicPrimary,
            onConfirm: () {
              Get.back();
            },
          );
        }
      }
    }, onError: (e) {
      hideLoading();
      Get.defaultDialog(
        title: "PERHATIAN",
        middleText: "${e.toString()}",
        barrierDismissible: false,
        confirmTextColor: basicWhite,
        buttonColor: basicPrimary,
        onConfirm: () {
          Get.back();
        },
      );
    });
  }

  deletePeserta(int? id) {
    showLoading();
    repository.deletePeserta(id).then((value) {
      hideLoading();
      if (value.statusRequest == StatusRequest.SUCCESS) {
        Get.defaultDialog(
          title: "Berhasil",
          middleText: "Berhasil menghapus, ${value.data?.name} - ${value.data?.instansi}",
          barrierDismissible: false,
          confirmTextColor: basicWhite,
          buttonColor: basicPrimary,
          onConfirm: () {
            Get.back();
            List<PesertaModel> newData = peserta.value.data ?? [];
            newData.removeWhere((element) => element.id == id);
            peserta.value.data = newData;
            peserta.value = StatusRequestModel.success(peserta.value.data??[]);
          },
        );
      } else {
        if (value.failure?.code == 400) {
          Get.defaultDialog(
            title: "PERHATIAN",
            middleText: "${value.failure?.msgShow}",
            barrierDismissible: false,
            confirmTextColor: basicWhite,
            buttonColor: basicPrimary,
            onConfirm: () {
              Get.back();
            },
          );
        }
      }
    }, onError: (e) {
      hideLoading();
      Get.defaultDialog(
        title: "PERHATIAN",
        middleText: "${e.toString()}",
        barrierDismissible: false,
        confirmTextColor: basicWhite,
        buttonColor: basicPrimary,
        onConfirm: () {
          Get.back();
        },
      );
    });
  }

  @override
  void onReady() {
    getDetailKegiatan();
    super.onReady();
  }
}
