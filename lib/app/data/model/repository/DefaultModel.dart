class DefaultModel {
  bool success = false;
  String? message;
  dynamic error;
  dynamic data;
  dynamic dataLaporgub;

  DefaultModel(
      {this.success = false,
      this.message,
      this.error,
      this.data,
      this.dataLaporgub});

  DefaultModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    error = json['error'];
    data = json['result'] ?? "NULL";
    dataLaporgub = json['data'] ?? "NULL";
  }

  Map<String, dynamic> toJson(DefaultModel model) => <String, dynamic>{
        'success': model.success,
        'message': model.message,
        'error': model.error,
        'result': model.data,
        'data': model.dataLaporgub
      };
}
