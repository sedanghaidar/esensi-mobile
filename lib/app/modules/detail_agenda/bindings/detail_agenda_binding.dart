import 'package:get/get.dart';

import '../controllers/detail_agenda_controller.dart';

class DetailAgendaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailAgendaController>(
      () => DetailAgendaController(),
    );
  }
}
