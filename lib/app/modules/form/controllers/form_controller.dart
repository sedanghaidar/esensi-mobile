import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:absensi_kegiatan/app/data/model/InstansiModel.dart';
import 'package:absensi_kegiatan/app/data/model/KegiatanModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiHelper.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/error.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../../data/model/repository/StatusRequestModel.dart';
import '../../../global_widgets/dialog/CLoading.dart';
import '../../../global_widgets/dialog/CQrCode.dart';
import '../../../global_widgets/sign/mobile_image_converter.dart'
    if (dart.library.html) '../../../global_widgets/sign/web_image_converter.dart';
import '../../../routes/app_pages.dart';

class FormController extends GetxController {
  ApiProvider repository = Get.find();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerInstansi = TextEditingController();
  TextEditingController controllerInstansiManual = TextEditingController();
  final TextEditingController controllerJabatan = TextEditingController();
  final GlobalKey<SfSignaturePadState> signaturePadKey = GlobalKey();
  final GlobalKey qrKey = GlobalKey();

  final kegiatan = StatusRequestModel<KegiatanModel>().obs;
  final instansi = StatusRequestModel<List<InstansiModel>>().obs;

  RxBool isSigned = false.obs;
  RxBool isOpenInstansi = false.obs;

  bool handleOnDrawStart() {
    isSigned.value = true;
    return false;
  }

  setIsOpenInstansi(bool value) {
    isOpenInstansi.value = value;
    debugPrint("IS OPEN INSTANSI ${isOpenInstansi.value}");
  }

  getKegiatan(String code) {
    kegiatan.value = StatusRequestModel.loading();
    repository.getKegiatanByCode(code).then((value) {
      kegiatan.value = value;
      if (kegiatan.value.data?.isLimitParticipant == true) {
        getInstansi();
      } else {
        getInstansiAll();
      }
    }, onError: (e) {
      kegiatan.value = StatusRequestModel.error(failure2(e));
    });
  }

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

  getInstansiAll() {
    instansi.value = StatusRequestModel.loading();
    repository.getInstansiSemua().then((value) {
      if (value.data?.isEmpty == true) {
        instansi.value = StatusRequestModel.empty();
      } else {
        value.data?.add(InstansiModel(name: "LAINNYA"));
        instansi.value = value;
      }
    }, onError: (e) {
      instansi.value = StatusRequestModel.error(failure2(e));
    });
  }

  Future<Uint8List> convertImage() async {
    late Uint8List img;
    if (kIsWeb) {
      final RenderSignaturePad renderSignaturePad =
          signaturePadKey.currentState!.context.findRenderObject()!
              as RenderSignaturePad;
      img =
          await ImageConverter.toImage(renderSignaturePad: renderSignaturePad);
    } else {
      final ui.Image imageData =
          await signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
      final ByteData? bytes =
          await imageData.toByteData(format: ui.ImageByteFormat.png);
      if (bytes != null) {
        img = bytes.buffer.asUint8List();
      }
    }
    return img;
  }

  insertPeserta() async {
    // late Uint8List img;
    // if (kIsWeb) {
    //   final RenderSignaturePad renderSignaturePad =
    //   signaturePadKey.currentState!.context.findRenderObject()!
    //   as RenderSignaturePad;
    //   img =
    //       await ImageConverter.toImage(renderSignaturePad: renderSignaturePad);
    // } else {
    //   final ui.Image imageData =
    //       await signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
    //   final ByteData? bytes =
    //       await imageData.toByteData(format: ui.ImageByteFormat.png);
    //   if (bytes != null) {
    //     img = bytes.buffer.asUint8List();
    //   }
    // }

    convertImage().then((value) {
      String i = controllerInstansi.text;
      if (i == "LAINNYA") {
        i = controllerInstansiManual.text;
      }

      Map<String, dynamic> data = {
        "activity_id": kegiatan.value.data?.id,
        "name": controllerName.text,
        "jabatan": controllerJabatan.text,
        "instansi": i,
        "nohp": controllerPhone.text,
        "signature": MultipartFile(value,
            filename: "${controllerName.text}_${kegiatan.value.data?.id}.jpeg")
      };
      showLoading();
      repository.insertPeserta(data).then((result) {
        hideLoading();
        if (result.statusRequest == StatusRequest.SUCCESS) {
          debugPrint("SUKSES LHO");
          Get.offAllNamed("${Routes.DETAIL_PESERTA}/${result.data?.id}");
        } else {
          debugPrint("${result.failure?.msgShow}");
          dialogError(
              Get.context!, "Terjadi Kesalahan. ${result.failure?.msgShow}",
              () {
            Get.back();
            insertPeserta();
          });
        }
      }, onError: (e) {
        hideLoading();
        debugPrint("$e");
        dialogError(Get.context!, "Terjadi Kesalahan ${e}", () {
          Get.back();
          insertPeserta();
        });
      });
    });
  }
}
