import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/button/CButton.dart';
import '../../../global_widgets/other/error.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';
import '../../../utils/constant.dart';
import '../../../utils/string.dart';
import '../../../utils/utils.dart';
import '../controllers/update_agenda_controller.dart';

class UpdateAgendaView extends GetView<UpdateAgendaController> {
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
        title: Text('Ubah Agenda'),
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
            child: Obx(() {
              switch (controller.kegiatan.value.statusRequest) {
                case StatusRequest.LOADING:
                  return loading(context);
                case StatusRequest.SUCCESS:
                  return Form(
                    key: controller.formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        formAgendaDefault(
                            controller.controllerName,
                            "Nama Agenda",
                            "Masukkan Nama Agenda", validator: (value) {
                          if (GetUtils.isBlank(value) == true) {
                            return msgBlank;
                          }
                          return null;
                        }),
                        formAgendaDate(
                          controller.controllerDate,
                          "Tanggal Agenda",
                          "Pilih Tanggal Agenda",
                          validator: (value) {
                            if (GetUtils.isBlank(value) == true) {
                              return msgBlank;
                            }
                            return null;
                          },
                        ),
                        formAgendaTime(
                          controller.controllerTime,
                          "Waktu Agenda",
                          "Pilih Waktu Agenda",
                          validator: (value) {
                            if (GetUtils.isBlank(value) == true) {
                              return msgBlank;
                            }
                            return null;
                          },
                        ),
                        formAgendaDefault(
                            controller.controllerLocation,
                            "Lokasi Agenda",
                            "Masukkan Lokasi Pelaksanaan Agenda",
                            validator: (value) {
                          if (GetUtils.isBlank(value) == true) {
                            return msgBlank;
                          }
                          return null;
                        }),
                        formAgendaDefault(
                          controller.controllerInformation,
                          "Catatan / Informasi Tambahan (Opsional)",
                          "Masukkan catatan / Informasi Tambahan",
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                        ),
                        formAgendaDate(
                            controller.controllerDateEnd,
                            "Tanggal Formulir Berakhir (Opsional)",
                            "Pilih Tanggal Formulir Berakhir"),
                        formAgendaTime(
                          controller.controllerTimeEnd,
                          "Waktu Formulir Berakhir (Opsional)",
                          "Pilih Waktu Formulir Berakhir",
                        ),
                        formAgendaType(controller.controllerType),
                        formAgendaSwitch(controller.isParticiationLimit),
                        const Divider(
                          height: 10,
                        ),
                        formAgendaMessageVerification(
                            controller.controllerMessage, controller.tagging),
                        CButton(() {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (!controller.formKey.currentState!.validate())
                            return;
                          controller.updateKegiatan();
                        }, "SIMPAN")
                      ],
                    ),
                  );
                case StatusRequest.ERROR:
                  return error(
                      context, "${controller.kegiatan.value.failure?.msgShow}",
                      () {
                    controller.getKegiatan();
                  });
                default:
                  return SizedBox();
              }
            }),
          ),
        ),
      ),
    );
  }
}
