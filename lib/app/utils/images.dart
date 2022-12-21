import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
