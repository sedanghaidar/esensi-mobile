import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../button/CButton.dart';
import '../button/CButtonStyle.dart';
import '../text/CText.dart';

showCDialogMessageError(BuildContext context, String message, Function() reload,
    {bool isDismissible = true}) {
  Get.dialog(cardDialog(CDialogMessage.errorMessage(context, message, reload)),
      barrierDismissible: isDismissible);
}

showCDialogMessageWarning(BuildContext context, String message,
    {bool isDismissible = true}) {
  Get.dialog(cardDialog(CDialogMessage.warningMessage(context, message)),
      barrierDismissible: isDismissible);
}

showCDialogMessageSuccess(BuildContext context, String title, String message,
    {bool isDismissible = true,
    Function()? onConfirm,
    Function()? onCancel,
    String? textConfirm,
    String? textCancel,
    String? urlImage}) {
  Get.dialog(
      cardDialog(CDialogMessage.successMessage(
        context,
        title,
        message,
        onConfirm: onConfirm,
        onCancel: onCancel,
        textConfirm: textConfirm,
        textCancel: textCancel,
        image: urlImage,
      )),
      barrierDismissible: isDismissible);
}

Widget cardDialog(Widget child) {
  return Center(
    child: SingleChildScrollView(
      child: Wrap(
        children: [
          Container(
            width: Get.context!.width > 800
                ? (Get.context?.width ?? 0) / 3
                : double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
              child: child,
            ),
          ),
        ],
      ),
    ),
  );
}

class CDialogMessage extends StatelessWidget {
  String type = "DEFAULT";

  final context;
  String? title;
  String? message;
  String? textConfirm;
  String? textCancel;
  Function()? onReload;
  Function()? onConfirm;
  Function()? onCancel;
  final String? image;
  final bool? useImage;
  final double? widthImage;
  final double? heightImage;

  CDialogMessage.errorMessage(
    this.context,
    this.message,
    this.onReload, {
    super.key,
    this.image,
    this.useImage = true,
    this.widthImage,
    this.heightImage,
  }) {
    type = "ERRORMESSAGE";
  }

  CDialogMessage.warningMessage(
    this.context,
    this.message, {
    super.key,
    this.image,
    this.useImage = true,
    this.widthImage,
    this.heightImage,
  }) {
    type = "WARNINGMESSAGE";
  }

  CDialogMessage.successMessage(
    this.context,
    this.title,
    this.message, {
    super.key,
    this.image,
    this.onConfirm,
    this.textConfirm,
    this.onCancel,
    this.textCancel,
    this.useImage = true,
    this.widthImage,
    this.heightImage,
  }) {
    type = "SUCCESSMESSAGE";
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case "ERRORMESSAGE":
        return componentError();
      case "WARNINGMESSAGE":
        return componentWarning();
      case "SUCCESSMESSAGE":
        return componentSuccess();
      default:
        return Container();
    }
  }

  Widget material(Widget child) {
    return Material(
      color: Colors.transparent,
      child: child,
    );
  }

  ///Mengatur tampilan / komponen error pada Widget error atau dialog error
  Widget componentError() {
    return Center(
      child: Container(
        padding: EdgeInsets.only(bottom: 24, left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Visibility(
            //   child: Image.asset(
            //     image ?? "assets/images/img_warning.png",
            //     width: 200,
            //     height: 200,
            //   ),
            // ),
            const SizedBox(
              height: 16,
            ),
            CText(
              message ?? "Terjadi Kesalahan",
              textAlign: TextAlign.center,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 16,
            ),
            CButton.small(
              onReload,
              "Ulangi",
              style: styleButtonFilledBoxSmall,
            )
          ],
        ),
      ),
    );
  }

  ///Mengatur tampilan / komponen warning pada Widget warning atau dialog warning
  Widget componentWarning() {
    return Center(
      child: Container(
        padding: EdgeInsets.only(bottom: 24, left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Visibility(
            //   child: Image.asset(
            //     image ?? "assets/images/img_warning.png",
            //     width: 200,
            //     height: 200,
            //   ),
            // ),
            const SizedBox(
              height: 5,
            ),
            CText(
              message ?? "Terjadi Kesalahan",
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  ///Mengatur tampilan / komponen warning pada Widget warning atau dialog warning
  Widget componentSuccess() {
    return Center(
      child: Container(
        padding: EdgeInsets.only(bottom: 24, left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              image ??
                  "https://cdn-icons-png.flaticon.com/512/3032/3032885.png",
              width: 200,
              height: 200,
            ),
            SizedBox(
              height: 5,
            ),
            CText(
              title ?? "Berhasil",
              maxLines: 5,
              textAlign: TextAlign.center,
              style: CText.textStyleBody.copyWith(fontWeight: FontWeight.bold),
            ),
            CText(
              message ?? "Sukses",
              maxLines: 5,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Row(
                children: [
                  onCancel == null
                      ? SizedBox()
                      : Expanded(
                          flex: 1,
                          child: CButton(
                            onCancel,
                            textCancel ?? "Batal",
                            // textColor: basicPrimary,
                            style: styleButtonOutline,
                          ),
                        ),
                  SizedBox(
                    width: onConfirm != null && onCancel != null ? 10 : 0,
                  ),
                  onConfirm == null
                      ? SizedBox()
                      : Expanded(
                          flex: 1,
                          child: CButton(
                            onConfirm,
                            textConfirm ?? "Oke",
                            style: styleButtonFilled,
                          ),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
