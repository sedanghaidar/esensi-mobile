import 'package:absensi_kegiatan/app/global_widgets/text/CText.dart';
import 'package:absensi_kegiatan/app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:magic_view/factory.dart';
import 'package:magic_view/style/MagicTextFieldBorder.dart';
import 'package:magic_view/style/MagicTextStyle.dart';

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

    decoration = InputDecoration(
      hintStyle: MagicFactory.magicTextStyle.toGoogleTextStyle(),
      hintText: widget.hintText,
      fillColor: basicWhite,
      filled: true,
      focusColor: basicWhite,
      border: MagicFactory.border.border?.toBorder() ?? InputBorder.none,
      enabledBorder:
          MagicFactory.border.enableBorder?.toBorder() ?? InputBorder.none,
      errorBorder:
          MagicFactory.border.errorBorder?.toBorder() ?? InputBorder.none,
      focusedErrorBorder: MagicFactory.border.focusedErrorBorder?.toBorder() ??
          InputBorder.none,
      focusedBorder:
          MagicFactory.border.focusedBorder?.toBorder() ?? InputBorder.none,
      disabledBorder:
          MagicFactory.border.disableBorder?.toBorder() ?? InputBorder.none,
    );
    align = TextAlignVertical.top;

    return DropdownButtonFormField<T>(
      decoration: decoration,
      items: widget.items,
      style: MagicFactory.magicTextStyle.toGoogleTextStyle(),
      onChanged: widget.onChange,
      validator: widget.validator,
      value: widget.value,
    );
  }
}
