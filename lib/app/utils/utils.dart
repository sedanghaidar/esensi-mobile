import 'package:absensi_kegiatan/app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/***
 * Mendeteksi aplikasi dibuka dimana
 * */
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

int getOrientation(BuildContext context) {
  final orientation = getPlatform(context);
  if (orientation == WEB_LANDSCAPE || orientation == DESKTOP_LANDSCAPE) {
    return 1;
  } else {
    return 2;
  }
}
