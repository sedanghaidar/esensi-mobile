import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

openDialogPicker(Function(XFile?) onValue) async {
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

openImagePickerCamera(Function(XFile?) onValue) async {
  await ImagePicker().pickImage(source: ImageSource.camera).then((value) {
    onValue(value);
  }, onError: (e) {
    debugPrint("PICK IMAGE ERROR $e");
    onValue(null);
  });
}

openImagePickerGallery(Function(XFile?) onValue) async {
  await ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
    onValue(value);
  }, onError: (e) {
    onValue(null);
  });
}
