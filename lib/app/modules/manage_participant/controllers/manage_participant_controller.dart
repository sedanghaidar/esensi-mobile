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

  final instansi = StatusRequestModel<List<InstansiModel>>().obs;
  Rx<StatusRequestModel<List<InstansiPartipantModel>>> participants = StatusRequestModel<List<InstansiPartipantModel>>().obs;

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

  addParticipant(InstansiPartipantModel data){
    List<InstansiPartipantModel> list = List.from(participants.value.data ?? List.empty())..add(data);
    participants.value = StatusRequestModel.success((list));
  }

  updateParticipant(InstansiPartipantModel data){
    List<InstansiPartipantModel> list = List.from(participants.value.data ?? List.empty())..map((e){
      if(e.organization?.name == data.organization?.name){
        e.maxParticipant = data.maxParticipant;
      }
    }).toList();
    participants.value = StatusRequestModel.success((list));
  }

  deleteParticipant(InstansiPartipantModel? data){
    List<InstansiPartipantModel> list = List.from(participants.value.data ?? List.empty())..remove(data);
    if(list.isEmpty){
      participants.value = StatusRequestModel.empty();
    }else{
      participants.value = StatusRequestModel.success((list));
    }
  }

  updateInstansiParticipant(){
    showLoading();
    List<PostPartipantModel> data = [];
    for(InstansiPartipantModel i in participants.value.data??List.empty()){
      data.add(PostPartipantModel(
        activityId: int.parse(id??"0"),
        organizationName: i.organization?.name,
        maxParticipant: i.maxParticipant
      ));
    }
    String json = jsonEncode(data);
    Map<String, dynamic> map = {
      "activity_id" : id,
      "data" : data
    };
    repository.postInstansiParticipant(map).then((value){
      hideLoading();
      getInstansiParticipant();
      showToast("Berhasil menambah data");
    }, onError: (e){
      hideLoading();
      showToast("Terjadi Kesalahan. $e");
    });
  }
}
