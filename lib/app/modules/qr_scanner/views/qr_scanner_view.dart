import 'package:absensi_kegiatan/app/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:magic_view/widget/button/MagicButton.dart';
import 'package:magic_view/widget/text/MagicText.dart';
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
      body: Column(
        children: [
          Expanded(
            flex: 0,
            child: Row(
              children: [
                MagicButton(
                  () {
                    controller.qrController?.flipCamera();
                  },
                  text: "Putar Kamera",
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      MagicText("Hidupkan Text To Speech"),
                      Obx(() {
                        return Switch(
                          value: controller.tts.value,
                          onChanged: (value) {
                            controller.tts.value = value;
                            if(value){
                              controller.settingTTS();
                            }
                          },
                        );
                      })
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Obx(
              () {
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
