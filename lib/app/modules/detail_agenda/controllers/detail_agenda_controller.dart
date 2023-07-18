import 'dart:core';

import 'package:absensi_kegiatan/app/data/model/InstansiParticipantModel.dart';
import 'package:absensi_kegiatan/app/data/model/KegiatanModel.dart';
import 'package:absensi_kegiatan/app/data/model/NotulenModel.dart';
import 'package:absensi_kegiatan/app/data/model/PesertaModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequestModel.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiHelper.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:absensi_kegiatan/app/data/repository/LaporgubProvider.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/utils/date.dart';
import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:magic_view/style/AutoCompleteData.dart';

import '../../../data/model/InstansiModel.dart';
import '../../../data/model/RegionModel.dart';
import '../../../global_widgets/other/toast.dart';
import '../../../utils/colors.dart';
import '../../../utils/string.dart';

class DetailAgendaController extends GetxController {
  ApiProvider repository = Get.find();
  LaporgubProvider repositoryLaporgub = Get.find();

  String? id = "0";
  final kegiatan = StatusRequestModel<KegiatanModel>().obs;
  final peserta = StatusRequestModel<List<PesertaModel>>().obs;
  final notulen = StatusRequestModel<NotulenModel>().obs;
  final regions = StatusRequestModel<List<RegionModel>>().obs;
  final instansi = StatusRequestModel<List<InstansiModel>>().obs;

  final controllerSearch = TextEditingController();

  RxList<PesertaModel> pesertaFilter = <PesertaModel>[].obs;
  String? filterTeks;
  String? filterStatus;
  AutoCompleteData<RegionModel>? filterRegion;
  AutoCompleteData<InstansiModel>? filterInstansi;

  // RxString filter = "".obs;
  // RxString status = "1".obs; //filter status scanned
  RxInt totalInstansi = 0.obs;
  RxInt totalScanned = 0.obs;
  RxInt totalUnScanned = 0.obs;

  bool showDetailAgenda = true;

  @override
  void onInit() {
    id = Get.parameters["id"];
    getDaftarPeserta();
    super.onInit();
  }

  @override
  void onReady() {
    getDetailKegiatan();
    super.onReady();
  }

  filterPeserta() {
    List<PesertaModel> list = peserta.value.data ?? [];

    //Filter nama
    list = list.where((element) {
      final nameLower = (element.name ?? "").toLowerCase();
      final instansiLower = getOptionString(element.instansiDetail).toLowerCase();
      final filterTeksLower = (filterTeks ?? "").toLowerCase();

      return nameLower.contains(filterTeksLower) ||
          instansiLower.contains(filterTeksLower);
    }).toList();

    //Filter status
    list = list.where((element) {
      if (filterStatus == "SCANNED") {
        return element.scannedAt != null;
      } else if (filterStatus == "UNSCANNED") {
        return element.scannedAt == null;
      } else {
        return true;
      }
    }).toList();

    //Filter region
    list = list.where((element) {
      if (filterRegion != null) {
        return "${element.wilayahId}" == filterRegion?.data?.id;
      }
      return true;
    }).toList();

    //Filter instansi
    list = list.where((element) {
      if (filterInstansi != null) {
        return element.instansiDetail?.id == filterInstansi?.data?.id;
      }
      return true;
    }).toList();

    pesertaFilter.value = list;
  }

  countResume() {
    totalUnScanned.value = (peserta.value.data ?? [])
        .where((element) => element.scannedAt == null)
        .length;
    totalScanned.value = (peserta.value.data ?? [])
        .where((element) => element.scannedAt != null)
        .length;
    totalInstansi.value = groupBy<PesertaModel, Map<String, dynamic>?>(
            (peserta.value.data ?? []),
            (obj) => {"wilayah": obj.wilayahId, "instansi": obj.instansiDetail})
        .length;
  }

  getDetailKegiatan() {
    kegiatan.value = StatusRequestModel.loading();
    update(['detail-kegiatan']);
    repository.getKegiatanById(id).then((value) {
      kegiatan.value = value;
      update(['detail-kegiatan']);
    }, onError: (e) {
      final err = repository.handleError<KegiatanModel>(e);
      kegiatan.value = err;
      update(['detail-kegiatan']);
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
        pesertaFilter.value = value.data ?? [];
        countResume();
      }
    }, onError: (e) {
      final err = repository.handleError<List<PesertaModel>>(e);
      peserta.value = err;
    });
  }

  scanQrPeserta(PesertaModel pesertaModel) {
    showLoading();
    Map<String, dynamic> data = {
      "qr_code": pesertaModel.qrCode,
    };
    repository.scanPeserta(data).then((value) {
      hideLoading();

      Get.defaultDialog(
        title: "Berhasil Scan",
        middleText:
            "Selamat datang, ${value.data?.name} - ${value.data?.instansi}",
        barrierDismissible: false,
        confirmTextColor: basicWhite,
        buttonColor: basicPrimary,
        onConfirm: () {
          Get.back();
          refreshPesertaAfterScan(
              pesertaModel,
              value.data!
                  .copyWith(instansiDetail: pesertaModel.instansiDetail));
        },
      );
    }, onError: (e) {
      hideLoading();
      final err = repository.handleError<PesertaModel>(e);
      Get.defaultDialog(
        title: "PERHATIAN",
        middleText: "${err.failure?.msgShow}",
        barrierDismissible: false,
        confirmTextColor: basicWhite,
        buttonColor: basicPrimary,
        onConfirm: () {
          Get.back();
        },
      );
    });
  }

  refreshPesertaAfterScan(PesertaModel before, PesertaModel after) {
    ;
    int? indexPeserta =
        peserta.value.data?.indexWhere((element) => element.id == before.id);
    if (indexPeserta != null && indexPeserta != -1) {
      peserta.value.data?[indexPeserta] = after;
    }
    int? indexPesertaFilter =
        pesertaFilter.indexWhere((element) => element.id == before.id);
    if (indexPesertaFilter != -1) {
      pesertaFilter[indexPesertaFilter] = after;
    }
    countResume();
  }

  refreshPesertaAfterDelete(PesertaModel? pesertaModel) {
    pesertaFilter.remove(pesertaModel);
    peserta.value.data?.remove(pesertaModel);
    peserta.value = StatusRequestModel.success(peserta.value.data ?? []);
    countResume();
  }

  deletePeserta(PesertaModel? pesertaModel) {
    showLoading();
    repository.deletePeserta(pesertaModel?.id).then((value) {
      hideLoading();
      Get.defaultDialog(
        title: "Berhasil",
        middleText:
            "Berhasil menghapus, ${value.data?.name} - ${value.data?.instansi}",
        barrierDismissible: false,
        confirmTextColor: basicWhite,
        buttonColor: basicPrimary,
        onConfirm: () {
          Get.back();
          refreshPesertaAfterDelete(pesertaModel);
          // List<PesertaModel> newData = peserta.value.data ?? [];
          // newData.removeWhere((element) => element.id == id);
          // peserta.value.data = newData;
          // pesertaFilter.value = newData;
          // peserta.value = StatusRequestModel.success(peserta.value.data ?? []);
        },
      );
    }, onError: (e) {
      hideLoading();
      final err = repository.handleError<PesertaModel>(e);
      Get.defaultDialog(
        title: "PERHATIAN",
        middleText: "${err.failure?.msgShow}",
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
            if (groups?.containsKey(data.organization?.name?.toUpperCase()) ==
                true) {
              sudahTerdaftarNumber++;
              sudahTerdaftar +=
                  "$sudahTerdaftarNumber. *${data.organization?.name}* (jumlah : ${groups?[data.organization?.name]?.length})\n";
              for (PesertaModel psrta
                  in groups![data.organization?.name?.toUpperCase()]!) {
                sudahTerdaftar += "\t- ${psrta.name}\n";
              }
            } else {
              belumTerdaftarNumber++;
              belumTerdaftar +=
                  "$belumTerdaftarNumber. *${data.organization?.name}* (jumlah: ${groups?[data.organization?.name]?.length ?? 0})\n";
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

  getNotulen() {
    notulen.value = StatusRequestModel.loading();
    repository.getNotulen(id ?? "").then((value) {
      notulen.value = value;
    }, onError: (e) {
      final err = repository.handleError<NotulenModel>(e);
      notulen.value = err;
    });
  }

  getRegion() {
    repositoryLaporgub.getRegion().then((value) {
      if (value.data?.isEmpty == true) {
        regions.value = StatusRequestModel.empty();
      } else {
        regions.value = value;
      }
    }, onError: (e) {
      final err = repository.handleError<List<RegionModel>>(e);
      regions.value = err;
    });
  }

  /// Mendapatkan daftar instansi yang sudah dipilih
  /// Jika isLimitParticipnat = true
  getInstansi() {
    instansi.value = StatusRequestModel.loading();
    repository.getInstansi("${kegiatan.value.data?.id}").then((value) {
      if (value.data?.isEmpty == true) {
        instansi.value = StatusRequestModel.empty();
      } else {
        instansi.value = value;
      }
    }, onError: (e) {
      instansi.value = StatusRequestModel.error(failure2(e));
    });
  }

  /// Mendapatkan daftar semua instansi
  getInstansiAll() {
    instansi.value = StatusRequestModel.loading();
    repository.getInstansiSemua().then((value) {
      if (value.data?.isEmpty == true) {
        instansi.value = StatusRequestModel.empty();
      } else {
        value.data?.insert(0, InstansiModel(name: "LAINNYA"));
        instansi.value = value;
      }
    }, onError: (e) {
      instansi.value = StatusRequestModel.error(failure2(e));
    });
  }

  List<AutoCompleteData<InstansiModel>> getListInstansi() {
    List<AutoCompleteData<InstansiModel>> result = [];
    List<AutoCompleteData<InstansiModel>> list =
        (instansi.value.data ?? []).map((e) {
      return getOption(e);
    }).toList();

    for (AutoCompleteData<InstansiModel> model in list) {
      if (!result.any((element) => element.option == model.option)) {
        result.add(model);
      }
    }
    return result;
  }
}
