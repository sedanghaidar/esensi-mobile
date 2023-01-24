import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/colors.dart';

class CText extends StatelessWidget {
  final String text;

  final style;
  final strutStyle;
  final textAlign;
  final textDirection;
  final locale;
  final softWrap;
  final overflow;
  final textScaleFactor;
  final maxLines;
  final semanticsLabel;
  final textWidthBasis;
  final textHeightBehavior;

  const CText(this.text,
      {super.key,
      this.style = textStyleBody,
      this.strutStyle,
      this.textAlign,
      this.textDirection,
      this.locale,
      this.softWrap,
      this.overflow,
      this.textScaleFactor,
      this.maxLines,
      this.semanticsLabel,
      this.textWidthBasis,
      this.textHeightBehavior});

  const CText.header(this.text,
      {super.key,
      this.style = textStyleHead,
      this.strutStyle,
      this.textAlign,
      this.textDirection,
      this.locale,
      this.softWrap,
      this.overflow,
      this.textScaleFactor,
      this.maxLines,
      this.semanticsLabel,
      this.textWidthBasis,
      this.textHeightBehavior});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  static const TextStyle textStyleHint = TextStyle(
    fontSize: 12,
    letterSpacing: 0.0,
    // fontFamily: fontRubik,
    fontWeight: FontWeight.w400,
    color: basicBlack,
  );

  static const TextStyle textStyleBody = TextStyle(
    fontSize: 14,
    letterSpacing: 0.25,
    // fontFamily: fontRubik,
    fontWeight: FontWeight.normal,
    color: basicBlack,
  );

  static const TextStyle textStyleBodyBold = TextStyle(
    fontSize: 14,
    letterSpacing: 0.25,
    // fontFamily: fontRubik,
    fontWeight: FontWeight.bold,
    color: basicBlack,
  );

  static const TextStyle textStyleHead = TextStyle(
    fontSize: 28,
    letterSpacing: 0.25,
    // fontFamily: fontRubik,
    fontWeight: FontWeight.bold,
    color: basicBlack,
  );

  static const TextStyle textStyleSubhead = TextStyle(
    fontSize: 20,
    letterSpacing: 0.25,
    // fontFamily: fontRubik,
    fontWeight: FontWeight.bold,
    color: basicBlack,
  );

  static TextStyle styleTitleAppBar = GoogleFonts.lato(
    textStyle: TextStyle(color: Colors.white, letterSpacing: 2),
  );
}
