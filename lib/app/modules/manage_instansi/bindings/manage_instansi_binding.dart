import 'package:get/get.dart';

import '../controllers/manage_instansi_controller.dart';

class ManageInstansiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageInstansiController>(
      () => ManageInstansiController(),
    );
  }
}
