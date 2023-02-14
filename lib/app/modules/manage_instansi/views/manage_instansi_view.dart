import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/model/InstansiModel.dart';
import '../../../data/model/repository/StatusRequest.dart';
import '../../../global_widgets/button/CButton.dart';
import '../../../global_widgets/dialog/CLoading.dart';
import '../../../global_widgets/other/error.dart';
import '../../../global_widgets/sized_box/CSizedBox.dart';
import '../../../global_widgets/text/CText.dart';
import '../../../global_widgets/text_field/CTextField.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';
import '../../../utils/string.dart';
import '../controllers/manage_instansi_controller.dart';

class ManageInstansiView extends GetView<ManageInstansiController> {
  const ManageInstansiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // return dialogOnBackPressed();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: basicPrimary,
          title: Text('Manajemen Instansi Partisipan'),
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              // dialogOnBackPressed();
              Get.offAllNamed(Routes.DASHBOARD);
            },
            child: Icon(
              Icons.home,
              color: basicWhite,
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                flex: 0,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: CButton.small(() {
                      openDialog(context, 1);
                    }, "Tambah Instansi Partisipan")),
              ),
              Expanded(flex: 0, child: CSizedBox.h30()),
              const Expanded(
                flex: 0,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: CText(
                      "Daftar Instansi Partisipan",
                      style: CText.textStyleSubhead,
                    )),
              ),
              const Expanded(flex: 0, child: CSizedBox.h20()),
              Expanded(
                  flex: 0,
                  child: Obx(() {
                    switch (controller.instansi.value.statusRequest) {
                      case StatusRequest.SUCCESS:
                        {
                          int total = 0;
                          for (InstansiModel i
                              in controller.instansi.value.data ?? []) {
                            total++;
                          }
                          return Align(
                              alignment: Alignment.centerLeft,
                              child: CText(
                                "Total instansi : $total",
                                style: CText.textStyleBodyBold,
                              ));
                        }
                      default:
                        return SizedBox();
                    }
                  })),
              const Expanded(flex: 0, child: CSizedBox.h10()),
              Expanded(
                  flex: 0,
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: CTextField(
                      controller: controller.controllerSearch,
                      hintText: "Cari Nama Instansi",
                      onChange: (value) {
                        controller.filter.value = value;
                      },
                      suffixIcon: const Icon(Icons.search),
                    ),
                  )),
              Expanded(
                flex: 1,
                child: Obx(() {
                  switch (controller.instansi.value.statusRequest) {
                    case StatusRequest.LOADING:
                      return loading(context);
                    case StatusRequest.EMPTY:
                      return warning(
                          context, "Instansi partisipan masih kosong");
                    case StatusRequest.SUCCESS:
                      String filter = controller.filter.value
                          .toLowerCase(); // jangan dihapus buat trigger search!
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          List<InstansiModel> instansi =
                              controller.instansi.value.data ?? [];
                          if (instansi[index]
                                  .name
                                  ?.toLowerCase()
                                  .contains(filter) ==
                              false) {
                            return Container();
                          }
                          return Card(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CText(
                                          controller.instansi.value.data?[index]
                                                  .name ??
                                              "",
                                          style: CText.textStyleBodyBold,
                                        ),
                                        CText(
                                            "${controller.instansi.value.data?[index].shortName}")
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      flex: 0,
                                      child: InkWell(
                                        onTap: () {
                                          openDialog(context, 2,
                                              initial: controller.instansi
                                                  .value.data?[index]);
                                        },
                                        child: const Icon(Icons.edit),
                                      )),
                                  Expanded(flex: 0, child: CSizedBox.w10()),
                                  Expanded(
                                      flex: 0,
                                      child: InkWell(
                                        onTap: () {
                                          controller.deleteInstansi(
                                              controller.instansi.value
                                                  .data?[index]);
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          color: basicRed1,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: controller.instansi.value.data?.length ?? 0,
                      );
                    case StatusRequest.ERROR:
                      return error(
                          context,
                          controller.instansi.value.failure?.msgShow ??
                              "Terjadi Kesalahan", () {
                        controller.getInstansiAll();
                      });
                    default:
                      return SizedBox();
                  }
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  openDialog(BuildContext context, int action, {InstansiModel? initial}) {
    controller.controllerName.text = initial == null ? "" : "${initial.name}";
    controller.controllerShortName.text =
        initial == null ? "" : "${initial.shortName}";

    showDialog(
        context: context,
        useSafeArea: true,
        builder: (context) {
          return AlertDialog(
              content: Form(
            key: controller.keyForm,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CText("Nama Instansi"),
                CSizedBox.h5(),
                CTextField(
                  controller: controller.controllerName,
                  hintText: "Masukkan Nama Instansi",
                  keyboardType: TextInputType.number,
                  inputFormatters: [UpperCaseTextFormatter()],
                  validator: (value) {
                    if (GetUtils.isNullOrBlank(value) == true) {
                      return msgBlank;
                    }
                    return null;
                  },
                ),
                CSizedBox.h10(),
                CText("Nama Pendek Instansi"),
                CSizedBox.h5(),
                CTextField(
                  controller: controller.controllerShortName,
                  hintText: "Masukkan Nama Pendek",
                  keyboardType: TextInputType.number,
                  inputFormatters: [UpperCaseTextFormatter()],
                  validator: (value) {
                    if (GetUtils.isNullOrBlank(value) == true) {
                      return msgBlank;
                    }
                    return null;
                  },
                ),
                CSizedBox.h20(),
                CButton(() {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (!controller.keyForm.currentState!.validate()) return;
                  Get.back();
                  if (action == 1) {
                    controller.addNewInstansi();
                  } else {
                    controller.updateInstansi(initial);
                  }
                }, action == 1 ? "Tambah" : "Ubah")
              ],
            ),
          ));
        });
  }
}
