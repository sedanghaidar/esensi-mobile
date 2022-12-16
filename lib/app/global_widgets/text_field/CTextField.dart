import 'package:flutter/material.dart';

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
  final onTap;
  final suffixIcon;
  final focusNode;

  CTextField(
      {Key? key,
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
      this.onTap,
      this.focusNode,
      this.suffixIcon})
      : assert(decoration != null || hintText != null,
            "Hanya boleh diisi salah satu");

  CTextField.password(
      {Key? key,
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
      this.onTap,
      this.focusNode,
      this.suffixIcon})
      : assert(decoration != null || hintText != null,
            "Hanya boleh diisi salah satu");

  CTextField.noStyle(
      {Key? key,
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
      this.onTap,
      this.focusNode,
      this.suffixIcon})
      : assert(decoration != null || hintText != null,
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
        suffixIcon: widget.suffixIcon,
        border: border);

    if (widget.decoration != null) {
      defaultDecoration = widget.decoration;
    }

    switch (widget.type) {
      case "PASSWORD":
        {
          defaultDecoration = defaultDecoration.copyWith(
            suffixIcon: InkWell(
              onTap: _togglePasswordView,
              child: icon,
            ),
          );
          break;
        }
      case "NOSTRYLE":
        {
          defaultDecoration = defaultDecoration.copyWith(
            contentPadding: EdgeInsets.only(right: 150, left: 10),
          );
          break;
        }
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
      cursorColor: basicPrimary,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      autovalidateMode: widget.autoValidateMode,
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      onTap: widget.onTap,
    );
  }
}
