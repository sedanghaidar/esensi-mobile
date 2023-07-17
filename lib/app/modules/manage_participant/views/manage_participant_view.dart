import 'package:absensi_kegiatan/app/data/model/InstansiParticipantModel.dart';
import 'package:absensi_kegiatan/app/data/model/RegionModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/global_widgets/button/CButton.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CDialog.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/error.dart';
import 'package:absensi_kegiatan/app/global_widgets/sized_box/CSizedBox.dart';
import 'package:absensi_kegiatan/app/global_widgets/text/CText.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_view/factory.dart';
import 'package:magic_view/style/AutoCompleteData.dart';
import 'package:magic_view/style/MagicTextFieldStyle.dart';
import 'package:magic_view/style/MagicTextStyle.dart';
import 'package:magic_view/widget/button/MagicButton.dart';
import 'package:magic_view/widget/text/MagicText.dart';
import 'package:magic_view/widget/textfield/MagicAutoComplete.dart';
import 'package:magic_view/widget/textfield/MagicTextField.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../../../data/model/InstansiModel.dart';
import '../../../global_widgets/other/responsive_layout.dart';
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
        backgroundColor: basicPrimary,
        appBar: widgetAppBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            openDialog(Get.context!, 1);
          },
          backgroundColor: basicPrimaryDark,
          child: const Icon(
            Icons.add,
            color: basicWhite,
          ),
        ),
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
      leading: InkWell(
        onTap: () {
          dialogOnBackPressed();
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
        switch (controller.participants.value.statusRequest) {
          case StatusRequest.LOADING:
            return loading(context);
          case StatusRequest.EMPTY:
            return warning(context, "Instansi partisipan masih kosong");
          case StatusRequest.SUCCESS:
            String filter = controller.filter.value
                .toLowerCase(); // jangan dihapus buat trigger search!
            return ListView.builder(
              shrinkWrap: true,
              primary: true,
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(bottom: 56),
              itemBuilder: (context, index) {
                InstansiPartipantModel? instansi =
                    controller.participants.value.data?[index];
                if (controller
                        .getNameInstansiPartisipan(instansi)
                        .toLowerCase()
                        .contains(filter) ==
                    false) {
                  return Container();
                }
                return Card(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MagicText.subhead(controller
                                  .getNameInstansiPartisipan(instansi)),
                              MagicText(
                                  "Jumlah maksimal : ${instansi?.maxParticipant}")
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
                        const Expanded(flex: 0, child: CSizedBox.w10()),
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
            return const SizedBox();
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
    /// Reset data
    controller.selectedInstansi = null;
    controller.controllerInstansi = TextEditingController();
    controller.selectedRegions = [];
    controller.controllerRegion = TextEditingController();
    controller.controllerMax.text =
        initial == null ? "0" : "${initial.maxParticipant}";

    Get.dialog(cardDialog2(
        Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: controller.keyForm,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// INSTANSI
                MagicText("Nama Instansi"),
                const CSizedBox.h5(),
                widgetInstansi(context, action, initial: initial),
                const CSizedBox.h5(),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: "Instansi tidak ditemukan? ",
                      style: MagicFactory.magicTextStyle.toGoogleTextStyle()),
                  TextSpan(
                      text: "Tambah Instansi",
                      style: MagicFactory.magicTextStyle
                          .copyWith(
                              color: basicPrimary, fontWeight: FontWeight.bold)
                          .toGoogleTextStyle(),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.back();
                          Get.toNamed(Routes.MANAGE_INSTANSI)?.then((value) {
                            controller.getInstansiAll();
                          });
                        }),
                ])),

                /// WILAYAH
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
                  controller.createOrUpdateParticipant(action,
                      instansiPartipantModel: initial);
                }, action == 1 ? "Tambah" : "Ubah")
              ],
            ),
          ),
        ),
        ResponsiveLayout.getWidth(Get.context!)));
  }

  Widget widgetInstansi(BuildContext context, int action,
      {InstansiPartipantModel? initial}) {
    if (action == 1) {
      final list = controller.instansi.value.data?.map((e) {
        return getOption(e);
      }).toList();
      return MagicAutoComplete<InstansiModel>(
          controller: controller.controllerInstansi,
          list: list ?? [],
          maxWidthOption: ResponsiveLayout.getWidth(Get.context!) - 40,
          textFieldStyle: MagicTextFieldStyle(
            hint: "Pilih Instansi",
            validator: (value) {
              if (GetUtils.isBlank(value) == true) {
                return msgBlank;
              }
              if (value != getOptionString(controller.selectedInstansi)) {
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
      return MagicTextField.border(
        controller.controllerInstansi,
        hint: "Nama Instansi",
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
              final list = controller.convertListRegionToAutoCompleteData();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CSizedBox.h10(),
                  MagicText("Nama Wilayah"),
                  MagicButton(
                    () {
                      for (int i = 0; i < (list?.length ?? 0); i++) {
                        if (list?[i].enable == true) {
                          controller.selectedRegions.add(list?[i].data);
                        }
                      }
                      controller.update(['regions']);
                    },
                    text: "Pilih Semua",
                  ),
                  CSizedBox.h5(),
                  widgetCheckboxRegion(list, (item, value) {
                    if (value == false) {
                      controller.selectedRegions.remove(item);
                    } else {
                      controller.selectedRegions.add(item);
                    }
                    controller.update(['regions']);
                  })
                ],
              );
            }
          } else {
            controller.controllerRegion.text = initial?.wilayahName ?? "";
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CSizedBox.h10(),
                MagicText("Nama Wilayah"),
                const CSizedBox.h5(),
                MagicTextField.border(
                  controller.controllerRegion,
                  hint: "Nama Wilayah",
                  enabled: false,
                )
              ],
            );
          }
        });
  }

  Widget widgetCheckboxRegion(List<AutoCompleteData<RegionModel>>? list,
      Function(RegionModel?, bool?) onChange) {
    return GetBuilder<ManageParticipantController>(
      id: 'regions',
      builder: (controller) {
        return ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return CheckboxListTile(
              value: (list?[index].enable == true
                  ? controller.selectedRegions.contains(list?[index].data)
                  : true),
              onChanged: (value) {
                onChange(list?[index].data, value);
              },
              title: MagicText(
                list?[index].option ?? "",
                color: list?[index].enable == true
                    ? null
                    : MagicFactory.colorDisable,
              ),
              enabled: list?[index].enable,
            );
          },
          itemCount: controller.regions.value.data?.length ?? 0,
        );
      },
    );
  }
}
