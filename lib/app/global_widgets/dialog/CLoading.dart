import 'package:absensi_kegiatan/app/global_widgets/text/CText.dart';
import 'package:absensi_kegiatan/app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget loading(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(color: basicPrimary,),
        CText("Mohon tunggu sebentar ...")
      ],
    ),
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
