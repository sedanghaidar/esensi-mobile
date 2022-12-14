import 'package:absensi_kegiatan/app/data/model/KegiatanModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/FailureModel.dart';
import 'package:absensi_kegiatan/app/data/static/dummy/kegiatan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../../data/model/repository/StatusRequestModel.dart';
import '../../../data/static/instansi.dart';

class FormController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerInstansi = TextEditingController();
  final TextEditingController controllerJabatan = TextEditingController();
  final GlobalKey<SfSignaturePadState> signaturePadKey = GlobalKey();
  final GlobalKey qrKey = GlobalKey();

  final focusNodeName = FocusNode();
  final focusNodePhone = FocusNode();
  final focusNodeInstansi = FocusNode();
  final focusNodeJabatan = FocusNode();

  final kegiatan = StatusRequestModel<KegiatanModel>().obs;
  final instansi = StatusRequestModel<List<String>>().obs;

  RxBool isSigned = false.obs;

  bool handleOnDrawStart() {
    isSigned.value = true;
    return false;
  }

  getKegiatan(String id){
    debugPrint("GET KEGIATAN");
    kegiatan.value = StatusRequestModel.loading();
    Future.delayed(const Duration(milliseconds: 2000), () {
      kegiatan.value = StatusRequestModel.success(kegiatanModel1);
      if(kegiatan.value.data?.isLimitParticipant==true){
        getInstansi();
      }
    });
  }

  getInstansi(){
    instansi.value = StatusRequestModel.loading();
    Future.delayed(const Duration(milliseconds: 2000), () {
      instansi.value = StatusRequestModel.success(all_instansi);
      // instansi.value = StatusRequestModel.error(FailureModel(400, "Error", "Error"));
    });
  }
}
