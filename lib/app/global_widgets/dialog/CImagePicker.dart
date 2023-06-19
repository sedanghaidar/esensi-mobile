import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

openDialogPicker(Function(XFile?, dynamic) onValue) async {
  Get.defaultDialog(
      title: "Ambil Gambar",
      middleText: "Silahkan Pilih Salah Satu",
      textConfirm: "Kamera",
      onConfirm: () {
        Get.back();
        openImagePickerCamera(onValue);
      },
      textCancel: "Galeri",
      onCancel: () {
        openImagePickerGallery(onValue);
      });
}

openImagePickerCamera(Function(XFile?, dynamic) onValue) async {
  await ImagePicker().pickImage(source: ImageSource.camera).then((value) {
    onValue(value, null);
  }, onError: (e) {
    onValue(null, e);
  });
}

openImagePickerGallery(Function(XFile?, dynamic) onValue) async {
  await ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
    onValue(value, null);
  }, onError: (e) {
    onValue(null, e);
  });
}
