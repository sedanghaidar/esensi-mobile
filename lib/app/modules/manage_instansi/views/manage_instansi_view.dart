import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:magic_view/widget/button/MagicButton.dart';
import 'package:magic_view/widget/text/MagicText.dart';
import 'package:magic_view/widget/textfield/MagicTextField.dart';

import '../../../data/model/InstansiModel.dart';
import '../../../data/model/repository/StatusRequest.dart';
import '../../../global_widgets/button/CButton.dart';
import '../../../global_widgets/dialog/CDialog.dart';
import '../../../global_widgets/dialog/CLoading.dart';
import '../../../global_widgets/other/error.dart';
import '../../../global_widgets/other/responsive_layout.dart';
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
        appBar: widgetAppBar(),
        backgroundColor: basicPrimary,
        body: ResponsiveLayout(Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: basicWhite),
          padding: EdgeInsets.all(16),
          child: Column(
            children: [textFieldSearch(), rowInformation(), listView()],
          ),
        )),
      ),
    );
  }

  AppBar widgetAppBar() {
    return AppBar(
      backgroundColor: basicPrimary,
      centerTitle: true,
      elevation: 0,
      title: MagicText("Daftar Instansi"),
      leading: InkWell(
        onTap: () {
          Get.offAllNamed(Routes.DASHBOARD);
        },
        child: const Icon(
          Icons.home,
          color: basicWhite,
        ),
      ),
    );
  }

  Widget rowInformation() {
    return Row(
      children: [
        Obx(() {
          switch (controller.instansi.value.statusRequest) {
            case StatusRequest.SUCCESS:
              {
                return information("Total Instansi",
                    controller.instansi.value.data?.length ?? 0);
              }
            default:
              return SizedBox();
          }
        }),
        MagicButton(
          () {
            openDialog(Get.context!, 1);
          },
          text: "Tambah Instansi",
          textColor: Colors.white,
        )
      ],
    );
  }

  Widget information(String title, int total) {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: basicWhite,
            border: Border.all(color: basicPrimary, width: 2.0)),
        child: Column(
          children: [
            CText(
              title,
              textAlign: TextAlign.center,
              style: CText.textStyleBodyBold.copyWith(color: basicPrimary),
            ),
            CText(
              "$total",
              textAlign: TextAlign.center,
              style: CText.textStyleSubhead.copyWith(color: basicPrimary),
            )
          ],
        ),
      ),
    );
  }

  Widget textFieldSearch() {
    return Container(
      margin: EdgeInsets.all(10),
      child: MagicTextField.border(
        controller.controllerSearch,
        hint: "Cari Nama Instansi",
        onChange: (value) {
          controller.filter.value = value;
        },
        suffixIcon: const Icon(Icons.search),
      ),
    );
  }

  Widget listView() {
    return Expanded(
      flex: 1,
      child: Obx(() {
        switch (controller.instansi.value.statusRequest) {
          case StatusRequest.LOADING:
            return loading(Get.context!);
          case StatusRequest.EMPTY:
            return warning(Get.context!, "Instansi masih kosong");
          case StatusRequest.SUCCESS:
            String filter = controller.filter.value
                .toLowerCase(); // jangan dihapus buat trigger search!
            return ListView.builder(
              shrinkWrap: true,
              primary: true,
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(bottom: 56),
              itemBuilder: (context, index) {
                InstansiModel? instansi =
                    controller.instansi.value.data?[index];
                if (instansi?.name?.toLowerCase().contains(filter) == false) {
                  return Container();
                }
                return Card(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CText(
                                controller.instansi.value.data?[index].name ??
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
                                    initial:
                                        controller.instansi.value.data?[index]);
                              },
                              child: const Icon(Icons.edit),
                            )),
                        Expanded(flex: 0, child: CSizedBox.w10()),
                        Expanded(
                            flex: 0,
                            child: InkWell(
                              onTap: () {
                                controller.deleteInstansi(
                                    controller.instansi.value.data?[index]);
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
                Get.context!,
                controller.instansi.value.failure?.msgShow ??
                    "Terjadi Kesalahan", () {
              controller.getInstansiAll();
            });
          default:
            return const SizedBox();
        }
      }),
    );
  }

  openDialog(BuildContext context, int action, {InstansiModel? initial}) {
    controller.controllerName.text = initial == null ? "" : "${initial.name}";
    controller.controllerShortName.text =
        initial == null ? "" : "${initial.shortName}";
    controller.isInstansiPemerintah.value = initial?.internal ?? false;

    Get.dialog(cardDialog2(
        Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: controller.keyForm,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MagicText("Nama Instansi"),
                const CSizedBox.h5(),
                MagicTextField.border(
                  controller.controllerName,
                  hint: "Masukkan Nama Instansi",
                  keyboardType: TextInputType.text,
                  // inputFormatters: [UpperCaseTextFormatter()],
                  validator: (value) {
                    if (GetUtils.isNullOrBlank(value) == true) {
                      return msgBlank;
                    }
                    return null;
                  },
                ),
                const CSizedBox.h10(),
                MagicText("Nama Pendek Instansi"),
                const CSizedBox.h5(),
                MagicTextField.border(
                  controller.controllerShortName,
                  hint: "Masukkan Nama Pendek Instansi",
                  keyboardType: TextInputType.text,
                  // inputFormatters: [UpperCaseTextFormatter()],
                  validator: (value) {
                    if (GetUtils.isNullOrBlank(value) == true) {
                      return msgBlank;
                    }
                    return null;
                  },
                ),
                const CSizedBox.h10(),
                MagicText("Instansi Internal (Pemerintah)"),
                Obx(() => Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ListTile(
                            title: const Text('Ya'),
                            leading: Radio<bool>(
                                value: true,
                                groupValue:
                                    controller.isInstansiPemerintah.value,
                                onChanged: (value) {
                                  controller.isInstansiPemerintah.value =
                                      value ?? false;
                                }),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: ListTile(
                            title: const Text('Tidak'),
                            leading: Radio<bool>(
                                value: false,
                                groupValue:
                                    controller.isInstansiPemerintah.value,
                                onChanged: (value) {
                                  controller.isInstansiPemerintah.value =
                                      value ?? false;
                                }),
                          ),
                        ),
                      ],
                    )),
                MagicButton(
                  () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (!controller.keyForm.currentState!.validate()) return;
                    Get.back();
                    if (action == 1) {
                      controller.addNewInstansi();
                    } else {
                      controller.updateInstansi(initial);
                    }
                  },
                  text: action == 1 ? "Tambah" : "Ubah",
                  widthInfinity: true,
                )
              ],
            ),
          ),
        ),
        ResponsiveLayout.getWidth(Get.context!)));
  }
}
