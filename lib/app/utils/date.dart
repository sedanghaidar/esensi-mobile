import 'package:absensi_kegiatan/app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

String to24(TimeOfDay? time) {
  if (time != null) {
    String hour = time.hour < 10 ? "0${time.hour}" : "${time.hour}";
    String minute = time.minute < 10 ? "0${time.minute}" : "${time.minute}";
    return "$hour:$minute:00";
  }
  return "00:00:00";
}

String dateToString(DateTime? date, {String? format}) {
  initializeDateFormatting();
  if (date == null) {
    return "-";
  } else {
    return DateFormat(format ?? "EEEE, dd MMMM yyyy", "id").format(date);
  }
}

bool checkOutDate(DateTime dateActivity, DateTime? dateEnd) {
  DateTime dateActivityEnd = DateTime(
      dateActivity.year, dateActivity.month, dateActivity.day, 23, 59, 59);
  if (compareDate(DateTime.now(), dateActivityEnd) == 1) return true;
  if (dateEnd != null) {
    if (compareDate(DateTime.now(), dateEnd) == 1) return true;
  }
  return false;
}

///Mendapatkan warna berdasarkan tanggal kegiatan [date] dan [time].
///[hijau] -> jika tanggal sekarang = tanggal kegiatan
///[orange] -> jika tanggal sekarang < tanggal kegiatan
///[merah] -> jika tanggal sekarang > tanggal kegiatan
Color getColorByDate(DateTime date, String? time) {
  final times = (time ?? "").split(":");
  final now = DateTime.now().copyWith(
      hour: int.parse(times[0] ?? "00"),
      minute: int.parse(times[1] ?? "00"),
      second: int.parse(times[2] ?? "00"),
      millisecond: 0);
  DateTime dates = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(times[0] ?? "00"),
      int.parse(times[1] ?? "00"),
      int.parse(times[2] ?? "00"),
      0);
  if (compareDate(now, dates) < 0) {
    return basicOrange;
  } else if (compareDate(now, dates) == 0) {
    return basicGreen;
  } else {
    return basicRed1;
  }
}

///Mendapatkan status editable kegiatan berdasarkan [date] dan [time].
///[trues] -> jika tanggal sekarang < tanggal kegiatan
///[falses] -> jika tanggal sekarang >= tanggal kegiatan
bool getStatusEditableKegiatan(DateTime date, String? time) {
  final times = (time ?? "").split(":");
  final now = DateTime.now().copyWith(
      hour: int.parse(times[0] ?? "00"),
      minute: int.parse(times[1] ?? "00"),
      second: int.parse(times[2] ?? "00"),
      millisecond: 0);
  DateTime dates = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(times[0] ?? "00"),
      int.parse(times[1] ?? "00"),
      int.parse(times[2] ?? "00"),
      0);
  if (compareDate(now, dates) < 0) {
    return true;
  } else {
    return false;
  }
}

int compareDate(DateTime dt1, DateTime dt2) {
  if (dt1.compareTo(dt2) > 0) return 1;
  if (dt1.compareTo(dt2) < 0) return -1;
  // if(dt1.compareTo(dt2)==0) return 0;
  return 0;
}
