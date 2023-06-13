import 'package:absensi_kegiatan/app/data/model/KegiatanModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/error.dart';
import 'package:absensi_kegiatan/app/routes/app_pages.dart';
import 'package:absensi_kegiatan/app/utils/colors.dart';
import 'package:absensi_kegiatan/app/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/repository/StatusRequestModel.dart';

class CreateAgendaController extends GetxController {
  ApiProvider repository = Get.find();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDate = TextEditingController();
  final TextEditingController controllerTime = TextEditingController();
  final TextEditingController controllerLocation = TextEditingController();
  final TextEditingController controllerInformation = TextEditingController();
  final TextEditingController controllerMessage = TextEditingController();
  final TextEditingController controllerDateEnd = TextEditingController();
  final TextEditingController controllerTimeEnd = TextEditingController();
  final TextEditingController controllerType = TextEditingController();

  final TextEditingController controllerTypeNotif = TextEditingController();

  List<String> tagging = [
    "#nama_peserta",
    "jabatan_peserta",
    "instansi_peserta",
    "nama_agenda",
    "tanggal_agenda",
    "waktu_agenda",
    "lokasi_agenda",
    "informasi_tambahan",
  ];

  final types = [].obs;
  RxBool isParticiationLimit = false.obs;
  final kegiatan = StatusRequestModel<KegiatanModel>();

  getTypes() {
    types.value = form_types;
  }

  addKegiatan() {
    String? datetimeEnd = null;
    if (controllerDateEnd.text != "") {
      datetimeEnd = "${controllerDateEnd.text} ${controllerTimeEnd.text}";
    }

    Map<String, dynamic> data = {
      "name": controllerName.text,
      "date": controllerDate.text,
      "time": controllerTime.text,
      "location": controllerLocation.text,
      "information": controllerInformation.text,
      "verification_message": controllerMessage.text,
      "max_date": "${controllerDateEnd.text} ${controllerTimeEnd.text}",
      "limit_participant": isParticiationLimit.value,
      "type": controllerType.text == TYPE_ABSENSI
          ? TYPE_ABSENSI_CODE
          : TYPE_PENDAFTARAN_CODE
    };

    debugPrint("$data");
    showLoading();
    repository.addNewKegiatan(data).then((value) {
      hideLoading();
      if (value.statusRequest == StatusRequest.SUCCESS) {
        Get.defaultDialog(
            title: "Berhasil",
            middleText: "Berhasil menambah kegiatan",
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

  @override
  void onInit() {
    controllerTypeNotif.text =
        notification_types_map[TYPE_NOTIFICATION_NONE_CODE] ?? "-";
    controllerMessage.text =
        "Terimakasih Bp/Ibu #nama_peserta, #jabatan_peserta dari #instansi_peserta telah mendaftar pada kegiatan *#nama_agenda* .\nKegiatan akan dilaksanakan pada :\nTanggal : #tanggal_agenda\nWaktu : #waktu_agenda WIB - selesai\nTempat : #lokasi_agenda\nCatatan : #informasi_tambahan";
    super.onInit();
  }
}
