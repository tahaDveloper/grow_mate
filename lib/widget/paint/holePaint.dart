import 'package:flutter/material.dart';

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    final path = Path();

    // شروع از گوشه پایین چپ
    path.moveTo(0, size.height);

    // بالا آمدن تا گوشه بالا چپ با انحنا
    path.lineTo(0, 50);
    path.quadraticBezierTo(0, 0, 50, 0); // گوشه بالا چپ گرد

    // انحنا به سمت مرکز
    path.quadraticBezierTo(size.width, 0, size.width * 0.3, 0);

    // فرورفتگی وسط
    path.quadraticBezierTo(size.width * 0.47, 45, size.width * 0.7, 0);

    // انحنا از مرکز تا گوشه راست
    path.quadraticBezierTo(size.width, 0, size.width - 50, 0);

    // گوشه بالا راست گرد
    path.quadraticBezierTo(size.width, 0, size.width, 50);

    // پایین آمدن تا گوشه پایین راست
    path.lineTo(size.width, size.height);

    // بستن مسیر
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
