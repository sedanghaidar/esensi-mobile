import 'dart:convert';
import 'dart:html';

import 'package:absensi_kegiatan/app/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../utils/colors.dart';
import '../button/CButton.dart';
import '../sized_box/CSizedBox.dart';
import '../text/CText.dart';

CQrCode(BuildContext context, String code, String title, String name) async {
  final GlobalKey qrKey = GlobalKey();

  Get.dialog(Center(
      child: Container(
    padding: EdgeInsets.all(10),
    constraints: BoxConstraints(maxHeight: context.height),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      color: basicWhite,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Image.memory(data!.buffer.asUint8List()),
        RepaintBoundary(
          key: qrKey,
          child: Container(
            color: basicWhite,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Image.asset(
                  imgJateng,
                  width: 50,
                  height: 50,
                ),
                CText(
                  title,
                  style: CText.textStyleSubhead,
                ),
                CSizedBox.h10(),
                PrettyQr(
                  data: code,
                  size: 400,
                  errorCorrectLevel: QrErrorCorrectLevel.M,
                  roundEdges: true,
                  // typeNumber: 100,
                ),
                CSizedBox.h10(),
                CText(
                  name,
                ),
              ],
            ),
          ),
        ),
        CSizedBox.h10(),
        CButton.small(() {
          getWidgetToImage(qrKey).then((value) {
            if (value != null) {
              debugPrint("ADA DATANYA");

              final content = base64Encode(value);
              AnchorElement(
                  href:
                      "data:application/octet-stream;charset=utf-16le;base64,$content")
                ..setAttribute("download", "file.png")
                ..click();
            } else {
              debugPrint("NULL BRO");
            }
          });
        }, "SIMPAN")
      ],
    ),
  )));
}
