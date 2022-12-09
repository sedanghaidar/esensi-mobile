import 'package:flutter/material.dart';

import '../../utils/colors.dart';

Widget suffixIconClear(Function() onTap) {
  return InkWell(
    onTap: onTap,
    child: Icon(
      Icons.close,
      color: basicPrimary,
    ),
  );
}
