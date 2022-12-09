import 'package:flutter/material.dart';

import '../../utils/colors.dart';

ButtonStyle styleButtonFilled = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
  minimumSize: Size.fromHeight(40),
  primary: basicPrimary,
  onPrimary: basicPrimaryDark,
  elevation: 0,
);

ButtonStyle styleButtonFilledBox = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  minimumSize: Size.fromHeight(40),
  primary: basicPrimary2,
  onPrimary: basicPrimary2Dark,
  elevation: 0,
);

ButtonStyle styleButtonFilledBoxSmall = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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