import 'package:flutter/material.dart';

import '../../util/color.dart';
import '../title/title_custom.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double paddingVertical;
  final double paddingHorizontal;
  final Color shadowColor;
  final Icon? icon;

  const CustomElevatedButton({
    required this.text,
    required this.onPressed,
    this.color = Colors.white,
    this.textColor = Colors.black,
    this.paddingVertical = 0,
    this.paddingHorizontal = 0,
    this.shadowColor = Colors.transparent,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // دکمه کل عرض را پر کند
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(
            vertical: paddingVertical,
            horizontal: paddingHorizontal,
          ),
          shadowColor: shadowColor,
          elevation: shadowColor == Colors.transparent ? 0 : 2,
        ),
        child: Align(
            alignment: Alignment.centerRight, // تراز کردن متن به راست
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  icon!,
                  SizedBox(width: 20),
                ],
        Text(
                    text,
                    style: TextStyle(color: textColor,fontSize: 16),
                    textAlign: TextAlign.right,
                  ),

              ],
            )
        ),
      ),
    );
  }
}

Widget categoryButton(VoidCallback onPressed, String text) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.transparent),
      side: WidgetStateProperty.all(
        BorderSide(
          color: AppTheme.buttonColor,
          width: 3,
        ),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevation: WidgetStateProperty.all(0),
    ),
    child: TitleCustom(text: text, color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800,)
    );
}
