import 'dart:convert';
import 'dart:typed_data';

import 'package:absensi_kegiatan/app/data/model/PesertaModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequestModel.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiHelper.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:absensi_kegiatan/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/Html.dart' if (dart.library.html) 'dart:html';
import '../../../global_widgets/text/CText.dart';
import '../../../utils/colors.dart';
import '../../../utils/images.dart';

class DetailPesertaController extends GetxController {
  ApiProvider repository = Get.find();
  final GlobalKey qrKey = GlobalKey();

  String? id = null;
  final peserta = StatusRequestModel<PesertaModel>().obs;
  Rx<ByteData?> image = null.obs;

  getPesertaById() {
    peserta.value = StatusRequestModel.loading();
    repository.getDetailPeserta(id).then((value) {
      peserta.value = value;

      Get.defaultDialog(
          title: "PERHATIAN",
          titleStyle: CText.textStyleBodyBold.copyWith(
            fontSize: 20,
            color: basicPrimary
          ),
          middleTextStyle: CText.textStyleBody.copyWith(
            fontSize: 18
          ),
          middleText:
              "Mohon Screenshoot dan Simpan QRCode ini.\nTunjukan saat akan masuk ke tempat kegiatan.\nTerimakasih.",
          buttonColor: basicPrimary,
          confirmTextColor: basicWhite,
          textConfirm: "SIAP",
          onConfirm: () {
            Get.back();
            downloadQrcode(qrKey,
                "${peserta.value.data?.kegiatan?.name}_${peserta.value.data?.name}");
          },
          barrierDismissible: false);
    }, onError: (e) {
      debugPrint("$e");
      peserta.value = StatusRequestModel.error(failure2(e));
    });
  }

  @override
  void onInit() {
    id = Get.parameters["id"];
    getPesertaById();
    super.onInit();
  }
}
