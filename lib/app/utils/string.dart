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
  TYPE_NOTIFICATION_NONE_CODE : TYPE_NOTIFICATION_NONE,
  TYPE_NOTIFICATION_WA_TEXT_CODE : TYPE_NOTIFICATION_WA_TEXT,
  TYPE_NOTIFICATION_WA_BUTTON_CODE : TYPE_NOTIFICATION_WA_BUTTON,
};
List<String> form_gender = ["Laki-laki", "Perempuan"];
