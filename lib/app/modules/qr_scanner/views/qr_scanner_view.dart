import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../controllers/qr_scanner_controller.dart';

class QrScannerView extends GetView<QrScannerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Tamu Undangan'),
        centerTitle: true,
      ),
      body: GetBuilder<QrScannerController>(
        builder: (_) => Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: QRView(
                key: controller.qrKey,
                onQRViewCreated: controller.onQRViewCreated,
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: (controller.result != null)
                    ? Text(
                        '${controller.peserta.value.data?.name} - ${controller.peserta.value.data?.instansi}')
                    : Text('Scan a code'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
