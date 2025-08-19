import 'package:get/get.dart';

import '../controllers/form_notulen_controller.dart';

class FormNotulenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FormNotulenController>(
      () => FormNotulenController(),
    );
  }
}
