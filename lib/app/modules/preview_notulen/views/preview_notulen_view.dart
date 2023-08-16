import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/error.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/responsive_layout.dart';
import 'package:absensi_kegiatan/app/utils/download_and_pdf.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_view/widget/button/MagicButton.dart';
import 'package:magic_view/widget/text/MagicText.dart';
import 'package:printing/printing.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';
import '../controllers/preview_notulen_controller.dart';

class PreviewNotulenView extends GetView<PreviewNotulenController> {
  const PreviewNotulenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: basicPrimary,
        title: MagicText.head(
          "Detail Agenda",
          color: basicWhite,
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.home,
            color: basicWhite,
          ),
        ),
      ),
      backgroundColor: basicPrimary,
      body: ResponsiveLayout(Container(
        child: Column(
          children: [
            Obx(() {
              return Visibility(
                  visible: controller.notulen.value.statusRequest ==
                      StatusRequest.SUCCESS,
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: options()),
                      Expanded(
                        flex: 1,
                        child: MagicButton(
                          () {
                            Get.toNamed(Routes.FORM_NOTULEN, parameters: {
                              "activity_id": "${controller.id}"
                            });
                          },
                          text: "Edit Notulen",
                          textColor: basicWhite,
                        ),
                      )
                    ],
                  ));
            }),
            SizedBox(
              height: 16,
            ),
            Obx(() {
              switch (controller.notulen.value.statusRequest) {
                case StatusRequest.LOADING:
                  return loading(Get.context!);
                case StatusRequest.SUCCESS:
                  if (controller.pdf != null) {
                    return Expanded(
                        flex: 1,
                        child: PdfPreview(
                            useActions: false,
                            build: (format) => controller.pdf!));
                  } else {
                    return Container();
                  }
                case StatusRequest.ERROR:
                  return error(
                      Get.context!,
                      "${controller.notulen.value.failure?.msgShow}",
                      () => controller.getNotulen());
                default:
                  return Container(
                    width: ResponsiveLayout.getWidthForDialog(Get.context!),
                    height: ResponsiveLayout.getWidthForDialog(Get.context!),
                    color: basicWhite,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MagicText("Buat Notulen Terlebih Dahulu"),
                        MagicButton(
                          () {
                            Get.toNamed(Routes.FORM_NOTULEN, parameters: {
                              "activity_id": "${controller.id}"
                            });
                          },
                          text: "Buat Notulen",
                          textColor: basicWhite,
                        )
                      ],
                    ),
                  );
              }
            })
          ],
        ),
      )),
    );
  }

  Widget options() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            if (controller.pdf != null) {
              downloadPdf(
                  "NOTULEN_${controller.notulen.value.data?.kegiatan?.name}",
                  controller.pdf!);
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
          onTap: () {
            if (controller.pdf != null) {
              sharePdf(
                  "NOTULEN_${controller.notulen.value.data?.kegiatan?.name}",
                  controller.pdf!);
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
          onTap: () {
            printPdf(controller.pdf!);
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
    );
  }
}
