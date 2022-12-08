import 'package:absensi_kegiatan/app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Center loading() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

showLoading() {
  if (Get.isDialogOpen == true) {
    Get.back();
  } else {
    Get.defaultDialog(
        content: CircularProgressIndicator(color: basicPrimary,),
        barrierDismissible: false,
        title: "Loading...");
  }
}

hideLoading() {
  if (Get.isDialogOpen == true) {
    Get.back();
  }
}
