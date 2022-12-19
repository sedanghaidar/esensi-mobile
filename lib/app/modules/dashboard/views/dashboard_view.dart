import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/error.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/toast.dart';
import 'package:absensi_kegiatan/app/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../global_widgets/button/CButton.dart';
import '../../../global_widgets/button/CButtonStyle.dart';
import '../../../global_widgets/sized_box/CSizedBox.dart';
import '../../../global_widgets/text/CText.dart';
import '../../../global_widgets/text_field/CTextField.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';
import '../../../utils/constant.dart';
import '../../../utils/utils.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  Widget iconProfil = ClipRRect(
    borderRadius: BorderRadius.circular(50),
    child: Container(
        color: basicPrimary2,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.person,
            size: 24,
          ),
        )),
  );

  DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget menu = const SizedBox();
    double paddingHorizontal = 20;

    final orientation = getPlatform(context);
    if (orientation == WEB_LANDSCAPE || orientation == DESKTOP_LANDSCAPE) {
      menu = Row(
        children: [
          CText("Nama User",
              style: CText.textStyleBody.copyWith(
                fontWeight: FontWeight.w200,
                color: basicWhite,
              )),
          const CSizedBox.w10(),
          iconProfil
        ],
      );
      if (Get.width >= 1200) {
        paddingHorizontal = Get.width * 0.25;
      }
    } else {
      menu = iconProfil;
    }

    debugPrint(
        "TOKENNNN2 ${controller.repository.hive.getUserModel().toString()}");
    controller.getKegiatan();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: basicPrimary,
        actions: [
          InkWell(
            onTap: () {
              ///TODO GO TO PROFILE
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.center,
                child: menu,
              ),
            ),
          )
        ],
      ),
      backgroundColor: basicGrey4,
      body: Padding(
        padding: EdgeInsets.only(
            top: 20, bottom: 20, left: 20, right: paddingHorizontal),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CTextField.noStyle(
                  hintText: "Masukkan nama agenda",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                      width: 150,
                      child: CButton.box(
                        () {
                          Get.toNamed(Routes.CREATE_AGENDA);
                        },
                        "Buat Agenda",
                      )),
                ),
              ],
            ),
            const CSizedBox.h20(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                CText.header(
                  "Daftar Agenda",
                  style: CText.textStyleSubhead,
                ),
              ],
            ),
            const CSizedBox.h20(),
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
                        itemCount: controller.kegiatan.value.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: basicWhite,
                                border: Border.all(color: basicGrey2),
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: CText(
                                        "${controller.kegiatan.value.data?[index].name}",
                                        style: CText.textStyleBodyBold.copyWith(
                                            fontSize: 24,
                                            letterSpacing: 0.75,
                                            fontWeight: FontWeight.w600),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(
                                        flex: 0,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                                width: 80,
                                                child: CButton.icon(
                                                    () {}, "Edit",
                                                    style:
                                                        styleButtonFilledBoxSmall,
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      size: 16,
                                                      color: basicWhite,
                                                    ))),
                                            const CSizedBox.w5(),
                                            SizedBox(
                                                width: 95,
                                                child: CButton.icon(() {
                                                  Get.defaultDialog(
                                                      title: "Perhatian",
                                                      middleText:
                                                          "Apakah anda yakin ingin menghapus?",
                                                      textConfirm: "Ya",
                                                      onConfirm: () {
                                                        controller.deleteKegiatan(
                                                            "${controller.kegiatan.value.data?[index].id}");
                                                      },
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      confirmTextColor:
                                                          basicWhite,
                                                      buttonColor: basicPrimary,
                                                      cancelTextColor:
                                                          basicPrimary,
                                                      textCancel: "Batal");
                                                }, "Hapus",
                                                    style:
                                                        styleButtonFilledBoxSmall,
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      size: 16,
                                                      color: basicWhite,
                                                    )))
                                          ],
                                        ))
                                  ],
                                ),
                                const CSizedBox.h5(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: context.width / 2),
                                        child: InkWell(
                                          child: CText(
                                            "${ApiProvider.BASE_URL}/form/${controller.kegiatan.value.data?[index].codeUrl}",
                                            style: CText.textStyleBody
                                                .copyWith(fontSize: 16),
                                            // overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                          onTap: () {
                                            Get.toNamed(
                                                    "${Routes.FORM}/${controller.kegiatan.value.data?[index].codeUrl}")
                                                ?.then((value) {
                                              controller.getKegiatan();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    const CSizedBox.w10(),
                                    Expanded(
                                      flex: 0,
                                      child: InkWell(
                                        onTap: () async {
                                          await Clipboard.setData(ClipboardData(
                                                  text:
                                                      "${controller.kegiatan.value.data?[index].codeUrl}"))
                                              .whenComplete(() {
                                            showToast("Berhasil menyalin kode");
                                          });
                                        },
                                        child: Container(
                                          color: basicGrey4,
                                          padding: const EdgeInsets.all(8),
                                          child: const Icon(
                                            Icons.copy,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const CSizedBox.h5(),
                                const Divider(height: 2),
                                const CSizedBox.h5(),
                                RichText(
                                  text: TextSpan(children: [
                                    const WidgetSpan(
                                        child: Icon(
                                      Icons.access_time_filled_rounded,
                                      size: 16,
                                    )),
                                    const WidgetSpan(child: CSizedBox.w5()),
                                    WidgetSpan(
                                        child: CText(
                                      dateToString(
                                          controller.kegiatan.value.data?[index]
                                              .createdAt,
                                          format:
                                              "EEEE, dd MMMM yyyy, HH:mm:ss"),
                                      style: CText.textStyleBody.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ))
                                  ]),
                                )
                              ],
                            ),
                          );
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
            ),
          ],
        ),
      ),
    );
  }
}
