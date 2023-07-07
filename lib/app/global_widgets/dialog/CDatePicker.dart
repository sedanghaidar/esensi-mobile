import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/colors.dart';

Future<DateTime?> CDatePicker(BuildContext context,
    {String? timeSelected, DateTime? firstDate}) async {
  DateTime initialDate = DateTime.now();
  if (timeSelected != null && timeSelected != "") {
    initialDate = DateFormat("yyyy-MM-dd").parse(timeSelected);
  }

  DateTime? picker = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate ?? DateTime.now(),
    lastDate: DateTime(2050),
    builder: (context, child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: basicPrimary,
          accentColor: basicPrimaryLight,
          colorScheme: ColorScheme.light(primary: basicPrimary),
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
        ),
        child: child!,
      );
    },
  );
  return picker;
}

Future<TimeOfDay?> CTimePicker(BuildContext context,
    {String? timeSelected}) async {
  TimeOfDay initialDate = TimeOfDay.now();
  if (timeSelected != null && timeSelected != "") {
    initialDate = TimeOfDay(
        hour: int.parse(timeSelected.split(":")[0]),
        minute: int.parse(timeSelected.split(":")[1]));
  }

  TimeOfDay? picker = await showTimePicker(
    context: context,
    initialTime: initialDate,
    builder: (context, child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: basicPrimary,
          accentColor: basicPrimaryLight,
          colorScheme: ColorScheme.light(primary: basicPrimary),
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
        ),
        child: child!,
      );
    },
  );
  return picker;
}
