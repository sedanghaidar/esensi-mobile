import 'package:flutter/material.dart';

class CSizedBox extends StatelessWidget {

  final height;
  final width;

  const CSizedBox({
    super.key,
    this.height,
    this.width
  });

  const CSizedBox.h30({
    super.key,
    this.height = 30.0,
    this.width = 0.0
  });

  const CSizedBox.h20({
    super.key,
    this.height = 20.0,
    this.width = 0.0
  });

  const CSizedBox.h10({
    super.key,
    this.height = 10.0,
    this.width = 0.0
  });

  const CSizedBox.h5({
    super.key,
    this.height = 5.0,
    this.width = 0.0
  });

  const CSizedBox.w10({
    super.key,
    this.height = 0.0,
    this.width = 10.0
  });

  const CSizedBox.w5({
    super.key,
    this.height = 0.0,
    this.width = 5.0
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height, width: width,);
  }

}