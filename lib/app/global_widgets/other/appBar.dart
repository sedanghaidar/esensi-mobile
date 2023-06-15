import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../../utils/colors.dart';
import '../text/CText.dart';

Widget? leadingDefault = InkWell(
  onTap: () {
    Get.offAllNamed(Routes.DASHBOARD);
  },
  child: const Icon(
    Icons.home,
    color: basicWhite,
  ),
);

AppBar customAppBar(String title, {Widget? leading}) {
  return AppBar(
    backgroundColor: basicPrimary,
    title: Text(
      title,
      style: CText.styleTitleAppBar,
    ),
    centerTitle: true,
    leading: leading,
  );
}
