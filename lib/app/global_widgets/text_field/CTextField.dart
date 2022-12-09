import 'package:absensi_kegiatan/app/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/colors.dart';
import '../text/CText.dart';

class CTextField extends StatefulWidget {
  final type;
  final controller;
  final decoration;
  final hintText;
  final keyboardType;
  final textInputAction;
  final style;
  final readOnly;
  bool obscureText;
  final maxLines;
  final minLines;
  final maxLength;
  final onEditingComplete;
  final onFieldSubmitted;
  final validator;
  final autoValidateMode;
  final enabled;

  CTextField({
    Key? key,
    this.type = "CUSTOM",
    this.controller,
    this.decoration,
    this.hintText,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.style = CText.textStyleBody,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.validator,
    this.autoValidateMode,
    this.enabled,
  }) : assert(decoration != null || hintText != null,
            "Hanya boleh diisi salah satu");

  CTextField.password({
    Key? key,
    this.type = "PASSWORD",
    this.controller,
    this.decoration,
    this.hintText,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.style = CText.textStyleBody,
    this.readOnly = false,
    this.obscureText = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.validator,
    this.autoValidateMode,
    this.enabled,
  }) : assert(decoration != null || hintText != null,
            "Hanya boleh diisi salah satu");

  CTextField.noStyle({
    Key? key,
    this.type = "NOSTYLE",
    this.controller,
    this.decoration,
    this.hintText,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.style = CText.textStyleBody,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.validator,
    this.autoValidateMode,
    this.enabled,
  }) : assert(decoration != null || hintText != null,
            "Hanya boleh diisi salah satu");

  @override
  State<CTextField> createState() => CTextFieldState();
}

class CTextFieldState extends State<CTextField> {
  Icon iconEye = Icon(
    Icons.visibility,
    color: basicPrimary,
  );
  Icon iconEyeOff = Icon(
    Icons.visibility_off,
    color: basicPrimary,
  );
  Icon icon = Icon(
    Icons.visibility_off,
    color: basicPrimary,
  );

  void _togglePasswordView() {
    setState(() {
      widget.obscureText = !widget.obscureText;
      if (widget.obscureText == true) {
        icon = iconEyeOff;
      } else {
        icon = iconEye;
      }
    });
  }

  OutlineInputBorder errorBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: basicRed1, width: 2.0),
    borderRadius: BorderRadius.circular(5),
  );

  OutlineInputBorder focusBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: basicPrimary2, width: 2.0),
    borderRadius: BorderRadius.circular(5),
  );

  OutlineInputBorder border = OutlineInputBorder(
    borderSide: const BorderSide(color: basicGrey2, width: 2.0),
    borderRadius: BorderRadius.circular(5),
  );

  @override
  Widget build(BuildContext context) {
    InputDecoration defaultDecoration = InputDecoration(
      hintStyle: CText.textStyleBody,
      hintText: widget.hintText,
      fillColor: basicWhite,
      filled: true,
      focusColor: basicWhite,
      errorBorder: errorBorder,
      focusedBorder: focusBorder,
      border: border,
    );

    if (widget.decoration != null) {
      defaultDecoration = widget.decoration;
    }

    if (widget.type == "PASSWORD") {
      defaultDecoration = defaultDecoration.copyWith(
        suffixIcon: InkWell(
          onTap: _togglePasswordView,
          child: icon,
        ),
      );
    } else if (widget.type == "NOSTYLE") {
      defaultDecoration = defaultDecoration.copyWith(
        contentPadding: EdgeInsets.only(right: 150, left: 10),
      );
    }

    return TextFormField(
      controller: widget.controller,
      decoration: defaultDecoration,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      style: widget.style,
      readOnly: widget.readOnly,
      obscureText: widget.obscureText,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      autovalidateMode: widget.autoValidateMode,
      enabled: widget.enabled,
    );
  }
}
