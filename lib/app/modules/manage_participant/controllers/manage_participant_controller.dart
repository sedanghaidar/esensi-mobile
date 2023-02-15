import 'dart:convert';

import 'package:absensi_kegiatan/app/data/model/InstansiModel.dart';
import 'package:absensi_kegiatan/app/data/model/InstansiParticipantModel.dart';
import 'package:absensi_kegiatan/app/data/model/PostParticipantModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequestModel.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiHelper.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/error.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageParticipantController extends GetxController {
  ApiProvider repository = Get.find();
  String? id = "0";

  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  TextEditingController controllerInstansi = TextEditingController();
  TextEditingController controllerMax = TextEditingController();
  final controllerSearch = TextEditingController();
  RxString filter = "".obs;

  final instansi = StatusRequestModel<List<InstansiModel>>().obs;
  Rx<StatusRequestModel<List<InstansiPartipantModel>>> participants =
      StatusRequestModel<List<InstansiPartipantModel>>().obs;

  @override
  void onInit() {
    id = Get.parameters["id"];
    getInstansiParticipant();
    getInstansiAll();
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

  createOrUpdateParticipant(int action) {
    showLoading();
    repository.createOrUpdatePartisipanInstansi({
      "activity_id": id,
      "organization_name": controllerInstansi.text,
      "max_participant": controllerMax.text
    }).then((value) {
      hideLoading();
      showToast("Berhasil menambah/mengubah data");
      if (value.data != null) {
        if (action == 1) {
          addParticipantToList(value.data!.copyWith(organization: InstansiModel(
            id: value.data?.organizationId,
            name: controllerInstansi.text
          )));
        } else {
          updateParticipantToList(value.data!);
        }
      }
    }, onError: (e) {
      hideLoading();
      showToast("Gagal menambah/mengubah data. ${failure2(e).msgShow}");
    });
  }

  addParticipantToList(InstansiPartipantModel data) {
    List<InstansiPartipantModel> list =
        List.from(participants.value.data ?? List.empty())..add(data);
    participants.value = StatusRequestModel.success((list));
  }

  updateParticipantToList(InstansiPartipantModel data) {
    List<InstansiPartipantModel> list =
        List.from(participants.value.data ?? List.empty())
          ..map((e) {
            if (e.organization?.id == data.organizationId) {
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
}
