import 'package:flutter/material.dart';

String to24(TimeOfDay? time) {
  if (time != null) {
    String hour = time.hour < 10 ? "0${time.hour}" : "${time.hour}";
    String minute = time.minute < 10 ? "0${time.minute}" : "${time.minute}";
    return "$hour:$minute:00";
  }
  return "00:00:00";
}
