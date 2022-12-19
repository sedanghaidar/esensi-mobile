import 'package:absensi_kegiatan/app/data/model/KegiatanModel.dart';
import 'package:absensi_kegiatan/app/data/model/PesertaModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequestModel.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiHelper.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:get/get.dart';

class DetailAgendaController extends GetxController {
  ApiProvider repository = Get.find();

  String? id = "0";
  final kegiatan = StatusRequestModel<KegiatanModel>().obs;
  final peserta = StatusRequestModel<List<PesertaModel>>().obs;

  @override
  void onInit() {
    id = Get.parameters["id"];
    getDetailKegiatan();
    getDaftarPeserta();
    super.onInit();
  }

  getDetailKegiatan() {
    kegiatan.value = StatusRequestModel.loading();
    repository.getKegiatanById(id).then((value) {
      kegiatan.value = value;
    }, onError: (e) {
      kegiatan.value = StatusRequestModel.error(failure2(e));
    });
  }

  getDaftarPeserta() {
    peserta.value = StatusRequestModel.loading();
    repository.getPesertaByKegiatan(id).then((value) {
      if (value.data == null || value.data?.isEmpty == true) {
        peserta.value = StatusRequestModel.empty();
      } else {
        peserta.value = value;
      }
    }, onError: (e) {
      peserta.value = StatusRequestModel.error(failure2(e));
    });
  }
}
