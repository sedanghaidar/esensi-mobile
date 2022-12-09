import 'package:flutter/material.dart';

class CSizedBox extends StatelessWidget {

  final height;
  final width;

  const CSizedBox({
    super.key,
    this.height,
    this.width
  });

  const CSizedBox.h20({
    super.key,
    this.height = 20,
    this.width = 0
  });

  const CSizedBox.h5({
    super.key,
    this.height = 5,
    this.width = 0
  });

  const CSizedBox.w10({
    super.key,
    this.height = 0,
    this.width = 10
  });

  const CSizedBox.w5({
    super.key,
    this.height = 0,
    this.width = 5
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height, width: width,);
  }

}