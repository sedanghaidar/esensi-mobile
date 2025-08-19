import 'package:magic_view/style/AutoCompleteData.dart';

import '../data/model/InstansiModel.dart';

const msgBlank = "Tidak boleh kosong";
const msgEmailNotValid = "Format email tidak valid";
const msgPhoneNotValid = "No. HP tidak valid";

const TYPE_ABSENSI_CODE = 1;
const TYPE_ABSENSI = "Absensi";
const TYPE_PENDAFTARAN_CODE = 2;
const TYPE_PENDAFTARAN = "Pendaftaran";

///Tipe Notifikasi Whatsapp
const TYPE_NOTIFICATION_NONE_CODE = "NONE";
const TYPE_NOTIFICATION_NONE = "NONE";
const TYPE_NOTIFICATION_WA_TEXT_CODE = "WA_TEXT";
const TYPE_NOTIFICATION_WA_TEXT = "WA TEXT";
const TYPE_NOTIFICATION_WA_BUTTON_CODE = "WA_BUTTON";
const TYPE_NOTIFICATION_WA_BUTTON = "WA TOMBOL";

List<String> form_types = [TYPE_ABSENSI, TYPE_PENDAFTARAN];
Map<String, String> notification_types_map = {
  TYPE_NOTIFICATION_NONE_CODE: TYPE_NOTIFICATION_NONE,
  TYPE_NOTIFICATION_WA_TEXT_CODE: TYPE_NOTIFICATION_WA_TEXT,
  TYPE_NOTIFICATION_WA_BUTTON_CODE: TYPE_NOTIFICATION_WA_BUTTON,
};
List<String> form_gender = ["Laki-laki", "Perempuan"];

/// Mendapatkan teks yang akan ditampilkan di pilihan instansi
/// [model] bertipe [InstansiModel] yang merupakan sumber data
///
/// Jika [kegiatan] pesertanya tidak dibatasi akan menampilkan
/// `nama-instansi` + `nama-parent-instansi` (jika ada)
/// contoh :
///   - Dinas Komunikasi dan Informatika
///   - Bidang E-Government Dinas Komunikasi dan Informatika
///
/// Jika [kegiatan] pesertanya dibatasi akan menampilkan
/// `nama-instansi` + `nama-parent-instansi` (jika ada) + `wilayah-instansi`
/// contoh :
///   - Dinas Komunikasi dan Informatika Provinsi Jawa Tengah
///   - Bidang E-Government Dinas Komunikasi dan Informatika Kota Semarang
///
AutoCompleteData<InstansiModel> getOption(InstansiModel? model,
    {bool? isLimitParticipant = false}) {
  final name1 = model?.name;
  final name2 = getOptionParent(model?.parent);
  if (isLimitParticipant == false) {
    return AutoCompleteData("$name1$name2", model);
  } else {
    final name3 = model?.wilayahName == null ? "" : " ${model?.wilayahName}";
    return AutoCompleteData("$name1$name2$name3", model);
  }
}

String getOptionString(InstansiModel? model,
    {bool isLimitParticipant = false}) {
  final name1 = model?.name;
  final name2 = getOptionParent(model?.parent);
  if (isLimitParticipant == false) {
    return "$name1$name2";
  } else {
    final name3 = model?.wilayahName == null ? "" : " ${model?.wilayahName}";
    return "$name1$name2$name3";
  }
}

String getOptionParent(InstansiModel? instansiModel) {
  if (instansiModel == null) {
    return "";
  } else {
    return " ${instansiModel.name}${getOptionParent(instansiModel.parent)}";
  }
}
