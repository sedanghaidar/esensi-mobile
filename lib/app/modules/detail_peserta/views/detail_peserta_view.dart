import 'dart:convert';
import '../../../global_widgets/Html.dart'
if (dart.library.html) 'dart:html';
// import 'dart:html';

import 'package:absensi_kegiatan/app/data/model/repository/StatusRequest.dart';
import 'package:absensi_kegiatan/app/global_widgets/dialog/CLoading.dart';
import 'package:absensi_kegiatan/app/global_widgets/other/error.dart';
import 'package:absensi_kegiatan/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../../global_widgets/button/CButton.dart';
import '../../../global_widgets/sized_box/CSizedBox.dart';
import '../../../global_widgets/text/CText.dart';
import '../../../utils/colors.dart';
import '../../../utils/images.dart';
import '../controllers/detail_peserta_controller.dart';

class DetailPesertaView extends GetView<DetailPesertaController> {
  @override
  Widget build(BuildContext context) {
    String? id = Get.parameters["id"].toString();
    controller.getPesertaById(id);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: basicPrimary,
        title: Text('Tiket Kegiatan'.toUpperCase()),
        centerTitle: true,
      ),
      body: Obx(() {
        switch (controller.peserta.value.statusRequest) {
          case StatusRequest.LOADING:
            return loading(context);
          case StatusRequest.SUCCESS:
            return Center(
                child: Container(
              padding: EdgeInsets.all(10),
              constraints: BoxConstraints(maxHeight: context.height),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: basicWhite,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.memory(data!.buffer.asUint8List()),
                  RepaintBoundary(
                    key: controller.qrKey,
                    child: Container(
                      color: basicWhite,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Image.asset(
                            imgJateng,
                            width: 50,
                            height: 50,
                          ),
                          CText(
                            controller.peserta.value.data?.kegiatan?.name ??
                                "-",
                            style: CText.textStyleSubhead,
                          ),
                          CSizedBox.h10(),
                          PrettyQr(
                            data: controller.peserta.value.data?.qrCode ??
                                "UNKNOWN",
                            size: 400,
                            errorCorrectLevel: QrErrorCorrectLevel.M,
                            roundEdges: true,
                            // typeNumber: 100,
                          ),
                          CSizedBox.h10(),
                          CText(
                            controller.peserta.value.data?.name ?? "UNKNOWN",
                          ),
                        ],
                      ),
                    ),
                  ),
                  CSizedBox.h10(),
                  CButton.small(() {
                    getWidgetToImage(controller.qrKey).then((value) {
                      if (value != null) {
                        debugPrint("ADA DATANYA");

                        final content = base64Encode(value);
                        AnchorElement(
                            href:
                                "data:application/octet-stream;charset=utf-16le;base64,$content")
                          ..setAttribute("download", "file.png")
                          ..click();
                      } else {
                        debugPrint("NULL BRO");
                      }
                    });
                  }, "SIMPAN")
                ],
              ),
            ));
          case StatusRequest.ERROR:
            return error(context, controller.peserta.value.failure?.msgShow,
                () {
              controller.getPesertaById(id);
            });
          default:
            return SizedBox();
        }
      }),
    );
  }
}
