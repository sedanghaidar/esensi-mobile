import 'dart:typed_data';

import 'package:absensi_kegiatan/app/data/model/PesertaModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequestModel.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiHelper.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:absensi_kegiatan/app/utils/download_and_pdf.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/text/CText.dart';
import '../../../utils/colors.dart';

class DetailPesertaController extends GetxController {
  ApiProvider repository = Get.find();

  String? id = null;
  final peserta = StatusRequestModel<PesertaModel>().obs;

  Uint8List? pdf;
  String filename = "";

  getPesertaById() {
    peserta.value = StatusRequestModel.loading();
    repository.getDetailPeserta(id).then((value) async {
      filename = "${value.data?.name}_${value.data?.kegiatan?.name}";
      pdf = await createPdfTicket(value.data);
      peserta.value = value;
      Get.defaultDialog(
          title: "PERHATIAN",
          titleStyle: CText.textStyleBodyBold
              .copyWith(fontSize: 20, color: basicPrimary),
          middleTextStyle: CText.textStyleBody.copyWith(fontSize: 18),
          middleText:
              "Simpan QRCode ini.\nTunjukan saat akan masuk ke tempat kegiatan.\nTerimakasih.",
          buttonColor: basicPrimary,
          confirmTextColor: basicWhite,
          textConfirm: "SIAP",
          onConfirm: () {
            Get.back();
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
