import 'package:get/get.dart';

import '../controllers/qr_form_absen_controller.dart';

class QrFormAbsenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrFormAbsenController>(
      () => QrFormAbsenController(),
    );
  }
}
