import 'package:absensi_kegiatan/app/data/model/PesertaModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CDialog.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/error.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/responsive_layout.dart';
import 'package:absensi_kegiatan/app/global_widgets/sized_box/CSizedBox.dart';
import 'package:absensi_kegiatan/app/utils/date.dart';
import 'package:absensi_kegiatan/app/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_view/factory.dart';
import 'package:magic_view/style/AutoCompleteData.dart';
import 'package:magic_view/style/MagicTextFieldStyle.dart';
import 'package:magic_view/style/MagicTextStyle.dart';
import 'package:magic_view/widget/button/MagicButton.dart';
import 'package:magic_view/widget/text/MagicText.dart';
import 'package:magic_view/widget/textfield/MagicAutoComplete.dart';
import 'package:magic_view/widget/textfield/MagicTextField.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/model/InstansiModel.dart';
import '../../../data/model/RegionModel.dart';
import '../../../global_widgets/text/CText.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';
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
      floatingActionButton: FloatingActionButton(
          backgroundColor: basicPrimaryDark,
          child: const Icon(
            Icons.note_add_outlined,
          ),
          onPressed: () {
            widgetNotulen();
          }),
      body: SingleChildScrollView(
        child: ResponsiveLayout(Container(
          decoration: const BoxDecoration(
              color: basicWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              )),
          padding: const EdgeInsets.all(24),
          constraints: BoxConstraints(minHeight: Get.context!.height),
          child: Column(
            children: [
              widgetDetailAgenda(),
              const SizedBox(
                height: 8,
              ),
              widgetIconResume(),
              const SizedBox(
                height: 8,
              ),
              widgetSearchPeserta(),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 4),
                child: Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MagicText(
                          "Data ditemukan : ${controller.pesertaFilter.length}"),
                      MagicButton(
                        () {
                          if (controller.regions.value.data == null) {
                            controller.getRegion();
                          }
                          if (controller.instansi.value.data == null) {
                            if (controller
                                    .kegiatan.value.data?.isLimitParticipant ==
                                true) {
                              controller.getInstansi();
                            } else {
                              controller.getInstansiAll();
                            }
                          }
                          widgetFilter();
                        },
                        text: "Filter",
                        background: controller.filterRegion != null ||
                                controller.filterInstansi != null
                            ? basicGreen
                            : basicPrimary,
                      )
                    ],
                  );
                }),
              ),
              const SizedBox(
                height: 8,
              ),
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
              return Column(
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

  widgetIconResume() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: basicPrimary, width: 1)),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: columnCard(icParticipant,
                    "${controller.peserta.value.data?.length ?? 0}",
                    action: () {
                  controller.filterStatus = null;
                  controller.filterPeserta();
                  // controller.status.value = "1";
                })),
            Expanded(
                flex: 1,
                child: columnCard(icOffice, "${controller.totalInstansi}",
                    action: () {
                  if (controller.kegiatan.value.data?.isLimitParticipant ==
                      true) {
                    controller.getInstansiParticipant();
                  }
                })),
            Visibility(
              visible: controller.kegiatan.value.data?.type == 2,
              child: Expanded(
                  flex: 1,
                  child: columnCard(icQrSuccess, "${controller.totalScanned}",
                      action: () {
                    controller.filterStatus = "SCANNED";
                    controller.filterPeserta();
                    // controller.status.value = "2";
                  })),
            ),
            Visibility(
              visible: controller.kegiatan.value.data?.type == 2,
              child: Expanded(
                  flex: 1,
                  child: columnCard(icQrError, "${controller.totalUnScanned}",
                      action: () {
                    controller.filterStatus = "UNSCANNED";
                    controller.filterPeserta();
                    // controller.status.value = "3";
                  })),
            ),
          ],
        ),
      );
    });
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
          const CSizedBox.w10(),
          CText(
            value,
            style: CText.textStyleSubhead,
          )
        ],
      ),
    );
  }

  /// Widget untuk mencari data peserta
  widgetSearchPeserta() {
    return MagicTextField.border(
      controller.controllerSearch,
      hint: "Cari Nama / Instansi",
      onChange: (value) {
        // controller.filter.value = value;
        controller.filterTeks = value;
        controller.filterPeserta();
      },
      suffixIcon: const Icon(Icons.search),
    );
  }

  widgetListPeserta() {
    return Obx(() {
      // String filter = controller.filter.value
      //     .toLowerCase(); // jangan dihapus buat trigger search!
      // String status = controller.status.value;
      switch (controller.peserta.value.statusRequest) {
        case StatusRequest.LOADING:
          return loading(Get.context!);
        case StatusRequest.SUCCESS:
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              // List<PesertaModel> peserta = controller.peserta.value.data ?? [];
              List<PesertaModel> peserta = controller.pesertaFilter.value;
              // if (!(peserta[index].name ?? "").toLowerCase().contains(filter) &&
              //     !(peserta[index].instansi ?? "")
              //         .toLowerCase()
              //         .contains(filter)) {
              //   return Container();
              // }
              // if (status == "1") {
              // } else if (status == "2") {
              //   if (peserta[index].scannedAt == null) return Container();
              // } else {
              //   if (peserta[index].scannedAt != null) return Container();
              // }

              ///Jika menggunakan canvaskit, load image pake ini
              // ui.platformViewRegistry.registerViewFactory(
              //     "images/${peserta[index].id}",
              //     (int viewId) => ImageElement(
              //         src:
              //             "${ApiProvider.BASE_URL}/storage/signature/${peserta[index].signature}"));

              return Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                padding: const EdgeInsets.all(10),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: basicPrimaryLight,
                      blurRadius: 5,
                      offset: Offset(0, 0),
                      spreadRadius: 3,
                    )
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            widgetDialogDetailParticipant(peserta[index]);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MagicText(
                                peserta[index].name ?? "",
                                fontSize: 16,
                              ),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: controller
                                        .getStringInstansi(peserta[index]),
                                    style: MagicFactory.magicTextStyle
                                        .copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16)
                                        .toGoogleTextStyle()),
                                TextSpan(
                                    text:
                                        " ${peserta[index].wilayahName ?? ""}",
                                    style: MagicFactory.magicTextStyle
                                        .copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: basicPrimaryLight)
                                        .toGoogleTextStyle())
                              ])),
                              MagicText(peserta[index].jabatan ?? ""),
                            ],
                          ),
                        )),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        flex: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widgetScanPeserta(peserta[index]),
                            const SizedBox(
                              height: 16,
                            ),
                            widgetDeleteParticipant(peserta[index])
                          ],
                        ))
                  ],
                ),
              );
            },
            itemCount: controller.pesertaFilter.value.length,
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

  ///
  widgetScanPeserta(PesertaModel peserta) {
    if (peserta.scannedAt == null) {
      return InkWell(
        onTap: () {
          controller.scanQrPeserta(peserta);
        },
        child: Image.asset(
          "assets/ic_qrcode.png",
          width: 24,
          height: 24,
          color: basicRed1,
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          Get.defaultDialog(middleText: "Sudah dilakukan pemindaian!");
        },
        child: Image.asset(
          "assets/ic_qrcode.png",
          width: 24,
          height: 24,
          color: basicGreen,
        ),
      );
    }
  }

  widgetDeleteParticipant(PesertaModel peserta) {
    return InkWell(
      onTap: () {
        Get.defaultDialog(
            title: "Perhatian",
            middleText: "Apakah anda yakin ingin menghapus data?",
            textConfirm: "Ya",
            textCancel: "Tidak",
            confirmTextColor: basicWhite,
            cancelTextColor: basicPrimary,
            buttonColor: basicPrimary,
            onConfirm: () {
              controller.deletePeserta(peserta);
            });
      },
      child: Image.asset(
        icDelete,
        color: basicRed1,
        width: 24,
        height: 24,
      ),
    );
  }

  widgetDialogDetailParticipant(PesertaModel peserta) {
    Get.dialog(cardDialog2(
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 0,
              child: Container(
                color: basicWhite,
                width: 150,
                height: 150,
                margin: const EdgeInsets.all(10),
                child: Image.network(
                    "${ApiProvider.BASE_URL}/storage/signature/${peserta.signature}"),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MagicText(peserta.name ?? ""),
                  MagicText(controller.getStringInstansi(peserta)),
                  MagicText(peserta.wilayahName ?? ""),
                  MagicText(peserta.jabatan ?? ""),
                ],
              ),
            )
          ],
        ),
        ResponsiveLayout.getWidth(Get.context!) - 100));
  }

  widgetNotulen() {
    controller.getNotulen();
    Widget widget = Obx(() {
      switch (controller.notulen.value.statusRequest) {
        case StatusRequest.LOADING:
          return loading(Get.context!);
        case StatusRequest.SUCCESS:
        case StatusRequest.EMPTY:
          return Container(
            padding: const EdgeInsets.all(16),
            width: ResponsiveLayout.getWidth(Get.context!) - 40,
            constraints: BoxConstraints(
                maxHeight: 600,
                minHeight: 500,
                maxWidth: ResponsiveLayout.getWidth(Get.context!) - 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CText(
                  "Notulen",
                  style: CText.textStyleBody.copyWith(color: basicGrey2),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 420,
                  width: ResponsiveLayout.getWidth(Get.context!) - 40,
                  child: QuillHtmlEditor(
                    controller: QuillEditorController(),
                    minHeight: 400,
                    text: controller.notulen.value.data?.delta,
                    textStyle: MagicFactory.magicTextStyle.toGoogleTextStyle(),
                    isEnabled: false,
                    hintText: "Buat notulen lebih dahulu",
                    hintTextStyle: MagicFactory.magicTextStyle
                        .copyWith(fontWeight: FontWeight.w300)
                        .toGoogleTextStyle(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: MagicButton(
                          () {
                            Get.back();
                            Get.toNamed(Routes.FORM_NOTULEN, parameters: {
                              "activity_id": "${controller.id}"
                            });
                          },
                          text: controller.notulen.value.data == null
                              ? "Buat Notulen"
                              : "Edit Notulen",
                          widthInfinity: true,
                          padding: const EdgeInsets.all(16),
                          textColor: basicWhite,
                        )),
                    const SizedBox(
                      width: 16,
                    ),
                    Visibility(
                      visible: controller.notulen.value.data != null,
                      child: Expanded(
                          flex: 1,
                          child: MagicButton(
                            () {
                              Get.back();
                              launchUrl(Uri.parse(
                                  "${ApiProvider.BASE_URL}/api/notulen/download/pdf?kegiatan_id=${controller.id}"));
                            },
                            text: "Download",
                            padding: const EdgeInsets.all(16),
                            widthInfinity: true,
                            textColor: basicWhite,
                          )),
                    ),
                  ],
                )
              ],
            ),
          );
        case StatusRequest.ERROR:
          return error(
              Get.context!,
              "${controller.notulen.value.failure?.msgShow}",
              () => controller.getNotulen());
        default:
          return Container();
      }
    });

    Get.dialog(cardDialog2(widget, ResponsiveLayout.getWidth(Get.context!)));
  }

  widgetFilter() {
    Get.dialog(cardDialog2(
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MagicText("Pilih Instansi"),
              Obx(() {
                switch (controller.instansi.value.statusRequest) {
                  case StatusRequest.LOADING:
                    return loading(Get.context!);
                  case StatusRequest.SUCCESS:
                    final list = controller.getListInstansi();
                    return MagicAutoComplete<InstansiModel>(
                      controller: TextEditingController(
                          text: controller.filterInstansi?.option),
                      list: list,
                      onSelected: (selected) {
                        controller.filterInstansi = selected;
                      },
                      maxWidthOption:
                          ResponsiveLayout.getWidth(Get.context!) - 40,
                      textFieldStyle: MagicTextFieldStyle(
                        hint: controller.filterInstansi?.option ??
                            "Pilih Instansi",
                        validator: (value) {
                          if (controller
                                  .kegiatan.value.data?.isLimitParticipant ==
                              true) {
                            if (value != controller.filterInstansi?.option) {
                              return "Silahkan pilih salah satu dari pilihan yang ada";
                            }
                          }
                          return null;
                        },
                      ),
                    );
                  case StatusRequest.ERROR:
                    return error(
                        Get.context!,
                        controller.instansi.value.failure?.msgShow,
                        () => controller.getInstansi());
                  default:
                    return SizedBox();
                }
              }),
              SizedBox(
                height: 16,
              ),
              MagicText("Pilih Wilayah"),
              Obx(() {
                switch (controller.regions.value.statusRequest) {
                  case StatusRequest.LOADING:
                    return loading(Get.context!);
                  case StatusRequest.SUCCESS:
                    List<RegionModel> result =
                        controller.regions.value.data ?? List.empty();
                    final list = result.map((e) {
                      return AutoCompleteData(e.name, e);
                    }).toList();
                    debugPrint("${controller.filterRegion?.option}");
                    return MagicAutoComplete<RegionModel>(
                      controller: TextEditingController(
                          text: controller.filterRegion?.option),
                      list: list,
                      onSelected: (selected) {
                        controller.filterRegion = selected;
                      },
                      maxWidthOption:
                          ResponsiveLayout.getWidth(Get.context!) - 40,
                      textFieldStyle: MagicTextFieldStyle(
                        hint: controller.filterRegion?.option ??
                            "Pilih Wilayah (Pilih Instansi dahulu)",
                        validator: (value) {
                          if (value != controller.filterRegion?.option) {
                            return "Silahkan pilih salah satu dari pilihan yang ada";
                          }
                          return null;
                        },
                      ),
                    );
                  case StatusRequest.ERROR:
                    return error(
                        Get.context!,
                        controller.regions.value.failure?.msgShow,
                        () => controller.getRegion());
                  default:
                    return SizedBox();
                }
              }),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: MagicButton(
                      () {
                        Get.back();
                        controller.filterRegion = null;
                        controller.filterInstansi = null;
                        controller.filterPeserta();
                      },
                      text: "RESET",
                      padding: const EdgeInsets.all(16),
                      strokeColor: basicPrimary,
                      strokeWidth: 2,
                      background: basicWhite,
                      widthInfinity: true,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    flex: 1,
                    child: MagicButton(
                      () {
                        Get.back();
                        controller.filterPeserta();
                      },
                      text: "FILTER",
                      padding: EdgeInsets.all(16),
                      textColor: basicWhite,
                      widthInfinity: true,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        ResponsiveLayout.getWidth(Get.context!)));
  }
}
