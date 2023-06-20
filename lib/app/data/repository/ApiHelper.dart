import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../model/repository/DefaultModel.dart';
import '../model/repository/FailureModel.dart';

FailureModel failure(int? code, DefaultModel model) {
  String message;
  switch (code) {
    case 401:
      message = "Unauthorized";
      Get.offAllNamed(Routes.LOGIN);
      break;
    default:
      message = model.message ?? "Terjadi Kesalahan";
  }
  return FailureModel(code, message, message);
}

FailureModel failure2(dynamic e){
  return FailureModel(400, "Terjadi Kesalahan. $e", "$e");
}

FailureModel toFailureModel(dynamic e, {String? message}) {
  return FailureModel(400, message == null ? "$e" : "$message. $e", "$e");
}

DefaultModel toDefaultModel(dynamic response) {
  if (response == null) {
    return DefaultModel(
        success: false, message: response["message"], error: response["error"]);
  } else {
    return DefaultModel.fromJson(response);
  }
}

DefaultModel toDefaultLaporgubModel(dynamic response) {
  if (response == null) {
    return DefaultModel(
        success: false, message: response["message"], error: response["error"]);
  } else {
    return DefaultModel.fromJson(response);
  }
}
