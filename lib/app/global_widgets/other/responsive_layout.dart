import 'dart:math';

import 'package:absensi_kegiatan/app/utils/constant.dart';
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget largeScreen;
  final Widget? mediumScreen;
  final Widget? smallScreen;

  const ResponsiveLayout(this.largeScreen,
      {super.key, this.mediumScreen, this.smallScreen});

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 800;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 800 &&
        MediaQuery.of(context).size.width < 1200;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 1200;
  }

  static getWidth(BuildContext context){
    if(isLargeScreen(context) || isMediumScreen(context)){
      return 800;
    }
    return width;
  }

  static getWidthForDialog(BuildContext context){
    if(isLargeScreen(context) || isMediumScreen(context)){
      return 800/1.75;
    }
    if(width >= 800){
      return width/1.75;
    }
    return width;
  }

  static double width = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        width = constraints.maxWidth;
        if (constraints.maxWidth > 1200) {
          return defaultLargeScreen();
        } else if (constraints.maxWidth < 1200 && constraints.maxWidth > 800) {
          return mediumScreen ?? defaultLargeScreen();
        } else {
          return smallScreen ?? defaultLargeScreen();
        }
      },
    );
  }

  Widget defaultLargeScreen(){
    return Center(
      child: Container(
        width: 800,
        child: largeScreen,
      ),
    );
  }
}
