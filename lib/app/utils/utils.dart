import 'dart:convert';

import 'package:absensi_kegiatan/app/utils/constant.dart';
import 'package:absensi_kegiatan/app/utils/images.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../global_widgets/Html.dart' if (dart.library.html) 'dart:html';

/// Mendeteksi aplikasi dibuka dimana
int getPlatform(BuildContext context) {
  final isMobile = GetPlatform.isMobile;
  final isDesktop = GetPlatform.isDesktop;
  final isWeb = GetPlatform.isWeb;

  ///APLIKASI MOBILE
  if (isMobile && !isDesktop && !isWeb) {
    return MOBILE;
  }

  ///MOBILE TAPI DI WEBSITE
  else if (isMobile && !isDesktop && isWeb) {
    return WEB_PORTRAIT;
  }

  ///APLIKASI DESKTOP
  else if (!isMobile && isDesktop && !isWeb) {
    if (context.width >= context.height) {
      return DESKTOP_LANDSCAPE;
    } else {
      return DESKTOP_PORTRAIT;
    }
  }

  ///DESKTOP TAPI DI WEBSITE
  else if (!isMobile && isDesktop && isWeb) {
    if (context.width >= context.height) {
      return WEB_LANDSCAPE;
    } else {
      return WEB_PORTRAIT;
    }
  } else {
    return WEB_LANDSCAPE;
  }
}

/// Mendpatkan nilai lebar
/// - Jika landscape maka mengembalikan setengah lebar penuh
/// - Jika portrait maka mengembalikan lebar penuh
double getWidthDefault(BuildContext context) {
  double width = context.width;
  final orientation = getPlatform(context);
  if (orientation == WEB_LANDSCAPE || orientation == DESKTOP_LANDSCAPE) {
    width = width / 2;
  } else {
    width = context.width;
  }
  return width;
}

/// Mendapatkan orientasi layar
int getOrientation(BuildContext context) {
  final orientation = getPlatform(context);
  if (orientation == WEB_LANDSCAPE || orientation == DESKTOP_LANDSCAPE) {
    return 1;
  } else {
    return 2;
  }
}

///Melakukan download QRCode dengan [qrkey] adalah konten/qrcode dan [filename] adalah nama file hasil download
downloadQrcode(GlobalKey qrKey, String filename) {
  getWidgetToImage(qrKey).then((value) {
    if (value != null) {
      if (kIsWeb) {
        final content = base64Encode(value);
        AnchorElement(
            href:
                "data:application/octet-stream;charset=utf-16le;base64,$content")
          ..setAttribute("download", "$filename.png")
          ..click();
      } else {
        ///todo DOWNLOAD FOR MOBILE
      }
    }
  });
}


