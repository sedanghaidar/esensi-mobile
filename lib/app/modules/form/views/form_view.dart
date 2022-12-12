import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/global_widgets/button/CButtonStyle.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/error.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/toast.dart';
import 'package:absensi_kegiatan/app/global_widgets/text_field/CAutoCompleteString.dart';
import 'package:absensi_kegiatan/app/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../../global_widgets/button/CButton.dart';
import '../../../global_widgets/other/suffix_icon.dart';
import '../../../global_widgets/sized_box/CSizedBox.dart';
import '../../../global_widgets/text/CText.dart';
import '../../../global_widgets/text_field/CTextField.dart';
import '../../../utils/colors.dart';
import '../../../utils/constant.dart';
import '../../../utils/string.dart';
import '../../../utils/utils.dart';
import '../controllers/form_controller.dart';

class FormView extends GetView<FormController> {
  double width = 0;

  @override
  Widget build(BuildContext context) {
    width = context.width;
    final orientation = getPlatform(context);
    if (orientation == WEB_LANDSCAPE || orientation == DESKTOP_LANDSCAPE) {
      width = width / 2;
    } else {
      width = context.width;
    }

    debugPrint("BUILD!");
    String id = Get.parameters['id'].toString();
    controller.getKegiatan(id);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: basicPrimary,
        title: Text('Formulir'),
        centerTitle: true,
      ),
      backgroundColor: basicGrey4,
      body: Obx(() {
        switch (controller.kegiatan.value.statusRequest) {
          case StatusRequest.LOADING:
            return loading(context);
          case StatusRequest.SUCCESS:
            {
              if (checkOutDate(
                  controller.kegiatan.value.data?.date ?? DateTime.now(),
                  controller.kegiatan.value.data?.dateEnd)) {
                return warning(context,
                    "Formulir sudah ditutup atau tanggal kegiatan sudah lewat");
              }
              return successBody(context);
            }
          default:
            return SizedBox();
        }
      }),
    );
  }

  successBody(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.topLeft,
        color: basicWhite,
        width: width,
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CText.header("${controller.kegiatan.value.data?.name}"),
                CSizedBox.h5(),
                CText("Kegiatan akan dilaksanakan pada :"),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 5),
                  child: RichText(
                      text: TextSpan(children: [
                    WidgetSpan(child: Icon(Icons.calendar_month)),
                    WidgetSpan(child: CSizedBox.w5()),
                    WidgetSpan(
                        child: CText(
                            "${dateToString(controller.kegiatan.value.data?.date)}"))
                  ])),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 5),
                  child: RichText(
                      text: TextSpan(children: [
                    WidgetSpan(child: Icon(Icons.access_time_rounded)),
                    WidgetSpan(child: CSizedBox.w5()),
                    WidgetSpan(
                        child: CText(
                            "${controller.kegiatan.value.data?.time} - selesai"))
                  ])),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 5),
                  child: RichText(
                      text: TextSpan(children: [
                    WidgetSpan(child: Icon(Icons.location_on_outlined)),
                    WidgetSpan(child: CSizedBox.w5()),
                    WidgetSpan(
                        child: CText(
                            "${controller.kegiatan.value.data?.location}"))
                  ])),
                ),
                Visibility(
                  visible: controller.kegiatan.value.data?.dateEnd == null
                      ? false
                      : true,
                  child: Container(
                    margin: EdgeInsets.only(left: 10, top: 5),
                    child: CText(
                      "Formulir akan ditutup pada ${dateToString(controller.kegiatan.value.data?.dateEnd)}",
                      style: CText.textStyleBody.copyWith(color: basicRed1),
                    ),
                  ),
                ),
                CSizedBox.h20(),
                CText("Nama"),
                CSizedBox.h5(),
                CTextField(
                  controller: controller.controllerName,
                  hintText: "Masukkan Nama",
                  validator: (value) {
                    if (GetUtils.isBlank(value) == true) return msgBlank;
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                ),
                CSizedBox.h10(),
                CText("No. Telp"),
                CSizedBox.h5(),
                CTextField(
                  controller: controller.controllerPhone,
                  hintText: "Masukkan No. Telp",
                  validator: (value) {
                    if (GetUtils.isBlank(value) == true) return msgBlank;
                    if (GetUtils.isPhoneNumber(value) == false)
                      return msgPhoneNotValid;
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                ),
                CSizedBox.h10(),
                CText("Instansi"),
                CSizedBox.h5(),
                Obx(() {
                  switch (controller.instansi.value.statusRequest) {
                    case StatusRequest.LOADING:
                      return loading(context);
                    case StatusRequest.SUCCESS:
                      List<String> result =
                          controller.instansi.value.data ?? List.empty();
                      return CAutoCompleteString(
                        controller.controllerInstansi,
                        (text) {
                          if (text.text.isEmpty) {
                            return result;
                          } else {
                            return (result).where((element) => (element)
                                .toLowerCase()
                                .contains(text.text.toLowerCase()));
                          }
                        },
                        result.length,
                        widthOPtions: width - 40,
                        validator: (value) {
                          if (GetUtils.isBlank(value) == true) return msgBlank;
                          if (result.contains(value) == false)
                            return "Silahkan pilih salah satu dari pilihan yang ada";
                          return null;
                        },
                      );
                    case StatusRequest.ERROR:
                      return error(
                          context,
                          controller.instansi.value.failure?.msgShow,
                          () => controller.getInstansi());
                    default:
                      return CTextField(
                        controller: controller.controllerInstansi,
                        hintText: "Masukkan Instansi",
                        validator: (value) {
                          if (GetUtils.isBlank(value) == true) return msgBlank;
                          return null;
                        },
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                      );
                  }
                }),
                CSizedBox.h10(),
                CText("Jabatan"),
                CSizedBox.h5(),
                CTextField(
                  controller: controller.controllerJabatan,
                  hintText: "Masukkan Jabatan",
                  validator: (value) {
                    if (GetUtils.isBlank(value) == true) return msgBlank;
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                ),
                CSizedBox.h10(),
                CText("Tanda Tangan"),
                CSizedBox.h5(),
                Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: basicBlack)),
                  child: SfSignaturePad(
                      minimumStrokeWidth: 1,
                      maximumStrokeWidth: 1,
                      strokeColor: basicBlack,
                      backgroundColor: basicWhite,
                      onDrawStart: controller.handleOnDrawStart,
                      key: controller.signaturePadKey),
                ),
                CSizedBox.h5(),
                Align(
                  alignment: Alignment.centerRight,
                  child: CButton.small(
                    () {
                      controller.isSigned.value = false;
                      controller.signaturePadKey.currentState?.clear();
                    },
                    "CLEAR",
                    style: styleButtonFilledBoxSmall2,
                  ),
                ),
                CSizedBox.h20(),
                CButton(() {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (!controller.formKey.currentState!.validate()) return;
                  if (GetUtils.isBlank(controller.controllerInstansi.text) == true) {
                    showToast("Anda harus memilih instansi terlebih dahulu");
                    return;
                  }
                  if (!controller.isSigned.value) {
                    showToast("Tanda tangan terlebih dahulu");
                    return;
                  }
                }, "SIMPAN")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
