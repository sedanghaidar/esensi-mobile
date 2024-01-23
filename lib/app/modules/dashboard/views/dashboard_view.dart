import 'package:absensi_kegiatan/app/data/model/KegiatanModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/error.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/responsive_layout.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/toast.dart';
import 'package:absensi_kegiatan/app/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:magic_view/factory.dart';
import 'package:magic_view/widget/button/MagicButton.dart';
import 'package:magic_view/widget/text/MagicText.dart';
import 'package:magic_view/widget/textfield/MagicTextField.dart';

import '../../../global_widgets/sized_box/CSizedBox.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';
import '../../../utils/constant.dart';
import '../../../utils/utils.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget menu = const SizedBox();

    return Scaffold(
      backgroundColor: basicPrimary,
      appBar: AppBar(
        backgroundColor: basicPrimary,
        elevation: 0,
        leadingWidth: 160,
        leading: Container(
          padding: EdgeInsets.all(8),
          child: Image.asset(
            "assets/ic_white_horizontal.png",
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.toNamed(Routes.PROFILE);
            },
            child: GetBuilder<DashboardController>(
              builder: (controller) {
                Widget iconProfil = ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                      color: basicGrey4,
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.person_2_rounded,
                          color: basicPrimary,
                          size: 24,
                        ),
                      )),
                );
                final orientation = getPlatform(context);
                if (orientation == WEB_LANDSCAPE ||
                    orientation == DESKTOP_LANDSCAPE) {
                  menu = Row(
                    children: [
                      MagicText.subhead(
                        controller.user?.name ?? "Nama User",
                        color: basicWhite,
                      ),
                      const CSizedBox.w10(),
                      iconProfil
                    ],
                  );
                } else {
                  menu = iconProfil;
                }

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Align(
                    alignment: Alignment.center,
                    child: menu,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              Get.toNamed(Routes.QR_SCANNER);
            },
            backgroundColor: basicPrimaryDark,
            child: const Icon(
              Icons.qr_code,
              color: basicWhite,
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              Get.toNamed(Routes.CREATE_AGENDA);
            },
            backgroundColor: basicPrimaryDark,
            child: const Icon(
              Icons.add,
              color: basicWhite,
            ),
          ),
        ],
      ),
      body: ResponsiveLayout(Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            MagicTextField.border(
              controller.controllerSearch,
              hint: "Cari Agenda",
              filled: true,
              fillColor: basicWhite,
              prefixIcon: const Icon(Icons.search),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (value) {
                controller.filterKegiatanByType();
              },
            ),
            const SizedBox(
              height: 24,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: MagicText.head(
                "Daftar Agenda",
                color: basicWhite,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Obx(() {
              return Row(
                children: [
                  buttonTypeForm(DashboardController.typePendaftaran),
                  const SizedBox(
                    width: 8,
                  ),
                  buttonTypeForm(DashboardController.typeAbsensi)
                ],
              );
            }),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              flex: 1,
              child: Obx(() {
                switch (controller.kegiatan.value.statusRequest) {
                  case StatusRequest.LOADING:
                    return loading(context);
                  case StatusRequest.EMPTY:
                    return error(context, "Daftar Kegiatan Kosong",
                        () => controller.getKegiatan());
                  case StatusRequest.SUCCESS:
                    return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount:
                            controller.kegiatanFilter.value.data?.length ?? 0,
                        padding: const EdgeInsets.only(bottom: 64),
                        itemBuilder: (context, index) {
                          final agenda =
                              controller.kegiatanFilter.value.data?[index];
                          return itemAgenda(agenda);
                        });
                  case StatusRequest.ERROR:
                    return error(
                        context,
                        "${controller.kegiatan.value.failure?.msgShow}",
                        () => controller.getKegiatan(),
                        height: 200);
                  default:
                    return const SizedBox();
                }
              }),
            )
          ],
        ),
      )),
    );
  }

  itemAgenda(KegiatanModel? agenda) {
    return InkWell(
      onTap: () {
        Get.toNamed("${Routes.DETAIL_AGENDA}/${agenda?.id}");
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Stack(
          children: [
            Container(
              height: 30,
              width: (ResponsiveLayout.getWidth(Get.context!) - 20) / 3,
              decoration: BoxDecoration(
                  color: getColorByDate(
                      agenda?.date ?? DateTime.now(), agenda?.time),
                  border: Border.all(color: basicWhite),
                  borderRadius: BorderRadius.circular(10)),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: basicWhite),
              child: Column(
                children: [
                  Visibility(
                    visible: agenda?.isLimitParticipant ?? false,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              "assets/ic_limited.png",
                              width: 48,
                              color: basicRed1,
                            ),
                            InkWell(
                              onTap: () {
                                Get.toNamed(
                                    "${Routes.MANAGE_PARTICIPANT}/${agenda?.id}");
                              },
                              child: Image.asset(
                                "assets/ic_participant.png",
                                width: 24,
                              ),
                            )
                          ],
                        ),
                        const Divider()
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            Get.toNamed("${Routes.FORM}/${agenda?.codeUrl}")
                                ?.then((value) {
                              controller.getKegiatan();
                            });
                          },
                          child: MagicText(
                            agenda?.name ?? "",
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            textOverflow: TextOverflow.ellipsis,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                          flex: 0,
                          child: Row(
                            children: [
                              InkWell(
                                  onTap: () async {
                                    await Clipboard.setData(ClipboardData(
                                            text:
                                                "${Uri.base.origin}/#/form/${agenda?.codeUrl}"))
                                        .whenComplete(() {
                                      showToast("Berhasil menyalin kode");
                                    });
                                  },
                                  child: const Icon(Icons.copy)),
                              Visibility(
                                visible: getStatusEditableKegiatan(
                                    agenda?.date ?? DateTime.now(),
                                    agenda?.time),
                                child: Row(
                                  children: [
                                    ///TOMBOL EDIT
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed(
                                            "${Routes.UPDATE_AGENDA}/${agenda?.id}");
                                      },
                                      child: const Icon(
                                        Icons.edit,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),

                                    ///TOMBOL HAPUS
                                    InkWell(
                                      onTap: () {
                                        Get.defaultDialog(
                                            title: "Perhatian",
                                            middleText:
                                                "Apakah anda yakin ingin menghapus?",
                                            textConfirm: "Ya",
                                            onConfirm: () {
                                              controller.deleteKegiatan(
                                                  "${agenda?.id}");
                                            },
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            confirmTextColor: basicWhite,
                                            buttonColor: basicPrimary,
                                            cancelTextColor: basicPrimary,
                                            textCancel: "Batal");
                                      },
                                      child: const Icon(
                                        Icons.delete,
                                        color: basicRed1,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            const Icon(Icons.access_time_sharp),
                            const SizedBox(
                              width: 8,
                            ),
                            MagicText(
                              dateToString(agenda?.date,
                                  format: "EEEE, dd MMMM yyyy"),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            openDialogDownload(agenda);
                          },
                          child: const Icon(Icons.file_download_outlined))
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  buttonTypeForm(String text) {
    return Expanded(
      flex: 1,
      child: MagicButton(
        () {
          controller.selectedType.value = text;
          controller.filterKegiatanByType();
        },
        text: text,
        background:
            text == controller.selectedType.value ? basicWhite : basicPrimary,
        strokeColor: text == controller.selectedType.value ? null : basicWhite,
        strokeWidth: text == controller.selectedType.value ? 0 : 2,
        textColor: text == controller.selectedType.value
            ? MagicFactory.colorText
            : basicWhite,
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}
