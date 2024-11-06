import 'package:absensi_kegiatan/app/utils/colors.dart';
import 'package:get/get.dart';

showToast(String message) {
  Get.snackbar("Perhatian", message);
  // Fluttertoast.showToast(
  //     msg: message,
  //     backgroundColor: basicRed1,
  //     webPosition: "right",
  //     webBgColor: "linear-gradient(to right, #e93838, #e93838)");
}
