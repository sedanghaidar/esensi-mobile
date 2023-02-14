import 'package:absensi_kegiatan/app/data/model/InstansiParticipantModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/global_widgets/button/CButton.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/error.dart';
import 'package:absensi_kegiatan/app/global_widgets/sized_box/CSizedBox.dart';
import 'package:absensi_kegiatan/app/global_widgets/text/CText.dart';
import 'package:absensi_kegiatan/app/global_widgets/text_field/CTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../../../data/model/InstansiModel.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';
import '../../../utils/string.dart';
import '../controllers/manage_participant_controller.dart';

class ManageParticipantView extends GetView<ManageParticipantController> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return dialogOnBackPressed();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: basicPrimary,
          title: Text('Manajemen Instansi Partisipan'),
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              dialogOnBackPressed();
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
                    }, "Tambah Partisipan")),
              ),
              const Expanded(flex: 0, child: CSizedBox.h10()),
              Expanded(
                flex: 0,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: CButton.small(() {
                      Get.toNamed(Routes.MANAGE_INSTANSI);
                    }, "Tambah Instansi")),
              ),
              const Expanded(flex: 0, child: CSizedBox.h30()),
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
                    switch (controller.participants.value.statusRequest) {
                      case StatusRequest.SUCCESS:
                        {
                          int total = 0;
                          for (InstansiPartipantModel i
                              in controller.participants.value.data ?? []) {
                            total = total + (i.maxParticipant ?? 0);
                          }
                          return Align(
                              alignment: Alignment.centerLeft,
                              child: CText(
                                "Total partisipan : $total",
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
                  switch (controller.participants.value.statusRequest) {
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
                          List<InstansiPartipantModel> instansi =
                              controller.participants.value.data ?? [];
                          if (instansi[index]
                                  .organization
                                  ?.name
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
                                          controller
                                                  .participants
                                                  .value
                                                  .data?[index]
                                                  .organization
                                                  ?.name ??
                                              "",
                                          style: CText.textStyleBodyBold,
                                        ),
                                        CText(
                                            "Jumlah maksimal : ${controller.participants.value.data?[index].maxParticipant}")
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      flex: 0,
                                      child: InkWell(
                                        onTap: () {
                                          openDialog(context, 2,
                                              initial: controller.participants
                                                  .value.data?[index]);
                                        },
                                        child: const Icon(Icons.edit),
                                      )),
                                  Expanded(flex: 0, child: CSizedBox.w10()),
                                  Expanded(
                                      flex: 0,
                                      child: InkWell(
                                        onTap: () {
                                          controller.deleteParticipant(
                                              controller.participants.value
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
                        itemCount:
                            controller.participants.value.data?.length ?? 0,
                      );
                    case StatusRequest.ERROR:
                      return error(
                          context,
                          controller.participants.value.failure?.msgShow ??
                              "Terjadi Kesalahan", () {
                        controller.getInstansiParticipant();
                      });
                    default:
                      return SizedBox();
                  }
                }),
              ),
              Expanded(
                  flex: 0,
                  child: CButton(() {
                    controller.updateInstansiParticipant();
                  }, "SIMPAN"))
            ],
          ),
        ),
      ),
    );
  }

  bool dialogOnBackPressed(){
    if (controller.isChange.value == true) {
      Get.defaultDialog(
          title: "Perhatian",
          middleText: "Ada perubahan yang belum disimpan. Yakin kembali?",
          textConfirm: "Ya",
          textCancel: "Tidak",
          onConfirm: () {
            Get.back();
            Get.offAllNamed(Routes.DASHBOARD);
          },
          buttonColor: basicPrimary,
          cancelTextColor: basicPrimary,
          confirmTextColor: basicWhite);
      return false;
    } else {
      Get.offAllNamed(Routes.DASHBOARD);
      return true;
    }
  }

  openDialog(BuildContext context, int action,
      {InstansiPartipantModel? initial}) {
    controller.controllerInstansi = TextEditingController();
    controller.controllerMax.text =
        initial == null ? "0" : "${initial.maxParticipant}";

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
                widgetInstansi(context, action, initial: initial),
                CSizedBox.h10(),
                CText("Maksimal Partisipan"),
                CSizedBox.h5(),
                CTextField(
                  controller: controller.controllerMax,
                  hintText: "Masukkan jumlah maksimal partisipan",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (GetUtils.isNullOrBlank(value) == true) {
                      return msgBlank;
                    }
                    if (!GetUtils.isNumericOnly(value)) {
                      return "Hanya boleh berupa angka";
                    }
                    if (int.parse(value) == 0) {
                      return "Minimal 1";
                    }
                    return null;
                  },
                ),
                CSizedBox.h20(),
                CButton(() {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (!controller.keyForm.currentState!.validate()) return;
                  Get.back();
                  controller.isChange.value = true;
                  InstansiPartipantModel newIpm = InstansiPartipantModel(
                      maxParticipant: int.parse(controller.controllerMax.text),
                      organization: InstansiModel(
                          name: controller.controllerInstansi.text));
                  if (action == 1) {
                    controller.addParticipant(newIpm);
                  } else {
                    controller.updateParticipant(newIpm);
                  }
                }, action == 1 ? "Tambah" : "Ubah")
              ],
            ),
          ));
        });
  }

  Widget widgetInstansi(BuildContext context, int action,
      {InstansiPartipantModel? initial}) {
    if (action == 1) {
      return Autocomplete<InstansiModel>(
        onSelected: (data) {
          controller.controllerInstansi.text = data.name ?? "";
          controller.controllerInstansi.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.controllerInstansi.text.length));
        },
        optionsBuilder: (text) {
          if (text.text.isEmpty) {
            return controller.instansi.value.data ?? List.empty();
          } else {
            return (controller.instansi.value.data ?? List.empty()).where(
                (element) => (element.name ?? "")
                    .toLowerCase()
                    .contains(text.text.toLowerCase()));
          }
        },
        displayStringForOption: (value) {
          return value.name ?? "";
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200, maxWidth: 275),
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      try {
                        final data = options.elementAt(index);
                        bool isEnabled = true;
                        Iterable<InstansiPartipantModel>? checkData = controller
                            .participants.value.data
                            ?.where((element) =>
                                element.organization?.name == data.name);
                        if (checkData?.isNotEmpty == true) isEnabled = false;
                        return ListTile(
                          title: SubstringHighlight(
                            text: data.name ?? "",
                            textStyle: CText.textStyleBody.copyWith(
                                color: isEnabled ? basicBlack : basicGrey2),
                            term: controller.controllerInstansi.text,
                            textStyleHighlight:
                                TextStyle(fontWeight: FontWeight.w700),
                          ),
                          enabled: isEnabled,
                          hoverColor:
                              isEnabled ? basicGrey2 : Colors.transparent,
                          onTap: () {
                            onSelected(data);
                          },
                        );
                      } catch (e) {
                        return SizedBox();
                      }
                    },
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: options.length),
              ),
            ),
          );
        },
        fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
          this.controller.controllerInstansi = controller;
          return CTextField(
            controller: controller,
            focusNode: focusNode,
            hintText: "Pilih salah satu dari pilihan yang ada",
            onEditingComplete: onEditingComplete,
            validator: (value) {
              if (GetUtils.isBlank(value) == true) {
                return msgBlank;
              }
              Iterable<InstansiModel> data =
                  (this.controller.instansi.value.data ?? List.empty())
                      .where((element) => element.name == value);
              if (data.isEmpty) {
                return "Silahkan pilih salah satu dari pilihan yang ada";
              }
              return null;
            },
          );
        },
      );
    } else {
      controller.controllerInstansi.text = initial?.organization?.name ?? "";
      return CTextField(
        controller: controller.controllerInstansi,
        hintText: "Nama Instansi",
        enabled: false,
      );
    }
  }
}
