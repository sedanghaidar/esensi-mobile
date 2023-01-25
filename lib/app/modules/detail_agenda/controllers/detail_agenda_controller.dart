import 'package:absensi_kegiatan/app/data/model/InstansiParticipantModel.dart';
import 'package:absensi_kegiatan/app/data/model/KegiatanModel.dart';
import 'package:absensi_kegiatan/app/data/model/PesertaModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequestModel.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiHelper.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/error.dart';
import 'package:absensi_kegiatan/app/utils/date.dart';
import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../global_widgets/other/toast.dart';
import '../../../utils/colors.dart';

class DetailAgendaController extends GetxController {
  ApiProvider repository = Get.find();

  String? id = "0";
  final kegiatan = StatusRequestModel<KegiatanModel>().obs;
  final peserta = StatusRequestModel<List<PesertaModel>>().obs;
  RxList<PesertaModel> pesertaFilter = <PesertaModel>[].obs;

  final controllerSearch = TextEditingController();
  RxString filter = "".obs;
  RxString status = "1".obs;        //filter status scanned
  RxInt totalInstansi = 0.obs;
  RxInt totalScanned = 0.obs;
  RxInt totalUnScanned = 0.obs;

  @override
  void onInit() {
    id = Get.parameters["id"];
    getDaftarPeserta();
    super.onInit();
  }

  getDetailKegiatan() {
    showLoading();
    repository.getKegiatanById(id).then((value) {
      hideLoading();
      if (value.statusRequest == StatusRequest.SUCCESS) {
        kegiatan.value = value;
      } else {
        dialogError(
            Get.context!,
            "Terjadi Kesalahan. ${value.failure?.msgShow}",
            () => getDetailKegiatan());
      }
    }, onError: (e) {
      hideLoading();
      dialogError(
          Get.context!, "Terjadi Kesalahan. $e", () => getDetailKegiatan());
    });
  }

  getDaftarPeserta() {
    peserta.value = StatusRequestModel.loading();
    repository.getPesertaByKegiatan(id).then((value) {
      if (value.data == null || value.data?.isEmpty == true) {
        peserta.value = StatusRequestModel.empty();
        totalUnScanned.value = 0;
        totalScanned.value = 0;
        totalInstansi.value = 0;
      } else {
        peserta.value = value;
        totalUnScanned.value = (peserta.value.data ?? [])
            .where((element) => element.scannedAt == null)
            .length;
        totalScanned.value = (peserta.value.data ?? [])
            .where((element) => element.scannedAt != null)
            .length;
        totalInstansi.value = groupBy(
                (peserta.value.data ?? []), <PesertaModel>(obj) => obj.instansi)
            .length;
      }
    }, onError: (e) {
      debugPrint(e);
      peserta.value = StatusRequestModel.error(failure2(e));
    });
  }

  scanQrPeserta(String? qrCode) {
    showLoading();
    Map<String, dynamic> data = {
      "qr_code": qrCode,
    };
    repository.scanPeserta(data).then((value) {
      hideLoading();
      if (value.statusRequest == StatusRequest.SUCCESS) {
        Get.defaultDialog(
          title: "Berhasil Scan",
          middleText:
              "Selamat datang, ${value.data?.name} - ${value.data?.instansi}",
          barrierDismissible: false,
          confirmTextColor: basicWhite,
          buttonColor: basicPrimary,
          onConfirm: () {
            Get.back();
            int? index = peserta.value.data?.indexWhere((element) => element.name == value.data?.name);
            if (index != null) {
              totalScanned.value = totalScanned.value+1;
              totalUnScanned.value = totalUnScanned.value-1;
              peserta.value.data?[index] = value.data!;
              peserta.value = StatusRequestModel.success(peserta.value.data ?? []);
            }
          },
        );
      } else {
        if (value.failure?.code == 400) {
          Get.defaultDialog(
            title: "PERHATIAN",
            middleText: "${value.failure?.msgShow}",
            barrierDismissible: false,
            confirmTextColor: basicWhite,
            buttonColor: basicPrimary,
            onConfirm: () {
              Get.back();
            },
          );
        }
      }
    }, onError: (e) {
      hideLoading();
      Get.defaultDialog(
        title: "PERHATIAN",
        middleText: "${e.toString()}",
        barrierDismissible: false,
        confirmTextColor: basicWhite,
        buttonColor: basicPrimary,
        onConfirm: () {
          Get.back();
        },
      );
    });
  }

  deletePeserta(int? id) {
    showLoading();
    repository.deletePeserta(id).then((value) {
      hideLoading();
      if (value.statusRequest == StatusRequest.SUCCESS) {
        Get.defaultDialog(
          title: "Berhasil",
          middleText:
              "Berhasil menghapus, ${value.data?.name} - ${value.data?.instansi}",
          barrierDismissible: false,
          confirmTextColor: basicWhite,
          buttonColor: basicPrimary,
          onConfirm: () {
            Get.back();
            List<PesertaModel> newData = peserta.value.data ?? [];
            newData.removeWhere((element) => element.id == id);
            peserta.value.data = newData;
            peserta.value =
                StatusRequestModel.success(peserta.value.data ?? []);
          },
        );
      } else {
        if (value.failure?.code == 400) {
          Get.defaultDialog(
            title: "PERHATIAN",
            middleText: "${value.failure?.msgShow}",
            barrierDismissible: false,
            confirmTextColor: basicWhite,
            buttonColor: basicPrimary,
            onConfirm: () {
              Get.back();
            },
          );
        }
      }
    }, onError: (e) {
      hideLoading();
      Get.defaultDialog(
        title: "PERHATIAN",
        middleText: "${e.toString()}",
        barrierDismissible: false,
        confirmTextColor: basicWhite,
        buttonColor: basicPrimary,
        onConfirm: () {
          Get.back();
        },
      );
    });
  }

  getInstansiParticipant() {
    showLoading();
    repository.getInstansiParticipant(id).then((value) async {
      if (value.statusRequest == StatusRequest.SUCCESS) {
        hideLoading();
        if (value.data == null || value.data?.isEmpty == true) {
          //empty
        } else {
          String sudahTerdaftar = "";
          int sudahTerdaftarNumber = 0;
          String belumTerdaftar = "";
          int belumTerdaftarNumber = 0;

          Map<dynamic, List<PesertaModel>>? groups =
              peserta.value.data?.groupListsBy((element) => element.instansi);

          for (InstansiPartipantModel data in value.data!) {
            if (groups?.containsKey(data.organization?.name?.toUpperCase()) == true) {
              sudahTerdaftarNumber++;
              sudahTerdaftar += "$sudahTerdaftarNumber. *${data.organization?.name}* (jumlah : ${groups?[data.organization?.name]?.length})\n";
              for(PesertaModel psrta in groups![data.organization?.name?.toUpperCase()]!){
                sudahTerdaftar += "\t- ${psrta.name}\n";
              }
            } else {
              belumTerdaftarNumber++;
              belumTerdaftar += "$belumTerdaftarNumber. *${data.organization?.name}* (jumlah: ${groups?[data.organization?.name]?.length??0})\n";
            }
          }
          await Clipboard.setData(ClipboardData(
                  text:
                      "Rekap ${kegiatan.value.data?.name}\nTanggal ${dateToString(kegiatan.value.data?.date, format: "EEEE, dd MMMM yyyy")}\n\nSudah Daftar (Total $sudahTerdaftarNumber) :\n$sudahTerdaftar\n\nBelum Daftar (Total $belumTerdaftarNumber) : \n$belumTerdaftar"))
              .whenComplete(() {
            showToast("Berhasil menyalin nama!");
          });
        }
      } else {
        //maybe error
      }
    }, onError: (e) {
      hideLoading();
    });
  }

  @override
  void onReady() {
    getDetailKegiatan();
    super.onReady();
  }
}
