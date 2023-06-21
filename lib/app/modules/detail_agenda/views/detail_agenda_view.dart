import 'package:absensi_kegiatan/app/data/model/PesertaModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/error.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/responsive_layout.dart';
import 'package:absensi_kegiatan/app/global_widgets/sized_box/CSizedBox.dart';
import 'package:absensi_kegiatan/app/global_widgets/text_field/CTextField.dart';
import 'package:absensi_kegiatan/app/utils/date.dart';
import 'package:absensi_kegiatan/app/utils/images.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:magic_view/factory.dart';
import 'package:magic_view/widget/text/MagicText.dart';
import 'package:magic_view/widget/textfield/MagicTextField.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../global_widgets/Html.dart' if (dart.library.html) 'dart:html';
import '../../../global_widgets/button/CButton.dart';
import '../../../global_widgets/other/toast.dart';
import '../../../global_widgets/text/CText.dart';

// import 'dart:ui' as ui;
import '../../../global_widgets/ui.dart' if (dart.library.html) 'dart:ui' as ui;
import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';
import '../../../utils/utils.dart';
import '../controllers/detail_agenda_controller.dart';

class DetailAgendaView extends GetView<DetailAgendaController> {
  const DetailAgendaView({Key? key}) : super(key: key);

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
            Get.offAllNamed(Routes.DASHBOARD);
          },
          child: const Icon(
            Icons.home,
            color: basicWhite,
          ),
        ),
      ),
      backgroundColor: basicPrimary,
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
      body: SingleChildScrollView(
        child: ResponsiveLayout(Container(
          decoration: const BoxDecoration(
              color: basicWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              )),
          padding: const EdgeInsets.all(24),
          constraints: BoxConstraints(
            minHeight: Get.context!.height
          ),
          child: Column(
            children: [
              widgetDetailAgenda(),
              SizedBox(height: 8,),
              widgetIconResume(),
              SizedBox(height: 8,),
              widgetSearchPeserta(),
              SizedBox(height: 8,),
              widgetListPeserta()
            ],
          ),
        )),
      ),
    );
  }

  /// Widget untuk menampilkan detail agenda seperti
  ///   - judul
  ///   - tanggal dan waktu pelaksanaan
  ///   - lokasi
  ///   - tanggal dan waktu formulir ditutup
  ///   - jenis formulir
  ///   - apakah peserta dibatasi
  widgetDetailAgenda() {
    return GetBuilder<DetailAgendaController>(
        id: 'detail-kegiatan',
        builder: (controller) {
          switch (controller.kegiatan.value.statusRequest) {
            case StatusRequest.LOADING:
              return loading(Get.context!);
            case StatusRequest.SUCCESS:
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: MagicText(
                              controller.kegiatan.value.data?.name ?? "-",
                              fontSize: 24,
                            )),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                            flex: 0,
                            child: InkWell(
                              onTap: () {
                                controller.showDetailAgenda =
                                    !controller.showDetailAgenda;
                                controller.update(['detail-kegiatan']);
                              },
                              child: Icon(
                                controller.showDetailAgenda == true
                                    ? Icons.arrow_circle_up_outlined
                                    : Icons.arrow_circle_down_outlined,
                                color: basicPrimary,
                                size: 36,
                              ),
                            )),
                      ],
                    ),
                    Visibility(
                        visible: controller.showDetailAgenda,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            widgetItemDetail(
                              icDate,
                              "Tanggal dan Waktu Pelaksanaan",
                              "${dateToString(controller.kegiatan.value.data?.date)} ${controller.kegiatan.value.data?.time}",
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            widgetItemDetail(icPlace, "Lokasi",
                                "${controller.kegiatan.value.data?.location}"),
                            const SizedBox(
                              height: 8,
                            ),
                            widgetItemDetail(
                                icDateClose,
                                "Tanggal dan Waktu Formulir Ditutup",
                                controller.kegiatan.value.data?.dateEnd == null
                                    ? "-"
                                    : dateToString(
                                        controller.kegiatan.value.data?.dateEnd,
                                        format: "EEEE, dd MMMM yyyy hh:mm:ss",
                                      )),
                            const SizedBox(
                              height: 8,
                            ),
                            widgetItemDetail(
                              icType,
                              "Jenis Formulir",
                              controller.kegiatan.value.data?.type == 1
                                  ? "Absensi"
                                  : "Pendaftaran",
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            widgetItemDetail(
                                icUserLimit,
                                "Pembatasan Peserta?",
                                controller.kegiatan.value.data
                                            ?.isLimitParticipant ==
                                        true
                                    ? "Ya"
                                    : "Tidak"),
                          ],
                        ))
                  ],
                ),
              );
            case StatusRequest.ERROR:
              return error(
                  Get.context!,
                  controller.kegiatan.value.failure?.msgShow ?? "",
                  () => controller.getDetailKegiatan());
            default:
              return Container();
          }
        });
  }

  /// Widget untuk mengatur komposisi tampilan dari detail agenda
  widgetItemDetail(String icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: MagicFactory.colorDisable,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              flex: 0,
              child: Image.asset(
                icon,
                width: 24,
                height: 24,
              )),
          const SizedBox(
            width: 16,
          ),
          Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MagicText(
                    title,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  MagicText.hint(value)
                ],
              )),
        ],
      ),
    );
  }

  widgetIconResume(){
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: basicPrimary,
            width: 1
          )
        ),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: columnCard(icParticipant,
                    "${controller.peserta.value.data?.length ?? 0}",
                    action: () {
                      controller.status.value = "1";
                    })),
            Expanded(
                flex: 1,
                child: columnCard(
                    icOffice, "${controller.totalInstansi}",
                    action: () {
                      if (controller.kegiatan.value.data
                          ?.isLimitParticipant ==
                          true) {
                        controller.getInstansiParticipant();
                      }
                    })),
            Visibility(
              visible: controller.kegiatan.value.data?.type==2,
                child: Expanded(
                flex: 1,
                child: columnCard(
                    icQrSuccess, "${controller.totalScanned}",
                    action: () {
                      controller.status.value = "2";
                    })),),
            Visibility(
                visible: controller.kegiatan.value.data?.type==2,
                child: Expanded(
                    flex: 1,
                    child: columnCard(
                        icQrError, "${controller.totalUnScanned}",
                        action: () {
                          controller.status.value = "3";
                        })),),
          ],
        ),
      );
    });
  }

  /// Widget untuk mencari data peserta
  widgetSearchPeserta(){
    return MagicTextField.border(
      controller.controllerSearch,
      hint: "Cari Nama / Instansi",
      onChange: (value) {
        controller.filter.value = value;
      },
      suffixIcon: const Icon(Icons.search),
    );
  }

  widgetListPeserta(){
    return Obx(() {
      String filter = controller.filter.value
          .toLowerCase(); // jangan dihapus buat trigger search!
      String status = controller.status.value;
      switch (controller.peserta.value.statusRequest) {
        case StatusRequest.LOADING:
          return loading(Get.context!);
        case StatusRequest.SUCCESS:
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              List<PesertaModel> peserta =
                  controller.peserta.value.data ?? [];
              if (!(peserta[index].name ?? "")
                      .toLowerCase()
                      .contains(filter) &&
                  !(peserta[index].instansi ?? "")
                      .toLowerCase()
                      .contains(filter)) {
                return Container();
              }
              if (status == "1") {
              } else if (status == "2") {
                if (peserta[index].scannedAt == null)
                  return Container();
              } else {
                if (peserta[index].scannedAt != null)
                  return Container();
              }
              ui.platformViewRegistry.registerViewFactory(
                  "images/$index",
                  (int viewId) => ImageElement(
                      src:
                          "${ApiProvider.BASE_URL}/storage/signature/${peserta[index].signature}"));

              return Card(
                color: basicPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11.0),
                ),
                child: Container(
                  padding: const EdgeInsets.only(right: 10),
                  margin: const EdgeInsets.only(left: 10),
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
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                CText(
                                  dateToString(
                                      peserta[index].createdAt),
                                  style: CText.textStyleHint,
                                ),
                                const Divider(),
                                InkWell(
                                  onTap: () async {
                                    await Clipboard.setData(ClipboardData(
                                            text:
                                                "${peserta[index].name}, ${peserta[index].instansi}"))
                                        .whenComplete(() {
                                      showToast(
                                          "Berhasil menyalin nama!");
                                    });
                                  },
                                  child: CText(
                                      peserta[index].name ?? ""),
                                ),
                                CText(
                                  "${peserta[index].instansiDetail?.name}${peserta[index].instansiDetail?.parent?.name == null ? "" : " ${peserta[index].instansiDetail?.parent?.name}"} ${peserta[index].wilayahName}",
                                  style: CText.textStyleBodyBold,
                                ),
                                CText(
                                  peserta[index].jabatan ?? "",
                                  style: CText.textStyleBody
                                      .copyWith(color: basicGrey2),
                                ),
                                const Divider(),
                                peserta[index].scannedAt == null
                                    ? CText(
                                        "Belum discan",
                                        style: CText.textStyleHint
                                            .copyWith(
                                                fontSize: 12,
                                                color: basicRed1),
                                      )
                                    : CText(
                                        "Discan pada ${dateToString(peserta[index].scannedAt)}",
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
                                  Get.defaultDialog(
                                      title: "Perhatian",
                                      middleText:
                                          "Apakah anda yakin ingin menghapus data?",
                                      textConfirm: "Ya",
                                      textCancel: "Tidak",
                                      confirmTextColor: basicWhite,
                                      cancelTextColor: basicPrimary,
                                      buttonColor: basicPrimary,
                                      onConfirm: () {
                                        controller.deletePeserta(
                                            peserta[index].id);
                                      });
                                },
                                child:
                                    iconButton(icDelete, basicRed1),
                              ),
                              const CSizedBox.h5(),
                              InkWell(
                                onTap: () {
                                  openDialogSignature(context, index);
                                },
                                child: iconButton(
                                    icSignature, basicPrimary),
                              ),
                              const CSizedBox.h5(),
                              InkWell(
                                onTap: () {
                                  openDialogQrcode(
                                      context, peserta[index]);
                                  // Get.toNamed(
                                  //     "${Routes.DETAIL_PESERTA}/${peserta[index].id}");
                                },
                                child: iconButton(
                                    icQrcode, basicPrimary2),
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
          return warning(Get.context!, "Belum ada peserta");
        case StatusRequest.ERROR:
          return error(
              Get.context!,
              "Terjadi Kesalahan.\n${controller.kegiatan.value.failure?.msgShow}",
              () => controller.getDetailKegiatan());
        default:
          return const SizedBox();
      }
    });
  }

  ///Mengatur tombol lihat tanda tangan dan qrcode pada setiap item di daftar
  ///[asset] icon yang akan dipakai
  Widget iconButton(String asset, Color background) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
          color: background,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              asset,
              width: 20,
              height: 20,
              color: basicWhite,
            ),
          )),
    );
  }

  openDialogDetail(BuildContext context) {
    Get.dialog(Center(
      child: Container(
        width: getWidthDefault(context),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(10),
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
              const CSizedBox.h10(),
              rowDetail(icDate, "Tanggal dan Waktu Pelaksanaan",
                  "${dateToString(controller.kegiatan.value.data?.date)} ${controller.kegiatan.value.data?.time}"),
              const CSizedBox.h10(),
              rowDetail(icPlace, "Lokasi",
                  "${controller.kegiatan.value.data?.location}"),
              const CSizedBox.h10(),
              rowDetail(
                  icDateClose,
                  "Tanggal dan Waktu Formulir Ditutup",
                  controller.kegiatan.value.data?.dateEnd == null
                      ? "-"
                      : dateToString(controller.kegiatan.value.data?.dateEnd,
                          format: "EEEE, dd MMMM yyyy hh:mm:ss")),
              const CSizedBox.h10(),
              rowDetail(
                  icType,
                  "Jenis Formulir",
                  controller.kegiatan.value.data?.type == 1
                      ? "Absensi"
                      : "Pendaftaran"),
              const CSizedBox.h10(),
              rowDetail(
                  icUserLimit,
                  "Pembatasan Peserta?",
                  controller.kegiatan.value.data?.isLimitParticipant == true
                      ? "Ya"
                      : "Tidak"),
              const CSizedBox.h10(),
              Obx(() {
                switch (controller.notulen.value.statusRequest) {
                  case StatusRequest.LOADING:
                    return loading(context);
                  case StatusRequest.SUCCESS:
                    return Column(
                      children: [
                        rowDetail2(
                          icUserLimit,
                          "Notulen",
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CButton(() {
                          Get.back();
                          Get.toNamed(Routes.FORM_NOTULEN,
                              parameters: {"activity_id": "${controller.id}"});
                        }, "BUAT NOTULEN"),
                        CButton(() {
                          launchUrl(Uri.parse(
                              "${ApiProvider.BASE_URL}/api/notulen/download/pdf?kegiatan_id=${controller.id}"));
                        }, "DOWNLOAD NOTULEN")
                      ],
                    );
                  case StatusRequest.ERROR:
                    if (controller.notulen.value.failure?.code == 405) {
                      return Column(
                        children: [
                          rowDetail(
                            icUserLimit,
                            "Notulen",
                            "-",
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CButton(() {
                            Get.back();
                            Get.toNamed(Routes.FORM_NOTULEN, parameters: {
                              "activity_id": "${controller.id}"
                            });
                          }, "BUAT NOTULEN"),
                        ],
                      );
                    }
                    return error(
                        context,
                        controller.notulen.value.failure?.msgShow,
                        () => controller.getNotulen());
                  default:
                    return Container();
                }
              }),
            ],
          ),
        ),
      ),
    ));
  }

  ///Membuat dan mengatur konten yang ditampilkan pada dialog detail
  ///[icon] ikon konten
  ///[title] judul konten
  ///[value] isi dari konten
  Widget rowDetail(String icon, String title, String value) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
            flex: 0,
            child: Image.asset(
              icon,
              width: 24,
              height: 24,
            )),
        const CSizedBox.w10(),
        Expanded(
            flex: 1,
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

  Widget rowDetail2(String icon, String title) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 0,
            child: Image.asset(
              icon,
              width: 24,
              height: 24,
            )),
        const CSizedBox.w10(),
        Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CText(
                  title,
                  style: CText.textStyleBody.copyWith(color: basicGrey2),
                ),
                QuillHtmlEditor(
                  text: controller.notulen.value.data?.delta,
                  minHeight: 200,
                  isEnabled: false,
                  padding: EdgeInsets.all(8),
                  hintTextPadding: EdgeInsets.all(8),
                  textStyle: CText.textStyleBody,
                  hintTextStyle: CText.textStyleBody,
                  hintText: "Masukkan isi notulensi disini",
                  controller: QuillEditorController(),
                ),
              ],
            )),
      ],
    );
  }

  void openDialogSignature(BuildContext context, int index) {
    Get.dialog(
        Center(
          child: Container(
            color: basicWhite,
            width: getWidthDefault(context) / 2,
            height: getWidthDefault(context) / 2,
            margin: const EdgeInsets.all(10),
            child: kIsWeb
                ? HtmlElementView(
                    viewType: 'images/$index',
                  )
                : Image.network(
                    "${ApiProvider.BASE_URL}/storage/signature/${controller.peserta.value.data?[index].signature}"),
          ),
        ),
        barrierDismissible: true);
  }

  void openDialogQrcode(BuildContext context, PesertaModel? data) {
    Get.dialog(
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: basicWhite,
                width: getWidthDefault(context) / 2,
                height: (getWidthDefault(context) / 2),
                margin: const EdgeInsets.all(10),
                child: QrImage(
                  data: data?.qrCode ?? "",
                  size: getWidthDefault(context) / 2,
                ),
              ),
              Visibility(
                  visible: data?.scannedAt == null,
                  child: Container(
                      width: getWidthDefault(context) / 2,
                      child: CButton(() {
                        Get.back();
                        controller.scanQrPeserta(data?.qrCode);
                      }, "SCAN !"))),
            ],
          ),
        ),
        barrierDismissible: true);
  }

  Widget columnCard(String asset, String value, {Function()? action}) {
    return InkWell(
      onTap: action,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            asset,
            width: 36,
            height: 32,
          ),
          CSizedBox.w10(),
          CText(
            value,
            style: CText.textStyleSubhead,
          )
        ],
      ),
    );
  }
}
