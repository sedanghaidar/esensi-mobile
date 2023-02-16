import 'package:absensi_kegiatan/app/data/model/UserModel.dart';
import 'package:absensi_kegiatan/app/data/repository/HiveHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/data/repository/ApiProvider.dart';
import 'app/data/repository/HiveUserAdapter.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<UserModel>(HiveUserAdapter());
  await Hive.openBox<dynamic>(HiveHelper.HIVE_APPNAME);

  runApp(
    GetMaterialApp(
      title: "Esensi",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {
        Get.put(ApiProvider());
      }),
    ),
  );
}
