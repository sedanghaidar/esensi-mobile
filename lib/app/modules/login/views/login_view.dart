import 'package:absensi_kegiatan/app/data/model/UserModel.dart';
import 'package:absensi_kegiatan/app/global_widgets/button/CButton.dart';
import 'package:absensi_kegiatan/app/global_widgets/sized_box/CSizedBox.dart';
import 'package:absensi_kegiatan/app/global_widgets/text_field/CTextField.dart';
import 'package:absensi_kegiatan/app/utils/constant.dart';
import 'package:absensi_kegiatan/app/utils/images.dart';
import 'package:absensi_kegiatan/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../global_widgets/text/CText.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/string.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    Widget body = SizedBox();
    final orientation = getPlatform(context);
    if (orientation == WEB_LANDSCAPE || orientation == DESKTOP_LANDSCAPE) {
      body = widgetLandscape();
    } else {
      body = widgetPortrait();
    }

    return Scaffold(body: body);
  }

  Widget widgetLandscape() {
    return Row(
      children: [
        Expanded(child: SvgPicture.asset(imgLogin)),
        Expanded(child: formLogin())
      ],
    );
  }

  Widget widgetPortrait() {
    return SingleChildScrollView(
      child: Column(
        children: [
          CSizedBox.h30(),
          Container(height: 200, child: SvgPicture.asset(imgLogin)),
          formLogin()
        ],
      ),
    );
  }

  Widget formLogin() {
    return Form(
      key: controller.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CText.header("Selamat datang di\nAplikasi Absensi Kegiatan"),
            const CSizedBox.h20(),
            const CText(
              "Email",
              style: CText.textStyleBodyBold,
            ),
            const CSizedBox.h5(),
            CTextField(
              controller: controller.controllerEmail,
              hintText: "Masukkan email",
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (GetUtils.isBlank(value) == true) return msgBlank;
                if (!GetUtils.isEmail(value)) return msgEmailNotValid;
                return null;
              },
              autoValidateMode: AutovalidateMode.onUserInteraction,
            ),
            const CSizedBox.h20(),
            const CText(
              "Kata Sandi",
              style: CText.textStyleBodyBold,
            ),
            const CSizedBox.h5(),
            CTextField.password(
              controller: controller.controllerPassword,
              hintText: "Masukkan password",
              keyboardType: TextInputType.emailAddress,
              obscureText: true,
              validator: (value) {
                if (GetUtils.isBlank(value) == true) return msgBlank;
                return null;
              },
              autoValidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) {
                login();
              },
            ),
            const CSizedBox.h20(),
            CButton(() {
              login();
            }, "MASUK")
          ],
        ),
      ),
    );
  }

  login() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!controller.formKey.currentState!.validate()) return;
    controller.login();
  }
}
