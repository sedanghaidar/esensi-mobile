import 'package:absensi_kegiatan/app/data/model/InstansiModel.dart';
import 'package:absensi_kegiatan/app/data/model/InstansiParticipantModel.dart';
import 'package:absensi_kegiatan/app/data/model/RegionModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequestModel.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiHelper.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:absensi_kegiatan/app/data/repository/LaporgubProvider.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/error.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_view/style/AutoCompleteData.dart';

class ManageParticipantController extends GetxController {
  ApiProvider repository = Get.find();
  LaporgubProvider repositoryLaporgub = Get.find();
  String? id = "0";

  RxInt totalInstansi = 0.obs;
  RxInt totalPartisipan = 0.obs;

  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  InstansiModel? selectedInstansi;
  TextEditingController controllerInstansi = TextEditingController();
  List<RegionModel?> selectedRegions = [];
  TextEditingController controllerRegion = TextEditingController();
  TextEditingController controllerMax = TextEditingController();
  final controllerSearch = TextEditingController();
  RxString filter = "".obs;

  final instansi = StatusRequestModel<List<InstansiModel>>().obs;
  final regions = StatusRequestModel<List<RegionModel>>().obs;
  Rx<StatusRequestModel<List<InstansiPartipantModel>>> participants =
      StatusRequestModel<List<InstansiPartipantModel>>().obs;

  @override
  void onInit() {
    id = Get.parameters["id"];
    getInstansiParticipant();
    getInstansiAll();
    getRegion();
    super.onInit();
  }

  getInstansiParticipant() {
    participants.value = StatusRequestModel.loading();
    repository.getInstansiParticipant(id).then((value) {
      if (value.statusRequest == StatusRequest.SUCCESS) {
        if (value.data == null || value.data?.isEmpty == true) {
          participants.value = StatusRequestModel.empty();
        } else {
          participants.value = value;
        }
      } else {
        participants.value = value;
      }
    }, onError: (e) {
      participants.value = StatusRequestModel.error(failure2(e));
    });
  }

  getInstansiAll() {
    repository.getInstansiSemua().then((value) {
      if (value.data?.isEmpty == true) {
        instansi.value = StatusRequestModel.empty();
      } else {
        instansi.value = value;
      }
    }, onError: (e) {
      dialogError(Get.context!, "Terjadi Kesalahan. $e", () {
        Get.back();
        getInstansiAll();
      });
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
      final err = repository.handleError<RegionModel>(e);
      debugPrint("${err.failure?.msgShow}");
    });
  }

  postParticipant(
      RegionModel? regionModel, InstansiModel? instansi, int action) {
    repository.createOrUpdatePartisipanInstansi({
      "activity_id": id,
      "organization_name": instansi?.name,
      "max_participant": controllerMax.text,
      "region_id": regionModel?.id,
      "region_name": regionModel?.name
    }).then((value) {
      if (value.data != null) {
        if (action == 1) {
          InstansiPartipantModel newData =
              value.data!.copyWith(organization: selectedInstansi);
          addParticipantToList(newData);
        } else {
          hideLoading();
          showToast(
              "Berhasil menambah/mengubah data ${selectedInstansi?.name}");
          updateParticipantToList(value.data!);
        }
      }
    }, onError: (e) {
      showToast("Gagal menambah/mengubah data. ${failure2(e).msgShow}");
    });
  }

  createOrUpdateParticipant(int action,
      {InstansiPartipantModel? instansiPartipantModel}) {
    showLoading();
    if (action == 1) {
      for (int i = 0; i < (selectedRegions.length); i++) {
        postParticipant(
            RegionModel(
                id: "${selectedRegions[i]?.id}",
                name: "${selectedRegions[i]?.name}"),
            selectedInstansi,
            action);
      }
      hideLoading();
    } else {
      debugPrint("${instansiPartipantModel?.toJson()}");
      postParticipant(
          RegionModel(
              id: "${instansiPartipantModel?.wilayahId}",
              name: instansiPartipantModel?.wilayahName),
          InstansiModel(
              name: instansiPartipantModel?.organization?.name,
              id: instansiPartipantModel?.organization?.id),
          action);
    }
  }

  addParticipantToList(InstansiPartipantModel data) {
    debugPrint(data.toJson().toString());
    List<InstansiPartipantModel> list =
        List.from(participants.value.data ?? List.empty())..add(data);
    participants.value = StatusRequestModel.success((list));
  }

  updateParticipantToList(InstansiPartipantModel data) {
    List<InstansiPartipantModel> list =
        List.from(participants.value.data ?? List.empty())
          ..map((e) {
            if (e.organization?.id == data.organizationId &&
                e.wilayahId == data.wilayahId) {
              e.maxParticipant = data.maxParticipant;
            }
          }).toList();
    participants.value = StatusRequestModel.success((list));
  }

  deleteParticipant(InstansiPartipantModel? data) {
    showLoading();
    debugPrint("${data?.id}");
    repository.deletePartisipanInstansi("${data?.id}").then((value) {
      hideLoading();
      showToast("Berhasil menghapus data");
      deleteParticipantFromList(data);
    }, onError: (Object e) {
      hideLoading();
      showToast("${(e as StatusRequestModel).failure?.msgShow}");
    });
  }

  deleteParticipantFromList(InstansiPartipantModel? data) {
    List<InstansiPartipantModel> list =
        List.from(participants.value.data ?? List.empty())..remove(data);
    if (list.isEmpty) {
      participants.value = StatusRequestModel.empty();
    } else {
      participants.value = StatusRequestModel.success((list));
    }
  }

  countTotalInstansi() {
    totalInstansi.value = 0;
    for (InstansiPartipantModel i in participants.value.data ?? []) {
      if (i.organization?.name?.toLowerCase().contains(filter) == true) {
        totalInstansi.value++;
      }
    }
  }

  countTotalPartisipan() {
    totalPartisipan.value = 0;
    for (InstansiPartipantModel i in participants.value.data ?? []) {
      if (i.organization?.name?.toLowerCase().contains(filter) == true) {
        totalPartisipan.value = totalPartisipan.value + (i.maxParticipant ?? 0);
      }
    }
  }

  String getNameInstansiPartisipan(InstansiPartipantModel? model) {
    String? name = model?.organization?.name ?? "";
    String? name2 = model?.organization?.parent?.name == null
        ? ""
        : " ${model?.organization?.parent?.name}";
    String? wilayah = model?.wilayahName ?? "";
    return "$name$name2 $wilayah";
  }

  List<AutoCompleteData<RegionModel>>? convertListRegionToAutoCompleteData() {
    return regions.value.data?.map((e) {
      final check = (participants.value.data ?? []).where((element) {
        return element.organization?.id == selectedInstansi?.id &&
            "${element.wilayahId}" == "${e.id}";
      });
      return AutoCompleteData<RegionModel>("${e.name}", e,
          enable: check.isEmpty);
    }).toList();
  }
}
