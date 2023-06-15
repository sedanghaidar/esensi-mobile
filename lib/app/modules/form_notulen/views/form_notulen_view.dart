import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:absensi_kegiatan/app/global_widgets/button/CButton.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/appBar.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/custom_layout.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/form.dart';
import 'package:absensi_kegiatan/app/global_widgets/text/CText.dart';
import 'package:absensi_kegiatan/app/utils/colors.dart';
import 'package:absensi_kegiatan/app/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

import '../../../global_widgets/dialog/CImagePicker.dart';
import '../controllers/form_notulen_controller.dart';

class FormNotulenView extends GetView<FormNotulenController> {
  const FormNotulenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Form Notulen"),
      body: SingleChildScrollView(
        child: CustomLayout(
            child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: CText(
                    "Isi Notulensi",
                    style: CText.textStyleBodyBold.copyWith(fontSize: 16),
                  )),
              SizedBox(
                height: 10,
              ),
              formAgendaDefault(controller.controllerNoSurat, "Nomer Surat",
                  "Masukkan Nomer Surat", validator: (value) {
                if (GetUtils.isBlank(value) == true) return msgBlank;
                return null;
              }),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: basicGrey2,
                      width: 2.0,
                    )),
                child: Column(
                  children: [
                    ToolBar.scroll(
                      controller: controller.controllerNotulenQuil,
                      customButtons: [
                        InkWell(
                          onTap: () async {
                            String result2 = await controller
                                .controllerNotulenQuil
                                .getText();
                            debugPrint(result2);
                          },
                          child: Icon(Icons.save),
                        )
                      ],
                      toolBarConfig: const [
                        ToolBarStyle.bold,
                        ToolBarStyle.italic,
                        ToolBarStyle.underline,
                        ToolBarStyle.align,
                        ToolBarStyle.indentAdd,
                        ToolBarStyle.indentMinus,
                        ToolBarStyle.listOrdered,
                        ToolBarStyle.listBullet,
                        ToolBarStyle.addTable,
                        ToolBarStyle.editTable,
                      ],
                    ),
                    QuillHtmlEditor(
                      controller: controller.controllerNotulenQuil,
                      text: controller.notulen?.hasil,
                      minHeight: 200,
                      padding: EdgeInsets.all(8),
                      hintTextPadding: EdgeInsets.all(8),
                      textStyle: CText.textStyleBody,
                      hintTextStyle: CText.textStyleBody,
                      hintText: "Masukkan isi notulensi disini",
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GetBuilder<FormNotulenController>(
                  id: 'images',
                  builder: (controller) {
                    return Row(
                      children: [
                        Expanded(flex: 1, child: image(1)),
                        Expanded(flex: 1, child: image(2)),
                        Expanded(flex: 1, child: image(3)),
                      ],
                    );
                  }),
              SizedBox(
                height: 16,
              ),
              Divider(
                height: 2,
                color: basicGrey1,
              ),
              SizedBox(
                height: 16,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: CText(
                    "Ditandatangani Oleh",
                    style: CText.textStyleBodyBold.copyWith(fontSize: 16),
                  )),
              SizedBox(
                height: 10,
              ),
              formAgendaDefault(
                  controller.controllerNama, "Nama", "Masukkan Nama",
                  validator: (value) {
                if (GetUtils.isBlank(value) == true) return msgBlank;
                return null;
              }),
              formAgendaDefault(controller.controllerNIP, "NIP", "Masukkan NIP",
                  validator: (value) {
                if (GetUtils.isBlank(value) == true) return msgBlank;
                return null;
              }),
              formAgendaDefault(
                  controller.controllerJabatan, "Jabatan", "Masukkan Jabatan",
                  validator: (value) {
                if (GetUtils.isBlank(value) == true) return msgBlank;
                return null;
              }),
              formAgendaDefault(
                  controller.controllerPangkat, "Pangkat", "Masukkan Pangkat",
                  validator: (value) {
                if (GetUtils.isBlank(value) == true) return msgBlank;
                return null;
              }),
              SizedBox(
                height: 10,
              ),
              CButton(() async {
                if (controller.formKey.currentState?.validate() == false)
                  return;
                if (controller.image1 == null) {
                  Get.defaultDialog(
                      title: "Perhatian",
                      middleText: "Dokumentasi pertama tidak boleh kosong");
                }

                if(controller.notulen==null){
                  controller.postNewNotulen();
                }else{
                  controller.updateNotulen();
                }
              }, "SIMPAN")
            ],
          ),
        )),
      ),
    );
  }

  Widget image2(XFile? file, String? url) {
    debugPrint("PATH ${file?.path}");
    debugPrint("URL $url");
    if (url == null && file == null) {
      return Image.asset("assets/add_image.png");
    } else if (url == null && file != null) {
      return Image.network(
        (file.path ?? ""),
      );
    } else if (url != null && file != null) {
      return Image.network(
        (file.path ?? ""),
      );
    } else {
      return Image.network(
        "${ApiProvider.BASE_URL}/storage/images/$url",
      );
    }
  }

  Widget image(int index) {
    return LayoutBuilder(builder: (context, constraints) {
      return InkWell(
        onTap: () {
          openDialogPicker((p0) {
            controller.settingImage(p0, index);
          });
        },
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: constraints.maxWidth - 10,
                height: constraints.maxWidth - 10,
                child: image2(
                    controller.getImage(index), controller.getImageUrl(index))),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: constraints.maxWidth,
              padding: EdgeInsets.all(8),
              color: index == 1 ? basicRed1 : basicGrey2,
              child: Center(
                  child: CText(
                index == 1 ? "Wajib Diisi" : "Opsional",
                style: CText.textStyleBody.copyWith(color: basicWhite),
              )),
            )
          ],
        ),
      );
    });
  }
}
