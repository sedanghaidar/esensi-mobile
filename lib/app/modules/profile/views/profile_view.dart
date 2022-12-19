import 'package:absensi_kegiatan/app/data/repository/HiveHelper.dart';
import 'package:absensi_kegiatan/app/routes/app_pages.dart';
import 'package:absensi_kegiatan/app/utils/colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  Widget iconLogout = ClipRRect(
    borderRadius: BorderRadius.circular(50),
    child: Container(
        color: basicPrimary2,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.logout,
            size: 24,
          ),
        )),
  );
  @override
  Widget build(BuildContext context) {
    controller.init();
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          centerTitle: true,
          backgroundColor: basicPrimary,
          actions: [
            InkWell(
              onTap: () {
                //dialog
                Get.defaultDialog(
                  title: "Konfirmasi".toUpperCase(),
                  middleText: "Apakah anda yakin akan keluar akun ?",
                  textConfirm: "Ya",
                  textCancel: "Batal",
                  buttonColor: basicPrimary,
                  cancelTextColor: basicPrimary,
                  confirmTextColor: basicWhite,
                  onConfirm: () {
                    HiveHelper.deleteData(HiveHelper.HIVE_OBJ_USER);
                    HiveHelper.putData(HiveHelper.HIVE_IS_LOGGED_IN, false);
                    Get.offAllNamed(Routes.LOGIN);
                  },
                  onCancel: () => Get.back(),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.center,
                  child: iconLogout,
                ),
              ),
            )
          ],
        ),
        body: GetBuilder<ProfileController>(
          builder: (_) => SingleChildScrollView(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      controller.user!.name!.toUpperCase(),
                      style: context.textTheme.titleLarge,
                    ),
                    Text(controller.user!.email.toString()),
                    SizedBox(
                      height: 32,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Menu Lain",
                          style: context.textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        MenuLink(
                          title: "Kebijakan Privasi",
                          action: () {},
                        ),
                        MenuLink(
                          title: "FAQ",
                          action: () {},
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class MenuLink extends StatelessWidget {
  const MenuLink(
      {Key? key, required this.title, required this.action, required})
      : super(key: key);

  final String title;
  final GestureTapCallback action;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: (Get.context as BuildContext)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
