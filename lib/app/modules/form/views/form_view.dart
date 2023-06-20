import 'package:absensi_kegiatan/app/data/model/RegionModel.dart';
import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/error.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/responsive_layout.dart';
import 'package:absensi_kegiatan/app/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_view/style/AutoCompleteData.dart';
import 'package:magic_view/style/MagicTextFieldStyle.dart';
import 'package:magic_view/widget/button/MagicButton.dart';
import 'package:magic_view/widget/text/MagicText.dart';
import 'package:magic_view/widget/textfield/MagicAutoComplete.dart';
import 'package:magic_view/widget/textfield/MagicTextField.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../../data/model/InstansiModel.dart';
import '../../../global_widgets/other/toast.dart';
import '../../../global_widgets/sized_box/CSizedBox.dart';
import '../../../global_widgets/text/CText.dart';
import '../../../global_widgets/text_field/CTextFieldDropDown.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';
import '../../../utils/constant.dart';
import '../../../utils/string.dart';
import '../../../utils/utils.dart';
import '../controllers/form_controller.dart';

class FormView extends GetView<FormController> {
  @override
  Widget build(BuildContext context) {
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
                  child: const Icon(
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
            Obx(() {
              switch (controller.kegiatan.value.statusRequest) {
                case StatusRequest.LOADING:
                  return loading(context);
                case StatusRequest.SUCCESS:
                  {
                    return controller.checkExpirationForm()
                        ? closedForm()
                        : body();
                  }
                default:
                  return const SizedBox();
              }
            }),
          ),
        ));
  }

  body() {
    return GetBuilder<FormController>(
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.topLeft,
        color: basicWhite,
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widgetTitle(),
              const CSizedBox.h10(),
              widgetAdditionalInformation(),
              const CSizedBox.h10(),
              widgetSubtitle(),
              widgetDateAndTime(
                Icons.calendar_month,
                dateToString(controller.kegiatan.value.data?.date),
              ),
              widgetDateAndTime(
                Icons.access_time_rounded,
                "${controller.kegiatan.value.data?.time} WIB - selesai",
              ),
              widgetDateAndTime(
                Icons.location_on_outlined,
                "${controller.kegiatan.value.data?.location}",
              ),
              widgetExpiredDateForm(),
              const CSizedBox.h20(),
              widgetTextfield(
                  "Nama", "Masukkan nama", controller.controllerName,
                  style: MagicTextFieldStyle(
                    validator: (value) {
                      if (GetUtils.isBlank(value) == true) return msgBlank;
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                  )),
              const CSizedBox.h10(),
              widgetTextfield("No. Telp (Whatsapp)", "Masukkan No. Telp",
                  controller.controllerPhone,
                  style: MagicTextFieldStyle(
                    validator: (value) {
                      if (GetUtils.isBlank(value) == true) return msgBlank;
                      if (GetUtils.isPhoneNumber(value ?? "") == false) {
                        return msgPhoneNotValid;
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                  )),
              const CSizedBox.h10(),
              widgetDropdown(),
              const CSizedBox.h10(),
              widgetAutocompleteInstansi(),
              const CSizedBox.h10(),
              widgetAutoCompleteWilayah(),
              const CSizedBox.h10(),
              widgetTextfield("Jabatan", "Masukan jabatan anda",
                  controller.controllerJabatan,
                  style: MagicTextFieldStyle(
                    validator: (value) {
                      if (GetUtils.isBlank(value) == true) return msgBlank;
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                  )),
              const CSizedBox.h10(),
              const CText("Tanda Tangan"),
              const CSizedBox.h5(),
              GetBuilder<FormController>(
                  id: 'padsign',
                  builder: (controller) {
                    return InkWell(
                      onTap: () => showPadTTD(Get.context!),
                      child: Container(
                          height: Get.context!.width >= maxWidth ? 350 : 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(color: basicBlack)),
                          child: controller.fileBytes != null
                              ? Image.memory(controller.fileBytes!)
                              : Center(
                                  child: MagicText(
                                    "Ketuk Disini untuk Tanda Tangan",
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                    );
                  }),
              const CSizedBox.h20(),
              MagicButton(
                () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (!controller.formKey.currentState!.validate()) return;
                  if (!controller.isSigned.value) {
                    showToast("Silahkan tanda tangan terlebih dahulu");
                    return;
                  }
                  controller.insertPeserta();
                },
                text: "SIMPAN",
                widthInfinity: true,
                textColor: basicWhite,
                padding: const EdgeInsets.all(16),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Widget untuk menampilkan peringatan jika formulir sudah ditutup
  Widget closedForm() {
    return Container(
      color: basicWhite,
      padding: EdgeInsets.all(16),
      width: ResponsiveLayout.getWidth(Get.context!),
      height: ResponsiveLayout.getWidth(Get.context!),
      child: warning(Get.context!,
          "Formulir sudah ditutup atau tanggal kegiatan sudah lewat"),
    );
  }

  /// Widget untuk judul formulir
  widgetTitle() {
    return MagicText(
      "${controller.kegiatan.value.data?.name}",
      fontSize: 28,
      fontWeight: FontWeight.bold,
    );
  }

  /// Widget untuk menampilkan sub judul
  widgetSubtitle() {
    return MagicText(
      "Kegiatan akan dilaksakan pada :",
      fontSize: 16,
    );
  }

  /// Widget untuk menampilkan tanggal, waktu dan tempat pelaksanaan
  widgetDateAndTime(IconData icon, String value) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        children: [Icon(icon), const CSizedBox.w10(), MagicText(value)],
      ),
    );
  }

  /// Widget untuk menampilkan informasi tambahan
  widgetAdditionalInformation() {
    return controller.kegiatan.value.data?.information != null
        ? Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(10),
            color: basicPrimary,
            child: Row(
              children: [
                const Icon(
                  Icons.info,
                  color: basicWhite,
                ),
                const CSizedBox.w10(),
                Expanded(
                  flex: 1,
                  child: SelectableText.rich(TextSpan(
                    children: extractText(
                        "${controller.kegiatan.value.data?.information}"),
                  )),
                )
              ],
            ),
          )
        : SizedBox();
  }

  /// Widget untuk menampilkan tanggal dan waktu kapan formulir akan ditutup
  widgetExpiredDateForm() {
    return Visibility(
      visible: controller.kegiatan.value.data?.dateEnd == null ? false : true,
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        child: MagicText(
          "Formulir akan ditutup pada ${dateToString(
            controller.kegiatan.value.data?.dateEnd,
            format: "EEEE, dd MMMM yyyy HH:mm",
          )} WIB",
          color: basicRed1,
        ),
      ),
    );
  }

  widgetTextfield(
    String title,
    String hint,
    TextEditingController textEditingController, {
    MagicTextFieldStyle? style,
  }) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: MagicText(title),
        ),
        const CSizedBox.h5(),
        MagicTextField.border(
          textEditingController,
          hint: hint,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (GetUtils.isBlank(value) == true) return msgBlank;
            return null;
          },
        ),
      ],
    );
  }

  /// Tampilan dropdown jenis kelamin
  widgetDropdown() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: MagicText("Jenis Kelamin"),
        ),
        const CSizedBox.h5(),
        CTextFieldDropDown<String>(
          hintText: "Pilih Jenis Kelamin",
          value: controller.controllerGender.text == ""
              ? null
              : controller.controllerGender.text,
          items: form_gender
              .map((e) =>
                  DropdownMenuItem<String>(value: e, child: MagicText(e)))
              .toList(),
          onChange: (value) {
            if (controller.controllerGender.text != value) {
              controller.controllerGender.text = value;
            }
          },
          validator: (value) {
            if (value == null ||
                GetUtils.isBlank(controller.controllerGender.text) == true ||
                GetUtils.isBlank(value) == true) return msgBlank;
            return null;
          },
        ),
      ],
    );
  }

  widgetAutocompleteInstansi() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: MagicText("Instansi"),
        ),
        const CSizedBox.h5(),
        Obx(() {
          switch (controller.instansi.value.statusRequest) {
            case StatusRequest.LOADING:
              return loading(Get.context!);
            case StatusRequest.SUCCESS:
              final list = controller.getListInstansi();
              return MagicAutoComplete<InstansiModel>(
                controller: controller.controllerInstansi,
                list: list,
                onSelected: (selected) {
                  controller.selectedInstansi = selected;
                  controller.controllerInstansi.text =
                      selected.data?.name ?? "";
                  controller.settingTextFieldCustomInstansi();
                  controller.settingWilayahWhenSelectedInstansi();
                },
                maxWidthOption: ResponsiveLayout.getWidth(Get.context!) - 40,
                textFieldStyle: MagicTextFieldStyle(
                  hint: "Pilih Instansi",
                  validator: (value) {
                    if (GetUtils.isBlank(value) == true) {
                      return msgBlank;
                    }
                    if (controller.kegiatan.value.data?.isLimitParticipant ==
                        true) {
                      if (value != controller.selectedInstansi?.option) {
                        return "Silahkan pilih salah satu dari pilihan yang ada";
                      }
                    }
                    return null;
                  },
                ),
              );
            case StatusRequest.ERROR:
              return error(
                  Get.context!,
                  controller.instansi.value.failure?.msgShow,
                  () => controller.getInstansi());
            default:
              return SizedBox();
          }
        }),
        SizedBox(
          height: 5,
        ),
        Obx(() {
          return Visibility(
            visible: controller.isOpenInstansi.value,
            child: MagicTextField.border(
              controller.controllerInstansiManual,
              hint: "Masukkan nama instansi anda",
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
      ],
    );
  }

  widgetAutoCompleteWilayah() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: MagicText("Wilayah Instansi"),
        ),
        const CSizedBox.h5(),
        Obx(() {
          switch (controller.regions.value.statusRequest) {
            case StatusRequest.LOADING:
              return loading(Get.context!);
            case StatusRequest.SUCCESS:
              List<RegionModel> result =
                  controller.regions.value.data ?? List.empty();
              final list = result.map((e) {
                return AutoCompleteData(e.name, e);
              }).toList();
              if (controller.kegiatan.value.data?.isLimitParticipant == true) {
                return MagicTextField.border(
                  controller.controllerWilayah,
                  enabled: false,
                );
              }
              return MagicAutoComplete<RegionModel>(
                initial: controller.controllerWilayah.text,
                controller: controller.controllerWilayah,
                list: list,
                onSelected: (selected) {
                  controller.selectedWilayah = selected;
                  controller.controllerWilayah.text = "${selected.data?.name}";
                },
                maxWidthOption: ResponsiveLayout.getWidth(Get.context!) - 40,
                textFieldStyle: MagicTextFieldStyle(
                  hint: "Pilih Wilayah (Pilih Instansi dahulu)",
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
                  Get.context!,
                  controller.instansi.value.failure?.msgShow,
                  () => controller.getRegion());
            default:
              return SizedBox();
          }
        }),
      ],
    );
  }

  showPadTTD(BuildContext context) {
    Get.dialog(
      Center(
        child: Container(
          width: ResponsiveLayout.getWidth(context) - 48,
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: basicWhite,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: basicBlack),
                  color: basicGrey1,
                ),
                height: 350,
                child: SfSignaturePad(
                    minimumStrokeWidth: 3.0,
                    maximumStrokeWidth: 5.0,
                    strokeColor: basicBlack,
                    backgroundColor: basicWhite,
                    onDrawStart: controller.handleOnDrawStart,
                    key: controller.signaturePadKey),
              ),
              const SizedBox(
                height: 32,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        flex: 1,
                        child: buttonOnDialog(() {
                          controller.isSigned.value = false;
                          controller.signaturePadKey.currentState?.clear();
                        }, "Bersihkan", basicPrimary2)),
                    CSizedBox.w10(),
                    Expanded(
                        flex: 1,
                        child: buttonOnDialog(() {
                          controller.pushImage();
                          Get.back();
                        }, "Simpan", basicPrimary)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  buttonOnDialog(Function()? onPressed, String text, Color background) {
    return MagicButton(
      onPressed,
      text: text,
      widthInfinity: true,
      textColor: basicWhite,
      background: background,
      padding: const EdgeInsets.all(16),
    );
  }
}
