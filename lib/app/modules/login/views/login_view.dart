import 'package:absensi_kegiatan/app/global_widgets/other/responsive_layout.dart';
import 'package:absensi_kegiatan/app/utils/colors.dart';
import 'package:absensi_kegiatan/app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_view/factory.dart';
import 'package:magic_view/widget/button/MagicButton.dart';
import 'package:magic_view/widget/text/MagicText.dart';
import 'package:magic_view/widget/textfield/MagicTextField.dart';

import '../../../utils/string.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: basicPrimary, body: ResponsiveLayout(layout()));
  }

  Widget layout() {
    return Center(
      child: Container(
        child: Column(
          children: [
            Expanded(
              flex: 0,
              child: Container(
                padding: EdgeInsets.only(top: 32, left: 28),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MagicText(
                        "Selamat",
                        fontSize: 36,
                        color: basicWhite,
                        fontWeight: FontWeight.w700,
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      MagicText(
                        "Datang!",
                        fontSize: 32,
                        color: basicWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(flex: 1, child: Image.asset("assets/img_login.png")),
            Flexible(
              flex: 0,
              child: Container(
                // height: 400,
                // width: context.width,
                padding: EdgeInsets.all(28),
                decoration: const BoxDecoration(
                    color: basicWhite,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40))),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      textFieldTitle("Email"),
                      textField(MagicTextField(
                        controller.controllerEmail,
                        hint: "Masukkan email",
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (GetUtils.isBlank(value) == true) return msgBlank;
                          if (!GetUtils.isEmail(value ?? "")) {
                            return msgEmailNotValid;
                          }
                          return null;
                        },
                        border: underlineBorder,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                      )),
                      SizedBox(
                        height: 16,
                      ),
                      textFieldTitle("Kata Sandi"),
                      textField(MagicTextField.password(
                        controller.controllerPassword,
                        hint: "Masukkan Kata Sandi",
                        keyboardType: TextInputType.text,
                        border: underlineBorder,
                        validator: (value) {
                          if (GetUtils.isBlank(value) == true) return msgBlank;
                          return null;
                        },
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (value) {
                          login();
                        },
                      )),
                      SizedBox(
                        height: 16,
                      ),
                      MagicButton(
                        () {
                          login();
                        },
                        text: "Masuk",
                        width: true,
                        padding: EdgeInsets.all(16),
                        textStyle: MagicFactory.magicTextStyle
                            .copyWith(color: basicWhite),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 28,
            ),
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

  Widget textFieldTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: MagicText(
        title,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget textField(Widget field) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          border: Border.all(color: basicPrimary, width: 2),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          const Expanded(flex: 0, child: Icon(Icons.email_outlined)),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              color: basicPrimary,
              height: 24,
              width: 2,
            ),
          ),
          Expanded(
            flex: 1,
            child: field,
          ),
        ],
      ),
    );
  }
}
