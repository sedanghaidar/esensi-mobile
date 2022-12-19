import 'package:absensi_kegiatan/app/data/model/PesertaModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequestModel.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiHelper.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:absensi_kegiatan/app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScannerController extends GetxController {
  ApiProvider repository = Get.find();
  RxBool isLoading = RxBool(false);
  Barcode? result;
  QRViewController? qrController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  final peserta = StatusRequestModel<PesertaModel>().obs;

  onQRViewCreated(QRViewController controller) {
    qrController = controller;
    update();
    controller.scannedDataStream.listen((scanData) {
      qrController?.pauseCamera();
      result = scanData;
      update();
      scanQrPeserta(scanData.code.toString());
    });
  }

  scanQrPeserta(String? qrCode) {
    isLoading.value = true;

    Map<String, dynamic> data = {
      "qr_code": qrCode,
    };
    peserta.value = StatusRequestModel.loading();
    repository.scanPeserta(data).then((value) {
      isLoading.value = false;
      if (value.statusRequest == StatusRequest.SUCCESS) {
        peserta.value = value;
        Get.defaultDialog(
          title: "Berhasil Scan",
          middleText:
              "Selamat datang, ${peserta.value.data?.name} - ${peserta.value.data?.instansi}",
          barrierDismissible: false,
          confirmTextColor: basicWhite,
          buttonColor: basicPrimary,
          onConfirm: () {
            Get.back();
            qrController?.resumeCamera();
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
              qrController?.resumeCamera();
            },
          );
        }
      }
    }, onError: (e) {
      debugPrint("${e}");
      peserta.value = StatusRequestModel.error(failure2(e));
    });
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    qrController?.dispose();
  }
}
