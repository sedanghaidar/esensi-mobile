import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';
import '../../utils/utils.dart';

class CustomLayout extends StatelessWidget {
  final Widget child;

  const CustomLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: getWidthDefault(context),
      // height: context.height,
      padding: const EdgeInsets.all(10),
      color: basicWhite,
      child: child,
    ));
  }
}
