import 'dart:convert';

import 'package:absensi_kegiatan/app/utils/colors.dart';
import 'package:absensi_kegiatan/app/utils/constant.dart';
import 'package:absensi_kegiatan/app/utils/images.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_view/factory.dart';
import 'package:magic_view/style/MagicTextStyle.dart';
import 'package:magic_view/widget/button/MagicButton.dart';
import 'package:magic_view/widget/text/MagicText.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../data/model/KegiatanModel.dart';
import '../data/repository/ApiProvider.dart';
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

List<TextSpan> extractText(String rawString) {
  List<TextSpan> textSpan = [];

  final urlRegExp = new RegExp(
      r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");

  getLink(String linkString) {
    textSpan.add(
      TextSpan(
        text: linkString,
        style: MagicFactory.magicTextStyle
            .copyWith(
              color: basicBlack,
              fontWeight: FontWeight.bold,
            )
            .toGoogleTextStyle(),
        recognizer: new TapGestureRecognizer()
          ..onTap = () {
            launchUrlString(linkString);
            debugPrint(linkString);
          },
      ),
    );
    return linkString;
  }

  getNormalText(String normalText) {
    textSpan.add(
      TextSpan(
        text: normalText,
        style: MagicFactory.magicTextStyle
            .copyWith(color: basicWhite)
            .toGoogleTextStyle(),
      ),
    );
    return normalText;
  }

  rawString.splitMapJoin(
    urlRegExp,
    onMatch: (m) => getLink("${m.group(0)}"),
    onNonMatch: (n) => getNormalText("${n.substring(0)}"),
  );

  return textSpan;
}

/// Membuka Dialog Download Daftar Hadir, menampilkan pilihan PDF dan Excel
/// [agenda] merupakan detail agenda yang akan didownload
openDialogDownload(KegiatanModel? agenda) {
  Get.dialog(Center(
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: basicWhite, borderRadius: BorderRadius.circular(16)),
      child: Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MagicText.subhead("Download Daftar Hadir"),
            const SizedBox(
              height: 8,
            ),
            MagicButton(
              () {
                Get.back();
                launchUrl(Uri.parse(
                    "${ApiProvider.BASE_URL}/api/peserta/download/excel?kegiatan_id=${agenda?.id}"));
              },
              text: "Download Excel",
              textColor: basicWhite,
              padding: const EdgeInsets.all(16),
            ),
            const SizedBox(
              height: 8,
            ),
            MagicButton(
              () {
                Get.back();
                launchUrl(Uri.parse(
                    "${ApiProvider.BASE_URL}/api/peserta/download/pdf?kegiatan_id=${agenda?.id}"));
              },
              text: "Download PDF",
              textColor: basicWhite,
              padding: const EdgeInsets.all(16),
            ),
          ],
        ),
      ),
    ),
  ));
}
