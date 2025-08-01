import 'dart:ui';

import 'package:flutter/cupertino.dart';

class TitleCustom extends StatelessWidget {
   TitleCustom({super.key, required this.text, required this.color, required this.fontSize, required this.fontWeight});

  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;


  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
        fontFamily: "IRANSans"
    ),);
  }
}
