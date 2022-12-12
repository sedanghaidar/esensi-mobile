import 'package:absensi_kegiatan/app/global_widgets/button/CButtonStyle.dart';
import 'package:absensi_kegiatan/app/global_widgets/sized_box/CSizedBox.dart';
import 'package:absensi_kegiatan/app/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../button/CButton.dart';
import '../text/CText.dart';

Widget warning(BuildContext context, String message) {
  return Center(
    child: Column(
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
  );
}

Widget error(BuildContext context, String? message, Function() reload,
    {double? width, double? height}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          imgError,
          width: width ?? 200,
          height: height ?? 200,
        ),
        CSizedBox.h5(),
        CText(message ?? "Terjadi Kesalahan"),
        CSizedBox.h5(),
        CButton.small(
          reload,
          "Ulangi",
          style: styleButtonFilledBoxSmall2,
        )
      ],
    ),
  );
}
