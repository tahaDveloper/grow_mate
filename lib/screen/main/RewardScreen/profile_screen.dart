import 'dart:ui';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 🎨 پس‌زمینه گرادینتی فانتزی با افکت بلور
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Color(0xFF00FFB3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(

                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),

          // ✨ المان‌های تزئینی (ذرات معلق)
          Positioned.fill(
            child: CustomPaint(
              painter: ParticlesPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

// 🎭 کلاس طراح ذرات معلق تزئینی
class ParticlesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // طراحی ذرات معلق به صورت تصادفی
    final random = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < 50; i++) {
      final x = (random * (i + 1)) % size.width;
      final y = (random * (i * 3 + 2)) % size.height;
      final radius = ((random * (i + 3)) % 3) + 1.0;

      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint..color = Colors.greenAccent.withOpacity(
            ((random * (i + 5)) % 8) / 10 + 0.2
        ),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}