import 'package:absensi_kegiatan/app/data/model/KegiatanModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiHelper.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/error.dart';
import 'package:absensi_kegiatan/app/routes/app_pages.dart';
import 'package:absensi_kegiatan/app/utils/colors.dart';
import 'package:absensi_kegiatan/app/utils/date.dart';
import 'package:absensi_kegiatan/app/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/repository/StatusRequestModel.dart';

class UpdateAgendaController extends GetxController {
  ApiProvider repository = Get.find();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDate = TextEditingController();
  final TextEditingController controllerTime = TextEditingController();
  final TextEditingController controllerLocation = TextEditingController();
  final TextEditingController controllerInformation = TextEditingController();
  final TextEditingController controllerDateEnd = TextEditingController();
  final TextEditingController controllerTimeEnd = TextEditingController();
  final TextEditingController controllerType = TextEditingController();

  String? id = null;
  RxBool isParticiationLimit = false.obs;
  final kegiatan = StatusRequestModel<KegiatanModel>().obs;

  @override
  void onInit() {
    id = Get.parameters["id"];
    getKegiatan();
    super.onInit();
  }

  getKegiatan() {
    kegiatan.value = StatusRequestModel.loading();
    repository.getKegiatanById(id).then((value) {
      kegiatan.value = value;
      if (value.statusRequest == StatusRequest.SUCCESS) {
        controllerName.text = value.data?.name ?? "";
        controllerDate.text = value.data?.date == null
            ? ""
            : dateToString(value.data?.date, format: "yyyy-MM-dd");
        controllerTime.text = value.data?.time ?? "";
        controllerLocation.text = value.data?.location ?? "";
        controllerInformation.text = value.data?.information ?? "";
        controllerDateEnd.text = value.data?.dateEnd == null
            ? ""
            : dateToString(value.data?.dateEnd, format: "yyyy-MM-dd");
        controllerTimeEnd.text = value.data?.dateEnd == null
            ? ""
            : dateToString(value.data?.dateEnd, format: "HH:mm:ss");
        controllerType.text = value.data?.type == TYPE_ABSENSI_CODE
            ? TYPE_ABSENSI
            : TYPE_PENDAFTARAN;
        isParticiationLimit.value = value.data?.isLimitParticipant ?? false;
      }
    }, onError: (e) {
      kegiatan.value = StatusRequestModel.error(failure2(e));
    });
  }

  updateKegiatan() {
    Map<String, dynamic> data = {
      "name": controllerName.text,
      "date": controllerDate.text,
      "time": controllerTime.text,
      "location": controllerLocation.text,
      "information": controllerInformation.text,
      "max_date": "${controllerDateEnd.text} ${controllerTimeEnd.text}",
      "limit_participant": isParticiationLimit.value,
      "type": controllerType.text == TYPE_ABSENSI
          ? TYPE_ABSENSI_CODE
          : TYPE_PENDAFTARAN_CODE
    };

    showLoading();
    repository.updateKegiatan(data, id).then((value) {
      hideLoading();
      if (value.statusRequest == StatusRequest.SUCCESS) {
        Get.defaultDialog(
            title: "Berhasil",
            middleText: "Berhasil mengubah data kegiatan",
            textConfirm: "Kembali ke halaman utama",
            barrierDismissible: false,
            onConfirm: () {
              Get.offAllNamed(Routes.DASHBOARD);
              Get.back();
            },
            confirmTextColor: basicWhite,
            buttonColor: basicPrimary);
      } else {
        dialogError(Get.context!, "${value.failure?.msgShow}", () => null);
      }
    }, onError: (e) {
      hideLoading();
      dialogError(Get.context!, "$e", () => null);
    });
  }
}
