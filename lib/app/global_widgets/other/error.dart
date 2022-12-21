import 'package:absensi_kegiatan/app/global_widgets/button/CButtonStyle.dart';
import 'package:absensi_kegiatan/app/global_widgets/sized_box/CSizedBox.dart';
import 'package:absensi_kegiatan/app/utils/colors.dart';
import 'package:absensi_kegiatan/app/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../button/CButton.dart';
import '../text/CText.dart';

Widget warning(BuildContext context, String message, {Color? background}) {
  return Center(
    child: Container(
      padding: EdgeInsets.all(10),
      constraints: BoxConstraints(maxHeight: 250),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: background ?? Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            imgWarning,
            width: 200,
            height: 200,
          ),
          CSizedBox.h5(),
          CText(message)
        ],
      ),
    ),
  );
}

Widget error(BuildContext context, String? message, Function() reload,
    {double? width, double? height, Color? background}) {
  return Center(
    child: Container(
      padding: EdgeInsets.all(10),
      constraints:
          BoxConstraints(maxHeight: height == null ? 300 : height + 350),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: background ?? Colors.transparent,
      ),
      child: Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              imgError,
              width: width ?? 200,
              height: height ?? 200,
            ),
            CSizedBox.h5(),
            CText(message ?? "Terjadi Kesalahan", maxLines: 1,),
            CSizedBox.h5(),
            CButton.small(
              reload,
              "Ulangi",
              style: styleButtonFilledBoxSmall2,
            )
          ],
        ),
      ),
    ),
  );
}

dialogWarning(BuildContext context, String message) {
  Get.dialog(warning(context, message, background: basicWhite),
      barrierDismissible: true);
}

dialogError(BuildContext context, String message, Function() reload) {
  Get.dialog(error(context, message, reload, background: basicWhite),
      barrierDismissible: true);
}
