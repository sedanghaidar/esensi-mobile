import 'package:absensi_kegiatan/app/global_widgets/text/CText.dart';
import 'package:absensi_kegiatan/app/utils/colors.dart';
import 'package:flutter/material.dart';

class CButton extends StatelessWidget {
  final onPressed;
  final onLongPress;
  final onHover;
  final onFocusChange;
  final style;
  final focusNode;
  final child;
  final text;

  CButton(this.onPressed, this.text,
      {Key? key,
      this.child,
      this.onLongPress,
      this.onHover,
      this.onFocusChange,
      this.style,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    Widget button = CText(
      text,
      style: CText.textStyleBody.copyWith(color: basicWhite),
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: style ?? styleButtonFilled,
      child: child ?? button,
    );
  }
}

ButtonStyle styleButtonFilled = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
  minimumSize: Size.fromHeight(40),
  primary: basicPrimary,
  onPrimary: basicPrimaryDark,
  elevation: 0,
);

ButtonStyle styleButtonOutline = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: basicPrimary, width: 2)),
    minimumSize: Size.fromHeight(40),
    primary: basicWhite,
    onPrimary: basicPrimaryDark,
    elevation: 0);
