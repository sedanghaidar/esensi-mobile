import 'package:absensi_kegiatan/app/data/model/UserModel.dart';
import 'package:absensi_kegiatan/app/data/repository/HiveHelper.dart';
import 'package:absensi_kegiatan/app/data/repository/LaporgubProvider.dart';
import 'package:absensi_kegiatan/app/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:magic_view/factory.dart';
import 'package:magic_view/property/font/font.dart';

import 'app/data/repository/ApiProvider.dart';
import 'app/data/repository/HiveUserAdapter.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<UserModel>(HiveUserAdapter());
  await Hive.openBox<dynamic>(HiveHelper.HIVE_APPNAME);

  if(kDebugMode){
    await dotenv.load(fileName: ".env.dev");
  }else{
    await dotenv.load(fileName: ".env");
  }

  MagicFactory.fontFamily = FontFamily.poppins;
  MagicFactory.colorBrand = basicPrimary;

  if(kReleaseMode){
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  runApp(
    GetMaterialApp(
      title: "Esensi",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {
        Get.put(ApiProvider());
        Get.put(LaporgubProvider());
      }),
    ),
  );
}
