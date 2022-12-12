import 'package:absensi_kegiatan/app/utils/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      backgroundColor: basicRed1,
      webPosition: "right",
      webBgColor: "linear-gradient(to right, #e93838, #e93838)");
}
