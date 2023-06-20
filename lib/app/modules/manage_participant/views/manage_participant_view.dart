import 'package:absensi_kegiatan/app/data/model/InstansiParticipantModel.dart';
import 'package:absensi_kegiatan/app/data/model/RegionModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/global_widgets/button/CButton.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/error.dart';
import 'package:absensi_kegiatan/app/global_widgets/responsive_layout/ResponsiveLayout.dart';
import 'package:absensi_kegiatan/app/global_widgets/sized_box/CSizedBox.dart';
import 'package:absensi_kegiatan/app/global_widgets/text/CText.dart';
import 'package:absensi_kegiatan/app/global_widgets/text_field/CTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_view/style/AutoCompleteData.dart';
import 'package:magic_view/style/MagicTextFieldStyle.dart';
import 'package:magic_view/widget/text/MagicText.dart';
import 'package:magic_view/widget/textfield/MagicAutoComplete.dart';
import 'package:magic_view/widget/textfield/MagicTextField.dart';

import '../../../data/model/InstansiModel.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';
import '../../../utils/string.dart';
import '../controllers/manage_participant_controller.dart';

class ManageParticipantView extends GetView<ManageParticipantController> {
  late BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return WillPopScope(
      onWillPop: () async {
        return dialogOnBackPressed();
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: basicPrimary,
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
            actions: [
              Center(
                child: InkWell(
                  onTap: () {
                    openDialog(context, 1);
                  },
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Image.network(
                            "https://cdn-icons-png.flaticon.com/512/2861/2861698.png",
                            width: 32,
                            height: 32,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          CText(
                            "Tambah\nPartisipan",
                            style:
                                CText.textStyleHint.copyWith(color: basicWhite),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                ),
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.MANAGE_INSTANSI);
                  },
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Image.network(
                            "https://cdn-icons-png.flaticon.com/512/993/993928.png",
                            width: 32,
                            height: 32,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          CText(
                            "Tambah\nInstansi",
                            style:
                                CText.textStyleHint.copyWith(color: basicWhite),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                ),
              ),
              SizedBox(
                width: 20,
              )
            ],
          ),
          body: ResponsiveLayout(
            largeScreen(),
            smallScreen: smallScreen(),
          )),
    );
  }

  Widget smallScreen() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        width: context.width,
        child: Stack(
          children: [
            Container(
              height: 220,
              decoration: BoxDecoration(
                  color: basicPrimary.withOpacity(0.25),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(120),
                      bottomRight: Radius.circular(120))),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CText(
                      "Manajemen Partisipan",
                      style: CText.textStyleSubhead,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                ),
                textFieldSearch(),
                rowInformation(),
                listView()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget largeScreen() {
    return Center(
      child: Container(
        width: context.width / 1.5,
        child: Stack(
          children: [
            Container(
              height: 220,
              decoration: BoxDecoration(
                  color: basicPrimary.withOpacity(0.25),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(120),
                      bottomRight: Radius.circular(120))),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CText(
                        "Manajemen Partisipan",
                        style: CText.textStyleSubhead,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                  ),
                  textFieldSearch(),
                  rowInformation(),
                  listView()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget rowInformation() {
    return Row(
      children: [
        Obx(() {
          switch (controller.participants.value.statusRequest) {
            case StatusRequest.SUCCESS:
              {
                controller.countTotalInstansi();
                return information(
                    "Total Instansi", controller.totalInstansi.value);
              }
            default:
              return SizedBox();
          }
        }),
        Obx(() {
          switch (controller.participants.value.statusRequest) {
            case StatusRequest.SUCCESS:
              {
                controller.countTotalPartisipan();
                return information(
                    "Total Partisipan", controller.totalPartisipan.value);
              }
            default:
              return SizedBox();
          }
        }),
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
      child: CTextField(
        controller: controller.controllerSearch,
        hintText: "Cari Nama Instansi",
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
        switch (controller.participants.value.statusRequest) {
          case StatusRequest.LOADING:
            return loading(context);
          case StatusRequest.EMPTY:
            return warning(context, "Instansi partisipan masih kosong");
          case StatusRequest.SUCCESS:
            String filter = controller.filter.value
                .toLowerCase(); // jangan dihapus buat trigger search!
            return ListView.builder(
              itemBuilder: (context, index) {
                List<InstansiPartipantModel> instansi =
                    controller.participants.value.data ?? [];
                if (controller.getNameInstansiPartisipan(instansi[index]).toLowerCase().contains(filter) == false) {
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
                                "${controller.participants.value.data?[index].organization?.name} ${controller.participants.value.data?[index].wilayahName}" ??
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
                                    initial: controller
                                        .participants.value.data?[index]);
                              },
                              child: const Icon(Icons.edit),
                            )),
                        Expanded(flex: 0, child: CSizedBox.w10()),
                        Expanded(
                            flex: 0,
                            child: InkWell(
                              onTap: () {
                                controller.deleteParticipant(
                                    controller.participants.value.data?[index]);
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
              itemCount: controller.participants.value.data?.length ?? 0,
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
    );
  }

  bool dialogOnBackPressed() {
    Get.offAllNamed(Routes.DASHBOARD);
    return true;
  }

  openDialog(BuildContext context, int action,
      {InstansiPartipantModel? initial}) {

    controller.selectedInstansi = null;
    controller.controllerInstansi = TextEditingController();
    controller.selectedRegion = initial == null ? null : RegionModel(
      name: initial.wilayahName,
      id: "${initial.wilayahId}"
    );
    controller.controllerRegion = TextEditingController();
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
                widgetRegion(context, action, initial: initial),
                CSizedBox.h10(),
                CText("Maksimal Partisipan"),
                CSizedBox.h5(),
                MagicTextField.border(
                  controller.controllerMax,
                  hint: "Masukkan jumlah maksimal partisipan",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (GetUtils.isNullOrBlank(value) == true) {
                      return msgBlank;
                    }
                    if (!GetUtils.isNumericOnly(value ?? "")) {
                      return "Hanya boleh berupa angka";
                    }
                    if (int.parse(value ?? "") == 0) {
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
                  controller.createOrUpdateParticipant(action);
                }, action == 1 ? "Tambah" : "Ubah")
              ],
            ),
          ));
        });
  }

  Widget widgetInstansi(BuildContext context, int action,
      {InstansiPartipantModel? initial}) {
    if (action == 1) {
      final list = controller.instansi.value.data?.map((e) {
        String parent = e.parent?.name == null ? "" : " ${e.parent?.name}";
        return AutoCompleteData<InstansiModel>("${e.name}$parent", e);
      }).toList();
      return MagicAutoComplete<InstansiModel>(
          controller: controller.controllerInstansi,
          list: list ?? [],
          maxWidthOption: 275,
          textFieldStyle: MagicTextFieldStyle(
            validator: (value) {
              if (GetUtils.isBlank(value) == true) {
                return msgBlank;
              }
              String name = controller.selectedInstansi?.name ?? "";
              String parent = controller.selectedInstansi?.parent?.name == null
                  ? ""
                  : " ${controller.selectedInstansi?.parent?.name}";
              if (value != "$name$parent") {
                return "Silahkan pilih salah satu dari pilihan yang ada";
              }
              return null;
            },
          ),
          onSelected: (value) {
            controller.controllerInstansi.text = value.data?.name ?? "";
            controller.controllerInstansi.selection =
                TextSelection.fromPosition(TextPosition(
                    offset: controller.controllerInstansi.text.length));
            controller.selectedInstansi = value.data;
            controller.update(['region']);
          });
    } else {
      controller.controllerInstansi.text = initial?.organization?.name ?? "";
      return CTextField(
        controller: controller.controllerInstansi,
        hintText: "Nama Instansi",
        enabled: false,
      );
    }
  }

  Widget widgetRegion(BuildContext context, int action,
      {InstansiPartipantModel? initial}) {
    return GetBuilder<ManageParticipantController>(
        id: 'region',
        builder: (controller) {
          if (action == 1) {
            if (controller.selectedInstansi == null) {
              return Container();
            } else {
              final list = controller.regions.value.data?.map((e) {
                final check =
                    (controller.participants.value.data ?? []).where((element) {
                  return element.organization?.id ==
                          controller.selectedInstansi?.id &&
                      "${element.wilayahId}" == "${e.id}";
                });
                return AutoCompleteData<RegionModel>("${e.name}", e,
                    enable: check.isEmpty);
              }).toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MagicText("Nama Wilayah"),
                  CSizedBox.h5(),
                  MagicAutoComplete<RegionModel>(
                      controller: controller.controllerRegion,
                      list: list ?? [],
                      maxWidthOption: 275,
                      textFieldStyle: MagicTextFieldStyle(
                        validator: (value) {
                          if (GetUtils.isBlank(value) == true) {
                            return msgBlank;
                          }
                          Iterable<RegionModel> data =
                              (this.controller.regions.value.data ??
                                      List.empty())
                                  .where((element) => element.name == value);
                          if (data.isEmpty) {
                            return "Silahkan pilih salah satu dari pilihan yang ada";
                          }
                          return null;
                        },
                      ),
                      onSelected: (value) {
                        controller.selectedRegion = value.data;
                      })
                ],
              );
            }
          } else {
            controller.controllerRegion.text = initial?.wilayahName ?? "";
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MagicText("Nama Wilayah"),
                CSizedBox.h5(),
                MagicTextField(
                  controller.controllerRegion,
                  hint: "Nama Wilayah",
                  enabled: false,
                )
              ],
            );
          }
        });
  }
}
