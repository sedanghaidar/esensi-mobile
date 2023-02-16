import 'package:absensi_kegiatan/app/data/model/InstansiModel.dart';
import 'package:absensi_kegiatan/app/data/model/InstansiParticipantModel.dart';
import 'package:absensi_kegiatan/app/data/model/KegiatanModel.dart';
import 'package:absensi_kegiatan/app/data/model/PesertaModel.dart';
import 'package:absensi_kegiatan/app/data/model/UserModel.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiHelper.dart';
import 'package:absensi_kegiatan/app/data/repository/HiveProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';

import '../model/repository/StatusRequestModel.dart';

class ApiProvider extends GetConnect {
  // static const String BASE_URL = "http://172.100.31.212:5000";
  // static const String BASE_URL = "https://cs.saturnalia.jatengprov.go.id";
  static const String BASE_URL = "http://127.0.0.1:8000";

  // static const String BASE_URL = "http://10.99.1.171:8000";

  HiveProvider hive = HiveProvider();

  @override
  void onInit() {
    httpClient.baseUrl = BASE_URL;

    httpClient.addRequestModifier<dynamic>((request2) {
      String? token = "${hive.getUserModel()?.token}";
      request2.headers['Authorization'] = "Bearer $token";
      return request2;
    });

    httpClient.addResponseModifier((request, response) {
        debugPrint(
          '\n╔══════════════════════════ Response ══════════════════════════\n'
              '╟ REQUEST ║ ${request.method.toUpperCase()}\n'
              '╟ url: ${request.url}\n'
              '╟ Headers: ${request.headers}\n'
          // '╟ Body: ${request.bodyBytes.map((event) => event.asMap().toString()) ?? ''}\n'
              '╟ Status Code: ${response.statusCode}\n'
              '╟ Data: ${response.bodyString?.toString() ?? ''}'
              '\n╚══════════════════════════ Response ══════════════════════════\n',
          wrapWidth: 1024,
        );

      httpClient.timeout = const Duration(minutes: 1);

      return response;
    });
    super.onInit();
  }

  /// Api login ke dalam aplikasi
  Future<StatusRequestModel<UserModel>> login(
      String email, String password) async {
    final response =
        await post("/api/login", {'email': email, 'password': password});
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(UserModel.fromJson(model.data));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  /// Mendapatkan daftar kegiatan yang sudah dibuat
  Future<StatusRequestModel<List<KegiatanModel>>> getKegiatan() async {
    final response = await get("/api/kegiatan");
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(List<KegiatanModel>.from(
          (model.data).map((u) => KegiatanModel.fromJson(u))));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  /// Menghapus data kegiatan berdasarkan [id]
  Future<StatusRequestModel<KegiatanModel>> deleteKegiatan(String? id) async {
    final response = await post("/api/kegiatan/delete/$id", {});
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(KegiatanModel.fromJson(model.data));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  /// Mendapatkan data kegiatan berdasarkan [code]. Dapat diakses tanpa header
  Future<StatusRequestModel<KegiatanModel>> getKegiatanByCode(
      String? code) async {
    final response = await get("/api/kegiatan/kode/$code");
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(KegiatanModel.fromJson(model.data));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  /// Mendapatkan data kegiatan berdasarkan [id]. Wajib diakses dengan header
  Future<StatusRequestModel<KegiatanModel>> getKegiatanById(String? id) async {
    final response = await get("/api/kegiatan/$id");
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(KegiatanModel.fromJson(model.data));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  /// Mendapatkan data daftar semua instansi
  Future<StatusRequestModel<List<InstansiModel>>> getInstansiSemua() async {
    final response = await get("/api/organisasi");
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(List<InstansiModel>.from(
          (model.data).map((u) => InstansiModel.fromJson(u))));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  /// Mendapatkan data daftar semua instansi berdasarkan [id] kegiatan
  Future<StatusRequestModel<List<InstansiModel>>> getInstansi(
      String? id) async {
    final response = await get("/api/organisasi/kegiatan/$id");
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(List<InstansiModel>.from(
          (model.data).map((u) => InstansiModel.fromJson(u))));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  /// Input absen peserta dengan [peserta] adalah data peserta yang ditulis
  Future<StatusRequestModel<PesertaModel>> insertPeserta(
      Map<String, dynamic> peserta) async {
    final response = await post("/api/peserta/daftar", FormData(peserta));
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(PesertaModel.fromJson(model.data));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  /// Mendapatkan data detail peserta berdasarkan [id]
  Future<StatusRequestModel<PesertaModel>> getDetailPeserta(String? id) async {
    final response = await get("/api/peserta/$id");
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(PesertaModel.fromJson(model.data));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  /// Menghapus peserta berdasarkan [id]
  Future<StatusRequestModel<PesertaModel>> deletePeserta(int? id) async {
    final response = await post("/api/peserta/delete/$id", {});
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(PesertaModel.fromJson(model.data));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  /// Mendapatkan data daftar peserta berdasarkan [id] kegiatan
  Future<StatusRequestModel<List<PesertaModel>>> getPesertaByKegiatan(
      String? id) async {
    final response = await get("/api/peserta/kegiatan/$id");
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(List<PesertaModel>.from(
          (model.data).map((u) => PesertaModel.fromJson(u))));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  /// Scan QR CODE peserta
  Future<StatusRequestModel<PesertaModel>> scanPeserta(
      Map<String, dynamic> peserta) async {
    final response = await post("/api/peserta/scan", FormData(peserta));
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(PesertaModel.fromJson(model.data));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  /// Menambah data kegiatan
  Future<StatusRequestModel<KegiatanModel>> addNewKegiatan(
      Map<String, dynamic> kegiatan) async {
    final response = await post("/api/kegiatan", kegiatan);
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(KegiatanModel.fromJson(model.data));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  /// Mengubah data kegiatan berdasarkan [id]
  Future<StatusRequestModel<KegiatanModel>> updateKegiatan(
      Map<String, dynamic> kegiatan, String? id) async {
    final response = await post("/api/kegiatan/$id", kegiatan);
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(KegiatanModel.fromJson(model.data));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  /// ----------------------------------------------------------------------------------------

  /// Mendapatkan data daftar instansi partisipan yang diijinkan berdasarkan [id] kegiatan
  Future<StatusRequestModel<List<InstansiPartipantModel>>>
      getInstansiParticipant(String? id) async {
    final response = await get("/api/organization-limit/byactid/$id");
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(List<InstansiPartipantModel>.from(
          (model.data).map((u) => InstansiPartipantModel.fromJson(u))));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  /// [ TIDAK_DIIMPLEMENTASIKAN ]
  /// Mengupdate data instansi participant, [data] merupakan data yang akan dikirim
  Future<StatusRequestModel<String>> postInstansiParticipant(
      Map<String, dynamic> data) async {
    final response = await post("/api/organization-limit/insert", data);
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success("Berhasil kirim data");
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  /// Menambah atau mengubah data partisipan instansi
  Future<StatusRequestModel<InstansiPartipantModel>> createOrUpdatePartisipanInstansi(Map<String, dynamic> data) async {
    final response = await post("/api/organization-limit/", data);
    final model = toDefaultModel(response.body);
    if (response.isOk && model.success==true) {
      return StatusRequestModel.success(InstansiPartipantModel.fromJson(model.data));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  /// Menghapus data partisipan instansi
  Future<StatusRequestModel<dynamic>> deletePartisipanInstansi(String? id) async {
    final response = await post("/api/organization-limit/delete/$id", {});
    final model = toDefaultModel(response.body);
    if (response.isOk && model.success==true) {
      return StatusRequestModel.success("Berhasil menghapus isntansi");
    } else {
      throw StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  /// ----------------------------------------------------------------------------------------

  /// Menambah data Instansi
  Future<StatusRequestModel<InstansiModel>> postInstansi(InstansiModel data) async {
    final response = await post("/api/organisasi/tambah", {
      "name": data.name,
      "short_name": data.shortName
    });
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(InstansiModel.fromJson(model.data));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  Future<StatusRequestModel<InstansiModel>> deleteInstansi(String? id) async {
    final response = await post("/api/organisasi/hapus/$id", {});
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(InstansiModel.fromJson(model.data));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }

  Future<StatusRequestModel<InstansiModel>> updateInstansi(String? id, InstansiModel instansi) async {
    final response = await post("/api/organisasi/update/$id", {
      "name": instansi.name,
      "short_name": instansi.shortName
    });
    final model = toDefaultModel(response.body);
    if (response.isOk) {
      return StatusRequestModel.success(InstansiModel.fromJson(model.data));
    } else {
      return StatusRequestModel.error(failure(response.statusCode, model));
    }
  }
}
