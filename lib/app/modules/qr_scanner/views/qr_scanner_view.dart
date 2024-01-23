import 'package:absensi_kegiatan/app/utils/colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:magic_view/widget/button/MagicButton.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../controllers/qr_scanner_controller.dart';

class QrScannerView extends GetView<QrScannerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: basicPrimary,
        title: const Text('QR SCANNER'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.showCamera.value == false) {
          return Center(
            child: MagicButton(
              () {
                controller.showCamera.value = true;
              },
              text: "Buka Kamera",
            ),
          );
        } else {
          return Container(
            height: double.infinity,
            width: double.infinity,
            child: QRView(
              key: controller.qrKey,
              onQRViewCreated: controller.onQRViewCreated,
            ),
          );
        }
      }),
    );
  }
}
