import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/global_widgets/button/CButton.dart';
import 'package:absensi_kegiatan/app/global_widgets/button/CButtonStyle.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/error.dart';
import 'package:absensi_kegiatan/app/routes/app_pages.dart';
import 'package:absensi_kegiatan/app/utils/date.dart';
import 'package:absensi_kegiatan/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../global_widgets/sized_box/CSizedBox.dart';
import '../../../global_widgets/text/CText.dart';
import '../../../utils/colors.dart';
import '../controllers/detail_peserta_controller.dart';

class DetailPesertaView extends GetView<DetailPesertaController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: basicPrimary,
        title: Text('Tiket Kegiatan'.toUpperCase()),
        centerTitle: true,
      ),
      body: Obx(() {
        switch (controller.peserta.value.statusRequest) {
          case StatusRequest.LOADING:
            return loading(context);
          case StatusRequest.SUCCESS:
            return Center(
                child: Container(
              width: getWidthDefault(context),
              padding: EdgeInsets.all(10),
              constraints: BoxConstraints(maxHeight: context.height),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: repaintBoundaryPortrait(context),
                  ),
                  CSizedBox.h10(),
                  Expanded(
                    flex: 0,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: CButton(
                            () {
                              Get.offAllNamed("${Routes.FORM}/${controller.peserta.value.data?.kegiatan?.codeUrl}");
                            },
                            "Kembali Ke Formulir",
                            style: styleButtonFilled2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
          case StatusRequest.ERROR:
            return error(context, controller.peserta.value.failure?.msgShow,
                () {
              controller.getPesertaById();
            });
          default:
            return SizedBox();
        }
      }),
    );
  }

  Widget repaintBoundaryPortrait(BuildContext context) {
    double width = ((getWidthDefault(context) - 20) / 2) > 250
        ? 300
        : (getWidthDefault(context) - 20) / 2;

    return RepaintBoundary(
      key: controller.qrKey,
      child: Container(
        color: basicWhite,
        padding: EdgeInsets.all(10),
        child: Card(
          elevation: 10,
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CText(
                        "Pemerintah Provinsi Jawa Tengah",
                        style: CText.textStyleSubhead,
                        textAlign: TextAlign.center,
                      ),
                      Divider(),
                      CSizedBox.h10(),
                      CText(
                        controller.peserta.value.data?.kegiatan?.name ?? "",
                        textAlign: TextAlign.center,
                        style: CText.textStyleBodyBold,
                      ),
                      CSizedBox.h10(),
                      CText(
                        "Tanggal",
                        style: CText.textStyleBodyBold
                            .copyWith(color: basicPrimary),
                      ),
                      CText(dateToString(
                          controller.peserta.value.data?.kegiatan?.date)),
                      CSizedBox.h10(),
                      CText(
                        "Waktu",
                        style: CText.textStyleBodyBold
                            .copyWith(color: basicPrimary),
                      ),
                      CText(
                          "${controller.peserta.value.data?.kegiatan?.time} WIB"),
                      CSizedBox.h10(),
                      CText(
                        "Tempat",
                        style: CText.textStyleBodyBold
                            .copyWith(color: basicPrimary),
                      ),
                      CText(
                          "${controller.peserta.value.data?.kegiatan?.location}"),
                    ],
                  ),
                ),
                CSizedBox.h20(),
                Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: controller.peserta.value.data?.qrCode == null
                              ? SizedBox()
                              : Align(
                                alignment: Alignment.center,
                                child: QrImage(
                                    data: controller.peserta.value.data?.qrCode ??
                                        "",
                                    // size: width,
                                  ),
                              ),
                        ),
                        Expanded(
                          flex: 0,
                          child: Container(
                            decoration: BoxDecoration(
                                color: basicPrimary,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CText(
                                  (controller.peserta.value.data?.name ?? "")
                                      .toUpperCase(),
                                  style: CText.textStyleBodyBold
                                      .copyWith(color: basicWhite),
                                ),
                                CSizedBox.h5(),
                                CText(
                                  controller.peserta.value.data?.instansi ?? "",
                                  textAlign: TextAlign.center,
                                  style: CText.textStyleBody
                                      .copyWith(color: basicGrey3),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
