import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/InstansiModel.dart';
import '../../../data/model/repository/StatusRequestModel.dart';
import '../../../global_widgets/other/error.dart';
import '../../../global_widgets/other/toast.dart';

class ManageInstansiController extends GetxController {
  ApiProvider repository = Get.find();

  final instansi = StatusRequestModel<List<InstansiModel>>().obs;

  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerShortName = TextEditingController();

  final controllerSearch = TextEditingController();
  RxString filter = "".obs;

  @override
  void onInit() {
    getInstansiAll();
    super.onInit();
  }

  getInstansiAll() {
    repository.getInstansiSemua().then((value) {
      if (value.data?.isEmpty == true) {
        instansi.value = StatusRequestModel.empty();
      } else {
        instansi.value = value;
      }
    }, onError: (e) {
      dialogError(Get.context!, "Terjadi Kesalahan. $e", () {
        Get.back();
        getInstansiAll();
      });
    });
  }

  addNewInstansi() {
    InstansiModel instansi = InstansiModel(
        name: controllerName.text, shortName: controllerShortName.text);
    showLoading();
    repository.postInstansi(instansi).then((value) {
      hideLoading();
      if (value.statusRequest == StatusRequest.SUCCESS) {
        showToast("Berhasil menambah data");
        getInstansiAll();
      } else {
        showToast("${value.failure?.msgShow}");
      }
    }, onError: (e) {
      hideLoading();
      showToast("Gagal menambah instansi. $e");
    });
  }

  deleteInstansi(InstansiModel? instansi){
    showLoading();
    repository.deleteInstansi("${instansi?.id}").then((value){
      hideLoading();
      showToast("Berhasil menghapus instansi");
      getInstansiAll();
    }, onError: (e){
      hideLoading();
      showToast("Gagal manghapus instansi. $e");
    });
  }

  updateInstansi(InstansiModel? instansi){
    showLoading();
    repository.updateInstansi("${instansi?.id}", InstansiModel(
      name: controllerName.text,
      shortName: controllerShortName.text
    )).then((value){
      hideLoading();
      showToast("Berhasil mengubah instansi");
      getInstansiAll();
    }, onError: (e){
      hideLoading();
      showToast("Gagal mengubah instansi. $e");
    });
  }
}
