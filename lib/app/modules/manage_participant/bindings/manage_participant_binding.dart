import 'package:get/get.dart';

import '../controllers/manage_participant_controller.dart';

class ManageParticipantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageParticipantController>(
      () => ManageParticipantController(),
    );
  }
}
