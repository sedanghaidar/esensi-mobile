import 'package:absensi_kegiatan/app/data/model/PesertaModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/error.dart';
import 'package:absensi_kegiatan/app/global_widgets/sized_box/CSizedBox.dart';
import 'package:absensi_kegiatan/app/utils/date.dart';
import 'package:absensi_kegiatan/app/utils/images.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/Html.dart' if (dart.library.html) 'dart:html';
import '../../../global_widgets/button/CButton.dart';
import '../../../global_widgets/text/CText.dart';
// import 'dart:ui' as ui;
import '../../../global_widgets/ui.dart' if (dart.library.html) 'dart:ui' as ui;
import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';
import '../../../utils/utils.dart';
import '../controllers/detail_agenda_controller.dart';

class DetailAgendaView extends GetView<DetailAgendaController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: basicPrimary,
        title: Text('Detail Agenda'),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.offAllNamed(Routes.DASHBOARD);
          },
          child: Icon(
            Icons.home,
            color: basicWhite,
          ),
        ),
      ),
      backgroundColor: basicGrey4,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: getWidthDefault(context),
            height: context.height,
            padding: EdgeInsets.all(10),
            color: basicWhite,
            child: Container(
              child: Obx(() {
                switch (controller.peserta.value.statusRequest) {
                  case StatusRequest.LOADING:
                    return loading(context);
                  case StatusRequest.SUCCESS:
                    return ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        List<PesertaModel> peserta =
                            controller.peserta.value.data ?? [];

                        ui.platformViewRegistry.registerViewFactory(
                            "images/$index",
                            (int viewId) => ImageElement(
                                src:
                                    "${ApiProvider.BASE_URL}/storage/signature/${peserta[index].signature}")
                            // ..style.width = '100%'
                            // ..style.height = '100%'
                            // ..src =
                            //     "${ApiProvider.BASE_URL}/storage/signature/${peserta[index].signature}",
                            );

                        return Card(
                          color: basicPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11.0),
                          ),
                          child: Container(
                            padding: EdgeInsets.only(right: 10),
                            margin: EdgeInsets.only(left: 10),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: basicWhite),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CText(
                                            dateToString(
                                                peserta[index].createdAt),
                                            style: CText.textStyleHint,
                                          ),
                                          Divider(),
                                          CText(peserta[index].name ?? ""),
                                          CText(
                                            peserta[index].instansi ?? "",
                                            style: CText.textStyleBodyBold,
                                          ),
                                          CText(
                                            peserta[index].jabatan ?? "",
                                            style: CText.textStyleBody
                                                .copyWith(color: basicGrey2),
                                          ),
                                          Divider(),
                                          peserta[index].scannedAt == null
                                              ? CText(
                                                  "Belum discan",
                                                  style: CText.textStyleHint
                                                      .copyWith(
                                                          fontSize: 12,
                                                          color: basicRed1),
                                                )
                                              : CText(
                                                  "Discan pada ${dateToString(peserta[index].scannedAt ?? null)}",
                                                  style: CText.textStyleHint
                                                      .copyWith(
                                                          fontSize: 12,
                                                          color: Colors.green),
                                                )
                                        ],
                                      ),
                                    )),
                                Expanded(
                                    flex: 0,
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.dialog(
                                                Center(
                                                  child: Container(
                                                    color: basicWhite,
                                                    width: getWidthDefault(
                                                            context) /
                                                        2,
                                                    height: getWidthDefault(
                                                            context) /
                                                        2,
                                                    margin: EdgeInsets.all(10),
                                                    child: kIsWeb
                                                        ? HtmlElementView(
                                                            viewType:
                                                                'images/$index',
                                                          )
                                                        : Image.network(
                                                            "${ApiProvider.BASE_URL}/storage/signature/${peserta[index].signature}"),
                                                  ),
                                                ),
                                                barrierDismissible: true);
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Container(
                                                color: basicPrimary,
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Image.asset(
                                                    icSignature,
                                                    width: 20,
                                                    height: 20,
                                                    color: basicWhite,
                                                  ),
                                                )),
                                          ),
                                        ),
                                        CSizedBox.h10(),
                                        InkWell(
                                          onTap: () {
                                            Get.toNamed(
                                                "${Routes.DETAIL_PESERTA}/${peserta[index].id}");
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Container(
                                                color: basicPrimary2,
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Image.asset(
                                                    icQrcode,
                                                    width: 20,
                                                    height: 20,
                                                    color: basicWhite,
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: controller.peserta.value.data?.length ?? 0,
                    );
                  case StatusRequest.EMPTY:
                    return warning(context, "Belum ada peserta");
                  case StatusRequest.ERROR:
                    return error(
                        context,
                        "Terjadi Kesalahan. ${controller.kegiatan.value.failure?.msgShow}",
                        () => controller.getDetailKegiatan());
                  default:
                    {
                      return SizedBox();
                    }
                }
              }),
            ),
          ),
        ),
      ),
      floatingActionButton: Obx(() {
        bool visibility = false;
        if (controller.kegiatan.value.statusRequest == StatusRequest.SUCCESS) {
          visibility = true;
        }
        return Visibility(
          visible: visibility,
          child: CButton.small(() {
            openDialogDetail(context);
          }, "Detail Formulir"),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  openDialogDetail(BuildContext context) {
    Get.dialog(Center(
      child: Container(
        width: getWidthDefault(context),
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.all(10),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: basicWhite),
        child: Material(
          color: basicWhite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CText(
                controller.kegiatan.value.data?.name ?? "Tidak Ada Judul",
                style: CText.textStyleSubhead,
              ),
              CSizedBox.h10(),
              rowDetail(icDate, "Tanggal dan Waktu Pelaksanaan",
                  "${dateToString(controller.kegiatan.value.data?.date)} ${controller.kegiatan.value.data?.time}"),
              CSizedBox.h10(),
              rowDetail(icPlace, "Lokasi",
                  "${controller.kegiatan.value.data?.location}"),
              CSizedBox.h10(),
              rowDetail(
                  icDateClose,
                  "Tanggal dan Waktu Formulir Ditutup",
                  controller.kegiatan.value.data?.dateEnd == null
                      ? "-"
                      : dateToString(controller.kegiatan.value.data?.dateEnd,
                          format: "EEEE, dd MMMM yyyy hh:mm:ss")),
              CSizedBox.h10(),
              rowDetail(
                  icType,
                  "Jenis Formulir",
                  controller.kegiatan.value.data?.type == 1
                      ? "Absensi"
                      : "Pendaftaran"),
              CSizedBox.h10(),
              rowDetail(
                  icUserLimit,
                  "Pembatasan Peserta?",
                  controller.kegiatan.value.data?.isLimitParticipant == true
                      ? "Ya"
                      : "Tidak"),
            ],
          ),
        ),
      ),
    ));
  }

  Widget rowDetail(String icon, String title, String value) {
    return Row(
      children: [
        Expanded(
            flex: 0,
            child: Image.asset(
              icon,
              width: 24,
              height: 24,
            )),
        CSizedBox.w10(),
        Expanded(
            flex: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CText(
                  title,
                  style: CText.textStyleBody.copyWith(color: basicGrey2),
                ),
                CText(value)
              ],
            )),
      ],
    );
  }
}
