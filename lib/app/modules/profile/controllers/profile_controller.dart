import 'package:absensi_kegiatan/app/data/model/UserModel.dart';
import 'package:absensi_kegiatan/app/data/repository/HiveProvider.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  UserModel? user;

  init() {
    user = HiveProvider().getUserModel();
    update();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
