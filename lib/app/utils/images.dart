import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:absensi_kegiatan/app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

const imgLogin = "assets/img_login.svg";
const imgWarning = "assets/img_warning.svg";
const imgError = "assets/img_error.svg";
const imgNotFound = "assets/img_not_found.svg";
const imgJateng = "assets/img_jateng.png";
const imgJatengSvg = "assets/logo_jateng.svg";
const icDate = "assets/ic_date.png";
const icDateClose = "assets/ic_date_close.png";
const icPlace = "assets/ic_place.png";
const icType = "assets/ic_type_form.png";
const icUserLimit = "assets/ic_user_limit.png";
const icQrcode = "assets/qrcode.png";
const icSignature = "assets/signature.png";
const icOffice = "assets/office.png";
const icParticipant = "assets/participant.png";
const icQrSuccess = "assets/qrscan_success.png";
const icQrError = "assets/qrscan_error.png";

Future<Uint8List?> getWidgetToImage(GlobalKey key) async {
  try {
    RenderRepaintBoundary boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    var pngBytes = byteData?.buffer.asUint8List();
    debugPrint("SUCCESS");
    return pngBytes;
  } catch (exception) {
    debugPrint("$exception");
    return null;
  }
}

FutureBuilder<ui.Image> generateQr() {
  return FutureBuilder(
      future: _loadOverlayImage(),
      builder: (ctx, snapshot) {
        const size = 280.0;
        if (!snapshot.hasData) {
          return Container(
            width: size,
            height: size,
            color: basicRed1,
          );
        }
        return CustomPaint(
          size: Size.square(size),
          painter: QrPainter(
            data: "Contoh Data",
            version: QrVersions.auto,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Color(0xff128760),
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.circle,
              color: Color(0xff1a5441),
            ),
            // size: 320.0,
            embeddedImage: snapshot.data,
            embeddedImageStyle: QrEmbeddedImageStyle(
              size: Size.square(60),
            ),
          ),
        );
      });
}

Future<ui.Image> _loadOverlayImage() async {
  final completer = Completer<ui.Image>();
  final byteData = await rootBundle.load(imgJateng);
  ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);
  return completer.future;
}

Future<Uint8List?> loadImage() async {
  try{
    final embeddedImage = await _loadOverlayImage();
    final qrcode = await QrPainter(
      data: "Contoh Data",
      version: QrVersions.auto,
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: Color(0xff128760),
      ),
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.circle,
        color: Color(0xff1a5441),
      ),
      // size: 320.0,
      embeddedImage: embeddedImage,
      embeddedImageStyle: QrEmbeddedImageStyle(
        size: Size.square(60),
      ),
    ).toImageData(200);
    return qrcode?.buffer.asUint8List();
    return null;
  }on Exception catch(e){
    return null;
  }
}
