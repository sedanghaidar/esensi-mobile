import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/error.dart';
import 'package:absensi_kegiatan/app/global_widgets/sized_box/CSizedBox.dart';
import 'package:absensi_kegiatan/app/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/text/CText.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';
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
      body: SingleChildScrollView(
        child: Container(
          width: context.width,
          height: context.height,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Flexible(
                flex: 0,
                child: Obx(() {
                  switch (controller.kegiatan.value.statusRequest) {
                    case StatusRequest.LOADING:
                      return loading(context);
                    case StatusRequest.SUCCESS:
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 10,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: CText(
                                  controller.kegiatan.value.data?.name ??
                                      "Judul Kegiatan Tidak Diketahui",
                                  style: CText.textStyleSubhead,
                                ),
                              ),
                              const CSizedBox.h10(),
                              const CText(
                                "Tanggal dan Waktu Pelaksanaan",
                                style: CText.textStyleBodyBold,
                              ),
                              const CSizedBox.h5(),
                              CText(
                                  " ${dateToString(controller.kegiatan.value.data?.date)} ${controller.kegiatan.value.data?.time}"),
                              const CSizedBox.h10(),
                              const CText(
                                "Lokasi Pelaksanaan",
                                style: CText.textStyleBodyBold,
                              ),
                              const CSizedBox.h5(),
                              CText(
                                  " ${controller.kegiatan.value.data?.location}"),
                              const CSizedBox.h10(),
                              const CText(
                                "Tanggal dan Waktu Penutupan Formulir",
                                style: CText.textStyleBodyBold,
                              ),
                              const CSizedBox.h5(),
                              CText(
                                  " ${controller.kegiatan.value.data?.dateEnd == null ? "-" : dateToString(controller.kegiatan.value.data?.dateEnd, format: "EEEE, dd MMMM yyyy hh:mm:ss")}"),
                              const CSizedBox.h10(),
                              const CText(
                                "Jenis Formulir",
                                style: CText.textStyleBodyBold,
                              ),
                              const CSizedBox.h5(),
                              CText(
                                  " ${controller.kegiatan.value.data?.type == 1 ? "Absensi" : "Pendaftaran"}"),
                              const CSizedBox.h10(),
                              const CText(
                                "Apakah peserta dibatasi?",
                                style: CText.textStyleBodyBold,
                              ),
                              const CSizedBox.h5(),
                              CText(
                                  " ${controller.kegiatan.value.data?.isLimitParticipant == true ? "Ya" : "Tidak"}"),
                            ],
                          ),
                        ),
                      );
                    case StatusRequest.ERROR:
                      return error(
                          context,
                          "Terjadi Kesalahan. ${controller.kegiatan.value.failure?.msgShow}",
                          () => controller.getDetailKegiatan());
                    default:
                      return SizedBox();
                  }
                }),
              ),
              Flexible(
                  child: Container(
                    child: Obx(() {
                      switch (controller.peserta.value.statusRequest) {
                        case StatusRequest.LOADING:
                          return loading(context);
                        case StatusRequest.SUCCESS:
                          return ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CText(
                                              "Nama",
                                              style: CText.textStyleBodyBold,
                                            ),
                                            CSizedBox.h5(),
                                            CText(controller.peserta.value
                                                    .data?[index].name ??
                                                "Tidak ada nama"),
                                            CText(
                                              "Instansi",
                                              style: CText.textStyleBodyBold,
                                            ),
                                            CSizedBox.h5(),
                                            CText(controller.peserta.value
                                                    .data?[index].instansi ??
                                                "Tidak ada nama instansi"),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 0,
                                        child: Container(
                                            width: 200,
                                            height: 100,
                                            child: Image.network(
                                                ApiProvider.BASE_URL +
                                                    "/storage/signature/" +
                                                    (controller
                                                            .peserta
                                                            .value
                                                            .data?[index]
                                                            .signature ??
                                                        ""))),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount:
                                controller.peserta.value.data?.length ?? 0,
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
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
