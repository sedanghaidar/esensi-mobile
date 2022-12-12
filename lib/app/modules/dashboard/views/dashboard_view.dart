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
import 'dart:html' as html;

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

    ///COBA CEK HIVE
    bool isLoggedIn = controller.repository.hive.isLoggedIn();
    debugPrint("${isLoggedIn}");

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
          CSizedBox.w10(),
          iconProfil
        ],
      );
      if (Get.width >= 1200) {
        paddingHorizontal = Get.width * 0.25;
      }
    } else {
      menu = iconProfil;
    }

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
      body: SingleChildScrollView(
        child: Padding(
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
              ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: 10,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: CText(
                                  "Pembahasan Rencana Induk Smart Province",
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
                                          child: CButton.icon(() {}, "Edit",
                                              style: styleButtonFilledBoxSmall,
                                              icon: const Icon(
                                                Icons.edit,
                                                size: 16,
                                                color: basicWhite,
                                              ))),
                                      CSizedBox.w5(),
                                      SizedBox(
                                          width: 100,
                                          child: CButton.icon(() {}, "Detail",
                                              style: styleButtonFilledBoxSmall,
                                              icon: const Icon(
                                                Icons.view_agenda_rounded,
                                                size: 16,
                                                color: basicWhite,
                                              )))
                                    ],
                                  ))
                            ],
                          ),
                          const CSizedBox.h5(),
                          Row(
                            children: [
                              Flexible(
                                child: InkWell(
                                  child: CText(
                                    "https://absensi-kegiatan-panjangbanget pokoknya.jatengprov.go.id/form/198",
                                    style: CText.textStyleBody
                                        .copyWith(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onTap: () {
                                    // if (orientation == WEB_LANDSCAPE || orientation == WEB_PORTRAIT) {
                                    //   html.window.open("http://localhost:56884/#/form/12", "_blank");
                                    // }
                                    Get.toNamed(Routes.FORM+"/12");
                                  },
                                ),
                              ),
                              const CSizedBox.w10(),
                              Expanded(
                                flex: 0,
                                child: InkWell(
                                  onTap: () async {
                                    await Clipboard.setData(
                                        ClipboardData(text: "COPY DATA"))
                                        .whenComplete(() =>
                                        debugPrint("Berhasil menyalinurl"));
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
                          Divider(height: 2),
                          const CSizedBox.h5(),
                          RichText(
                            text: TextSpan(children: [
                              WidgetSpan(
                                  child: Icon(
                                    Icons.access_time_filled_rounded,
                                    size: 16,
                                  )),
                              WidgetSpan(child: CSizedBox.w5()),
                              WidgetSpan(
                                  child: CText(
                                    "12 Des 2022 09:00",
                                    style: CText.textStyleBody.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ))
                            ]),
                          )
                        ],
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
