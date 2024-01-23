import 'package:absensi_kegiatan/app/data/model/PesertaModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequestModel.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiHelper.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../global_widgets/other/error.dart';

class QrScannerController extends GetxController {
  ApiProvider repository = Get.find();
  RxBool showCamera = RxBool(false);
  Barcode? result;
  QRViewController? qrController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  final peserta = StatusRequestModel<PesertaModel>().obs;

  onQRViewCreated(QRViewController controller) {
    qrController = controller;
    qrController?.scannedDataStream.listen((scanData) {
      if(!kIsWeb){
        qrController?.pauseCamera();
      }else{
        showCamera.value = false;
      }
      result = scanData;
      debugPrint("result ${scanData.code.toString()}");
      scanQrPeserta(scanData.code.toString());
    });
  }

  scanQrPeserta(String? qrCode) {
    showLoading();

    Map<String, dynamic> data = {
      "qr_code": qrCode,
    };
    repository.scanPeserta(data).then((value) {
      hideLoading();
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
            if(!kIsWeb){
              qrController?.resumeCamera();
            }
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
              if(!kIsWeb){
                qrController?.resumeCamera();
              }
            },
          );
        }
      }
    }, onError: (e) {
      hideLoading();
      var err = repository.handleError(e);
      debugPrint("ERROR ${err.failure?.msgShow}");
      dialogError(
        Get.context!,
        "${err.failure?.msgShow}",
        () {
          Get.back();
          if(!kIsWeb){
            qrController?.resumeCamera();
          }
        },
      );
    });
  }

  @override
  void onInit() {
    if(kIsWeb){
      showCamera.value = false;
    }else{
      showCamera.value = true;
    }
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
