import 'dart:convert';
import 'dart:typed_data';

import 'package:absensi_kegiatan/app/data/model/PesertaModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequestModel.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiHelper.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/Html.dart' if (dart.library.html) 'dart:html';
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
          middleText:
              "Mohon simpan QRCode ini dan tunjukan saat akan masuk ke tempat kegiatan. Terimakasih.",
          buttonColor: basicPrimary,
          confirmTextColor: basicWhite,
          textConfirm: "SIAP",
          onConfirm: () {
            Get.back();
            getWidgetToImage(qrKey).then((value) {
              if (value != null) {
                final content = base64Encode(value);
                AnchorElement(
                    href:
                        "data:application/octet-stream;charset=utf-16le;base64,$content")
                  ..setAttribute("download",
                      "${peserta.value.data?.kegiatan?.name}_${peserta.value.data?.name}.png")
                  ..click();
              }
            });
          },
          barrierDismissible: false);
    }, onError: (e) {
      debugPrint("${e}");
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
