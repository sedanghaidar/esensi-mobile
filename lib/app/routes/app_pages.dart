import 'package:get/get.dart';

import '../modules/create_agenda/bindings/create_agenda_binding.dart';
import '../modules/create_agenda/views/create_agenda_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/detail_agenda/bindings/detail_agenda_binding.dart';
import '../modules/detail_agenda/views/detail_agenda_view.dart';
import '../modules/detail_peserta/bindings/detail_peserta_binding.dart';
import '../modules/detail_peserta/views/detail_peserta_view.dart';
import '../modules/form/bindings/form_binding.dart';
import '../modules/form/views/form_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/manage_participant/bindings/manage_participant_binding.dart';
import '../modules/manage_participant/views/manage_participant_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/qr_scanner/bindings/qr_scanner_binding.dart';
import '../modules/qr_scanner/views/qr_scanner_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_AGENDA,
      page: () => CreateAgendaView(),
      binding: CreateAgendaBinding(),
    ),
    GetPage(
      name: _Paths.FORM + "/:code",
      page: () => FormView(),
      binding: FormBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_PESERTA + "/:id",
      page: () => DetailPesertaView(),
      binding: DetailPesertaBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_AGENDA + "/:id",
      page: () => DetailAgendaView(),
      binding: DetailAgendaBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.QR_SCANNER,
      page: () => QrScannerView(),
      binding: QrScannerBinding(),
    ),
    GetPage(
      name: _Paths.MANAGE_PARTICIPANT+"/:id",
      page: () => ManageParticipantView(),
      binding: ManageParticipantBinding(),
    ),
  ];
}
