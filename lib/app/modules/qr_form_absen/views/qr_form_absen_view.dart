import 'package:absensi_kegiatan/app/global_widgets/other/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:magic_view/widget/text/MagicText.dart';
import 'package:magic_view/widget/textfield/MagicTextField.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../data/model/repository/StatusRequest.dart';
import '../../../global_widgets/other/toast.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';
import '../../../utils/download_and_pdf.dart';
import '../controllers/qr_form_absen_controller.dart';

class QrFormAbsenView extends GetView<QrFormAbsenController> {
  const QrFormAbsenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: basicPrimary,
        title: MagicText.head(
          "QR Formulir Agenda",
          color: basicWhite,
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.offAllNamed(Routes.DASHBOARD);
          },
          child: const Icon(
            Icons.home,
            color: basicWhite,
          ),
        ),
      ),
      backgroundColor: basicPrimary,
      body: ResponsiveLayout(Container(
        padding: EdgeInsets.all(16),
        color: basicWhite,
        child: Column(
          children: [
            Obx(() => Visibility(
                  visible: controller.kegiatan.value.statusRequest ==
                      StatusRequest.SUCCESS,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: basicPrimaryLight,
                        )),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                              onTap: () {
                                launchUrlString(controller.url);
                              },
                              child: MagicText(
                                controller.url,
                                textOverflow: TextOverflow.ellipsis,
                              )),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        InkWell(
                          onTap: () async {
                            await Clipboard.setData(
                                    ClipboardData(text: controller.url))
                                .whenComplete(() {
                              showToast("Berhasil menyalin kode");
                            });
                          },
                          child: Icon(Icons.copy),
                        )
                      ],
                    ),
                  ),
                )),
            SizedBox(
              height: 8,
            ),
            MagicTextField.border(
              controller.controllerShortUrl,
              hint: "Masukkan short url (jika ada)",
              onChange: (value) {
                controller.shortUrl.value = value;
              },
            ),
            Divider(
              height: 20,
            ),
            options(),
            SizedBox(
              height: 16,
            ),
            Obx(() => Visibility(
                  visible: controller.kegiatan.value.statusRequest ==
                      StatusRequest.SUCCESS,
                  child: MagicText.head(
                    controller.kegiatan.value.data?.name ?? "",
                    color: basicPrimary,
                  ),
                )),
            Obx(() => Expanded(
                  flex: 1,
                  child: Visibility(
                    visible: controller.kegiatan.value.statusRequest ==
                        StatusRequest.SUCCESS,
                    child: Center(child: QrImageView(data: controller.url)),
                  ),
                )),
            Obx(() => Visibility(
                  visible: controller.kegiatan.value.statusRequest ==
                      StatusRequest.SUCCESS,
                  child: MagicText.subhead(
                    controller.shortUrl.value,
                    color: basicPrimary,
                  ),
                )),
          ],
        ),
      )),
    );
  }

  Widget options() {
    return Obx(() {
      return Visibility(
          visible:
              controller.kegiatan.value.statusRequest == StatusRequest.SUCCESS,
          child: Row(
            children: [
              InkWell(
                onTap: () async {
                  controller.pdf = await createPdfQrAbsen(
                      controller.kegiatan.value.data,
                      controller.controllerShortUrl.text.isBlank == true
                          ? controller.url
                          : controller.controllerShortUrl.text);
                  if (controller.pdf != null) {
                    downloadPdf(controller.filename, controller.pdf!);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: basicRed1,
                      border: Border.all(color: basicWhite, width: 1)),
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.download,
                    color: basicWhite,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              InkWell(
                onTap: () async {
                  controller.pdf = await createPdfQrAbsen(
                      controller.kegiatan.value.data,
                      controller.controllerShortUrl.text.isBlank == true
                          ? controller.url
                          : controller.controllerShortUrl.text);
                  if (controller.pdf != null) {
                    sharePdf(controller.filename, controller.pdf!);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: basicOrange,
                      border: Border.all(color: basicWhite, width: 1)),
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.share,
                    color: basicWhite,
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              InkWell(
                onTap: () async {
                  controller.pdf = await createPdfQrAbsen(
                      controller.kegiatan.value.data,
                      controller.controllerShortUrl.text.isBlank == true
                          ? controller.url
                          : controller.controllerShortUrl.text);
                  if (controller.pdf != null) {
                    printPdf(controller.pdf!);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: basicGreen,
                      border: Border.all(color: basicWhite, width: 1)),
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.print,
                    color: basicWhite,
                  ),
                ),
              ),
            ],
          ));
    });
  }
}
