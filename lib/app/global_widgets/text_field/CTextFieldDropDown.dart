import 'package:absensi_kegiatan/app/global_widgets/text/CText.dart';
import 'package:absensi_kegiatan/app/utils/colors.dart';
import 'package:flutter/material.dart';

class CTextFieldDropDown<T> extends StatefulWidget {
  final hintText;
  final items;
  final onChange;
  final T? value;
  final validator;

  CTextFieldDropDown({
    Key? key,
    this.value,
    this.items,
    this.onChange,
    this.validator,
    this.hintText,
  }) : super(key: key);

  @override
  State<CTextFieldDropDown<T>> createState() => CTextFieldDropDownState<T>();
}

class CTextFieldDropDownState<T> extends State<CTextFieldDropDown<T>> {
  @override
  Widget build(BuildContext context) {
    InputDecoration decoration;
    TextAlignVertical align;

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

    decoration = InputDecoration(
        hintStyle: CText.textStyleBody,
        hintText: widget.hintText,
        fillColor: basicWhite,
        filled: true,
        focusColor: basicWhite,
        errorBorder: errorBorder,
        focusedBorder: focusBorder,
        border: border);
    align = TextAlignVertical.top;

    return DropdownButtonFormField<T>(
      decoration: decoration,
      items: widget.items,
      style: CText.textStyleBody,
      onChanged: widget.onChange,
      validator: widget.validator,
      value: widget.value,
    );
  }
}
