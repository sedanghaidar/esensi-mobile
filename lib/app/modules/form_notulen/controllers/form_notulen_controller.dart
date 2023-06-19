import 'package:absensi_kegiatan/app/data/model/NotulenModel.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CDialog.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class FormNotulenController extends GetxController {
  ApiProvider repository = Get.find();

  String? activityId;
  NotulenModel? notulen;

  final formKey = GlobalKey<FormState>();
  TextEditingController controllerNoSurat = TextEditingController();
  QuillEditorController controllerNotulenQuil = QuillEditorController();
  TextEditingController controllerJabatan = TextEditingController();
  TextEditingController controllerNama = TextEditingController();
  TextEditingController controllerPangkat = TextEditingController();
  TextEditingController controllerNIP = TextEditingController();
  XFile? image1;
  XFile? image2;
  XFile? image3;

  settingImage(XFile? file, int index) {
    switch (index) {
      case 1:
        {
          image1 = file;
          break;
        }
      case 2:
        {
          image2 = file;
          break;
        }
      case 3:
        {
          image3 = file;
          break;
        }
    }
    update(['images']);
  }

  getImage(int index) {
    switch (index) {
      case 1:
        return image1;
      case 2:
        return image2;
      case 3:
        return image3;
    }
  }

  getImageUrl(int index) {
    switch (index) {
      case 1:
        return notulen?.image1;
      case 2:
        return notulen?.image2;
      case 3:
        return notulen?.image3;
    }
  }

  postNewNotulen() async {
    FormData data = await parseToFormData();
    showLoading();
    repository.postNewNotulen(data).then((value) {
      hideLoading();
      notulen = value.data;
      clearAllForm();
      initData();
      showCDialogMessageSuccess(
          Get.context!, "Berhasil", "Berhasil menyimpan notulen");
    }, onError: (e) {
      hideLoading();
      debugPrint("gagal");
    });
  }

  updateNotulen() async {
    FormData data = await parseToFormData();
    showLoading();
    repository.updateNewNotulen(data, "${notulen?.id}").then((value) {
      hideLoading();
      notulen = value.data;
      clearAllForm();
      initData();
      showCDialogMessageSuccess(
          Get.context!, "Berhasil", "Berhasil menyimpan notulen");
    }, onError: (e) {
      hideLoading();
      debugPrint("gagal");
    });
  }

  clearAllForm() {
    controllerNoSurat.clear();
    controllerNotulenQuil.clear();
    controllerJabatan.clear();
    controllerNama.clear();
    controllerNIP.clear();
    controllerPangkat.clear();
    image1 = null;
    image2 = null;
    image3 = null;
  }

  initData() {
    if (notulen != null) {
      controllerNoSurat.text = notulen?.nosurat ?? "";
      controllerNotulenQuil.insertText(notulen?.delta ?? "");
      controllerJabatan.text = notulen?.jabatan ?? "";
      controllerNama.text = notulen?.nama ?? "";
      controllerNIP.text = notulen?.nip ?? "";
      controllerPangkat.text = notulen?.pangkat ?? "";
      update(['images']);
    }
  }

  Future<FormData> parseToFormData() async {
    Map<String, dynamic> data = {};
    data["activity_id"] = activityId;
    data["jabatan"] = controllerJabatan.text;
    data["nama"] = controllerNama.text;
    data["pangkat"] = controllerPangkat.text;
    data["nip"] = controllerNIP.text;
    data["nosurat"] = controllerNoSurat.text;

    final result2 = await controllerNotulenQuil.getDelta();
    List<dynamic> ops = result2["ops"];
    final converter = QuillDeltaToHtmlConverter(
      List.castFrom(ops),
      ConverterOptions.forEmail(),
    );

    data["hasil"] = "${converter.convert()}";
    data["delta"] = await controllerNotulenQuil.getText();
    debugPrint("$data");
    if (image1 != null) {
      data["image1"] = await getMultipartFromFile(image1);
    }
    if (image2 != null) {
      data["image2"] = await getMultipartFromFile(image2);
    }
    if (image3 != null) {
      data["image3"] = await getMultipartFromFile(image3);
    }

    return FormData(data);
  }

  Future<MultipartFile?> getMultipartFromFile(XFile? file) async {
    if (kIsWeb) {
      final bytes = await file?.readAsBytes();
      return MultipartFile(bytes, filename: file?.name ?? "");
    }
    return null;
  }

  @override
  void onInit() {
    activityId = Get.parameters["activity_id"];
    super.onInit();
  }

  getNotulen() {
    showLoading();
    repository.getNotulen(activityId ?? "").then((value) {
      hideLoading();
      notulen = value.data;
      initData();
    }, onError: (e) {
      hideLoading();
    });
  }

  @override
  void onReady() {
    getNotulen();
    super.onReady();
  }
}
