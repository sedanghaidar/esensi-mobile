import 'package:absensi_kegiatan/app/global_widgets/text_field/CTextFieldDropDown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../global_widgets/button/CButton.dart';
import '../../../global_widgets/dialog/CDatePicker.dart';
import '../../../global_widgets/other/suffix_icon.dart';
import '../../../global_widgets/sized_box/CSizedBox.dart';
import '../../../global_widgets/text/CText.dart';
import '../../../global_widgets/text_field/CTextField.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';
import '../../../utils/constant.dart';
import '../../../utils/date.dart';
import '../../../utils/string.dart';
import '../../../utils/utils.dart';
import '../controllers/create_agenda_controller.dart';

class CreateAgendaView extends GetView<CreateAgendaController> {
  @override
  Widget build(BuildContext context) {
    double width = context.width;
    final orientation = getPlatform(context);
    if (orientation == WEB_LANDSCAPE || orientation == DESKTOP_LANDSCAPE) {
      width = width / 2;
    } else {
      width = context.width;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: basicPrimary,
        title: Text('Buat Agenda Baru'),
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
            padding: EdgeInsets.all(20),
            alignment: Alignment.topLeft,
            color: basicWhite,
            width: width,
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CText("Nama Agenda"),
                  CSizedBox.h5(),
                  CTextField(
                    controller: controller.controllerName,
                    hintText: "Masukkan Nama Agenda",
                    validator: (value) {
                      if (GetUtils.isBlank(value) == true) return msgBlank;
                      return null;
                    },
                    suffixIcon: suffixIconClear(() {
                      controller.controllerName.clear();
                    }),
                  ),
                  CSizedBox.h10(),
                  CText("Tanggal Agenda"),
                  CSizedBox.h5(),
                  CTextField(
                    controller: controller.controllerDate,
                    hintText: "Pilih Tanggal Agenda",
                    readOnly: true,
                    onTap: () {
                      CDatePicker(Get.context!,
                              timeSelected: controller.controllerDate.text)
                          .then((value) {
                        if (value != null) {
                          controller.controllerDate.text =
                              DateFormat("yyyy-MM-dd").format(value);
                        }
                      });
                    },
                    suffixIcon: suffixIconClear(() {
                      controller.controllerDate.clear();
                    }),
                    validator: (value) {
                      if (GetUtils.isBlank(value) == true) return msgBlank;
                      return null;
                    },
                  ),
                  CSizedBox.h10(),
                  CText("Waktu Agenda"),
                  CSizedBox.h5(),
                  CTextField(
                    controller: controller.controllerTime,
                    hintText: "Pilih Waktu Agenda",
                    readOnly: true,
                    suffixIcon: suffixIconClear(() {
                      controller.controllerTime.clear();
                    }),
                    onTap: () {
                      CTimePicker(Get.context!,
                              timeSelected: controller.controllerTime.text)
                          .then((value) {
                        if (value != null) {
                          controller.controllerTime.text = to24(value);
                        }
                      });
                    },
                    validator: (value) {
                      if (GetUtils.isBlank(value) == true) return msgBlank;
                      return null;
                    },
                  ),
                  CSizedBox.h10(),
                  CText("Lokasi Agenda"),
                  CSizedBox.h5(),
                  CTextField(
                    controller: controller.controllerLocation,
                    hintText: "Masukkan Lokasi Agenda",
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    validator: (value) {
                      if (GetUtils.isBlank(value) == true) return msgBlank;
                      return null;
                    },
                    suffixIcon: suffixIconClear(() {
                      controller.controllerLocation.clear();
                    }),
                  ),
                  CSizedBox.h10(),
                  CText("Informasi Tambahan"),
                  CSizedBox.h5(),
                  CTextField(
                    controller: controller.controllerInformation,
                    hintText: "Masukkan Informasi Tambahan (Opsional)",
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    validator: (value) {
                      return null;
                    },
                    suffixIcon: suffixIconClear(() {
                      controller.controllerInformation.clear();
                    }),
                  ),
                  CSizedBox.h10(),
                  CText("Tanggal Formulir Berakhir (Opsional)"),
                  CSizedBox.h5(),
                  CTextField(
                    controller: controller.controllerDateEnd,
                    hintText: "Pilih Tanggal Formulir Berakhir",
                    readOnly: true,
                    onTap: () {
                      CDatePicker(Get.context!,
                              timeSelected: controller.controllerDateEnd.text)
                          .then((value) {
                        if (value != null) {
                          controller.controllerDateEnd.text =
                              DateFormat("yyyy-MM-dd").format(value);
                        }
                      });
                    },
                    suffixIcon: suffixIconClear(() {
                      controller.controllerDateEnd.clear();
                    }),
                    validator: (value) {
                      if (GetUtils.isBlank(controller.controllerTimeEnd.text) ==
                              false &&
                          GetUtils.isBlank(value) == true) return msgBlank;
                      return null;
                    },
                  ),
                  CSizedBox.h10(),
                  CText("Waktu Formulir Berakhir (Opsional)"),
                  CSizedBox.h5(),
                  CTextField(
                    controller: controller.controllerTimeEnd,
                    hintText: "Pilih Waktu Agenda",
                    readOnly: true,
                    suffixIcon: suffixIconClear(() {
                      controller.controllerTimeEnd.clear();
                    }),
                    onTap: () {
                      CTimePicker(Get.context!,
                              timeSelected: controller.controllerTimeEnd.text)
                          .then((value) {
                        if (value != null) {
                          controller.controllerTimeEnd.text = to24(value);
                        }
                      });
                    },
                    validator: (value) {
                      if (GetUtils.isBlank(controller.controllerDateEnd.text) ==
                              false &&
                          GetUtils.isBlank(value) == true) return msgBlank;
                      return null;
                    },
                  ),
                  CSizedBox.h10(),
                  CText("Tipe Formulir"),
                  CSizedBox.h5(),
                  CTextFieldDropDown<String>(
                    hintText: "Pilih Tipe Formulir",
                    value: controller.controllerType.text == ""
                        ? null
                        : controller.controllerType.text,
                    items: form_types
                        .map((e) =>
                            DropdownMenuItem<String>(value: e, child: CText(e)))
                        .toList(),
                    onChange: (value) {
                      if (controller.controllerType.text != value) {
                        controller.controllerType.text = value;
                      }
                    },
                    validator: (value) {
                      debugPrint("TIPE FORMULIR $value");
                      if (value == null ||
                          GetUtils.isBlank(controller.controllerType.text) ==
                              true ||
                          GetUtils.isBlank(value) == true) return msgBlank;
                      return null;
                    },
                  ),
                  CSizedBox.h20(),
                  CText("Pembatasan Instansi Peserta"),
                  CSizedBox.h5(),
                  Obx(() {
                    return Switch(
                      // thumb color (round icon)
                      activeColor: basicPrimary,
                      activeTrackColor: basicPrimaryDark,
                      inactiveThumbColor: Colors.blueGrey.shade600,
                      inactiveTrackColor: Colors.grey.shade400,
                      value: controller.isParticiationLimit.value,
                      onChanged: (value) =>
                          controller.isParticiationLimit.value = value,
                    );
                  }),
                  Divider(
                    height: 10,
                  ),
                  CSizedBox.h5(),
                  CText(
                    "Notifikasi / Pesan Pendaftaran Via WA",
                    style: CText.textStyleBodyBold,
                  ),
                  CSizedBox.h10(),
                  CText("Pesan Verifikasi (Opsional)"),
                  CSizedBox.h5(),
                  Container(
                    height: 50,
                    child: ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              controller.controllerMessage.text =
                                  "${controller.controllerMessage.text} ${controller.tagging[index]}";
                            },
                            child: Container(
                              height: 50,
                              margin: EdgeInsets.all(4),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: basicWhite,
                                  border:
                                      Border.all(width: 1, color: basicBlack)),
                              child: Center(
                                  child: CText(controller.tagging[index])),
                            ),
                          );
                        },
                        itemCount: controller.tagging.length,
                        scrollDirection: Axis.horizontal),
                  ),
                  CTextField(
                    controller: controller.controllerMessage,
                    hintText: "Masukkan Pesan Verifikasi",
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    validator: (value) {
                      return null;
                    },
                    suffixIcon: suffixIconClear(() {
                      controller.controllerMessage.clear();
                    }),
                  ),
                  CSizedBox.h20(),
                  CButton(() {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (!controller.formKey.currentState!.validate()) return;
                    controller.addKegiatan();
                  }, "SIMPAN")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
