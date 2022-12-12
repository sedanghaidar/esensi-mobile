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

String dateToString(DateTime? date) {
  initializeDateFormatting();
  return DateFormat("EEEE, dd MMMM yyyy", "id").format(date ?? DateTime.now());
}

bool checkOutDate(DateTime dateActivity, DateTime? dateEnd) {
  if (compareDate(DateTime.now(), dateActivity) == 1) return true;
  if (dateEnd != null) {
    if (compareDate(DateTime.now(), dateEnd) == 1) return true;
  }
  return false;
}

int compareDate(DateTime dt1, DateTime dt2) {
  if (dt1.compareTo(dt2) > 0) return 1;
  if (dt1.compareTo(dt2) < 0) return -1;
  // if(dt1.compareTo(dt2)==0) return 0;
  return 0;
}
