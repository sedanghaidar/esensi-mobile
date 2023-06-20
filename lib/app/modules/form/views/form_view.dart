import 'package:absensi_kegiatan/app/data/model/RegionModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/global_widgets/button/CButtonStyle.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/error.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/responsive_layout.dart';
import 'package:absensi_kegiatan/app/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_view/factory.dart';
import 'package:magic_view/style/AutoCompleteData.dart';
import 'package:magic_view/style/MagicTextFieldStyle.dart';
import 'package:magic_view/widget/textfield/MagicAutoComplete.dart';
import 'package:magic_view/widget/textfield/MagicTextField.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../../data/model/InstansiModel.dart';
import '../../../global_widgets/button/CButton.dart';
import '../../../global_widgets/other/toast.dart';
import '../../../global_widgets/sized_box/CSizedBox.dart';
import '../../../global_widgets/text/CText.dart';
import '../../../global_widgets/text_field/CTextField.dart';
import '../../../global_widgets/text_field/CTextFieldDropDown.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';
import '../../../utils/constant.dart';
import '../../../utils/string.dart';
import '../../../utils/utils.dart';
import '../controllers/form_controller.dart';

class FormView extends GetView<FormController> {
  double width = 0;

  @override
  Widget build(BuildContext context) {
    width = context.width;
    final orientation = getPlatform(context);
    if (orientation == WEB_LANDSCAPE || orientation == DESKTOP_LANDSCAPE) {
      width = width / 2;
    } else {
      width = context.width;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: basicPrimary,
        title: const Text('Formulir'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        leading: controller.repository.hive.isLoggedIn() == true
            ? InkWell(
                onTap: () {
                  Get.offAllNamed(Routes.DASHBOARD);
                },
                child: Icon(
                  Icons.home,
                  color: basicWhite,
                ),
              )
            : Container(),
      ),
      backgroundColor: basicPrimary,
      body: SingleChildScrollView(
        primary: true,
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: ResponsiveLayout(
          Container(
            child: Obx(() {
              switch (controller.kegiatan.value.statusRequest) {
                case StatusRequest.LOADING:
                  return loading(context);
                case StatusRequest.SUCCESS:
                  {
                    if ("${controller.kegiatan.value.data?.id}" !=
                        "${controller.id}") {
                      if (checkOutDate(
                          controller.kegiatan.value.data?.date ?? DateTime.now(),
                          controller.kegiatan.value.data?.dateEnd)) {
                        return warning(context,
                            "Formulir sudah ditutup atau tanggal kegiatan sudah lewat");
                      }
                    }
                    return successBody(context);
                  }
                default:
                  return const SizedBox();
              }
            }),
          ),),
      )
    );
  }

  successBody(BuildContext context) {
    return Center(
      child: GetBuilder<FormController>(
        builder: (_) => Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.topLeft,
          color: basicWhite,
          width: width,
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CText.header("${controller.kegiatan.value.data?.name}"),
                const CSizedBox.h20(),
                const CText("Kegiatan akan dilaksanakan pada :"),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month),
                      CSizedBox.w10(),
                      CText(dateToString(controller.kegiatan.value.data?.date))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Icon(Icons.access_time_rounded),
                      CSizedBox.w10(),
                      Expanded(
                        flex: 1,
                        child: CText(
                            "${controller.kegiatan.value.data?.time} - selesai"),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Icon(Icons.location_on_outlined),
                      CSizedBox.w10(),
                      Expanded(
                        flex: 1,
                        child: CText(
                            "${controller.kegiatan.value.data?.location}"),
                      )
                    ],
                  ),
                ),
                controller.kegiatan.value.data?.information != null
                    ? Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(10),
                        color: basicPrimary,
                        child: Row(
                          children: [
                            Icon(
                              Icons.info,
                              color: basicWhite,
                            ),
                            CSizedBox.w10(),
                            Expanded(
                              flex: 1,
                              child: SelectableText.rich(TextSpan(
                                children: extractText("${controller.kegiatan.value.data?.information}"),
                              )),
                            )
                          ],
                        ),
                      )
                    : SizedBox(),
                Visibility(
                  visible: controller.kegiatan.value.data?.dateEnd == null
                      ? false
                      : true,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, top: 5),
                    child: CText(
                      "Formulir akan ditutup pada ${dateToString(controller.kegiatan.value.data?.dateEnd)}",
                      style: CText.textStyleBody.copyWith(color: basicRed1),
                    ),
                  ),
                ),
                const CSizedBox.h20(),
                const CText("Nama"),
                const CSizedBox.h5(),
                CTextField(
                  controller: controller.controllerName,
                  focusNode: controller.name,
                  hintText: "Masukkan Nama",
                  validator: (value) {
                    if (GetUtils.isBlank(value) == true) return msgBlank;
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                ),
                const CSizedBox.h10(),
                const CText("No. Telp"),
                const CSizedBox.h5(),
                CTextField(
                  controller: controller.controllerPhone,
                  hintText: "Masukkan No. Telp",
                  validator: (value) {
                    if (GetUtils.isBlank(value) == true) return msgBlank;
                    if (GetUtils.isPhoneNumber(value) == false) {
                      return msgPhoneNotValid;
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                ),
                const CSizedBox.h10(),
                const CText("Jenis Kelamin"),
                const CSizedBox.h5(),
                CTextFieldDropDown<String>(
                  hintText: "Pilih Jenis Kelamin",
                  value: controller.controllerGender.text == ""
                      ? null
                      : controller.controllerGender.text,
                  items: form_gender
                      .map((e) =>
                          DropdownMenuItem<String>(value: e, child: CText(e)))
                      .toList(),
                  onChange: (value) {
                    if (controller.controllerGender.text != value) {
                      controller.controllerGender.text = value;
                    }
                  },
                  validator: (value) {
                    if (value == null ||
                        GetUtils.isBlank(controller.controllerGender.text) ==
                            true ||
                        GetUtils.isBlank(value) == true) return msgBlank;
                    return null;
                  },
                ),
                const CSizedBox.h10(),
                const CText("Instansi"),
                const CSizedBox.h5(),
                Obx(() {
                  switch (controller.instansi.value.statusRequest) {
                    case StatusRequest.LOADING:
                      return loading(context);
                    case StatusRequest.SUCCESS:
                      List<InstansiModel> result =
                          controller.instansi.value.data ?? List.empty();
                      final list = result.map((e) {
                        if (controller
                                .kegiatan.value.data?.isLimitParticipant ==
                            false) {
                          final name1 = e.name;
                          final name2 = e.parent?.name == null
                              ? ""
                              : " ${e.parent?.name}";
                          return AutoCompleteData("$name1$name2", e);
                        } else {
                          final name1 = e.name;
                          final name2 = e.parent?.name == null
                              ? ""
                              : " ${e.parent?.name}";
                          final name3 =
                              e.wilayahName == null ? "" : " ${e.wilayahName}";
                          return AutoCompleteData("$name1$name2$name3", e);
                        }
                      }).toList();
                      return MagicAutoComplete<InstansiModel>(
                        controller: controller.controllerInstansi,
                        list: list,
                        onSelected: (selected) {
                          final name1 = selected.data?.name;
                          final name2 = selected.data?.parent?.name;
                          controller.selectedInstansi = selected;
                          controller.controllerInstansi.text =
                              "$name1 ${name2 ?? ""}";
                          controller.controllerInstansi.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: controller
                                      .controllerInstansi.text.length));
                          if (selected.data?.name == "LAINNYA") {
                            controller.setIsOpenInstansi(true);
                          } else {
                            controller.setIsOpenInstansi(false);
                          }

                          if(controller.kegiatan.value.data?.isLimitParticipant==true){
                            controller.selectedWilayah = AutoCompleteData(selected.data?.wilayahName, RegionModel(
                              name: selected.data?.wilayahName,
                              id: "${selected.data?.wilayahId}",
                            ));
                            controller.controllerWilayah.text = selected.data?.wilayahName ?? "";
                            controller.enableWilayah.value = false;
                          }else{
                            controller.selectedWilayah = null;
                            controller.enableWilayah.value = true;
                          }
                        },
                        maxWidthOption: width - 40,
                        textFieldStyle: MagicTextFieldStyle(
                          validator: (value) {
                            if (GetUtils.isBlank(value) == true) {
                              return msgBlank;
                            }
                            if (controller
                                    .kegiatan.value.data?.isLimitParticipant ==
                                true) {
                              if (value !=
                                  controller.selectedInstansi?.option) {
                                return "Silahkan pilih salah satu dari pilihan yang ada";
                              }
                            }
                            return null;
                          },
                        ),
                      );
                    case StatusRequest.ERROR:
                      return error(
                          context,
                          controller.instansi.value.failure?.msgShow,
                          () => controller.getInstansi());
                    default:
                      return SizedBox();
                  }
                }),
                Obx(() {
                  return Visibility(
                    visible: controller.isOpenInstansi.value,
                    child: CTextField(
                      hintText: "Masukkan nama instansi anda",
                      controller: controller.controllerInstansiManual,
                      textCapitalization: TextCapitalization.characters,
                      validator: (value) {
                        if (controller.controllerInstansi.text == "LAINNYA") {
                          if (GetUtils.isBlank(value) == true) {
                            return "Nama Instansi Tidak Boleh Kosong";
                          }
                        }
                        return null;
                      },
                    ),
                  );
                }),
                const CSizedBox.h10(),
                const CText("Wilayah"),
                const CSizedBox.h5(),
                Obx(() {
                  switch (controller.regions.value.statusRequest) {
                    case StatusRequest.LOADING:
                      return loading(context);
                    case StatusRequest.SUCCESS:
                      List<RegionModel> result =
                          controller.regions.value.data ?? List.empty();
                      final list = result.map((e) {
                        return AutoCompleteData(e.name, e);
                      }).toList();
                      if(controller.kegiatan.value.data?.isLimitParticipant == true){
                        return MagicTextField.border(controller.controllerWilayah, enabled: false,);
                      }
                      return MagicAutoComplete<RegionModel>(
                        initial: controller.controllerWilayah.text,
                        controller: controller.controllerWilayah,
                        list: list,
                        onSelected: (selected) {
                          controller.selectedWilayah = selected;
                          controller.controllerWilayah.text =
                          "${selected.data?.name}";
                        },
                        maxWidthOption: width - 40,
                        textFieldStyle: MagicTextFieldStyle(
                          enabled: controller.enableWilayah.value,
                          validator: (value) {
                            if (GetUtils.isBlank(value) == true) {
                              return msgBlank;
                            }
                            if (value != controller.selectedWilayah?.option) {
                              return "Silahkan pilih salah satu dari pilihan yang ada";
                            }
                            return null;
                          },
                        ),
                      );
                    case StatusRequest.ERROR:
                      return error(
                          context,
                          controller.instansi.value.failure?.msgShow,
                          () => controller.getInstansi());
                    default:
                      return SizedBox();
                  }
                }),
                const CSizedBox.h10(),
                const CText("Jabatan"),
                const CSizedBox.h5(),
                CTextField(
                  controller: controller.controllerJabatan,
                  hintText: "Masukkan Jabatan",
                  validator: (value) {
                    if (GetUtils.isBlank(value) == true) return msgBlank;
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                ),
                const CSizedBox.h10(),
                const CText("Tanda Tangan"),
                const CSizedBox.h5(),
                InkWell(
                  onTap: () => showPadTTD(context),
                  child: Container(
                      height: context.width >= maxWidth ? 350 : 250,
                      width: double.infinity,
                      decoration:
                          BoxDecoration(border: Border.all(color: basicBlack)),
                      child: controller.fileBytes != null
                          ? Image.memory(controller.fileBytes!)
                          : const Center(
                              child: Text(
                                "Tap Me\n(Signature)",
                                textAlign: TextAlign.center,
                              ),
                            )),
                ),
                const CSizedBox.h20(),
                CButton(() {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (!controller.formKey.currentState!.validate()) return;
                  if (!controller.isSigned.value) {
                    showToast("Silahkan tanda tangan terlebih dahulu");
                    return;
                  }
                  controller.insertPeserta();
                }, "SIMPAN")
              ],
            ),
          ),
        ),
      ),
    );
  }

  showPadTTD(BuildContext context) {
    Get.dialog(
      Center(
        child: Container(
          // constraints: BoxConstraints(maxWidth: 1080),
          height: context.width >= maxWidth ? 550 : 450,
          width: context.width >= maxWidth ? 550 : double.infinity,
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: basicWhite,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: basicBlack),
                  color: basicGrey1,
                ),
                width: context.width >= maxWidth ? 450 : double.infinity,
                height: context.width >= maxWidth ? 350 : 350,
                child: SfSignaturePad(
                    minimumStrokeWidth: 3.0,
                    maximumStrokeWidth: 5.0,
                    strokeColor: basicBlack,
                    backgroundColor: basicWhite,
                    onDrawStart: controller.handleOnDrawStart,
                    key: controller.signaturePadKey),
              ),
              SizedBox(
                height: 32,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 1,
                      child: CButton(
                        () {
                          controller.isSigned.value = false;
                          controller.signaturePadKey.currentState?.clear();
                        },
                        "Clear",
                        style: styleButtonFilled2,
                      ),
                    ),
                    CSizedBox.w10(),
                    Expanded(
                      flex: 1,
                      child: CButton(() {
                        controller.pushImage();
                        Get.back();
                      }, "Simpan"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
