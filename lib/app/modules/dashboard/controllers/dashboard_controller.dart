import 'package:absensi_kegiatan/app/data/model/KegiatanModel.dart';
import 'package:absensi_kegiatan/app/data/model/UserModel.dart';
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

  TextEditingController controllerSearch = TextEditingController();

  static String typePendaftaran = "Pendaftaran";
  static String typeAbsensi = "Absensi";
  RxString selectedType = typePendaftaran.obs;

  final kegiatan = StatusRequestModel<List<KegiatanModel>>().obs;
  final kegiatanFilter = StatusRequestModel<List<KegiatanModel>>().obs;
  UserModel? user;

  init() {
    user = repository.hive.getUserModel();
    update();
  }

  getKegiatan() {
    kegiatan.value = StatusRequestModel.loading();
    repository.getKegiatan().then((value) {
      if (value.statusRequest == StatusRequest.SUCCESS) {
        if (value.data == null || value.data?.isEmpty == true) {
          kegiatan.value = StatusRequestModel.empty();
          return;
        }
      }
      kegiatan.value = value;
      filterKegiatanByType();
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
        dialogWarning(Get.context!,
            "Gagal menghapus kegiatan. ${value.failure?.msgShow}");
      }
    }, onError: (e) {
      dialogWarning(Get.context!, "Gagal menghapus kegiatan. $e");
    });
  }

  filterKegiatanByType() {
    kegiatanFilter.value = StatusRequestModel.success(
        kegiatan.value.data?.where((element){
          if(selectedType.value==typeAbsensi){
            return element.type == 1 && (element.name??"").toLowerCase().contains(controllerSearch.text);
          }else{
            return element.type == 2 && (element.name??"").toLowerCase().contains(controllerSearch.text);
          }
        }).toList() ??
            []);
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }

  @override
  void onReady() {
    getKegiatan();
    super.onReady();
  }
}
