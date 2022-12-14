import 'package:absensi_kegiatan/app/data/model/KegiatanModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequestModel.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiHelper.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/error.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  ApiProvider repository = Get.find();

  final kegiatan = StatusRequestModel<List<KegiatanModel>>().obs;

  getKegiatan() {
    debugPrint("GET KEGIATAN");
    kegiatan.value = StatusRequestModel.loading();
    repository.getKegiatan().then((value) {
      if (value.statusRequest == StatusRequest.SUCCESS) {
        if (value.data == null || value.data?.isEmpty == true) {
          kegiatan.value = StatusRequestModel.empty();
          return;
        }
      }
      kegiatan.value = value;
    }, onError: (e) {
      kegiatan.value = StatusRequestModel.error(failure2(e));
    });
  }

  deleteKegiatan(String? id) {
    showLoading();
    repository.deleteKegiatan(id).then((value) {
      if (value.statusRequest == StatusRequest.SUCCESS) {
        Get.defaultDialog(
            title: "Berhasil",
            middleText: "Data Berhasil dihapus",
            barrierDismissible: false,
            onConfirm: () {
              Get.back();
              getKegiatan();
            });
      } else {
        dialogWarning(Get.context!, "Gagal menghapus kegiatan. ${value.failure?.msgShow}");
      }
    }, onError: (e) {
      dialogWarning(Get.context!, "Gagal menghapus kegiatan. $e");
    });
  }
}
