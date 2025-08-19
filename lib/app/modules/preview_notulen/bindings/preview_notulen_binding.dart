import 'package:get/get.dart';

import '../controllers/preview_notulen_controller.dart';

class PreviewNotulenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreviewNotulenController>(
      () => PreviewNotulenController(),
    );
  }
}
