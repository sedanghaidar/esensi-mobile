import 'package:absensi_kegiatan/app/global_widgets/text/CText.dart';
import 'package:absensi_kegiatan/app/utils/colors.dart';
import 'package:flutter/material.dart';

import 'CButtonStyle.dart';

class CButton extends StatelessWidget {
  final onPressed;
  final onLongPress;
  final onHover;
  final onFocusChange;
  final style;
  final focusNode;
  final child;
  final text;
  final type;
  final icon;

  CButton(this.onPressed, this.text,
      {Key? key,
      this.type = "ROUND",
      this.child,
      this.onLongPress,
      this.onHover,
      this.onFocusChange,
      this.style,
      this.icon,
      this.focusNode});

  CButton.box(this.onPressed, this.text,
      {Key? key,
      this.type = "BOX",
      this.child,
      this.onLongPress,
      this.onHover,
      this.onFocusChange,
      this.style,
      this.icon,
      this.focusNode});

  CButton.small(this.onPressed, this.text,
      {Key? key,
      this.type = "SMALL",
      this.child,
      this.onLongPress,
      this.onHover,
      this.onFocusChange,
      this.style,
      this.icon,
      this.focusNode});

  CButton.icon(this.onPressed, this.text,
      {Key? key,
      this.type = "ICON",
      this.child,
      this.onLongPress,
      this.onHover,
      this.onFocusChange,
      this.style,
      this.icon,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    Widget button = CText(
      text,
      textAlign: TextAlign.center,
      style: CText.textStyleBody.copyWith(color: basicWhite),
    );

    ButtonStyle defaultStyle = styleButtonFilled;
    switch (type) {
      case "BOX":
        {
          defaultStyle = styleButtonFilledBox;
          break;
        }
      case "SMALL":
        {
          defaultStyle = styleButtonFilledBoxSmall.copyWith();
          button = CText(
            text,
            style: CText.textStyleBody
                .copyWith(color: basicWhite, fontWeight: FontWeight.w200),
          );
          break;
        }
    }

    if (type == "ICON") {
      return ElevatedButton.icon(
        icon: icon,
        onPressed: onPressed,
        style: style ?? defaultStyle,
        label: child ?? button,
      );
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        style: style ?? defaultStyle,
        child: child ?? button,
      );
    }
  }
}
