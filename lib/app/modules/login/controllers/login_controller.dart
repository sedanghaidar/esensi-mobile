import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/error.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/repository/StatusRequest.dart';
import '../../../data/repository/ApiProvider.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  ApiProvider repository = Get.find();

  login() {
    showLoading();
    repository
        .login(controllerEmail.text, controllerPassword.text)
        .then((value) {
          hideLoading();
          if(value.statusRequest==StatusRequest.SUCCESS){
            debugPrint("BERHASIL LOGIN CUK");
            repository.hive.login(value.data!);
            Get.offNamed(Routes.DASHBOARD);
          }else{
            dialogWarning(Get.context!, "${value.failure?.msgShow}");
          }
    }, onError: (e) {
          hideLoading();
          dialogWarning(Get.context!, "$e");
          debugPrint("GAGAL LOGIN CUK $e");
    });
  }

  @override
  void onInit() {
    bool isLoggedIn = repository.hive.isLoggedIn();
    if(isLoggedIn){
      Get.offAllNamed(Routes.DASHBOARD);
    }
    super.onInit();
  }
}
