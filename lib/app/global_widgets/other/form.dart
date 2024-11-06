import 'package:absensi_kegiatan/app/global_widgets/other/suffix_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utils/colors.dart';
import '../../utils/date.dart';
import '../../utils/string.dart';
import '../dialog/CDatePicker.dart';
import '../sized_box/CSizedBox.dart';
import '../text/CText.dart';
import '../text_field/CTextField.dart';
import '../text_field/CTextFieldDropDown.dart';

Widget formAgendaDefault(
  TextEditingController controller,
  String title,
  String hint, {
  TextInputType? keyboardType,
  TextInputAction? textInputAction,
  String? Function(String?)? validator,
  int? minLines,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CText(title),
      CSizedBox.h5(),
      CTextField(
        controller: controller,
        hintText: hint,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        validator: validator,
        minLines: minLines,
        suffixIcon: suffixIconClear(() {
          controller.clear();
        }),
      ),
      CSizedBox.h10(),
    ],
  );
}

Widget formAgendaDate(
  TextEditingController controller,
  String title,
  String hint, {
  String? Function(String?)? validator,
  String? year,
}) {

  DateTime dateTime = DateTime.now();
  if(year!=null){
    try{
      dateTime = DateTime(int.parse(year));
    }catch(e){
      debugPrint("form.dart $e");
    }
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CText(title),
      CSizedBox.h5(),
      CTextField(
          controller: controller,
          hintText: hint,
          readOnly: true,
          onTap: () {
            debugPrint("YEAR $year");
            CDatePicker(Get.context!,
                    timeSelected: controller.text,
                    firstDate: dateTime)
                .then((value) {
              if (value != null) {
                controller.text = DateFormat("yyyy-MM-dd").format(value);
              }
            });
          },
          suffixIcon: suffixIconClear(() {
            controller.clear();
          }),
          validator: validator),
      CSizedBox.h10(),
    ],
  );
}

Widget formAgendaTime(
  TextEditingController controller,
  String title,
  String hint, {
  String? Function(String?)? validator,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CText(title),
      CSizedBox.h5(),
      CTextField(
          controller: controller,
          hintText: hint,
          readOnly: true,
          suffixIcon: suffixIconClear(() {
            controller.clear();
          }),
          onTap: () {
            CTimePicker(Get.context!, timeSelected: controller.text)
                .then((value) {
              if (value != null) {
                controller.text = to24(value);
              }
            });
          },
          validator: validator),
      CSizedBox.h10(),
    ],
  );
}

Widget formAgendaType(TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CText("Tipe Formulir"),
      CSizedBox.h5(),
      CTextFieldDropDown<String>(
        hintText: "Pilih Tipe Formulir",
        value: controller.text == "" ? null : controller.text,
        items: form_types
            .map((e) => DropdownMenuItem<String>(value: e, child: CText(e)))
            .toList(),
        onChange: (value) {
          if (controller.text != value) {
            controller.text = value;
          }
        },
        validator: (value) {
          debugPrint("TIPE FORMULIR $value");
          if (value == null ||
              GetUtils.isBlank(controller.text) == true ||
              GetUtils.isBlank(value) == true) return msgBlank;
          return null;
        },
      ),
      CSizedBox.h20(),
    ],
  );
}

Widget formAgendaSwitch(RxBool limit) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CText("Pembatasan Instansi Peserta"),
      CSizedBox.h5(),
      Obx(() {
        return Switch(
          // thumb color (round icon)
          activeColor: basicPrimary,
          activeTrackColor: basicPrimaryDark,
          inactiveThumbColor: Colors.blueGrey.shade600,
          inactiveTrackColor: Colors.grey.shade400,
          value: limit.value,
          onChanged: (value) => limit.value = value,
        );
      }),
    ],
  );
}

Widget formAgendaMessageVerification(
    TextEditingController controller, List<String> tagging) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CSizedBox.h5(),
      CText(
        "Notifikasi / Pesan Pendaftaran Via WA",
        style: CText.textStyleBodyBold,
      ),
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
                  controller.text = "${controller.text} ${tagging[index]}";
                },
                child: Container(
                  height: 50,
                  margin: EdgeInsets.all(4),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: basicWhite,
                      border: Border.all(width: 1, color: basicBlack)),
                  child: Center(child: CText(tagging[index])),
                ),
              );
            },
            itemCount: tagging.length,
            scrollDirection: Axis.horizontal),
      ),
      CSizedBox.h5(),
      CTextField(
        controller: controller,
        hintText: "Masukkan Pesan Verifikasi",
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        validator: (value) {
          return null;
        },
        suffixIcon: suffixIconClear(() {
          controller.clear();
        }),
      ),
      CSizedBox.h20(),
    ],
  );
}
