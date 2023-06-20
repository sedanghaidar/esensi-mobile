import 'dart:ui' as ui;

import 'package:absensi_kegiatan/app/data/model/InstansiModel.dart';
import 'package:absensi_kegiatan/app/data/model/KegiatanModel.dart';
import 'package:absensi_kegiatan/app/data/model/PesertaModel.dart';
import 'package:absensi_kegiatan/app/data/model/RegionModel.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiHelper.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:absensi_kegiatan/app/data/repository/LaporgubProvider.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/error.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_view/style/AutoCompleteData.dart';
import 'package:magic_view/widget/textfield/MagicAutoComplete.dart';
import 'package:magic_view/widget/textfield/MagicTextField.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../../data/model/repository/StatusRequestModel.dart';
import '../../../global_widgets/dialog/CLoading.dart';
import '../../../global_widgets/sign/mobile_image_converter.dart'
    if (dart.library.html) '../../../global_widgets/sign/web_image_converter.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';
import '../../../utils/date.dart';

class FormController extends GetxController {
  String? id = "0"; //kode khusus untuk membuka formulir walaupun sudah outdated
  ApiProvider repository = Get.find();
  LaporgubProvider repositoryLaporgub = Get.find();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerPhone = TextEditingController();

  AutoCompleteData<InstansiModel>? selectedInstansi;
  TextEditingController controllerInstansi = TextEditingController();
  RxBool isOpenInstansi =
      false.obs; // Kondisi kustom [MagicTextField] dibuka atau ditutup
  TextEditingController controllerInstansiManual = TextEditingController();

  AutoCompleteData<RegionModel>? selectedWilayah;
  RxBool enableWilayah = false.obs;
  TextEditingController controllerWilayah = TextEditingController();

  final TextEditingController controllerJabatan = TextEditingController();
  final TextEditingController controllerGender = TextEditingController();

  Uint8List? fileBytes;
  RxBool isSigned = false.obs;
  final GlobalKey<SfSignaturePadState> signaturePadKey = GlobalKey();

  final kegiatan = StatusRequestModel<KegiatanModel>().obs;
  final instansi = StatusRequestModel<List<InstansiModel>>().obs;
  final regions = StatusRequestModel<List<RegionModel>>().obs;

  /// Cek apakah formulir sudah melewati batas pengisian atau belum
  /// atau sudah melewati tanggal kegiatan atau belum
  ///
  /// @return [bool]
  bool checkExpirationForm() {
    /**
     * id disini merupakan id khusus yang dapat dimasukan di url formulir.
     * Jika id khusus tersebut = id kegiatan formulir makan pengecekan tanggal
     * kadaluarsa formulir akan diabaikan
     * */
    if ("${kegiatan.value.data?.id}" != "$id") {
      if (checkOutDate(kegiatan.value.data?.date ?? DateTime.now(),
          kegiatan.value.data?.dateEnd)) {
        return true;
      }
    }
    return false;
  }

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
  AutoCompleteData<InstansiModel> getOption(InstansiModel model) {
    final name1 = model.name;
    final name2 = model.parent?.name == null ? "" : " ${model.parent?.name}";
    if (kegiatan.value.data?.isLimitParticipant == false) {
      return AutoCompleteData("$name1$name2", model);
    } else {
      final name3 = model.wilayahName == null ? "" : " ${model.wilayahName}";
      return AutoCompleteData("$name1$name2$name3", model);
    }
  }

  /// Mendapatkan daftar instansi yang sudah diproses atau dikonversi
  /// dari List [InstansiModel] menjadi List [AutoCompleteData]
  /// sehingga dapat dipakai di [MagicAutoComplete]
  List<AutoCompleteData<InstansiModel>> getListInstansi() {
    return (instansi.value.data ?? []).map((e) {
      return getOption(e);
    }).toList();
  }

  /// Mengatur tampilan [MagicAutoComplete] dari Wilayah setelah memilih instansi
  /// berdasarkan [kegiatan] dibatasi atau tidak
  ///
  /// Jika [kegiatan] membatasi peserta maka setting [MagicAutoComplete] wilayah
  /// sesuai dengan data wilayah yang didapat dari memilih instansi dan kunci
  /// tampilan wilayah agar tidak bisa diedit
  ///
  /// Jika [kegiatan] tidak membatasi peserta maka buka [MagicAutoComplete]
  /// wilayah agar dapat memilih wilayah
  settingWilayahWhenSelectedInstansi() {
    if (kegiatan.value.data?.isLimitParticipant == true) {
      selectedWilayah = AutoCompleteData(
          selectedInstansi?.data?.wilayahName,
          RegionModel(
            name: selectedInstansi?.data?.wilayahName,
            id: "${selectedInstansi?.data?.wilayahId}",
          ));
      controllerWilayah.text = selectedInstansi?.data?.wilayahName ?? "";
      enableWilayah.value = false;
    } else {
      selectedWilayah = null;
      enableWilayah.value = true;
    }
  }

  bool handleOnDrawStart() {
    isSigned.value = true;
    return false;
  }

  /// Tampilkan atau sembunyikan [MagicTextField] instansi, agar user dapat
  /// mengetik nama instansi mereka yang tidak terdaftar di [instansi].
  /// Hanya berlaku jika [kegiatan] tidak dilakukan pembatasan peserta
  settingTextFieldCustomInstansi() {
    if (kegiatan.value.data?.isLimitParticipant == false) {
      if (selectedInstansi?.data?.name == "LAINNYA") {
        isOpenInstansi.value = true;
      } else {
        isOpenInstansi.value = false;
      }
    }
  }

  pushImage() {
    convertImage().then(
      (value) {
        fileBytes = value;
        update();
      },
    );
  }

  /// Mengkonversi gambar tandatangan dari [SfSignaturePad] menjadi [Uint8List]
  Future<Uint8List> convertImage() async {
    late Uint8List img;
    if (kIsWeb) {
      final RenderSignaturePad renderSignaturePad =
          signaturePadKey.currentState!.context.findRenderObject()!
              as RenderSignaturePad;
      img =
          await ImageConverter.toImage(renderSignaturePad: renderSignaturePad);
    } else {
      final ui.Image imageData =
          await signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
      final ByteData? bytes =
          await imageData.toByteData(format: ui.ImageByteFormat.png);
      if (bytes != null) {
        img = bytes.buffer.asUint8List();
      }
    }
    return img;
  }

  /// Mendapatkan detail kegiatan berdasarkan kode
  getKegiatan(String code) {
    kegiatan.value = StatusRequestModel.loading();
    repository.getKegiatanByCode(code).then((value) {
      kegiatan.value = value;
      if (kegiatan.value.data?.isLimitParticipant == true) {
        getInstansi();
      } else {
        getInstansiAll();
      }
    }, onError: (e) {
      kegiatan.value = StatusRequestModel.error(failure2(e));
    });
  }

  /// Mendapatkan daftar wilayah
  getRegion() {
    repositoryLaporgub.getRegion().then((value) {
      if (value.data?.isEmpty == true) {
        regions.value = StatusRequestModel.empty();
      } else {
        regions.value = value;
      }
    }, onError: (e) {
      final err = repository.handleError<List<RegionModel>>(e);
      regions.value = err;
    });
  }

  /// Mendapatkan daftar instansi yang sudah dipilih
  getInstansi() {
    instansi.value = StatusRequestModel.loading();
    repository.getInstansi("${kegiatan.value.data?.id}").then((value) {
      if (value.data?.isEmpty == true) {
        instansi.value = StatusRequestModel.empty();
      } else {
        instansi.value = value;
      }
    }, onError: (e) {
      instansi.value = StatusRequestModel.error(failure2(e));
    });
  }

  /// Mendapatkan daftar semua instansi
  getInstansiAll() {
    instansi.value = StatusRequestModel.loading();
    repository.getInstansiSemua().then((value) {
      if (value.data?.isEmpty == true) {
        instansi.value = StatusRequestModel.empty();
      } else {
        value.data?.insert(0, InstansiModel(name: "LAINNYA"));
        instansi.value = value;
      }
    }, onError: (e) {
      instansi.value = StatusRequestModel.error(failure2(e));
    });
  }

  insertPeserta() async {
    if (fileBytes != null) {
      String i = controllerInstansi.text;
      if (i == "LAINNYA") {
        i = controllerInstansiManual.text;
      }

      Map<String, dynamic> data = {
        "activity_id": kegiatan.value.data?.id,
        "name": controllerName.text,
        "jabatan": controllerJabatan.text,
        "instansi": i.toUpperCase(),
        "nohp": controllerPhone.text,
        "gender": controllerGender.text,
        "region_id": selectedWilayah?.data?.id,
        "region_name": selectedWilayah?.data?.name,
        "signature": MultipartFile(fileBytes,
            filename: "${controllerName.text}_${kegiatan.value.data?.id}.jpeg")
      };

      showLoading();
      repository.insertPeserta(data).then((result) {
        hideLoading();

        if (kegiatan.value.data?.type == 1) {
          showDialogSuccess();
        } else {
          Get.offAllNamed("${Routes.DETAIL_PESERTA}/${result.data?.id}");
        }
      }, onError: (e) {
        hideLoading();
        final err = repository.handleError<PesertaModel>(e);
        dialogError(
          Get.context!,
          "Terjadi Kesalahan.\n${err.failure?.msgShow}",
          () {
            Get.back();
          },
        );
      });
    }
  }

  showDialogSuccess() {
    Get.defaultDialog(
        title: "Berhasil",
        middleText: "Data anda berhasil tersimpan. Terimakasih.",
        barrierDismissible: false,
        onConfirm: () {
          controllerName.clear();
          controllerInstansi.clear();
          controllerInstansiManual.clear();
          controllerPhone.clear();
          controllerJabatan.clear();
          isSigned.value = false;
          signaturePadKey.currentState?.clear();
          fileBytes = null;
          update(['padsign']);
          Get.back();
        },
        confirmTextColor: basicWhite,
        buttonColor: basicPrimary,
        textConfirm: "Oke");
  }

  @override
  void onInit() {
    String code = Get.parameters['code'].toString();
    id = Get.parameters['id'].toString();
    getKegiatan(code);
    getRegion();
    super.onInit();
  }
}
