import 'package:get/get.dart';

import '../controllers/update_agenda_controller.dart';

class UpdateAgendaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateAgendaController>(
      () => UpdateAgendaController(),
    );
  }
}
